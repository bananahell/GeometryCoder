% function comparePlys
%  Compares two point clouds.
%
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function eq = comparePlys2(file1, file2)

[loc1, ~] = plyRead(file1, 0);
[loc2, ~] = plyRead(file2, 0);

[N1, ~] = size(loc1);
[N2, ~] = size(loc2);

if (N1 ~= N2)
    eq = 0;
else
    loc1 = sortrows(loc1);
    loc2 = sortrows(loc2);
    
    eq = isequal(loc1,loc2);
end
