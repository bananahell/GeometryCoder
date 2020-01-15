% function enc = encodePointCloudGeometry
%  - Input Parameters: 
%     - inputFile  - The complete path for the point cloud to be encoded.
%     - outputFile - The complete path for the output binary file.
%
%  - Output Parameters
%     - enc        - the Encoder Data structure.
%
% Ex: enc =
% encodePointCloudGeometry(
%    'C:\eduardo\Sequences\PointClouds\ricardo9\ply\frame0000.ply' ,
%    'C:\workspace\ricardo_frame0000.bin' );
%   
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
% 29/10/2019
function enc = encodePointCloudGeometry_Inter(inputFile, predictionFile, outputFile)

disp('Running Point Cloud Geometry Coder based on Dyadic Decomposition')
disp('Author: Eduardo Peixoto')
disp('E-mail: eduardopeixoto@ieee.org')
disp('Universidade de Brasilia')

%----------------------------------------------
%Performs a basic parameter check.
if (isempty(inputFile))
    error('Empty input File.');
else
    if (~ischar(inputFile))
        error('The input file must be a string');
    end
end

if (isempty(outputFile))
    error('Empty output File.');
else
    if (~ischar(outputFile))
        error('The output file must be a string');
    end
end
%----------------------------------------------

%----------------------------------------------
%These are the settings for the SPL Results.
numberOfContextsIndependent = 1;
numberOfContextsMasked      = 1;
windowSizeFor3DContexts     = 1;
numberOf3DContexts          = 9;
windowSizeFor4DContexts     = 0;
numberOf4DContexts          = 1;
numberOfContextsParams      = 4;

testMode       = [1 1];
verbose        = 0;
%----------------------------------------------

%----------------------------------------------
%Parses the input
inputFile(inputFile == '\') = '/'; 
idx = find(inputFile == '/',1,'last');
if (isempty(idx))
    dataFolder = '';
    pointCloudFile = inputFile;
else
    dataFolder = inputFile(1:idx);
    pointCloudFile = inputFile(idx+1:end);    
end

%This file only needs to be open.
predictionFile(predictionFile == '\') = '/'; 

outputFile(outputFile == '\') = '/'; 
idx = find(outputFile == '/',1,'last');
if (isempty(idx))
    workspaceFolder = '';
    bitstreamFile = outputFile;
else
    workspaceFolder = outputFile(1:idx);
    bitstreamFile = outputFile(idx+1:end);    
end 
%----------------------------------------------

%-----------------------------------------------
params = getEncoderParams();
params.sequence        = '';
params.workspaceFolder = workspaceFolder;
params.dataFolder      = dataFolder;
params.pointCloudFile  = pointCloudFile;
params.predictionFile  = predictionFile;
params.bitstreamFile   = bitstreamFile;
params.outputPlyFile   = '';
params.matlabFile      = '';
params.testMode        = testMode;
params.verbose         = verbose;
params.JBIGFolder      = '';
params.BACParams.numberOfContextsIndependent = numberOfContextsIndependent;
params.BACParams.numberOfContextsMasked      = numberOfContextsMasked;
params.BACParams.windowSizeFor3DContexts     = windowSizeFor3DContexts;
params.BACParams.numberOf3DContexts          = numberOf3DContexts;
params.BACParams.windowSizeFor4DContexts     = windowSizeFor4DContexts;
params.BACParams.numberOf4DContexts          = numberOf4DContexts;
params.BACParams.numberOfContextsParams      = numberOfContextsParams;

%-----------------------------------------------

%-----------------------------------------------
enc = getEncoder();
enc.params = params;

tStart = tic;
%Loads the PointCloud
enc = loadPointCloud(enc);

%Encodes the PointCloud
[enc, ~] = encodeGeometryInter(enc);

encTime = toc(tStart);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Writes the output.
disp(' ')
disp(' ')
disp('==============================================')
disp(['Encoding file ' pointCloudFile ''])
disp(['Elapsed Time Encoding: ' num2str(encTime, '%2.1f') ' seconds.'])
disp(['Rate  = ' num2str(enc.rate_bpov,'%2.4f') ' bpov.'])
disp('==============================================')