%Contexts
%       6 
%    4  2  3
% 5  1  ?
function contextNumber = get2DContext_v2(A, pixel, contextVector, numberOfContexts)

y = pixel(1) + 3;
x = pixel(2) + 3;

%Initialize all contexts as zeros.
c = [0 0 0 0 0 0];

c(1)  = A(y     , x - 1);
c(2)  = A(y - 1, x    );
c(3)  = A(y - 1, x + 1);
c(4)  = A(y - 1, x - 1);
c(5)  = A(y    , x - 2);
c(6)  = A(y - 2, x    );

idx = contextVector == 1;
c2 = c(idx);

p = [1 2 4 8 16 32];
p2 = p(1:numberOfContexts);

p2c = p2 .* c2;

contextNumber = sum(p2c);
%context       = c(1:numberOfContexts);













    