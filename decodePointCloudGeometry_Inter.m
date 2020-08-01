% function dec = decodePointCloudGeometry_Inter
%  - Input Parameters: 
%     - inputFile  - The complete path for the input binary file.
%     - predictionFile  - The complete path for the reference point cloud.
%     - outputFile - The complete path for the output Ply
%
%  - Output Parameters
%     - dec        - the Decoder Data structure.
%
% Ex: dec =
% decodePointCloudGeometry(
%    'C:\workspace\ricardo_frame0000.bin' ,
%    'C:\eduardo\Sequences\PointClouds\ricardo9\ply\frame0000.ply' ,
%    'C:\workspace\dec_ricardo_frame0000.ply' );
%   
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
% 27/05/2020
function dec = decodePointCloudGeometry_Inter(inputFile, predictionFile, outputFile)

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
%Defines the decoder parameters.
params = getEncoderParams();
params.sequence        = '';
params.workspaceFolder = workspaceFolder;
params.dataFolder      = '';
params.pointCloudFile  = '';
params.predictionFile  = predictionFile;
params.bitstreamFile   = bitstreamFile;
params.outputPlyFile   = outputFile;
params.matlabFile      = '';
params.testMode        = [1 1];
params.verbose         = 0;
params.JBIGFolder      = '';

params.BACParams.numberOfContextsIndependent = 3;
params.BACParams.numberOfContextsMasked      = 3;
params.BACParams.windowSizeFor3DContexts     = 1;
params.BACParams.numberOf3DContexts          = 9;
params.BACParams.windowSizeFor4DContexts     = 1;
params.BACParams.numberOf4DContexts          = 1;
params.BACParams.numberOfContexts3DOnly      = 5;
params.BACParams.numberOfContextsParams      = 4;
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