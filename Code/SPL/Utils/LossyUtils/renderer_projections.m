function img = renderer_projections(V, C, yuv2rgb, nviews, s, focus, up)
%RENDERER_PROJECTIONS  Gets projections from point clouds using the MPEG Renderer
%  Creates a camera path defined by the number of views indicated by the
%  user and runs the PccAppRenderer (version 3.02_beta) to get the
%  projections.
%
%  img = renderer_projections(V, C, yuv2rgb, nviews, [focus], [up])
%  
%  INPUTS:
%  - V and C are the geometry and color of the point cloud.
%  - YUV2RGB is either 1 or 0 for the convertion.
%  - NVIEWS is the number of projections used for the metrics.
%  - FOCUS is an optional parameter is the camera's point of focus [x y z]. 
%    It can be passed as a matrix with the size of NVIEWS (in case different 
%    point of focus are needed for each camera position) or it can be just 
%    a vector for a fixed point of focus. The default value is the center of 
%    the cube containing the point cloud, e.i. [2^(L-1) 2^(L-1) 2^(L-1)].
%  - UP is an optional parameter, it indicates the axis in which the point 
%    cloud is vertically aligned. Usually point clouds are aligned in the 
%    y-axis [0 1 0] or in the z-axis [0 0 1]. This parameter can be passed 
%    either as a matrix, if axes rotation is desired, or as a single vector
%    for a fixed axes direction. The default value is aligned with the
%    y-axis [0 1 0].
%  - S is an optional parameter, it indicates the size of the points used
%    to render the point cloud (default is 1).
% 
%  OUTPUT:
%  - IMG is a cell containing all the projections taken from the renderer.
%

L = nextpow2(max(max(V)));
w = 2^L;
h = 2^L;
boxsize = 2^L;


if nargin < 5 
    s = 1;
end

if nargin < 6
    focus = boxsize/2*ones(1,3);
    up = [0 1 0];
end

if isscalar(nviews)
    cam_pos = get_positions(nviews);
else
    cam_pos = nviews;
end

if yuv2rgb
    C = uint8(YUVtoRGB(C));
else
    C = uint8(C);
end

create_path(cam_pos, focus, up, boxsize, 'path.txt');

PccAppRenderer(V,C,'ortho', 1, 'overlay', 0, 'camera', 'path.txt', 'RgbFile', 'projections', 'size', s);

img = read_rgb_video('projections.rgb', w, h);
fclose('all');
delete path.txt projections.rgb

end % function


function pos = get_positions(nviews)
if(nviews == 4) % tetrahedron
    x = [ 1  1 -1 -1]/sqrt(3);
    y = [ 1 -1  1 -1]/sqrt(3);
    z = [ 1 -1 -1  1]/sqrt(3);
    
elseif(nviews == 6) % octahedron
    x = [-1  1  0  0  0  0];
    y = [ 0  0 -1  1  0  0];
    z = [ 0  0  0  0 -1  1];
    
elseif(nviews == 8) % cube
    x = [-1  1 -1  1 -1  1 -1  1]/sqrt(3);
    y = [-1 -1  1  1 -1 -1  1  1]/sqrt(3);
    z = [-1 -1 -1 -1  1  1  1  1]/sqrt(3);
    
elseif(nviews == 12) % icosahedron
    p = (1+sqrt(5))/2;
    x = [ 0  0  0  0 -1  1 -1  1 -p  p -p  p]/sqrt(1+p^2);
    y = [-1  1 -1  1 -p -p  p  p  0  0  0  0]/sqrt(1+p^2);
    z = [-p -p  p  p  0  0  0  0 -1 -1  1  1]/sqrt(1+p^2);
elseif(nviews == 20) % dodecahedron
    p = (1+sqrt(5))/2;
    x = [ 1   1/p  -p    p    -1    0    -p    1   -1   -1    1   1/p   -1    0    0  -1/p   p   -1/p   1    0 ];
    y = [ 1    0  -1/p  1/p    1   -p    1/p  -1    1   -1   -1    0    -1   -p    p    0  -1/p    0    1    p ];
    z = [ 1    p    0    0    -1  -1/p    0    1    1    1   -1   -p    -1   1/p -1/p   p    0    -p   -1   1/p];
elseif(nviews == 42) % icosahedron with 1 level dyadic split 
    p = (1+sqrt(5))/2;
    x = [ 0  0  0  0 -1  1 -1  1 -p  p -p  p]/sqrt(1+p^2);
    y = [-1  1 -1  1 -p -p  p  p  0  0  0  0]/sqrt(1+p^2);
    z = [-p -p  p  p  0  0  0  0 -1 -1  1  1]/sqrt(1+p^2);
    V = [x' y' z'];
    d = zeros(12*12,3);
    for i=1:12
        for j =1:12
            d(12*(i-1)+j,:)=(V(i,:)-V(j,:))/2;
        end
    end
    d = unique(d,'rows');
    norm_diff=round(vecnorm(d,2,2),4);
    val_norm = unique(norm_diff); %4 possible values 0 ~0.5 ~0.8 and 1
    d = d(norm_diff == val_norm(3),:);
    x = [x d(:,1)'];
    y = [y d(:,2)'];
    z = [z d(:,3)'];
    
else
    [x, y, z] = fibonacci_sphere(nviews);
end
pos = cat(1,x,y,z)';

end %function


function [x, y, z] = fibonacci_sphere(N)
i = linspace(1,N,N);
gold = (1+sqrt(5))/2;

theta = acos(1 - 2*i./N); %[0~pi]
phi = pi * gold * i; %[0~2*pi]

x = cos(phi) .* sin(theta);
y = sin(phi) .* sin(theta);
z = cos(theta);
end %function