function create_path(cam_pos, cam_view, cam_up, boxsize, path_name)
% CREATE_PATH Creates a camera path to be used to get projections from
% PccAppRenderer.
% INPUTS:
%  POS: is a matrix with the camera positions to get the projections from,
%  it can be passed either as [x, y, z] cartesian coordinates or as 
%  [theta, phi] spherical coordinates (azimuth theta, elevation phi).
%  
%  VIEW: is the camera's point of focus [x y z]. It can be passed as a 
%  matrix with the same size of input POS (in case different point of focus
%  are needed for each camera position) or it can be just a vector for a
%  fixed point of focus. For the center of the cube containing the point
%  cloud use [2^(L-1) 2^(L-1) 2^(L-1)].
% 
%  UP: it is an idication of the camera's up axis, in other words it indicates
%  the axis in which the point cloud is vertically aligned. Usually point
%  clouds are aligned in the y-axis [0 1 0] or in the z-axis [0 0 1]. Again
%  this parameter can be passed either as a matrix, if axes rotation is
%  desired, or as a single vector for a fixed axes direction. (Depending on
%  the position of the camera, a forced axes rotation can be applyed to
%  deal with cases where POS and UP are parallel to each other).
% 
%  BOXSIZE: 2^L where L is the depth of the point cloud.
%  
%  PATH_NAME: string with the name of the path to be recorded (eg.
%  path.txt)

numPoints = size(cam_pos,1);
idx = linspace(0,numPoints-1,numPoints);
r = 3 * boxsize; % 1:1 size

if size(cam_pos,2) == 3
    x = cam_pos(:,1);
    y = cam_pos(:,2);
    z = cam_pos(:,3);
    [theta, phi] = cart2sph(x,y,z);
elseif size(cam_pos,2) == 2
    theta = cam_pos(:,1);
    phi   = cam_pos(:,2);
else
    error('Accepted coordinate systems are for cartesian [x y z] matrix spherical [TH PHI] matrix');
end

[pos(:,1),pos(:,2),pos(:,3)] = sph2cart(theta,phi,r);
pos = round(cam_view - pos, 8); % round to avoid eps error

if size(cam_view,1) == 1    
    view = repmat(cam_view-0.5, [numPoints, 1]);
elseif size(cam_view,1) == numPoints
    view = cam_view-0.5; %minu bias correction (trial and error)
else
    error('VIEW must be either a vector or a matriz with the same size of input POS');
end


if size(cam_up,1) == 1    
    up = repmat(cam_up, [numPoints, 1]);
elseif size(cam_up,1) == numPoints
    up = cam_view;
else
    error('UP must be either a vector or a matriz with the same size of input POS');
end

norm_pos = pos-boxsize/2;
norm_pos = 1./vecnorm(norm_pos')'.*norm_pos;
inval_up = find(abs(dot(norm_pos,up,2)) == 1); %up and pos parallel
if ~isempty(inval_up)
    up(inval_up,:) = rotate_axes(up(inval_up,:),pi/2,0,pi/2);
end

path = [idx', pos, view, up];

fid = fopen(path_name,'w');
header = "#Index        pos.x           pos.y           pos.z             view.x       view.y       view.z            up.x         up.y         up.z\n";
fprintf(fid, header);
fprintf(fid, "%4d  %15.8f %15.8f %15.8f      %12.8f %12.8f %12.8f     %12.8f %12.8f %12.8f \n", path');

fclose(fid);

end %function
