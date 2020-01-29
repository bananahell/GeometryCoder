%Script script_testMan
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
prevPly    = 'C:\eduardo\Sequences\PointClouds\man29\ply\frame0000.ply';
inputPly   = 'C:\eduardo\Sequences\PointClouds\man29\ply\frame0001.ply';
binaryFile = 'C:\eduardo\workspace\ICIP_Inter\Test_Man\man_frame0001.bin';
outputPly  = 'C:\eduardo\workspace\ICIP_Inter\Test_Man\dec_man_frame0001.ply';

tabela = [1 9 5 5 
          9 9 5 5
          9 1 5 5
          1 9 4 5
          1 9 3 5
          1 9 5 4
          1 9 5 3];
      
for (i = 1:1:length(tabela))
          
    %Runs the Encoder
    encStartTime = tic;
    enc = encodePointCloudGeometry_Inter(inputPly, prevPly, binaryFile,'test3DOnlyContextsForInter',1,'fastChoice3Dvs4D',0,'numberOf4DContexts',tabela(i,1),'numberOf3DContexts',tabela(i,2),'numberOfContextsMasked',tabela(i,3),'numberOfContexts3DOnly',tabela(i,4));
    encTime = toc(encStartTime);
    
    %Runs the Decoder
    decStartTime = tic;
    dec = decodePointCloudGeometry_Inter(binaryFile, prevPly, outputPly,'numberOf4DContexts',tabela(i,1),'numberOf3DContexts',tabela(i,2),'numberOfContextsMasked',tabela(i,3),'numberOfContexts3DOnly',tabela(i,4));
    decTime = toc(decStartTime);
    
    %Checks the two Ply
    tCheck = tic;
    checkPly  = comparePlys2(inputPly, outputPly);
    elapsedTimeCheck = toc(tCheck);
    
    bestAxis = find('xyz' == enc.dimensionSliced);
    
    %Writes the results
    filename = ['C:\eduardo\workspace\ICIP_Inter\Test_Man\results_inter.txt'];
    fid = fopen(filename,'a');
    fprintf(fid,'%d\t%d\t%2.2f\t%2.2f\t%2.4f\t%2.4f\t%2.4f\t%2.4f\n',bestAxis, checkPly,encTime, decTime, enc.rate_bpov_per_axis(1), enc.rate_bpov_per_axis(2), enc.rate_bpov_per_axis(3), enc.rate_bpov);
    fclose(fid);
end

