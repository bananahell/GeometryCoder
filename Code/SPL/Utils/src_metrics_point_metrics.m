function err = point_metrics(V_A, V_B, varargin)
%POINT_METRICS  Calculates point-to-point and point-to-plane metrics
%acording to MPEG. Same code used in pcerror adapted to MATLAB.
% Usage:
%  err = point_metrics(V_A, V_B) only p2point
%  err = point_metrics(V_A, V_B, N_A) p2point and p2plane
%  err = point_metrics(V_A, V_B, C_A, C_B) p2point and p2point-color metrics
%  err = point_metrics(V_A, V_B, N_A, C_A, C_B) p2point, p2plane and p2point-color
%  C_A and C_B are expected to be in RGB
%
% Still under development

mse_A  = [];
mse_B  = [];
psnr_yuv_A = []; 
psnr_yuv_B = [];
psnr_A = [];
psnr_B = [];
p2plane_A = [];
p2plane_B = [];
normal_metric = false;
color_metric   = false;
L = nextpow2(max(max(V_A)));
res = 2^L - 1;
peak_val = norm([res, res, res]);

L_A = length(V_A);
L_B = length(V_B);
[i_A, d_A] = knnsearch(V_B, V_A, 'K', 27, 'NSMethod', 'kdtree', 'Distance', 'euclidean'); %search in DEGR for ORIG
[i_B, d_B] = knnsearch(V_A, V_B, 'K', 27, 'NSMethod', 'kdtree', 'Distance', 'euclidean'); %search in ORIG for DEGR

p2point_A = sum(d_A(:,1).^2)/L_A;
p2point_B = sum(d_B(:,1).^2)/L_B;
p2point = max(p2point_A, p2point_B);
p2point_b = p2point_A + p2point_B; %this way holes are considered



% TODO:
% 1 adicionar verificacoes para NaNs
% 2 adicionar opcao para nao fazer average
% 3 adicionar as outras metricas de cor
% 4 criar funcoes para calular as metricas

% scale normals: verifica se normais diferentes sao atribuidas a um mesmo
% ponto
if size(varargin,2) > 0
    switch size(varargin,2)
        case 1
            N_A = varargin{1};
            N_B = zeros(size(V_B));
            normal_metric = true;
        case 2
            C_A = uint8(varargin{end-1});
            C_B = uint8(varargin{end});
            mC_A = C_A(i_B(:,1),:);
            mC_B = C_B(i_A(:,1),:);
            color_metric = true;
        case 3
            N_A = varargin{1};
            N_B = zeros(size(V_B));
            C_A = uint8(varargin{end-1});
            C_B = uint8(varargin{end});
            mC_A = C_A(i_B(:,1),:);
            mC_B = C_B(i_A(:,1),:);
            color_metric  = true;
            normal_metric = true;
    end
        counts = zeros(size(V_B,1),1);
    
    for i = 1:size(V_A,1)
        same_dist_points = d_A(i,:) <= d_A(i,1);
        if normal_metric
            N_B(i_A(i,same_dist_points),:) =  N_B(i_A(i,same_dist_points),:) + N_A(i,:);

        end
        if color_metric
            mC_B(i,:) = round(sum( C_B(i_A(i,same_dist_points),:), 1) / sum(same_dist_points));
        end
        counts(i_A(i,same_dist_points)) = counts(i_A(i,same_dist_points)) + 1;
    end
    
    % counts(counts==0) = 1;
    % N_B = N_B./counts;
    % average normals: tira a media das normais que estao num mesmo ponto.
    for i = 1:size(V_B,1)
        same_dist_points = d_B(i,:) <= d_B(i,1);
        if normal_metric
            if counts(i) > 0
                N_B(i,:) = N_B(i,:)/counts(i);
            else    
                N_B(i,:) = ( N_B(i,:) + sum( N_A(i_B(i,same_dist_points),:), 1) ) / sum(same_dist_points);
            end
        end
        if color_metric
            mC_A(i,:) = round(sum( C_A(i_B(i,same_dist_points),:), 1) / sum(same_dist_points));
        end
    end
    if normal_metric
    
        % calcula point2plane em A
        c2c_A = compute_point2plane(V_A, V_B, N_B, d_A, i_A);
        
        % calcula point2plane em B
        
        c2c_B = compute_point2plane(V_B, V_A, N_A, d_B, i_B);
        
        p2plane_A  = c2c_A;
        p2plane_B = c2c_B;
    end
