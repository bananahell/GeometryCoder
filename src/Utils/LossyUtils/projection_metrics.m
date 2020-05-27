function [err, img_ref, img_dist] = projection_metrics(V_ref, C_ref, V_dist, C_dist, yuv2rgb, nviews, metrics, region, point_size, img_ref)
%PROJECTION_METRICS   Creates the projections and calculates the metrics
%  PSNR, MSE, SSIM (matlab), SSIM(zwang) and VIFp. The projections are
%  obtained from the PccAppRenderer (version 3.02_beta).
% 
%  [err, img_ref, img_dist] = projection_metrics(V_ref, C_ref, V_dist, C_dist, yuv2rgb, nviews, metrics, img_ref)
%
%  INPUTS:
%  - V_REF and C_REF are the geometry and color from the reference point
%    cloud, V_DIST and C_DIST the geometry and color from the distorted point
%    cloud. Notice that both REF and DIST must have the same geometry depth.
%  - YUV2RGB is either 1 or 0 for the convertion.
%  - NVIEWS is the number of projections used for the metrics.
%  - METRICS is an array of strings with up to three strings, indicating which of 
%    the metrics should be calculated: "psnr", "ssim" and "vifp" are availabe.
%  - [REGION] specify if a ROI will be used to calculate the metrics
%    (faster). Options are: 'whole', 'ref', 'intersection', 'union'. Default
%    is 'whole'.
%  - [IMG_REF] can be used in cases where the same reference is used for many
%    distortions, in that case one can save IMG_REF from the fisrt run and
%    use it in the next to save time. Obs.: IMG_REF must be 'whole'.
%
%  OUTPUTS:
%  - ERR contains all the errors computed, structured as follows:
%         err.PSNR  = PSNR
%         err.MSE   = MSE
%         err.SSIM  = SSIM (matlab)
%         err.SSIM2 = SSIM (zwang)
%         err.VIFp  = VFIp
%
%  - IMG_REF and IMG_DIST contains a horizontaly concatenated version of
%    the projections used for the calculations.
%
%  Projection PSNR is based from:
%  https://github.com/digitalivp/ProjectedPSNR
%
%  SSIM(zwang) and VIFp were taken from:
%  http://live.ece.utexas.edu/research/Quality/index_algorithms.htm
%

if nargin < 7
    error('At least one of the metrics must be choosen.')
end

if size(metrics,2) > 3
    error('Too many input metrics.')
end

allowedMetrics = ["psnr","ssim","vifp"];
% [ok_metric,~] = cellfun(@(x) ismember(x, allowedMetrics), varargin);
ok_metric = ismember(metrics, allowedMetrics);

% if (size(varargin,2) ~= sum(ok_metric))
%     error("Input metric " + sprintf('''%s'' ', varargin{~ok_metric}) + "not allowed, check function documentation. Allowed metrics are: " + sprintf('''%s'' ', allowedMetrics) + "." );
% end

if (size(metrics,2) ~= sum(ok_metric))
    error("Input metric " + sprintf('''%s'' ', metrics(~ok_metric)) + "not allowed, check function documentation. Allowed metrics are: " + sprintf('''%s'' ', allowedMetrics) + "." );
end

if exist('img_ref','var')
    if size(img_ref,2) ~= nviews
        error("Input IMG_REF must be a cell with size equal to nviews.")
    end
end

if nargin < 9
    point_size = 1;
end

if nviews == 6 && point_size == 1
    if nargin < 10
        img_ref = pointcloud_cube_projs(V_ref, C_ref, yuv2rgb, 127); % a bit faster than renderer_projections
        img_ref = {imrotate(img_ref{3},180) imrotate(img_ref{4},180) imrotate(img_ref{5},180),...
                   imrotate(img_ref{6},180) flip(img_ref{1})         flip(img_ref{2})}; %just to standardize projections
    end
    img_dist = pointcloud_cube_projs(V_dist, C_dist, yuv2rgb, 127);
    img_dist = {imrotate(img_dist{3},180) imrotate(img_dist{4},180) imrotate(img_dist{5},180),...
                imrotate(img_dist{6},180) flip(img_dist{1})         flip(img_dist{2})};
else
    if nargin < 10
        img_ref = renderer_projections(V_ref, C_ref, yuv2rgb, nviews, point_size);

    end
    img_dist = renderer_projections(V_dist, C_dist, yuv2rgb, nviews, point_size);

end

% metrics just in the foreground cropping ROIs and padding images to get
% the smaller size possible.
if nargin >= 8  
    if ~isequal(region,'whole')
        s = zeros(nviews,3);
        for i=1:nviews
            [img_ref{i}, img_dist{i}, bgl] = metric_region(img_ref{i}, img_dist{i}, region);
            s(i,:) = size(img_ref{i});
        end
        max_w = max(s(:,1));
        max_h = max(s(:,2));
        
        for i=1:nviews
            img_ref{i}  = padarray(img_ref{i},  [max_w-s(i,1) max_h-s(i,2)], bgl, 'post');
            img_dist{i} = padarray(img_dist{i}, [max_w-s(i,1) max_h-s(i,2)], bgl, 'post');
        end
    end
end

img_ref_a = [img_ref{:}];
img_dist_a = [img_dist{:}];

PSNR  = [];
MSE   = [];
SSIM  = [];
SSIM2 = [];
VIFp  = [];

if any(strcmp(metrics,'psnr'))
    PSNR = psnr(img_dist_a, img_ref_a);
    MSE  = immse(img_dist_a,img_ref_a);
end

if any(strcmp(metrics,'ssim'))
%     SSIM = ssim(img_dist_a, img_ref_a);
    SSIM2 = ssim_index(img_dist_a, img_ref_a);
end

if any(strcmp(metrics,'vifp'))
    VIFp = vifp_mscale(img_ref_a,img_dist_a);
end

err       = struct;
err.PSNR  = PSNR;
err.MSE   = MSE;
err.SSIM  = SSIM;
err.SSIM2 = SSIM2;
err.VIFp  = VIFp;

fn  = fieldnames(err);
tf  = cellfun(@(x) isempty(err.(x)), fn);
err = rmfield(err, fn(tf));
end %function

