%Contexts
%          14
%    11  9  6 10 12
% 15  7  4  2  3  8 16
% 13  5  1  ?
%
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function contextNumber = get2DContext(A, pixel, numberOfContexts)
if (nargin == 2)
    numberOfContexts = 6;
end

% Initialize constants across repeated calls.
%contX = [-1 0 +1 -1 -2 0 -2 +2 -1 +1 -2 +2 -3 0 -3 +3];
%contY = [0 -1 -1 -1 0 -2 -1 -1 -2 -2 -2 -2 0 -3 -1 -1];

%y = pixel(1) + 3;
%x = pixel(2) + 3;

%index = sub2ind(...
%    size(A), ...
%    y + contY(1:numberOfContexts), ...
%    x + contX(1:numberOfContexts));

%contX =        [2 3 4 2 1 3 1 5 2 4 1 5 0 3 0 6];
contXminusOne = [1 2 3 1 0 2 0 4 1 3 0 4 -1 2 -1 5];
contY = [3 2 2 2 3 1 2 2 1 1 1 1 3 0 2 2];

%index = sub2ind(size(A), contY(1:numberOfContexts) + pixel(1), contX(1:numberOfContexts) + pixel(2));

%TODO: the number of rows must be a parameter to the function, it takes too
%long to compute it from the line below.
[rows,~] = size(A);
%rows = 518;
index = contY(1:numberOfContexts) + pixel(1) + (rows .*(contXminusOne(1:numberOfContexts) + pixel(2)));


%contextNumber = sum(2.^(0:numberOfContexts-1) .* A(index(1:numberOfContexts)));
    
p = [1 2 4 8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768];
p2 = p(1:numberOfContexts);

c2 = A(index);

p2c = p2 .* c2;

contextNumber = sum(p2c);
