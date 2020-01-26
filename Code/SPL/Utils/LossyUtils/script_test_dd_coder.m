path = '~/Documents/mpeg-pcc-tmc13/experiment/interpolative-compr/'; %%path containing compressed PCs
cod = {'dd_coder'};
cat = {'lossy-geom-lossy-attrs'};
seq = {'loot_vox10', 'redandblack_vox10', 'soldier_vox10', ...
    'redandblack_vox10', 'redandblack_vox10'};
frame = {1200, 1550, 690, 1650, 1651};
pc = {['loot_vox10_' num2str(frame{1},'%04d')], ...
    ['redandblack_vox10_' num2str(frame{2},'%04d')], ...
    ['soldier_vox10_' num2str(frame{3},'%04d')], ...
    ['redandblack_vox10_' num2str(frame{4},'%04d')], ...
    ['redandblack_vox10_' num2str(frame{5},'%04d')]};
% pc = {'longdress_vox10_1300'};
r  = {'r01', 'r02', 'r03', 'r04', 'r05', 'r06'};
r_params = {3.2, 3.2, 2, (1/0.75), 1, 1; ...
            4, 2, 2, 2, 2, 1};
% r  = {'r05'};

results_folder = './dd_coder_results/lossy-geom-lossy-attrs/';
mkdir('./dd_coder_results/lossy-geom-lossy-attrs/');

samples   = length(cod)*length(cat)*6; %per point cloud
point_err = cell(length(pc),samples);
proj_err  = cell(length(pc),samples);
num_bits  = cell(length(pc),samples);
img_dist  = cell(length(pc),samples);
metrics   = ["psnr", "ssim", "vifp"];
content   = cell(length(pc),samples);

num_points = struct;
num_points.InputPoints = [];
num_points.OutputPoints = [];
num_points = repmat({num_points}, length(pc), samples);
n = 0;

kernel = xyz_displacements(-1:1);
weights = ones(size(kernel,1),1);

