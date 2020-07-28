function structVector = generateAllContextVector_v2(num)

if num<6
    structVector.context2DMasked         = [ones(1,num) zeros(1,6-num)];
else
    structVector.context2DMasked         = ones(1,6);
end

if num<15
    structVector.context3DORImages       = [ones(1,num) zeros(1,15-num)];
    structVector.contexts2DTIndependent  = [ones(1,num) zeros(1,15-num)];
    structVector.contexts2DTMasked       = [ones(1,num) zeros(1,15-num)];
else
    structVector.context3DORImages       = ones(1,15);
    structVector.contexts2DTIndependent  = ones(1,15);
    structVector.contexts2DTMasked       = ones(1,15);
end

structVector.contexts3DTORImages     = [ones(1,num) zeros(1,24-num)];
