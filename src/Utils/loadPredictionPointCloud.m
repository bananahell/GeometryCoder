function ptCloud = loadPredictionPointCloud(filename)

[vertex, ~] = plyRead(filename, 0);

ptCloud = getPointCloudStruct();

ptCloud.Location = vertex;
ptCloud.Count = length(vertex);
mm = min(vertex);
mx = max(vertex);
ptCloud.XLimits = [mm(1) mx(1)];
ptCloud.YLimits = [mm(2) mx(2)];
ptCloud.ZLimits = [mm(3) mx(3)];

end