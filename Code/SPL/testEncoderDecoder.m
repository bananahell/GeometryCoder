% Function testEncoderDecoder
%
%  This function tests both the encoder and the decoder of the proposed
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

function testEncoderDecoder(inputPly, binaryFile, outputPly)
  global toggleSlicesFlags;
  global toggleSlicesIndexes;
  global encoderType;
  % When I ran my "best to remove logic order", I got this index order
  % toggleSlicesIndexes = [84 111 71 85 82 83 76 78 75 110 77 79 105 108 86 74 106 80 72 100 61 103 70 89 90 97 73 116 95 102 87 101 81 88 93 120 60 99 91 14 96 119 114 125 118 104 28 92 109 94 68 107 26 124 98 27 115 67 122 25 59 17 16 10 12 15 37 13 123 32 66 112 172 151 29 58 149 62 36 117 152 24 38 173 170 44 40 57 18 23 142 176 69 19 169 140 166 8 31 35 34 144 141 175 30 20 167 127 56 153 126 55 155 47 165 45 128 11 138 33 39 48 137 171 146 42 41 150 46 143 156 22 174 113 131 21 43 52 130 9 132 134 121 139 145 50 154 160 133 6 54 148 135 161 51 168 159 157 5 53 7 179 163 158 129 177 178 147 49 136 164 162 3 4 65 182 181 180 2 184 63 183 185 186 1 64];
  % So I made these 10 flag arrays getting the best until the worst in the top 10 (and I made an absolute worst case in the end after the 10th too)
  % toggleSlicesFlags10 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 0 1 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];

  %Runs the Encoder
  encoderType = 'lossy encoder';
  enc = encodePointCloudGeometry(inputPly, binaryFile);

  %Runs the Decoder
  dec = decodePointCloudGeometry(binaryFile, outputPly);

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

  % %Checks the geometry cubes.
  % checkCube = isequal(enc.geometryCube,dec.geometryCube);
  %
  % %Checks the two Ply
  % checkPly  = comparePlys(inputPly, outputPly);
  %
  % % disp(' ')
  % % disp('==============================================')
  % disp(' ');
  % if (checkCube == 1)
  %     disp('[RESULT] The off encoder and off decoder geometry cubes are equal.');
  % else
  %     disp('[RESULT] The off encoder and off decoder geometry cubes are NOT equal.');
  % end
  % if (checkPly == 1)
  %     disp('[RESULT] The original and off Ply Geometries are equal.');
  % else
  %     disp('[RESULT] The original and off Ply Geometries are NOT equal.');
  % end
  % % disp('==============================================')%


  % figure("Name", "Input ply");
  % pcshow(inputPly);
  % figure("Name", "Output ply");
  % pcshow(outputPly);
end
