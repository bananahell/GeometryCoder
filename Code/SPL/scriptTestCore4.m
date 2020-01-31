%Script scriptRunEncoder
%
%  This script encodes all files in the JPEG Pleno dataset.
%  The JPEG Pleno dataset can be downloaded at:
%     https://jpeg.org/plenodb/
%  Both the Microsoft Voxelized Upper Bodies [1] dataset and the 
%  8i Voxelized Full Bodies [2] dataset can be encoded.
%  Note that the 9 bits sequences in the Upper Bodies Dataset run in a
%  reasonable time (around 120 seconds) in a good Desktop PC, but the 10
%  bits sequences take significantly longer (from 3000 to 6000 seconds,
%  depending on the number of voxels). 
%  To run this script, you must first write the datasetFolder as the
%  basis Folder where the data is kept.
%
%   [1] C. Loop, Q. Cai, S. O. Escolano, and P. A. Chou, "Microsoft 
%       Voxelized Upper Bodies � A Voxelized Point Cloud Dataset," ISO/IEC 
%       JTC1/SC29/WG11 m38673 ISO/IEC JTC1/SC29/WG1 M72012, Geneva, 
%       Switzerland, Tech. Rep., 2016.
%
%   [2] E. d�Eon, B. Harrison, T. Myers, and P. A. Chou, "8i Voxelized
%       Full Bodies, version 2 � A Voxelized Point Cloud Dataset," ISO/IEC
%       JTC1/SC29/WG11 m40059 ISO/IEC JTC1/SC29/WG1 M74006 Geneva, 
%       Switzerland, Tech. Rep., 2017.
%
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
% 29/10/2019

%Change this to reflect your system
%The output folders must exist before the script is executed.
datasetFolder  = 'C:\eduardo\Sequences\PointClouds\';
outputFolder   = 'C:\eduardo\workspace\ICIP_Inter\Results\';

k = 0;

