function C_new = pointcloud_interpolation(V, C, V_new, xyz_max_dist)

% warning([char(10) "    pointcloud_interpolation() has a bug," ...
% 	char(10) "    which wasn't fixed so as to keep" ...
% 	char(10) "    previous results repeatable. Use" ...
% 	char(10) "    pointcloud_filtering() instead."]);

[old_pos, old_pos_org] = ismember(V_new,V,'rows');
new_pos = ~old_pos;
V_created = V_new(new_pos,:);

deltas = xyz_displacements(-xyz_max_dist:xyz_max_dist);
dists = sqrt(sum(deltas.^2,2));
val_deltas = find(dists>0);
deltas = deltas(val_deltas,:);
dists = dists(val_deltas,:);

C_created = V_created*0;
C_weights = C_created;
for k = 1:length(dists)
	[~,delta_ok,created_ok] = intersect(bsxfun(@plus,V,deltas(k,:)),V_created,'rows');
	C_created(created_ok,:) = C_weights(created_ok,:) + C(delta_ok,:)/dists(k);
	C_weights(created_ok,:) = 1/dists(k);
end
C_created = bsxfun(@rdivide, C_created, C_weights);
C_new = V_new*0;
C_new(old_pos,:) = C(old_pos_org(old_pos_org>0),:);
C_new(new_pos,:) = C_created;