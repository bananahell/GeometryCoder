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
%       Voxelized Upper Bodies – A Voxelized Point Cloud Dataset," ISO/IEC 
%       JTC1/SC29/WG11 m38673 ISO/IEC JTC1/SC29/WG1 M72012, Geneva, 
%       Switzerland, Tech. Rep., 2016.
%
%   [2] E. d’Eon, B. Harrison, T. Myers, and P. A. Chou, "8i Voxelized
%       Full Bodies, version 2 – A Voxelized Point Cloud Dataset," ISO/IEC
%       JTC1/SC29/WG11 m40059 ISO/IEC JTC1/SC29/WG1 M74006 Geneva, 
%       Switzerland, Tech. Rep., 2017.
%
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
% Author: Evaristo Ramalho
% E-mail: evaristora28@gmail.com
% Author: Edil Medeiros
% E-mail: j.edil@ene.unb.br
% 11/05/2021

%Change this to reflect your system
%The output folders must exist before the script is executed.
datasetFolder  = 'C:\eduardo\Sequences\PointClouds\';
outputFolder   = 'C:\eduardo\workspace\ResultsSPLInter\SpeedTest\';
k = 0;

k = k + 1;
%longdress
sequence{k}        = 'longdress';
name{k}            = 'longdress_vox10_';
parentFolder{k}    = outputFolder;
newFolder{k}       = 'longdress';
dataFolder{k}      = [datasetFolder 'longdress\Ply\'];
workspaceFolder{k} = [outputFolder 'longdress\'];
frameStart{k}      = 1300;
frameEnd{k}        = 1300;

k = k + 1;
%loot
sequence{k}        = 'loot';
name{k}            = 'loot_vox10_';
parentFolder{k}    = outputFolder;
newFolder{k}       = 'loot';
dataFolder{k}      = [datasetFolder 'loot\Ply\'];
workspaceFolder{k} = [outputFolder 'loot\'];
frameStart{k}      = 1200;
frameEnd{k}        = 1200;

k = k + 1;
%redandblack
sequence{k}        = 'redandblack';
name{k}            = 'redandblack_vox10_';
parentFolder{k}    = outputFolder;
newFolder{k}       = 'redandblack';
dataFolder{k}      = [datasetFolder 'redandblack\Ply\'];
workspaceFolder{k} = [outputFolder 'redandblack\'];
frameStart{k}      = 1550;
frameEnd{k}        = 1550;

k = k + 1;
%soldier
sequence{k}        = 'soldier';
name{k}            = 'soldier_vox10_';
parentFolder{k}    = outputFolder;
newFolder{k}       = 'soldier';
dataFolder{k}      = [datasetFolder 'soldier\Ply\'];
workspaceFolder{k} = [outputFolder 'soldier\'];
frameStart{k}      = 0690;
frameEnd{k}        = 0690;

N = k;
for k = 1:1:N
    
    if not(isfolder(workspaceFolder{k}))
       mkdir(workspaceFolder{k})
    end
    
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
        
        currWorkspaceFolder4D = [workspaceFolder{k} 'cs4D_Fast\'];
        binaryFile4D          = [currWorkspaceFolder4D filename '.bin'];
        outputFile4D          = [currWorkspaceFolder4D 'dec_' filename '.ply'];
        filename4D           = [workspaceFolder{k} sequence{k} '_results_cs4D_Fast.txt'];
        
        if not(isfolder(currWorkspaceFolder4D))
			mkdir(currWorkspaceFolder4D)
		end
        
        disp('4D Files')
        disp(['InputFile  = ' inputFile ''])
        disp(['prevFile   = ' prevFile ''])
        disp(['binaryFile = ' binaryFile4D ''])
        disp(['outputFile = ' outputFile4D ''])
        disp(['filename   = ' filename4D ''])
        disp('')
         
        %------------------------------------------------------------------
        %Run 4D.
        %Encodes the file
        encStartTime = tic;
        enc = encodePointCloudGeometry_Inter(inputFile, prevFile, binaryFile4D);        
        encTime = toc(encStartTime);
        
        decStartTime = tic;
        dec = decodePointCloudGeometry_Inter(binaryFile4D, prevFile, outputFile4D);
        decTime = toc(decStartTime);

        %Checks the two Ply
        checkPly  = comparePlys2(inputFile, outputFile4D);
        
        bestAxis = find('xyz' == enc.dimensionSliced);
        
        %Writes the results
        fid = fopen(filename4D,'a');
        fprintf(fid,'%s\t%s\t%d\t%d\t%2.2f\t%2.2f\t%2.4f\t%2.4f\t%2.4f\t%2.4f\t%2.4f\t%2.4f\t%2.4f\n',strNumFile, strNumPrev, bestAxis, checkPly,encTime, decTime, enc.entropy_value(1),enc.entropy_value(2),enc.entropy_value(3), enc.rate_bpov_per_axis(1), enc.rate_bpov_per_axis(2), enc.rate_bpov_per_axis(3), enc.rate_bpov);
        fclose(fid);
        clear enc dec

    end
end