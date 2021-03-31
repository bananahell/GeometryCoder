% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function cabac = entropyWithMaskInterSingle(A,idx_i, idx_j,Yleft,pA,cabac)

%This function uses the contexts in:
% cabac.BACContexts_3DT

nC4D            = cabac.BACParams.numberOf4DContexts;
w4D             = cabac.BACParams.windowSizeFor4DContexts;
contextVector4D = cabac.BACParams.contextVector4D;
padpA           = padarray(pA, [w4D w4D]);

nC3D            = cabac.BACParams.numberOf3DContexts;
contextVector3D = cabac.BACParams.contextVector3D;
w               = cabac.BACParams.windowSizeFor3DContexts;

A = double(A);
padYleft  = padarray(Yleft,[w w]);
padA      = padarray(A,[3 3]);

contextVector2D = [1 1 1 1 1 1];
nC2D            = 6;

for k = 1:1:length(idx_i)
    y = idx_j(k);
    x = idx_i(k);        %It only encodes it IF the mask says so.
    
    currSymbol               = A(y,x);
    %contextNumber2D          = get2DContext(padA, [y x]);
    contextNumber2D          = get2DContext_v2(padA, [y x], contextVector2D, nC2D);
    contextNumberLeft        = getContextLeft_v2(padYleft,[y x], w,contextVector3D,nC3D);
    contextNumber4D          = getContextFromImage_v2(padpA, [y x], w4D, contextVector4D,nC4D);
    %contextNumber2D_3DOnly   = get2DContext(padA, [y x]);
    %contextNumberLeft_3DOnly = getContextLeft_v2(padYleft,[y x], w,contextVector3D,nC3D);
    
    %Updates the context.
    if (currSymbol == false)
        cabac.BACContexts_3DT(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 1) = cabac.BACContexts_3DT(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 1) + 1;
%         cabac.BACContexts_3D(contextNumberLeft_3DOnly, contextNumber2D_3DOnly + 1, 1)            = cabac.BACContexts_3D(contextNumberLeft_3DOnly, contextNumber2D_3DOnly + 1, 1) + 1;
    else
        cabac.BACContexts_3DT(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 2) = cabac.BACContexts_3DT(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 2) + 1;
%         cabac.BACContexts_3D(contextNumberLeft_3DOnly, contextNumber2D_3DOnly + 1, 2)            = cabac.BACContexts_3D(contextNumberLeft_3DOnly, contextNumber2D_3DOnly + 1, 2) + 1;
    end
end