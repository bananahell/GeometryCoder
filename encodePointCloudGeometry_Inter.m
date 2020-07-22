% function enc = encodePointCloudGeometry_Inter
%  - Input Parameters: 
%     - inputFile       - The complete path for the point cloud to be encoded.
%     - predictionFile  - The complete path for the reference point cloud.
%     - outputFile      - The complete path for the output binary file.
%
%  - Output Parameters
%     - enc        - the Encoder Data structure.
%
% Ex: enc =
% encodePointCloudGeometry_Inter(
%    'C:\eduardo\Sequences\PointClouds\ricardo9\ply\frame0001.ply' ,
%    'C:\eduardo\Sequences\PointClouds\ricardo9\ply\frame0000.ply' ,
%    'C:\workspace\ricardo_frame0000.bin' );
%
% Optional arguments:
% Usage: enc = encodePointCloudGeometry_Inter(inputFile, predictionFile, outputFile,'param_key',param_value, ...)
% 
%   `numberOfSlicesToTestSingleMode`
%      Possible Values: [0 1 2 4 8 16 32 64 128 256 512 1024]
% 	 Default: 16
% 	 This marks the point at which the single-mode encoding starts being considered in addition to the dyadic decomposition. 
% 	 
% 	 
%   `mode`
%      Possible Values: [0 1 2]
% 	 Default: 0
% 	 As explained in the paper, the codec has three modes:
%     0 - S4D             - This is the algorithm using the Multi-Mode decision (i.e., it considers both 3D and 4D contexts) and the proposed fast mode decision.
% 	  1 - S4D-Multi-Mode  - This is the algorithm using the Multi-Mode decision (i.e., it considers both 3D and 4D contexts) but it tests both contexts and decides for the best. 
% 	  2 - S4D-Inter       - This is the algorithm considering only 4D contexts. 
%   
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
% 27/05/2020
function enc = encodePointCloudGeometry_Inter(inputFile, predictionFile, outputFile, varargin)

if (nargin == 3)
    defaultParameters = 1;
else
    defaultParameters = 0;
end

disp('Running Point Cloud Inter Geometry Coder based on Dyadic Decomposition')
disp('Author: Eduardo Peixoto  - eduardopeixoto@ieee.org')
disp('Author: Edil Medeiros    - j.edil@ene.unb.br ')
disp('Author: Evaristo Ramalho - evaristora28@gmail.com')
disp('Universidade de Brasilia')
disp('Electrical Engineering Department')
disp(' ')

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
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Writes the output.
disp(' ')
disp(' ')
disp('==============================================')
disp(['Encoding file ' pointCloudFile ''])
disp(['Elapsed Time Encoding: ' num2str(encTime, '%2.1f') ' seconds.'])
disp(['Rate  = ' num2str(enc.rate_bpov,'%2.4f') ' bpov.'])
disp('==============================================')