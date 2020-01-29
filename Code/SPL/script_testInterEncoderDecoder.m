%Script script_testInterEncoderDecoder
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
% prevPly    = 'C:\eduardo\Sequences\PointClouds\longdress\Ply\longdress_vox10_1051.ply';
% inputPly   = 'C:\eduardo\Sequences\PointClouds\longdress\Ply\longdress_vox10_1052.ply';
% binaryFile = 'C:\eduardo\workspace\ICIP_Inter\longdress_vox10_1052.bin';
% outputPly  = 'C:\eduardo\workspace\ICIP_Inter\dec_longdress_vox10_1052.ply';


prevPly    = 'C:\eduardo\Sequences\PointClouds\ricardo9\ply\frame0000.ply';
inputPly   = 'C:\eduardo\Sequences\PointClouds\ricardo9\ply\frame0001.ply';
binaryFile = 'C:\eduardo\workspace\ICIP_Inter\ricardo_frame0001.bin';
outputPly  = 'C:\eduardo\workspace\ICIP_Inter\dec_ricardo_frame0001.ply';

% prevPly    = 'C:\eduardo\Sequences\PointClouds\andrew9\ply\frame0000.ply';
% inputPly   = 'C:\eduardo\Sequences\PointClouds\andrew9\ply\frame0001.ply';
% binaryFile = 'C:\eduardo\workspace\ICIP_Inter\andrew_frame0001.bin';
% outputPly  = 'C:\eduardo\workspace\ICIP_Inter\dec_andrew_frame0001.ply';

% prevPly    = 'C:\eduardo\Sequences\PointClouds\soldier\Ply\soldier_vox10_0536.ply';
% inputPly   = 'C:\eduardo\Sequences\PointClouds\soldier\Ply\soldier_vox10_0537.ply';
% binaryFile = 'C:\eduardo\workspace\ICIP_Inter\soldier_0537.bin';
% outputPly  = 'C:\eduardo\workspace\ICIP_Inter\dec_soldier_0537.ply';

%Runs the Encoder
enc = encodePointCloudGeometry_Inter(inputPly, prevPly, binaryFile,'test3DOnlyContextsForInter',1,'fastChoice3Dvs4D',1);

%Runs the Decoder
dec = decodePointCloudGeometry_Inter(binaryFile, prevPly, outputPly);

%Checks the two Ply
tCheck = tic;
checkPly  = comparePlys2(inputPly, outputPly);
elapsedTimeCheck = toc(tCheck);

disp(' ')
disp('==============================================')
disp(['Elapsed time for checking: ' num2str(elapsedTimeCheck,'%2.2f') ' seconds'])
if (checkPly == 1)
    disp('The encoder and decoder Ply Geometry are equal.')
else
    disp('The encoder and decoder Ply Geometry are NOT equal.')
end
disp('==============================================')%
