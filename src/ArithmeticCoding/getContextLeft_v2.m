function contextNumber = getContextLeft_v2(A,pixel, w,contextVector,numberOfContexts)

y = pixel(1) + w;
x = pixel(2) + w;

c = [0 0 0 0 0 0 0 0 0];

c(1)  = A(y - 1, x - 1);
c(2)  = A(y - 1, x    );
c(3)  = A(y - 1, x + 1);
c(4)  = A(y    , x - 1);
c(5)  = A(y    , x    );
c(6)  = A(y    , x + 1);
c(7)  = A(y + 1, x - 1);
c(8)  = A(y + 1, x    );
c(9)  = A(y + 1, x + 1);

idx = contextVector == 1;
c2 = c(idx);

p = [1 2 4 8 16 32 64 128 256];

p2 = p(1:numberOfContexts);

p2c = p2 .* c2;

contextNumber = sum(p2c) + 1;