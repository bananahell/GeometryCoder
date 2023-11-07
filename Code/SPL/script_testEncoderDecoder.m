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

global toggleSlicesFlags;
global toggleSlicesIndexes;
global lossyProcesing;
global encoderType;
% When I ran my "best to remove logic order", I got this index order
% toggleSlicesIndexes = [84 111 71 85 82 83 76 78 75 110 77 79 105 108 86 74 106 80 72 100 61 103 70 89 90 97 73 116 95 102 87 101 81 88 93 120 60 99 91 14 96 119 114 125 118 104 28 92 109 94 68 107 26 124 98 27 115 67 122 25 59 17 16 10 12 15 37 13 123 32 66 112 172 151 29 58 149 62 36 117 152 24 38 173 170 44 40 57 18 23 142 176 69 19 169 140 166 8 31 35 34 144 141 175 30 20 167 127 56 153 126 55 155 47 165 45 128 11 138 33 39 48 137 171 146 42 41 150 46 143 156 22 174 113 131 21 43 52 130 9 132 134 121 139 145 50 154 160 133 6 54 148 135 161 51 168 159 157 5 53 7 179 163 158 129 177 178 147 49 136 164 162 3 4 65 182 181 180 2 184 63 183 185 186 1 64];
% So I made these 10 flag arrays getting the best until the worst in the top 10 (and I made an absolute worst case in the end after the 10th too)
toggleSlicesFlags00 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
toggleSlicesFlags01 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
toggleSlicesFlags02 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
toggleSlicesFlags03 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
toggleSlicesFlags04 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
toggleSlicesFlags05 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 1 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
toggleSlicesFlags06 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
toggleSlicesFlags07 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
toggleSlicesFlags08 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 1 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
toggleSlicesFlags09 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 0 1 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
toggleSlicesFlags10 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 0 1 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
% toggleSlicesFlagsAll = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];

%Files Used:
%Change this to reflect your system
inputPly   = '../frame0000.ply';
binaryFileOff = '../ricardo_frame0000-off.bin';
binaryFile00 = '../ricardo_frame0000-00.bin';
binaryFile01 = '../ricardo_frame0000-01.bin';
binaryFile02 = '../ricardo_frame0000-02.bin';
binaryFile03 = '../ricardo_frame0000-03.bin';
binaryFile04 = '../ricardo_frame0000-04.bin';
binaryFile05 = '../ricardo_frame0000-05.bin';
binaryFile06 = '../ricardo_frame0000-06.bin';
binaryFile07 = '../ricardo_frame0000-07.bin';
binaryFile08 = '../ricardo_frame0000-08.bin';
binaryFile09 = '../ricardo_frame0000-09.bin';
binaryFile10 = '../ricardo_frame0000-10.bin';
outputPlyOff  = '../dec_ricardo_frame0000-off.ply';
outputPly00  = '../dec_ricardo_frame0000-00.ply';
outputPly01  = '../dec_ricardo_frame0000-01.ply';
outputPly02  = '../dec_ricardo_frame0000-02.ply';
outputPly03  = '../dec_ricardo_frame0000-03.ply';
outputPly04  = '../dec_ricardo_frame0000-04.ply';
outputPly05  = '../dec_ricardo_frame0000-05.ply';
outputPly06  = '../dec_ricardo_frame0000-06.ply';
outputPly07  = '../dec_ricardo_frame0000-07.ply';
outputPly08  = '../dec_ricardo_frame0000-08.ply';
outputPly09  = '../dec_ricardo_frame0000-09.ply';
outputPly10  = '../dec_ricardo_frame0000-10.ply';

%Runs the Encoder
lossyProcesing = false;
encoderType = 'off encoder';
encOff = encodePointCloudGeometry(inputPly,binaryFileOff);