end


if color_metric       
    C_A = convertRGBtoYUV_BT709(C_A);
    C_B = convertRGBtoYUV_BT709(C_B);
    mC_A = convertRGBtoYUV_BT709(mC_A);
    mC_B = convertRGBtoYUV_BT709(mC_B);
    mse_A = sum((C_A - mC_B).^2,1)/L_A; % o calculo do MSE vai ser feito com as os vetores mC
    mse_B = sum((C_B - mC_A).^2,1)/L_B;
    
    psnr_A = 10*log10(1^2./mse_A);
    
    psnr_B = 10*log10(1^2./mse_B);
    
    psnr_yuv_A = psnr_A * [6 1 1]' / 8;
    psnr_yuv_B = psnr_B * [6 1 1]' / 8;
end


p2plane = max(p2plane_A, p2plane_B);
p2plane_b = p2plane_A + p2plane_B;

if ~isempty(p2plane)
    p2plane_psnr = 10*log10(peak_val^2/p2plane);
else
    p2plane_psnr = [];
end

err              = struct;
err.p2point_mse  = [p2point_A p2point_B p2point ];
err.p2point_psnr = [10*log10(peak_val^2/p2point)];
err.p2point_b    = [p2point_b/2 ];
err.p2plane_mse  = [p2plane_A p2plane_B p2plane ];
err.p2plane_psnr = [p2plane_psnr];
err.p2plane_b    = [p2plane_b/2 ];
% err.N_B          = N_B;
err.mse_A        = mse_A;
err.mse_B        = mse_B;
err.psnr_A       = psnr_A;
err.psnr_B       = psnr_B;
err.psnr_yuv_A   = psnr_yuv_A;
err.psnr_yuv_B   = psnr_yuv_B;

fn  = fieldnames(err);
tf  = cellfun(@(x) isempty(err.(x)), fn);
err = rmfield(err, fn(tf));
end

function point2plane = compute_point2plane(V_A, V_B, N_B, d_A, i_A)

point2plane = 0;
L_A = size(V_A,1);
for i = 1:L_A
    same_d = d_A(i,:) <= d_A(i,1);
    if sum(same_d) == 1
        err_proj = dot( ( V_A(i,:) - V_B(i_A(i,1),:) ), N_B(i_A(i,1),:), 2)^2;
%         err_proj =  (( V_A(i,:) - V_B(i_A(i,1),:) )*N_B(i_A(i,1),:)').^2;
        point2plane = point2plane + err_proj;
    else
        err_proj = dot( ( V_A(i,:) - V_B(i_A(i,same_d),:) ), N_B(i_A(i,same_d),:), 2).^2;
        point2plane = point2plane + mean(err_proj);
    end

end
point2plane = point2plane/L_A;
end

function YUV = convertRGBtoYUV_BT709(RGB)
% YUV and RGB are Nx3 uint8 matrices
RGB = double(RGB);

Q = [0.2126 -0.1146  0.5000;
     0.7152 -0.3854 -0.4542;
     0.0722  0.5000 -0.0458];
 
T = [0.0000 0.5000 0.5000]; 
YUV = RGB * Q / 255 + T;
end

% function point2plane = compute_point2plane2(V_A, V_B, N_A, d_A, i_A)
% 
% point2plane = 0;
% L_A = size(V_A,1);
% for i = 1:L_A
%     same_d = d_A(i,:) <= d_A(i,1);
%     if sum(same_d) == 1
%         err_proj = dot( ( V_A(i,:) - V_B(i_A(i,1),:) ), N_A(i,:), 2)^2;
%         point2plane = point2plane + err_proj;
%     else
%         err_proj = dot( ( V_A(i,:) - V_B(i_A(i,same_d),:) ), repmat(N_A(i,:),[sum(same_d), 1]), 2).^2;
%         point2plane = point2plane + mean(err_proj);
%     end
% 
% end
% point2plane = point2plane/L_A;
% end