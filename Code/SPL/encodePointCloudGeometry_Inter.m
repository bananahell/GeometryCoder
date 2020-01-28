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
function enc = encodePointCloudGeometry_Inter(inputFile, predictionFile, outputFile, varargin)

if (nargin == 3)
    defaultParameters = 1;
else
    defaultParameters = 0;
end

disp('Running Point Cloud Inter Geometry Coder based on Dyadic Decomposition')
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

if (isempty(predictionFile))
    error('Empty prediction File.');
else
    if (~ischar(predictionFile))
        error('The prediction file must be a string');
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
if (defaultParameters == 1)
    params = initParams();
else
    params = initParams(varargin);
end

params.workspaceFolder = workspaceFolder;
params.dataFolder      = dataFolder;
params.pointCloudFile  = pointCloudFile;
params.predictionFile  = predictionFile;
params.bitstreamFile   = bitstreamFile;
%-----------------------------------------------

%-----------------------------------------------
enc = getEncoder();
enc.params = params;

tStart = tic;
%Loads the PointCloud to be encoded.
enc = loadPointCloud(enc);

%Loads the prediction point cloud.
enc.predictionPointCloud = loadPredictionPointCloud(enc.params.predictionFile);

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