k = k + 1;
%longdress
sequence{k}        = 'soldier';
name{k}            = 'soldier_vox10_';
parentFolder{k}    = outputFolder;
newFolder{k}       = 'soldier';
dataFolder{k}      = [datasetFolder 'soldier\Ply\'];
workspaceFolder{k} = [outputFolder 'soldier\'];
frameStart{k}      = 0537;
frameEnd{k}        = 0637;



N = k;
for k = 1:1:N
    for i = frameStart{k}:1:frameEnd{k}
        strNumFile = num2str(i);
        leadingZeros = char(zeros(1,4 - length(strNumFile)) + 48);
        filename = [name{k} '' leadingZeros '' strNumFile ''];
        strNumFile = ['' leadingZeros '' strNumFile ''];
        
        strNumPrev = num2str(i-1);
        leadingZeros = char(zeros(1,4 - length(strNumPrev)) + 48);
        prevfilename = [name{k} '' leadingZeros '' strNumPrev ''];
        strNumPrev = ['' leadingZeros '' strNumPrev ''];
        
        inputFile   = [dataFolder{k} filename '.ply'];
        prevFile    = [dataFolder{k} prevfilename '.ply'];
        
        currWorkspaceFolder4D = [workspaceFolder{k} '4D\'];
        binaryFile4D          = [currWorkspaceFolder4D filename '.bin'];
        outputFile4D          = [currWorkspaceFolder4D 'dec_' filename '.ply'];
        filename4D           = [workspaceFolder{k} sequence{k} '_results_inter_4D.txt'];
        
        currWorkspaceFolder4D_3D = [workspaceFolder{k} '4D_3D\'];
        binaryFile4D_3D          = [currWorkspaceFolder4D_3D filename '.bin'];
        outputFile4D_3D          = [currWorkspaceFolder4D_3D 'dec_' filename '.ply'];
        filename4D_3D            = [workspaceFolder{k} sequence{k} '_results_inter_4D_3D.txt'];
        
        currWorkspaceFolder4D_3D_Fast = [workspaceFolder{k} '4D_3D_Fast\'];
        binaryFile4D_3D_Fast          = [currWorkspaceFolder4D_3D_Fast filename '.bin'];
        outputFile4D_3D_Fast          = [currWorkspaceFolder4D_3D_Fast 'dec_' filename '.ply'];
        filename4D_3D_Fast            = [workspaceFolder{k} sequence{k} '_results_inter_4D_3D_Fast.txt'];
        
        disp('4D Files')
        disp(['InputFile  = ' inputFile ''])
        disp(['prevFile   = ' prevFile ''])
        disp(['binaryFile = ' binaryFile4D ''])
        disp(['outputFile = ' outputFile4D ''])
        disp(['filename   = ' filename4D ''])
        disp('')
        
        disp('4D_3D Files')
        disp(['InputFile  = ' inputFile ''])
        disp(['prevFile   = ' prevFile ''])
        disp(['binaryFile = ' binaryFile4D_3D ''])
        disp(['outputFile = ' outputFile4D_3D ''])
        disp(['filename   = ' filename4D_3D ''])
        disp('')
        
        disp('4D_3D_Fast Files')
        disp(['InputFile  = ' inputFile ''])
        disp(['prevFile   = ' prevFile ''])
        disp(['binaryFile = ' binaryFile4D_3D_Fast ''])
        disp(['outputFile = ' outputFile4D_3D_Fast ''])
        disp(['filename   = ' filename4D_3D_Fast ''])
        disp('')
        
        %------------------------------------------------------------------
        %Run 4D.
        %Encodes the file
        encStartTime = tic;
        enc = encodePointCloudGeometry_Inter(inputFile, prevFile, binaryFile4D,'test3DOnlyContextsForInter',0,'fastChoice3Dvs4D',0);        
        encTime = toc(encStartTime);
        
        decStartTime = tic;
        dec = decodePointCloudGeometry_Inter(binaryFile4D, prevFile, outputFile4D);
        decTime = toc(decStartTime);

        %Checks the two Ply
        checkPly  = comparePlys2(inputFile, outputFile4D);
        
        bestAxis = find('xyz' == enc.dimensionSliced);
        
        %Writes the results
        fid = fopen(filename4D,'a');
        fprintf(fid,'%s\t%s\t%d\t%d\t%2.2f\t%2.2f\t%2.4f\t%2.4f\t%2.4f\t%2.4f\n',strNumFile, strNumPrev, bestAxis, checkPly,encTime, decTime, enc.rate_bpov_per_axis(1), enc.rate_bpov_per_axis(2), enc.rate_bpov_per_axis(3), enc.rate_bpov);
        fclose(fid);
        clear enc dec
        
        %------------------------------------------------------------------
        %Run 4D_3D.        
        %Encodes the file
        encStartTime = tic;        
        enc = encodePointCloudGeometry_Inter(inputFile, prevFile, binaryFile4D_3D,'test3DOnlyContextsForInter',1,'fastChoice3Dvs4D',0);        
        encTime = toc(encStartTime);
        
        decStartTime = tic;
        dec = decodePointCloudGeometry_Inter(binaryFile4D_3D, prevFile, outputFile4D_3D);
        decTime = toc(decStartTime);

        %Checks the two Ply
        checkPly  = comparePlys2(inputFile, outputFile4D_3D);
        
        bestAxis = find('xyz' == enc.dimensionSliced);
        
        %Writes the results
        
        fid = fopen(filename4D_3D,'a');
        fprintf(fid,'%s\t%s\t%d\t%d\t%2.2f\t%2.2f\t%2.4f\t%2.4f\t%2.4f\t%2.4f\n',strNumFile, strNumPrev, bestAxis, checkPly,encTime, decTime, enc.rate_bpov_per_axis(1), enc.rate_bpov_per_axis(2), enc.rate_bpov_per_axis(3), enc.rate_bpov);
        fclose(fid);
        clear enc dec
        
        %------------------------------------------------------------------
        %Run 4D_3D_Fast.
        %Encodes the file
        encStartTime = tic;
        enc = encodePointCloudGeometry_Inter(inputFile, prevFile, binaryFile4D_3D_Fast,'test3DOnlyContextsForInter',1,'fastChoice3Dvs4D',1);        
        encTime = toc(encStartTime);
        
        decStartTime = tic;
        dec = decodePointCloudGeometry_Inter(binaryFile4D_3D_Fast, prevFile, outputFile4D_3D_Fast);
        decTime = toc(decStartTime);

        %Checks the two Ply
        checkPly  = comparePlys2(inputFile, outputFile4D_3D_Fast);
        
        bestAxis = find('xyz' == enc.dimensionSliced);
        
        %Writes the results       
        fid = fopen(filename4D_3D_Fast,'a');
        fprintf(fid,'%s\t%s\t%d\t%d\t%2.2f\t%2.2f\t%2.4f\t%2.4f\t%2.4f\t%2.4f\n',strNumFile, strNumPrev, bestAxis, checkPly,encTime, decTime, enc.rate_bpov_per_axis(1), enc.rate_bpov_per_axis(2), enc.rate_bpov_per_axis(3), enc.rate_bpov);
        fclose(fid);
        clear enc dec
    end
end