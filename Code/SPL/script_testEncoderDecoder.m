%Script script_testEncoderDecoder
%
%  This script tests both the encoder and the decoder of the proposed
%  Geometry Coder using Dyadic Decomposition.
%
%  First, it takes the file inputPly, encodes it using the Geometry
%  Coder, and writes a bitstream to file binaryFile.
%
%  Then, it opens this binaryFile, decodes it, and outputs a Ply file in 
%  outputPly.
%
%  Finally, it compares both the geometry Cube in both the encoder and
%  decoder and the two Ply files, and writes if they are equal.
%  Note that the outputPly file does NOT contain any colour information,
%  and the points may be in a different order than the original inputPly
%  file.
%  
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
% 29/10/2019

%Files Used:
%Change this to reflect your system
inputPly   = '../frame0000.ply';
binaryFile = '../ricardo_frame0000.bin';
outputPly  = '../dec_ricardo_frame0000.ply';

%Runs the Encoder
enc = encodePointCloudGeometry(inputPly,binaryFile);

%Runs the Decoder
dec = decodePointCloudGeometry(binaryFile,outputPly);

%Checks the geometry cubes.
checkCube = isequal(enc.geometryCube,dec.geometryCube);

%Checks the two Ply
checkPly  = comparePlys(inputPly, outputPly);

%EDUARDO: Isso aqui funciona mas demora pra caceta. Mas � bom pra debugar.
%List points that ARE in the outputPly but are NOT in the input ply
[eq, diffPoints] = listPointsInPly1ThatAreNotInPly2(outputPly, inputPly);
disp(['The following points are found in the outputPly but are NOT in the inputPly:'])
disp(diffPoints)

%List points that ARE in the inputPly but are NOT in the outputPly
[eq, diffPoints2] = listPointsInPly1ThatAreNotInPly2(inputPly, outputPly);
disp(['The following points are found in the inputPly but are NOT in the outputPly:'])
disp(diffPoints2)

disp(' ')
disp('==============================================')
if (checkCube == 1)
    disp('The encoder and decoder geometry cubes are equal.')
else
    disp('The encoder and decoder geometry cubes are NOT equal.')
end
if (checkPly == 1)
    disp('The encoder and decoder Ply Geometry are equal.')
else
    disp('The encoder and decoder Ply Geometry are NOT equal.')
end
disp('==============================================')%
