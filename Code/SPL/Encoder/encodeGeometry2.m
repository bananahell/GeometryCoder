%function [enc, rateBPOVPerAxis] = encodeGeometry2(enc)
%
% This is the main encoder function.
%  It performs the point cloud slicing, initializes the arithmetic coder,
%  tests all three axis, and writes the output file.
%
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function [enc, rateBPOVPerAxis] = encodeGeometry2(enc)

global toggleSlicesFlags;
global toggleSlicesFlagsIndexes;
global nBitsDyadicVector;
global mseDyadicVector;
global nBitsDyadicVectorNormal;
global psnrDyadicVectorNormal;
global toggledOffIndexes;
global currentIndex;
global bitsPercentage;
global encodeMode;
global totalNumberOfBits;
global preEncodeDone;
axisArray      = 'xyz';
bestRate       = Inf;
bestAxis       = '0';
bestGeoCube    = [];
bestStat       = [];
bestBitstream  = [];

rateBPOVPerAxis   = [0 0 0];

%Checks if the testMode is correct
if (sum(enc.params.testMode) == 0)
    error('At least one mode should be tested -> params.testMode');
end

%Iterate to find the best axis
%EDUARDO: turning off the test for all axis to speed-up debugging
for k = 1:1:1
%for k = 1:1:3

    toggleSlicesFlags = [];
    toggleSlicesFlagsIndexes = [];
    nBitsDyadicVectorNormal = [];
    psnrDyadicVectorNormal = [];
    toggledOffIndexes = [];
    currentIndex = 1;
    tStart_Axis = tic;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Splices the geoCube
    currAxis = axisArray(k);
    disp(['[AXIS] Encoding ' currAxis ' axis...']);
    %geoCube = ptcld2Slices(enc.pointCloud.Location,currAxis,enc.pcLimit);
    geoCube = [];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Initializes the cabac.
    cabac = getCABAC();
    cabac = initCABAC(cabac, enc.params.BACParams);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Encodes the Geometry Cube.
    iStart = 1;
    iEnd   = enc.pcLimit + 1;%size(geoCube,3);

    % Need the original silhouette slices' matrices to compare and get psnr
    origYSlices = cell(512,1);
    origYPointList = [];
    for i = 1:1:512
        auxSlice = silhouetteFromCloud(enc.pointCloud.Location, enc.pcLimit + 1, currAxis, i, i, false);
        origYSlices{i} = auxSlice;
        origYPointList = expandPointCloud(auxSlice, origYPointList, currAxis, i);
    end

    if (preEncodeDone == 0)
        % First pass, only getting the nBits and mse information
        [enc2, cabac2] = preEncodeGeoCube(geoCube, enc, cabac, currAxis, iStart, iEnd, origYSlices, origYPointList, enc.pointCloud);
        totalNumberOfBits = cabac2.BACEngine.bitstream.size() + cabac2.ParamBitstream.size();
    end

    if (encodeMode == 1)
        % Normalize both vectors from min 0 to max 1 (normal = (vec - min)/diffMaxMin)
        % TODO
        % This is a place the project can get better
        % I'm giving the same importance weight to both mse and nBits. There should
        % be a gradient x that makes mse + x*nBits optimal!
        for i = 1:1:length(nBitsDyadicVector)
            mseBitrate = nBitsDyadicVector(i) / (mseDyadicVector(i) + 0.001);
            toggleSlicesFlags = [toggleSlicesFlags mseBitrate];
        end
    end

    if (encodeMode == 0)
        toggleSlicesFlags = nBitsDyadicVector;
    end

    % Get the indexes of the slices sorted from what I most want to least want
    % to process, where the slices I most want to process are the ones with the
    % highest psnr and nBits (least error and most loss of bits)
    toggleSlicesFlagsIndexes = sort(toggleSlicesFlags, 'descend');
    for i = 1:1:length(toggleSlicesFlags)
        aux = find(toggleSlicesFlags == toggleSlicesFlagsIndexes(i));
        toggleSlicesFlagsIndexes(i) = aux(1);
        toggleSlicesFlags(aux(1)) = -1;
    end

    % TODO
    % Here's the kick - right now I'm just selecting the best 10 slices I want
    % to process, but I can change this to continue in the loop until I get rid
    % of any ammount of pixels I want to get rid of. I can get the number of
    % pixels I get rid of by adding from the nBitsDyadicVector!
    nBitsTotal  = totalNumberOfBits;
    nBitsMax = nBitsTotal * bitsPercentage;
    index = 1;
    while nBitsMax < nBitsTotal
        flagsArraySize = size(toggleSlicesFlagsIndexes);
        if (flagsArraySize < index)
            disp('[SLICES OVER] All end slices encoded, so not meeting bpov max!');
            break;
        end
        toggledOffIndexes = [toggledOffIndexes toggleSlicesFlagsIndexes(index)];
        nBitsTotal = nBitsTotal - nBitsDyadicVector(toggleSlicesFlagsIndexes(index));
        index = index + 1;
    end

    % In toggleSlicesFlags, I turn the values selected above in toggleOffIndexes
    % to 1, the rest to 0, which means that every slice marked as 1 in this
    % vector will get to be processed in the second pass
    for i = 1:1:length(toggleSlicesFlags)
        toggleSlicesFlags(i) = 0;
    end
    for i = 1:1:length(toggledOffIndexes)
        toggleSlicesFlags(toggledOffIndexes(i)) = 1;
    end

    % Second pass, applying the decision vector and returning the cabac
    [enc, cabac] = encodeGeoCube(geoCube, enc, cabac, currAxis, iStart, iEnd);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Closes the cabac Bitstream.
    cabac.BACEngine = closeBitstreamBAC(cabac.BACEngine);

    %Get the size of the parameters.
    length_bitstreamParam = cabac.ParamBitstream.size();

    %Encodes the bitstream param.
    bitstreamParam = encodeBitstreamParam(cabac.ParamBitstream.data(1:cabac.ParamBitstream.p),enc.params);

    %Gets the bitstream header.
    bitstream = createBitstreamHeader(enc.pcLimit, currAxis, length_bitstreamParam);

    %Merges all bitstreams.
    bitstream = bitstream.merge(bitstreamParam);
    bitstream = bitstream.merge(cabac.BACEngine.bitstream);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    totalRate = (ceil(bitstream.size() / 8) * 8) + 1;

    rateBPOVPerAxis(k) = totalRate / enc.numberOfOccupiedVoxels;
    if (totalRate < bestRate)
        bestAxis      = currAxis;
        bestRate      = totalRate;
        bestGeoCube   = [];
        bestBitstream = bitstream;
    end

    tEnd_Axis = toc(tStart_Axis);
    if (k == 1)
        disp(['[AXIS DONE] Axis X - Rate = ' num2str(rateBPOVPerAxis(1),'%2.4f') ' bpov - Encoding Time = ' num2str(tEnd_Axis,'%2.1f') ' seconds.']);
    elseif (k == 2)
        disp(['[AXIS DONE] Axis Y - Rate = ' num2str(rateBPOVPerAxis(2),'%2.4f') ' bpov - Encoding Time = ' num2str(tEnd_Axis,'%2.1f') ' seconds.']);
    elseif (k == 3)
        disp(['[AXIS DONE] Axis Z - Rate = ' num2str(rateBPOVPerAxis(3),'%2.4f') ' bpov - Encoding Time = ' num2str(tEnd_Axis,'%2.1f') ' seconds.']);
    end
end

%Writes the encoder out.
enc.rate            = bestRate;
enc.rate_bpov       = bestRate / enc.numberOfOccupiedVoxels;
enc.bitstream       = bestBitstream;
enc.dimensionSliced = bestAxis;
enc.geometryCube    = bestGeoCube;

%Writes the bitstream.
bitstreamFile     = [enc.params.workspaceFolder enc.params.bitstreamFile];
disp(['[WRITE] Writing to file ' bitstreamFile '']);
bestBitstream.flushesToFile(bitstreamFile);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
