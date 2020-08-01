% function enc = calcEntropyPC
%  - Input Parameters: 
%     - inputFile       - The complete path for the point cloud to be encoded.
%     - predictionFile  - The complete path for the reference point cloud.
%
%  - Output Parameters
%     - H        - the Final Entropy.
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
% 27/05/2020
function H = calcEntropyPC(inputFile, predictionFile)

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
%----------------------------------------------

%-----------------------------------------------
params = initParams();

params.workspaceFolder = '';
params.dataFolder      = dataFolder;
params.pointCloudFile  = pointCloudFile;
params.predictionFile  = predictionFile;
%-----------------------------------------------

%-----------------------------------------------
enc = getEncoder();
enc.params = params;

%Loads the PointCloud to be encoded.
enc = loadPointCloud(enc);

%Loads the prediction point cloud.
enc.predictionPointCloud = loadPredictionPointCloud(enc.params.predictionFile);

posBinInd = dec2bin(0:2^15-1);
structTables = createContextTableInter(enc,'y',1,512);

H1 = zeros(1,24);
H2 = zeros(1,24);
H3 = zeros(1,24);
H4 = zeros(1,24);
H5 = zeros(1,24);

for h = 1:24
    structVector = generateAllContextVector_v2(h);
    if h<7
        H1(h) = calcHContextsBits(structTables.BACContexts_2D_Masked,structVector.context2DMasked,posBinInd);
    end
    if h<15
        H2(h) = calcHContextsBits3D(structTables.BACContexts_3D_ORImages,structVector.context3DORImages,posBinInd);
        H3(h) = calcHContextsBits3D(structTables.BACContexts_2DT_Independent,structVector.contexts2DTIndependent,posBinInd);
        H4(h) = calcHContextsBits3D(structTables.BACContexts_2DT_Masked,structVector.contexts2DTMasked,posBinInd);        
    end
    H5(h) = calcHContextsBits4D(structTables.BACContexts_3DT_ORImages,structVector.contexts3DTORImages,posBinInd);
end

H = H5 + H1 + H3 + H4 + H2;
%enc         = addContextVectors(enc,structVector);

