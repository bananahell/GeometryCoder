function imgs = pointcloud_cube_projs(V, C, convert_yuv2rgb, bgl)

if nargin < 4
    bgl = 128;
end

N = 2.^ceil(log2(max(max(V))+1));

if convert_yuv2rgb
	C = YUVtoRGB(C);
end

imgs = cell(1,6);
imgs{1} = cube_projection(V, C, N, [1 2 3], bgl);
imgs{2} = cube_projection([N-1-V(:,1) V(:,2) N-1-V(:,3)], C, N, [1 2 3], bgl);
imgs{3} = cube_projection(V, C, N, [3 2 1], bgl);
imgs{4} = cube_projection([N-1-V(:,1) V(:,2) N-1-V(:,3)], C, N, [3 2 1], bgl);
imgs{5} = cube_projection(V, C, N, [1 3 2], bgl);
imgs{6} = cube_projection([N-1-V(:,1) N-1-V(:,2) V(:,3)], C, N, [1 3 2], bgl);

function img = cube_projection(V, C, N, V_order, bgl)

img = bgl*ones(N,N,3);
[sV, si] = sortrows(V, V_order);
sC = C(si,:);
n = ones(size(V,1),1);
for k = 1:3
	img( ...
		sub2ind([N N 3], ...
			sV(:,V_order(2))+1, ...
			sV(:,V_order(1))+1, ...
			k*n) ...
		) = sC(:,k);
end
img = uint8(min(max(img,0),255));