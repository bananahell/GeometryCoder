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
% 29/10/2019

%Change this to reflect your system
%The output folders must exist before the script is executed.
datasetFolder  = 'C:\eduardo\Sequences\PointClouds\';
outputFolder   = 'C:\eduardo\workspace\ICIP_Inter\Test2701\';

k = 0;

% k = k + 1;
% %Andrew
% sequence{k}        = 'andrew';
% name{k}            = 'frame';
% parentFolder{k}    = outputFolder_UpperBodies;
% newFolder{k}       = 'andrew9';
% dataFolder{k}      = [datasetFolder_UpperBodies 'andrew9\'];
% workspaceFolder{k} = [outputFolder_UpperBodies 'andrew9\'];
% frameStart{k}      = 0;
% frameEnd{k}        = 317;
% 
k = k + 1;
%David
sequence{k}        = 'longdress';
name{k}            = 'longdress_vox10_';
parentFolder{k}    = outputFolder;
newFolder{k}       = 'longdress';
dataFolder{k}      = [datasetFolder 'longdress\Ply\'];
workspaceFolder{k} = [outputFolder 'longdress\4D_3D\'];
params{k}          = [1 0];
frameStart{k}      = 1052;
frameEnd{k}        = 1055;

k = k + 1;
%David
sequence{k}        = 'longdress';
name{k}            = 'longdress_vox10_';
parentFolder{k}    = outputFolder;
newFolder{k}       = 'longdress';
dataFolder{k}      = [datasetFolder 'longdress\Ply\'];
workspaceFolder{k} = [outputFolder 'longdress\4D\'];
params{k}          = [0 0];
frameStart{k}      = 1052;
frameEnd{k}        = 1055;

k = k + 1;
%David
sequence{k}        = 'longdress';
name{k}            = 'longdress_vox10_';
parentFolder{k}    = outputFolder;
newFolder{k}       = 'longdress';
dataFolder{k}      = [datasetFolder 'longdress\Ply\'];
workspaceFolder{k} = [outputFolder 'longdress\4D_3D_Fast\'];
params{k}          = [1 1];
frameStart{k}      = 1052;
frameEnd{k}        = 1055;

% 
% k = k + 1;
% %Phil
% sequence{k}        = 'phil';
% name{k}            = 'frame';
% parentFolder{k}    = outputFolder_UpperBodies;
% newFolder{k}       = 'phil9';
% dataFolder{k}      = [datasetFolder_UpperBodies 'phil9\'];
% workspaceFolder{k} = [outputFolder_UpperBodies 'phil9\'];
% frameStart{k}      = 0;
% frameEnd{k}        = 244;
% 
% k = k + 1;
% %Ricardo
% sequence{k}        = 'ricardo';
% name{k}            = 'frame';
% parentFolder{k}    = outputFolder_UpperBodies;
% newFolder{k}       = 'ricardo9';
% dataFolder{k}      = [datasetFolder_UpperBodies 'ricardo9\'];
% workspaceFolder{k} = [outputFolder_UpperBodies 'ricardo9\'];
% frameStart{k}      = 0;
% frameEnd{k}        = 215;
% 
% k = k + 1;
% %Sarah
% sequence{k}        = 'sarah';
% name{k}            = 'frame';
% parentFolder{k}    = outputFolder_UpperBodies;
% newFolder{k}       = 'sarah9';
% dataFolder{k}      = [datasetFolder_UpperBodies 'sarah9\'];
% workspaceFolder{k} = [outputFolder_UpperBodies 'sarah9\'];
% frameStart{k}      = 0;
% frameEnd{k}        = 206;

% k = k + 1;
% %Longdress
% sequence{k}        = 'longdress';
% name{k}            = 'longdress_vox10_';
% parentFolder{k}    = outputFolder_FullBodies;
% newFolder{k}       = 'longdress';
% dataFolder{k}      = [datasetFolder_FullBodies 'longdress\Ply\'];
% workspaceFolder{k} = [outputFolder_FullBodies 'longdress\4DSingle_NoME\'];
% params{k}          = [1 0];
% frameStart{k}      = 1052;
% frameEnd{k}        = 1071;
% 
% k = k + 1;
% %Longdress
% sequence{k}        = 'longdress';
% name{k}            = 'longdress_vox10_';
% parentFolder{k}    = outputFolder_FullBodies;
% newFolder{k}       = 'longdress';
% dataFolder{k}      = [datasetFolder_FullBodies 'longdress\Ply\'];
% workspaceFolder{k} = [outputFolder_FullBodies 'longdress\3DSingle\'];
% params{k}          = [0 0];
% frameStart{k}      = 1052;
% frameEnd{k}        = 1071;
% 
% k = k + 1;
% %Longdress
% sequence{k}        = 'longdress';
% name{k}            = 'longdress_vox10_';
% parentFolder{k}    = outputFolder_FullBodies;
% newFolder{k}       = 'longdress';
% dataFolder{k}      = [datasetFolder_FullBodies 'longdress\Ply\'];
% workspaceFolder{k} = [outputFolder_FullBodies 'longdress\4DSingle_ME\'];
% params{k}          = [1 1];
% frameStart{k}      = 1052;
% frameEnd{k}        = 1071;


% 
% k = k + 1;
% Loot
% sequence{k}        = 'loot';
% name{k}            = 'loot_vox10_';
% parentFolder{k}    = outputFolder_FullBodies;
% newFolder{k}       = 'loot';
% dataFolder{k}      = [datasetFolder_FullBodies 'loot\'];
% workspaceFolder{k} = [outputFolder_FullBodies 'loot\'];
% frameStart{k}      = 1001;
% frameEnd{k}        = 1010;

% k = k + 1;
% %RedAndBlack
% sequence{k}        = 'redandblack';
% name{k}            = 'redandblack_vox10_';
% parentFolder{k}    = outputFolder_FullBodies;
% newFolder{k}       = 'redandblack';
% dataFolder{k}      = [datasetFolder_FullBodies 'redandblack\Ply\'];
% workspaceFolder{k} = [outputFolder_FullBodies 'redandblack\'];
% frameStart{k}      = 1451;
% frameEnd{k}        = 1460;
% 
% k = k + 1;
% %Soldier
% sequence{k}        = 'soldier';
% name{k}            = 'soldier_vox10_';
% parentFolder{k}    = outputFolder_FullBodies;
% newFolder{k}       = 'soldier';
% dataFolder{k}      = [datasetFolder_FullBodies 'soldier\Ply\'];
% workspaceFolder{k} = [outputFolder_FullBodies 'soldier\'];
% frameStart{k}      = 0537;
% frameEnd{k}        = 0546;

N = k;
for k = 1:1:N
    for i = frameStart{k}:1:frameEnd{k}
        strNum = num2str(i);
        leadingZeros = char(zeros(1,4 - length(strNum)) + 48);
        filename = [name{k} '' leadingZeros '' strNum ''];
        
        strNum = num2str(i-1);
        leadingZeros = char(zeros(1,4 - length(strNum)) + 48);
        prevfilename = [name{k} '' leadingZeros '' strNum ''];
        
        inputFile   = [dataFolder{k} filename '.ply'];
        prevFile    = [dataFolder{k} prevfilename '.ply'];
        binaryFile  = [workspaceFolder{k} filename '.bin'];
        outputFile  = [workspaceFolder{k} 'dec_' filename '.ply'];
        
        %Checks if the output folder exists.
        [success, message, messageid] = mkdir(parentFolder{k},newFolder{k});
        if (success == 0)
            error(['Could not create output folder - Message: ' message ' .'])
        end
        
        %Encodes the file
        %enc = encodePointCloudGeometry(inputFile, binaryFile);      
        encStartTime = tic;
        enc = encodePointCloudGeometry_Inter(inputFile, prevFile, binaryFile,'test3DOnlyContextsForInter',params{k}(1),'fastChoice3Dvs4D',params{k}(2));   
        encTime = toc(encStartTime);
        
        decStartTime = tic;
        %dec = decodePointCloudGeometry_Inter(binaryFile, prevFile, outputFile);
        decTime = toc(decStartTime);

        %Checks the two Ply
        %checkPly  = comparePlys(inputFile, outputFile);
        checkPly = 0;
        
        bestAxis = find('xyz' == enc.dimensionSliced);
        
        %Writes the results
        filename = [workspaceFolder{k} sequence{k} '_results_inter.txt'];
        fid = fopen(filename,'a');
        fprintf(fid,'%d\t%d\t%2.2f\t%2.2f\t%2.4f\t%2.4f\t%2.4f\t%2.4f\n',bestAxis, checkPly,encTime, decTime, enc.rate_bpov_per_axis(1), enc.rate_bpov_per_axis(2), enc.rate_bpov_per_axis(3), enc.rate_bpov);
        fclose(fid);
    end
end