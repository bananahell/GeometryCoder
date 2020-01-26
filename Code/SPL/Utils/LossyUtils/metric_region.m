function [roi_ref, roi_dist, bgl] = metric_region(img_ref, img_dist, region)
if isequal(region,'whole')
    roi_ref  = img_ref;
    roi_dist = img_dist;
elseif isequal(region,'ref')
    [x, y, bgl] = roi_foreground(img_ref);
    roi = [x(1) y(1) x(2)-x(1) y(2)-y(1)];
    roi_ref  = imcrop(img_ref, roi);
    roi_dist = imcrop(img_dist, roi);
elseif isequal(region,'intersection')
    [x_r, y_r, bgl] = roi_foreground(img_ref);
    [x_d, y_d] = roi_foreground(img_dist);
    x_i = [max(x_r(1),x_d(1)) min(x_r(2),x_d(2))];
    y_i = [max(y_r(1),y_d(1)) min(y_r(2),y_d(2))];
    roi = [x_i(1) y_i(1) x_i(2)-x_i(1) y_i(2)-y_i(1)];
    roi_ref  = imcrop(img_ref, roi);
    roi_dist = imcrop(img_dist, roi);
elseif isequal(region, 'union')
    [x_r, y_r, bgl] = roi_foreground(img_ref);
    [x_d, y_d] = roi_foreground(img_dist);
    x_u = [min(x_r(1),x_d(1)) max(x_r(2),x_d(2))];
    y_u = [min(y_r(1),y_d(1)) max(y_r(2),y_d(2))];
    roi = [x_u(1) y_u(1) x_u(2)-x_u(1) y_u(2)-y_u(1)];
    roi_ref  = imcrop(img_ref, roi);
    roi_dist = imcrop(img_dist, roi);
end
end

function [x, y, bgl] = roi_foreground(img, background_level)
if nargin == 1
%     background_level = 127;
    background_level = imhist(img);
    [~,background_level] = max(background_level);
    background_level = background_level -1;
end
background_level = background_level*ones(1,3);
bgl = background_level(1);

[y, x] = find(all(img ~= permute(background_level, [1 3 2]), 3));
x_min = min(x) - 1;
x_max = max(x) + 1;
y_min = min(y) - 1;
y_max = max(y) + 1;
x = [x_min x_max];
y = [y_min y_max];
% crop_array = [x_min y_min x_max-x_min y_max-y_min];
end
