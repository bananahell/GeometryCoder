% function dec = decodePointCloudGeometry
%  - Input Parameters: 
%     - inputFile  - The complete path for the input binary file.
%     - outputFile - The complete path for the output Ply
%
%  - Output Parameters
%     - dec        - the Decoder Data structure.
%
% Ex: dec =
% decodePointCloudGeometry(
%    'C:\workspace\ricardo_frame0000.bin' ,
%    'C:\workspace\dec_ricardo_frame0000.ply' );
%   
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
% 29/10/2019
function dec = decodePointCloudGeometry_Inter(inputFile, predictionFile, outputFile)

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

%This file only needs to be open.
predictionFile(predictionFile == '\') = '/';

if (isempty(outputFile))
    error('Empty output File.');
else
    if (~ischar(outputFile))
        error('The output file must be a string');
    end
end
%----------------------------------------------


%----------------------------------------------
%These are the settings for the ICIP Results.
numberOfContextsIndependent = 3;
numberOfContextsMasked      = 3;
windowSizeFor3DContexts     = 1;
numberOf3DContexts          = 9;
windowSizeFor4DContexts     = 1;
numberOf4DContexts          = 0;
numberOfContextsParams      = 4;

testMode       = [1 1];
verbose        = 0;
%----------------------------------------------

%----------------------------------------------
%Parses the input
inputFile(inputFile == '\') = '/'; 
idx = find(inputFile == '/',1,'last');
if (isempty(idx))
    workspaceFolder = '';
    bitstreamFile   = inputFile;
else
    workspaceFolder = inputFile(1:idx);
    bitstreamFile   = inputFile(idx+1:end);    
end

outputFile(outputFile == '\') = '/'; 
%----------------------------------------------



%-----------------------------------------------
params = getEncoderParams();
params.sequence        = '';
params.workspaceFolder = workspaceFolder;
params.dataFolder      = '';
params.pointCloudFile  = '';
params.predictionFile  = predictionFile;
params.bitstreamFile   = bitstreamFile;
params.outputPlyFile   = outputFile;
params.matlabFile      = '';
params.testMode        = testMode;
params.verbose         = 0;
params.JBIGFolder      = '';
params.BACParams.numberOfContextsIndependent = numberOfContextsIndependent;
params.BACParams.numberOfContextsMasked      = numberOfContextsMasked;
params.BACParams.windowSizeFor3DContexts     = windowSizeFor3DContexts;
params.BACParams.numberOf3DContexts          = numberOf3DContexts;
params.BACParams.windowSizeFor4DContexts     = windowSizeFor4DContexts;
params.BACParams.numberOf4DContexts          = numberOf4DContexts;
params.BACParams.numberOfContextsParams      = numberOfContextsParams;
%-----------------------------------------------

%Decodes the PointCloud
tStart = tic;
dec = getDecoder();
dec.params = params;

%Loads the prediction point cloud.
dec.predictionPointCloud = loadPredictionPointCloud(dec.params.predictionFile);

dec = decodeGeometryInter(dec);
decTime = toc(tStart);

disp(' ')
disp('==============================================')
disp(['Decoding time for ' bitstreamFile '  = ' num2str(decTime,'%2.1f') ' seconds.'])
disp('==============================================')