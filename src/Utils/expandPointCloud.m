function [pointCloudList] = expandPointCloud(image, pointCloudList, axis, depth)
%EXPANDPOINTCLOUD Receive and image and add the nonzero points to the point cloud list

[x,y] = find(image);
if(axis == 'x')
    pointCloudList = [pointCloudList; padarray([x y], [0 1], depth, 'pre') - 1];
elseif(axis == 'y')
    temp = padarray([x y], [0 1], depth, 'pre');
    if(not(isempty(temp)))
        temp(:,[1 2]) = temp(:,[2 1]);
    end
    pointCloudList = [pointCloudList; temp - 1];
elseif(axis == 'z')
    pointCloudList = [pointCloudList; padarray([x y], [0 1], depth, 'post') - 1];
end

end

