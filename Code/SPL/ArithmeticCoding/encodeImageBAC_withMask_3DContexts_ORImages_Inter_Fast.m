% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function cabac = encodeImageBAC_withMask_3DContexts_ORImages_Inter_Fast(A,mask,Yleft,pA,cabac)

%This function uses the contexts in:
% cabac.BACContexts_3DT

nC4D  = cabac.BACParams.numberOf4DContexts;
w4D   = cabac.BACParams.windowSizeFor4DContexts;
padpA = padarray(pA, [w4D w4D]);

A = double(A);
%mask = double(mask);
w         = cabac.BACParams.windowSizeFor3DContexts;
padYleft  = padarray(Yleft,[w w]);
padA      = padarray(A,[3 3]);

numberOfContexts = cabac.BACParams.numberOfContextsMasked;
numberOfContexts3DOnly = cabac.BACParams.numberOfContexts3DOnly;

maxValueContext = cabac.BACParams.maxValueContext;
currBACContext = getBACContext(false,maxValueContext/2,maxValueContext);

[idx_i, idx_j] = find(mask');

NPoints = length(idx_i);

targetX   = zeros(NPoints,1,'logical');
Prob_3D4D = zeros(NPoints,2);

for k = 1:1:NPoints
    y = idx_j(k);
    x = idx_i(k);        %It only encodes it IF the mask says so.
    
    currSymbol               = A(y,x);
    contextNumber2D          = get2DContext(padA, [y x], numberOfContexts);
    contextNumberLeft        = getContextLeft(padYleft,[y x], w);
    contextNumber4D          = getContextFromImage(padpA, [y x], w4D, nC4D);
    contextNumber2D_3DOnly   = get2DContext(padA, [y x], numberOfContexts3DOnly);
    
    %Gets the current count for this context.
    currCount4D = [0 0];
    currCount4D(1) = cabac.BACContexts_3DT_ORImages(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 1);
    currCount4D(2) = cabac.BACContexts_3DT_ORImages(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 2);
        
    %Gets the current count for this context.
    currCount3D = [0 0];
    currCount3D(1) = cabac.BACContexts_3D_ORImages(contextNumberLeft, contextNumber2D_3DOnly + 1, 1);
    currCount3D(2) = cabac.BACContexts_3D_ORImages(contextNumberLeft, contextNumber2D_3DOnly + 1, 2);
    
    %Gets the probabilities.
    Prob_3D4D(k,1) = currCount3D(2) / (sum(currCount3D));
    Prob_3D4D(k,2) = currCount4D(2) / (sum(currCount4D));
    targetX(k)     = currSymbol;
        
    %Updates the context.
    if (currSymbol == false)
        cabac.BACContexts_3DT_ORImages(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 1) = cabac.BACContexts_3DT_ORImages(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 1) + 1;
        cabac.BACContexts_3D_ORImages(contextNumberLeft, contextNumber2D_3DOnly + 1, 1)            = cabac.BACContexts_3D_ORImages(contextNumberLeft, contextNumber2D_3DOnly + 1, 1) + 1;
    else
        cabac.BACContexts_3DT_ORImages(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 2) = cabac.BACContexts_3DT_ORImages(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 2) + 1;
        cabac.BACContexts_3D_ORImages(contextNumberLeft, contextNumber2D_3DOnly + 1, 2)            = cabac.BACContexts_3D_ORImages(contextNumberLeft, contextNumber2D_3DOnly + 1, 2) + 1;
    end
    
end

X3D         = (Prob_3D4D(:,1) >= 0.5);
d3d         = (X3D ~= targetX);
nBitsDiff3D = sum(d3d);

X4D         = (Prob_3D4D(:,2) >= 0.5);
d4d         = (X4D ~= targetX);
nBitsDiff4D = sum(d4d);

if (nBitsDiff3D < nBitsDiff4D)    
    dim = 1;
    cabac = encodeParam(true,cabac);
else
    dim = 2;
    cabac = encodeParam(false,cabac);
end

%Actually encode it with this choice
for k = 1:1:NPoints
            
    if (Prob_3D4D(k,dim) > 0.5)
        currBACContext.MPS = true;
        currBACContext.countMPS = floor(Prob_3D4D(k,dim) * maxValueContext);
    else
        currBACContext.MPS = false;
        currBACContext.countMPS = floor((1 - Prob_3D4D(k,dim)) * maxValueContext);
    end
    
    %Encodes the current symbol using the current context probability.
    cabac.BACEngine = encodeOneSymbolBAC(cabac.BACEngine,currBACContext,targetX(k));
end

end

