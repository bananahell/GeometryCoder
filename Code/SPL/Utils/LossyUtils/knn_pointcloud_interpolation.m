function C_new = knn_pointcloud_interpolation(V, C, V_new, xyz_max_norm)
% V and V_new must have the same resolution (depth)
% xyz_max_dist max neighbourhood to considerer
C = double(C);
maxd = double(eps('single')) + xyz_max_norm; %double(eps('single'))+sqrt(3)
[old_pos, old_pos_org] = ismember(V_new, V, 'rows');
new_pos = ~old_pos;
V_created = V_new(new_pos,:); % V_created has only the points from V_new that don't exist in V
[idx, d] = rangesearch(V, V_created, maxd, 'NSMethod', 'kdtree', 'Distance', 'euclidean');
 
% isolated_points = cellfun(@(x) size(x,2)==1,idx); if there is a new
% isolated point so there's no way to interpolate its color so we leave it
% black.
C_created = 0 * V_created;
% tic
for i=1:size(V_created,1)
    weights = 1./d{i}; %there's no 1/0 because these are all new points so the distance is garanteed to be > 0
    C_created(i,:) = (weights*C(idx{i},:))/sum(weights);
end
C_new = V_new*0;
C_new(old_pos,:) = C(old_pos_org(old_pos_org>0),:);
C_new(new_pos,:) = C_created;

end %function