lossyProcesing = true;
toggleSlicesFlags = toggleSlicesFlags00;
encoderType = '00 encoder';
enc00 = encodePointCloudGeometry(inputPly, binaryFile00);
toggleSlicesFlags = toggleSlicesFlags01;
encoderType = '01 encoder';
enc01 = encodePointCloudGeometry(inputPly, binaryFile01);
toggleSlicesFlags = toggleSlicesFlags02;
encoderType = '02 encoder';
enc02 = encodePointCloudGeometry(inputPly, binaryFile02);
toggleSlicesFlags = toggleSlicesFlags03;
encoderType = '03 encoder';
enc03 = encodePointCloudGeometry(inputPly, binaryFile03);
toggleSlicesFlags = toggleSlicesFlags04;
encoderType = '04 encoder';
enc04 = encodePointCloudGeometry(inputPly, binaryFile04);
% toggleSlicesFlags = toggleSlicesFlags05;
% encoderType = '05 encoder';
% enc05 = encodePointCloudGeometry(inputPly, binaryFile05);
% toggleSlicesFlags = toggleSlicesFlags06;
% encoderType = '06 encoder';
% enc06 = encodePointCloudGeometry(inputPly, binaryFile06);
% toggleSlicesFlags = toggleSlicesFlags07;
% encoderType = '07 encoder';
% enc07 = encodePointCloudGeometry(inputPly, binaryFile07);
% toggleSlicesFlags = toggleSlicesFlags08;
% encoderType = '08 encoder';
% enc08 = encodePointCloudGeometry(inputPly, binaryFile08);
% toggleSlicesFlags = toggleSlicesFlags09;
% encoderType = '09 encoder';
% enc09 = encodePointCloudGeometry(inputPly, binaryFile09);
% toggleSlicesFlags = toggleSlicesFlags10;
% encoderType = '10 encoder';
% enc10 = encodePointCloudGeometry(inputPly, binaryFile10);

%Runs the Decoder
decOff = decodePointCloudGeometry(binaryFileOff, outputPlyOff);
dec00 = decodePointCloudGeometry(binaryFile00, outputPly00);
dec01 = decodePointCloudGeometry(binaryFile01, outputPly01);
dec02 = decodePointCloudGeometry(binaryFile02, outputPly02);
dec03 = decodePointCloudGeometry(binaryFile03, outputPly03);
dec04 = decodePointCloudGeometry(binaryFile04, outputPly04);
% dec05 = decodePointCloudGeometry(binaryFile05, outputPly05);
% dec06 = decodePointCloudGeometry(binaryFile06, outputPly06);
% dec07 = decodePointCloudGeometry(binaryFile07, outputPly07);
% dec08 = decodePointCloudGeometry(binaryFile08, outputPly08);
% dec09 = decodePointCloudGeometry(binaryFile09, outputPly09);
% dec10 = decodePointCloudGeometry(binaryFile10, outputPly10);

% %EDUARDO: Isso aqui funciona mas demora pra caceta. Mas � bom pra debugar.
% %List points that ARE in the outputPly but are NOT in the input ply
% [eq, diffPoints] = listPointsInPly1ThatAreNotInPly2(outputPly, inputPly);
% disp(['The following points are found in the outputPly but are NOT in the inputPly:'])
% disp(diffPoints)
% 
% %List points that ARE in the inputPly but are NOT in the outputPly
% [eq, diffPoints2] = listPointsInPly1ThatAreNotInPly2(inputPly, outputPly);
% disp(['The following points are found in the inputPly but are NOT in the outputPly:'])
% disp(diffPoints2)

%Checks the geometry cubes.
checkCube = isequal(encOff.geometryCube,decOff.geometryCube);

%Checks the two Ply
checkPly  = comparePlys(inputPly, outputPlyOff);

% disp(' ')
% disp('==============================================')
disp(' ');
if (checkCube == 1)
    disp('[RESULT] The off encoder and off decoder geometry cubes are equal.');
else
    disp('[RESULT] The off encoder and off decoder geometry cubes are NOT equal.');
end
if (checkPly == 1)
    disp('[RESULT] The original and off Ply Geometries are equal.');
else
    disp('[RESULT] The original and off Ply Geometries are NOT equal.');
end
% disp('==============================================')%

%Checks the geometry cubes.
checkCube = isequal(enc00.geometryCube,dec00.geometryCube);

%Checks the two Ply
checkPly  = comparePlys(inputPly, outputPly00);

% disp(' ')
% disp('==============================================')
disp(' ');
if (checkCube == 1)
    disp('[RESULT] The 00 encoder and 00 decoder geometry cubes are equal.');
else
    disp('[RESULT] The 00 encoder and 00 decoder geometry cubes are NOT equal.');
end
if (checkPly == 1)
    disp('[RESULT] The original and 00 Ply Geometries are equal.');
else
    disp('[RESULT] The original and 00 Ply Geometries are NOT equal.');
end
% disp('==============================================')%

disp(' ');
disp('[FINISH] Finished all operations!')
