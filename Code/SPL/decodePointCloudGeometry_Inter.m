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

if (nargin == 3)
    defaultParameters = 1;
else
    defaultParameters = 0;
end

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
if (defaultParameters == 1)
    params = initParams();
else
    params = initParams(varargin);
end

params.workspaceFolder = workspaceFolder;
params.dataFolder      = '';
params.pointCloudFile  = '';
params.outputPlyFile   = outputFile;
params.predictionFile  = predictionFile;
params.bitstreamFile   = bitstreamFile;
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