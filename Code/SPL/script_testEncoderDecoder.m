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
inputPly   = 'C:\Users\drcft\OneDrive\Documents\UnB\Mestrado\Pesquisas\Correlacao\Point Clouds\ricardo9\ricardo9\ply\frame0000.ply'
% inputPly   = 'C:\Users\drcft\OneDrive\Documents\UnB\Mestrado\Pesquisas\Sequences\longdress_vox10\longdress_vox10_1300.ply';
% binaryFile = '..\longdress_vox10_1300.bin';
% outputPly  = '..\longdress_vox10_1300.ply';
binaryFile = '..\ricardo9_frame0000.bin';
outputPly  = '..\ricardo9_frame0000.ply';

%Runs the Encoder
enc = encodePointCloudGeometry(inputPly,binaryFile);

%Runs the Decoder
dec = decodePointCloudGeometry(binaryFile,outputPly);

%Checks the geometry cubes.
checkCube = isequal(enc.geometryCube,dec.geometryCube);

%Checks the two Ply
checkPly  = comparePlys(inputPly, outputPly);

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

% Compute metrics for lossy encoding
pc = pcread(inputPly);
V_a = pc.Location;
pc = pcread(outputPly);
V_b = pc.Location;

pt2pt = src_metrics_point_metrics(V_a, V_b);

disp(strcat('MSE Point-to-Point:', {' '}, int2str(pt2pt.p2point_mse)));
disp(strcat('PSNR Point-to-Point:', {' '}, int2str(pt2pt.p2point_psnr), 'dB'));
disp('==============================================')%