for i_pc=1:length(pc)
    count = 0;
    inputPly = strcat('C:\Users\drcft\OneDrive\Documents\UnB\Mestrado\Pesquisas\Sequences\', seq{i_pc}, ...
        '\', pc{i_pc},'.ply');
    [V, C] = readPC(inputPly);  %path for reference pointclouds
    [~,~,N] = readPC(strcat('C:\Users\drcft\OneDrive\Documents\UnB\Mestrado\Pesquisas\Sequences\', seq{i_pc}, ...
        '\', pc{i_pc},'_n.ply')); %path for reference normals
    img_ref = pointcloud_cube_projs(V, C, 0, 127);
    img_ref = {imrotate(img_ref{3},180) imrotate(img_ref{4},180) imrotate(img_ref{5},180),...
        imrotate(img_ref{6},180) flip(img_ref{1})         flip(img_ref{2})};
    cur_dir = strcat(results_folder, pc{i_pc},'/');
    mkdir(cur_dir);
   
    % DD encoder/decoder
    for i_r = 1:length(r)
        lossy_params.nDownsample = r_params{1,i_r};
        lossy_params.step = r_params{2,i_r}; 
    %encoder
        tic;
        count = count + 1;
        content{i_pc, count} = strcat(pc{i_pc}, '_', cod{1},  '_', cat{1}, r{i_r});
        filename = strcat(results_folder, pc{i_pc}, '/', pc{i_pc}, '_', r{i_r},...
        '.bin');
        outputPly = strcat(results_folder, pc{i_pc}, '/', pc{i_pc}, '_', r{i_r},...
        '.ply');
    
        %Runs the Encoder
        enc = encodePointCloudGeometry(inputPly,filename, lossy_params);

        %Runs the Decoder
        dec = decodePointCloudGeometry(filename,outputPly, lossy_params);
		% Venc = dd_encoder(V)
        Vdec = readPC(outputPly);
        
%         Cdec = pointcloud_filtering(Vdec, C, kernel, weights,'color');
        Vdec1 = [Vdec; zeros(size(V,1) - size(Vdec,1),3)];
%         Cdec = pointcloud_filtering(V, C, kernel, weights,'interpolation',Vdec1);
        Cdec = pointcloud_interpolation(V, C, Vdec1, 1);
        Cdec = Cdec(1:size(Vdec,1),:);
%         [~, idxs] = ismember(Vdec,V,'rows');
%         no_locations = find(idxs == 0);
%         idxs(no_locations) = 1;
%         Cdec = C(idxs,:);
        
%         counter1 = 0;
%         counter2 = 0;
%         for idx = no_locations'
% %             if(idx > 1)
% %                 Cdec(idx,:) = [0 0 0];
% %             else
% %                 Cdec(idx,:) = [0 0 0];
% %             end
%             if(idx ~= 1 && (geomdist(Vdec(idx,:),Vdec(idx-1,:)) <= 27))
%                 Cdec(idx,:) = Cdec(idx-1,:);
%             else
%                 if(idx ~= 1)
%                     counter1 = counter1 + 1;
%                     Distances = geomdist(Vdec(idx,:), Vdec(1:(idx-1),:));
%                     if(min(Distances) <= 27)
%                         min_color = Cdec(Distances == min(Distances),:);
%                         Cdec(idx, :) = min_color(1,:);
%                     else
%                         counter2 = counter2 + 1;
%                         Distances = geomdist(Vdec(idx,:), V);
%                         min_color = C(Distances == min(Distances),:);
%                         Cdec(idx, :) = min_color(1,:);
%                     end
%                 else
%                     Distances = geomdist(Vdec(idx,:), V);
%                     min_color = C(Distances == min(Distances),:);
%                     Cdec(idx, :) = min_color(1,:);
%                 end
%             end
%         end
        % write Venc in filename.bin
        file = dir(filename);

%        num_bits{i_pc, count} = read_TMC13_log_file(log_filename);
%        num_bits{i_pc, count}.bitstream_T = num_bits{i_pc, count}.bitstream_T - num_bits{i_pc, count}.bitstream_C + file.bytes*8; % aproximadamente
        num_bits{i_pc, count}.bitstream_V = file.bytes*8;

        %decoder
%		Vdec = dd_decoder(filename);
        
        num_points{i_pc, count}.OutputPoints = length(Vdec);
        num_points{i_pc, count}.InputPoints  = length(V);
        point_err{i_pc, count} = point_metrics(V, Vdec, N, C, Cdec);
        [proj_err{i_pc, count}, ~, img_dist{i_pc, count}] = projection_metrics(V, C, Vdec, Cdec,...
            0, 6, metrics, 'union', 2, img_ref);
        im = img_dist{i_pc, count};
        im = [im{:}];
        imwrite(im, strcat(results_folder, pc{i_pc}, '/', content{i_pc, count},'.png'))
        n = n+1;
        fprintf(2,'%s, t = %4.3f, %3.2f%%\n', content{i_pc, count}, toc, 100*n/(samples*length(pc)));
    end
        


end

%% writing RD table
for i_pc = 1:length(pc)
    w_num_bits   = num_bits(i_pc,:);
    w_num_points = num_points(i_pc,:);
    w_point_err  = point_err(i_pc,:);
    w_proj_err   = proj_err(i_pc,:);
    
    table_RD = [struct2table([w_num_bits{:}]'), struct2table([w_num_points{:}]'),...
        struct2table([w_point_err{:}]'), struct2table([w_proj_err{:}]')];
    
    table_RD.Properties.RowNames = content(i_pc,:);
    
    table_RD.bpp_V = table_RD.bitstream_V ./ table_RD.InputPoints;
    
    table_RD = [table_RD(:,1:3) table_RD(:,20) table_RD(:,4:19)];
    table_RD = [table_RD(:,1:6) table_RD(:,8:9) table_RD(:,17:20)];
    
%     table_RD = movevars(table_RD,'bpp_V','After','InputPoints');
%     table_RD.bpp_C = table_RD.bitstream_C ./ table_RD.InputPoints;
%     table_RD = movevars(table_RD,'bpp_C','After','bpp_V');
%     table_RD.bpp_T = table_RD.bitstream_T ./ table_RD.InputPoints;
%     table_RD = movevars(table_RD,'bpp_T','After','bpp_C');
%     table_RD = movevars(table_RD,'OutputPoints','After','bpp_T');
    
%     table_RD.color_mse_yuv = max(table_RD.mse_A,table_RD.mse_B);
%     table_RD = movevars(table_RD,'color_mse_yuv','After','p2plane_b');
%     table_RD.color_psnr_yuv = min(table_RD.psnr_A,table_RD.psnr_B);
%     table_RD = movevars(table_RD,'color_psnr_yuv','After','color_mse_yuv');
%     table_RD.color_psnr_yuv_waverage = min(table_RD.psnr_yuv_A,table_RD.psnr_yuv_B);
%     table_RD = movevars(table_RD,'color_psnr_yuv','After','color_psnr_yuv');
    
%     table_RD_ed = table_RD;
%     table_RD_ed.p2point_mse = table_RD.p2point_mse(:,3);
%     table_RD_ed.p2plane_mse = table_RD.p2plane_mse(:,3);
%     table_RD_ed = removevars(table_RD_ed,'p2point_b');
%     table_RD_ed = removevars(table_RD_ed,'p2plane_b');
%     table_RD_ed = removevars(table_RD_ed,'color_psnr_yuv_waverage');
%     table_RD_ed = removevars(table_RD_ed,'mse_A');
%     table_RD_ed = removevars(table_RD_ed,'mse_B');
%     table_RD_ed = removevars(table_RD_ed,'psnr_A');
%     table_RD_ed = removevars(table_RD_ed,'psnr_B');
%     table_RD_ed = removevars(table_RD_ed,'psnr_yuv_A');
%     table_RD_ed = removevars(table_RD_ed,'psnr_yuv_B');
%     
%     table_RD_ed = splitvars(table_RD_ed,{'color_mse_yuv','color_psnr_yuv'},...
%         'NewVariableNames',{{'color_Y_mse','color_U_mse','color_V_mse'},...
%                             {'color_Y_psnr','color_U_psnr','color_V_psnr'}});
    
    ref_name = regexprep(pc{i_pc},'vox(\d)','vox10');
    
%     writetable(table_RD_ed, strcat(results_folder, pc{i_pc}, '/', 'table_RD_',pc{i_pc},'.xls'),'WriteRowNames',true);
    writetable(table_RD, strcat(results_folder, pc{i_pc}, '/', 'table_RD_',pc{i_pc},'_full.xls'),'WriteRowNames',true);
end
