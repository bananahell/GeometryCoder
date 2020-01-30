% Script to test point cloud metrics for the 6 different levels of
% distortion throughout nFrames

%The output folders must exist before the script is executed.
datasetFolder  = 'C:\Users\drcft\OneDrive\Documents\UnB\Mestrado\Pesquisas\Sequences\';
outputFolder   = 'C:\Users\drcft\Documents\GitHub\Lossy_Coder_ICIP\GeometryCoderDev\Code\SPL\Utils\LossyUtils\dd_coder_results\test-cores\';
metrics   = ["psnr", "ssim", "vifp"];

k = 0;

k = k + 1;
%redandblack
sequence{k}        = 'redandblack_vox10';
name{k}            = 'redandblack_vox10_';
parentFolder{k}    = outputFolder;
newFolder{k}       = 'redandblack_vox10';
dataFolder{k}      = [datasetFolder 'redandblack_vox10\'];
workspaceFolder{k} = [outputFolder 'redandblack_vox10\'];
frameStart{k}      = 1451;
frameEnd{k}        = 1550;

r_params = {3.2, 3.2, 2, (1/0.75), 1, 1; ...
            4, 2, 2, 2, 2, 1};

N = k;
for k = 1:1:N
    for i = frameStart{k}:1:frameEnd{k}
        strNumFile = num2str(i);
        leadingZeros = char(zeros(1,4 - length(strNumFile)) + 48);
        output_file = [name{k} '' leadingZeros '' strNumFile ''];
%         strNumFile = ['' leadingZeros '' strNumFile ''];
        
        
        inputFile   = [dataFolder{k} output_file '.ply'];
        inputFile_n = [dataFolder{k} output_file '_n.ply'];
        [V, C] = readPC(inputFile);
        [~,~,N] = readPC(inputFile_n);
        
        %------------------------------------------------------------------
        %Run 4D.
        currWorkspaceFolder = [workspaceFolder{k} num2str(i, '%04d') '\'];
        
        % DD encoder/decoder
        for i_r = 1:size(r_params,2)
            lossy_params.nDownsample = r_params{1,i_r};
            lossy_params.step = r_params{2,i_r}; 
            mkdir([workspaceFolder{k} name{k} num2str(i,'%04d') ...
                '\']);
            binaryFile  = [workspaceFolder{k} name{k} num2str(i,'%04d') ...
                '\' output_file '_r' num2str(i_r, '%02d') '.bin'];
            outputFile  = [workspaceFolder{k} name{k} num2str(i,'%04d') ...
                '\' 'dec_' output_file '_r' num2str(i_r, '%02d') '.ply'];

            %Encodes the file
            encStartTime = tic;
            enc = encodePointCloudGeometry(inputFile,binaryFile, lossy_params);
            encTime = toc(encStartTime);
            
            %Runs the Decoder
            decStartTime = tic;
            dec = decodePointCloudGeometry(binaryFile,outputFile);
            decTime = toc(decStartTime);
            
            Vdec = readPC(outputFile);
%             Cdec = knn_pointcloud_interpolation(V, C, Vdec, sqrt(3));
            point_err = point_metrics(V, Vdec, N);

            bestAxis = find('xyz' == enc.dimensionSliced);

            %Writes the results
            txt_file = [workspaceFolder{k} sequence{k} '_r' num2str(i_r, '%02d') '.txt'];
            fid = fopen(txt_file,'a');
            fprintf(fid,'%s\t%d\t%2.2f\t%2.2f\t%2.4f\t%2.4f\t%2.4f\t%2.4f\t%2.4f\n',strNumFile, bestAxis, ...
                encTime, decTime, enc.rate_bpov, point_err.p2point_psnr, point_err.p2point_mse(:,3), ...
                point_err.p2plane_psnr, point_err.p2plane_mse(:,3));
            fclose(fid);

            fprintf(2, 'Rate %02d for Frame %d processed,  %3.2f%% completed\n', i_r, i, ...
                100*((6*(i - frameStart{k}) + i_r)/(6*(frameEnd{k} - frameStart{k} + 1))));
        end
    end
end