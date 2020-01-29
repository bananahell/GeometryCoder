% Script script_testParameters

% This script tests different number of values for parameters for lossy
% compression, in order to infer the most adequate ones for optimization

% To achieve that, the codec is run over a group of n frames

% frames = [1, 10, 30, 50, 80, 100, 130, 150, 180, 200];

% stepValues = [4, 2, 1, 4, 2, 1, 4, 2, 1, 4, 2, 1, ...
%     4, 2, 1, 4, 2, 1];
        
% downsampleValues = [4, 4, 4, 3.2, 3.2, 3.2, 2, 2, 2, ...
%     1.6, 1.6, 1.6, (1/0.75), (1/0.75), (1/0.75), 1, 1, 1];
stepValues = [2];
downsampleValues = [(1/0.75)];
frames = [1300];

% PSNR = zeros(length(stepValues), length(frames));
% MSE_1 = zeros(length(stepValues),length(frames));
% MSE_2 = zeros(length(stepValues),length(frames));
% Rates = zeros(length(stepValues),length(frames));
PSNR = zeros(length(stepValues),1);
MSE_1 = zeros(length(stepValues),1);
MSE_2 = zeros(length(stepValues),1);
Rates = zeros(length(stepValues),1);

% lossy_params.nDownsample = 0;
% lossy_params.step = 0;

% folder_path = 'C:\Users\drcft\Documents\GitHub\Lossy_Coder_ICIP\GeometryCoderDev\Code\SPL\Utils\LossyUtils\dd_coder_results\all-points\ricardo9_200\';
% folder_path = 'C:\Users\drcft\Documents\GitHub\Lossy_Coder_ICIP\GeometryCoderDev\Code\SPL\Utils\LossyUtils\dd_coder_results\all-points\redandblack_vox10_1550\';
% inputPly   = 'C:\Users\drcft\OneDrive\Documents\UnB\Mestrado\Pesquisas\Sequences\soldier_vox10\soldier_vox10_0690.ply';
% inputPly   = 'C:\Users\drcft\OneDrive\Documents\UnB\Mestrado\Pesquisas\Sequences\redandblack_vox10\redandblack_vox10_1550.ply';
% inputPly   = 'C:\Users\drcft\OneDrive\Documents\UnB\Mestrado\Pesquisas\Sequences\ricardo9\frame0200.ply';
% folder_path = 'C:\Users\drcft\Documents\GitHub\Lossy_Coder_ICIP\GeometryCoderDev\Code\SPL\Utils\LossyUtils\dd_coder_results\all-points\man2\';
folder_path = 'C:\Users\drcft\Documents\GitHub\Lossy_Coder_ICIP\GeometryCoderDev\Code\SPL\Utils\LossyUtils\dd_coder_results\all-points\';


for outer_i = 1:length(frames)
%     inputPly   = ['C:\Users\drcft\OneDrive\Documents\UnB\Mestrado\Pesquisas\Sequences\man2\' ...
%         'man2_' num2str(frames(outer_i), '%03d') '.ply'];
    inputPly   = ['C:\Users\drcft\OneDrive\Documents\UnB\Mestrado\Pesquisas\Sequences\longdress_vox10\' ...
        'longdress_vox10_' num2str(frames(outer_i), '%04d') '.ply'];

% parfor i = 1:nFrames
    for i = 1:length(stepValues)
        lossy_params = getLossyParams();
        lossy_params.nDownsample = downsampleValues(i);
        lossy_params.step = stepValues(i);

        disp(['Running Codec with Downsample = ' num2str(lossy_params.nDownsample) ...
            ' and Step = ' num2str(lossy_params.step)]);

        binaryFile = [folder_path 'frame_' num2str(frames(outer_i), '%04d') '_d' num2str(downsampleValues(i),'%0.2f') ...
            '_s' num2str(stepValues(i),'%02d') '.bin'];
        outputPly  = [folder_path 'frame_' num2str(frames(outer_i), '%04d') '_d' num2str(downsampleValues(i),'%0.2f') ...
            '_s' num2str(stepValues(i),'%02d') '.ply'];

        %Runs the Encoder
        enc = encodePointCloudGeometry(inputPly,binaryFile, lossy_params);

        %Runs the Decoder
        dec = decodePointCloudGeometry(binaryFile,outputPly, lossy_params);

        % Compute metrics for lossy encoding
        pc = pcread(inputPly);
        V_a = pc.Location;
        pc = pcread(outputPly);
        V_b = pc.Location;

        pt2pt = src_metrics_point_metrics(V_a, V_b);

        Rates(i, outer_i) = enc.rate_bpov;
        MSE_1(i, outer_i) = pt2pt.p2point_mse(1);
        MSE_2(i, outer_i) = pt2pt.p2point_mse(2);
        PSNR(i, outer_i) = pt2pt.p2point_psnr;
        
        
    end
%     fprintf(2,'%s completed, %d out of %d\n', inputPly, outer_i, length(frames))
end
