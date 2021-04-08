%function [enc, rateBPOVPerAxis] = encodeGeometry2(enc)
%
% This is the main encoder function.
%  It performs the point cloud slicing, initializes the arithmetic coder,
%  tests all three axis, and writes the output file.
%
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function [enc, rateBPOVPerAxis] = encodeGeometryInter(enc)

axisArray      = 'xyz';
bestRate       = Inf;
bestAxis       = '0';
bestGeoCube    = [];
bestStat       = [];
bestBitstream  = [];

rateBPOVPerAxis   = [0 0 0];
entropyValue      = [0 0 0];

%Checks if the testMode is correct
if (sum(enc.params.testMode) == 0)
    error('At least one mode should be tested -> params.testMode');
end

%Define if single mode will be used to find the contexts
useSingleModeContSel = 1;

%Iterate to find the best axis
for k = 1:1:3
    

    tStart_Axis = tic;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Splices the geoCube
    currAxis = axisArray(k);
    disp(['Encoding ' currAxis ' axis...'])
    
    %-----------------Starts the context selection algorithm----------
    
    [structTables,HData] = createContextTableInter(enc,currAxis,1,enc.pcLimit+1,useSingleModeContSel);
    [structVector,FinalH] = generateAllContextVector(structTables,useSingleModeContSel,enc.numberOfOccupiedVoxels,enc.pcLimit+1,HData);
    enc          = addContextVectors(enc,useSingleModeContSel,structVector);
    %enc         = addContextVectors(enc);
    %-----------------------------------------------------------------
    
    geoCube = [];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Initializes the cabac.
    cabac = getCABAC();
    cabac = initCABAC(cabac, enc.params.BACParams, 1, enc.params.test3DOnlyContextsForInter);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Encodes the Geometry Cube.
    iStart = 1;
    iEnd   = enc.pcLimit + 1;%size(geoCube,3);
        
    cabac = encodeGeoCubeInter(geoCube, enc, cabac, currAxis, iStart, iEnd);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Closes the cabac Bitstream.
    cabac.BACEngine = closeBitstreamBAC(cabac.BACEngine);
    
    %Get the size of the parameters.
    length_bitstreamParam = cabac.ParamBitstream.size();
        
    %Encodes the bitstream param.
    bitstreamParam = encodeBitstreamParam(cabac.ParamBitstream.data(1:cabac.ParamBitstream.p),enc.params);
    
    %Join all context vectors
    fullContextVector = genFullContextVector(enc);
    
    %Gets the bitstream header.
    bitstream = createBitstreamHeader(enc.pcLimit, currAxis, fullContextVector, length_bitstreamParam);
    
    %Merges all bitstreams.
    bitstream = bitstream.merge(bitstreamParam);
    bitstream = bitstream.merge(cabac.BACEngine.bitstream);    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    totalRate = (ceil(bitstream.size() / 8) * 8) + 1;
    
    rateBPOVPerAxis(k) = totalRate / enc.numberOfOccupiedVoxels;
    entropyValue(k) = FinalH;
    if (totalRate < bestRate)
        bestAxis      = currAxis;
        bestRate      = totalRate;
        bestGeoCube   = [];
        bestStat      = cabac.StatInter;
        bestBitstream = bitstream;
    end
    
    tEnd_Axis = toc(tStart_Axis);
    if (k == 1)
        disp(['Axis X - Rate    = ' num2str(rateBPOVPerAxis(1),'%2.4f') ' bpov - Encoding Time = ' num2str(tEnd_Axis,'%2.1f') ' seconds.'])
        disp(['Axis X - Entropy = ' num2str(entropyValue(1),'%2.4f')])
    elseif (k == 2)
        disp(['Axis Y - Rate    = ' num2str(rateBPOVPerAxis(2),'%2.4f') ' bpov - Encoding Time = ' num2str(tEnd_Axis,'%2.1f') ' seconds.'])
        disp(['Axis Y - Entropy = ' num2str(entropyValue(2),'%2.4f')])
    elseif (k == 3)
        disp(['Axis Z - Rate    = ' num2str(rateBPOVPerAxis(3),'%2.4f') ' bpov - Encoding Time = ' num2str(tEnd_Axis,'%2.1f') ' seconds.'])
        disp(['Axis Z - Entropy = ' num2str(entropyValue(3),'%2.4f')])
    end
    vectorsSelectedMsg(enc);
    
end

%Writes the encoder out.
enc.rate               = bestRate;
enc.rate_bpov          = bestRate / enc.numberOfOccupiedVoxels;
enc.bitstream          = bestBitstream;
enc.dimensionSliced    = bestAxis;
enc.geometryCube       = bestGeoCube;
enc.rate_bpov_per_axis = rateBPOVPerAxis;
enc.stat               = bestStat;
enc.entropy_value      = entropyValue;

%Writes the bitstream.
bitstreamFile     = [enc.params.workspaceFolder enc.params.bitstreamFile];
disp(['Writing to file ' bitstreamFile ''])
bestBitstream.flushesToFile(bitstreamFile);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
