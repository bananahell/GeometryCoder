% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function cabac = entropyWithMask3DContextsInter(A,idx_i, idx_j,Yleft,pA,cabac, consider3DOnlyContexts)

%This function uses the contexts in:
% cabac.BACContexts_3DT

nC4D            = cabac.BACParams.numberOf4DContexts;
contextVector4D = cabac.BACParams.contextVector4D;
w4D             = cabac.BACParams.windowSizeFor4DContexts;
padpA           = padarray(pA, [w4D w4D]);

A = double(A);
%mask = double(mask);

nC3D            = cabac.BACParams.numberOf3DContexts;
contextVector3D = cabac.BACParams.contextVector3D;
w               = cabac.BACParams.windowSizeFor3DContexts;
padYleft        = padarray(Yleft,[w w]);
padA            = padarray(A,[3 3]);

numberOfContexts = cabac.BACParams.numberOfContextsMasked;
numberOfContexts3DOnly = cabac.BACParams.numberOfContexts3DOnly;
contextVector2D = cabac.BACParams.contextVector2D;

if (consider3DOnlyContexts == 1)        
    for k = 1:1:length(idx_i)
        y = idx_j(k);
        x = idx_i(k);        %It only encodes it IF the mask says so.
        
        currSymbol               = A(y,x);
        contextNumber2D          = get2DContext_v2(padA, [y x], contextVector2D,numberOfContexts);
        contextNumberLeft        = getContextLeft_v2(padYleft,[y x], w,contextVector3D,nC3D);
        contextNumber4D          = getContextFromImage_v2(padpA, [y x], w4D, contextVector4D,nC4D);
        contextNumber2D_3DOnly   = get2DContext_v2(padA, [y x], [1 1 1 1 1 0],numberOfContexts3DOnly);
        
        %Updates the context.
        if (currSymbol == false)
            cabac.BACContexts_3DT(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 1) = cabac.BACContexts_3DT(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 1) + 1;
            cabac.BACContexts_3D(contextNumberLeft, contextNumber2D_3DOnly + 1, 1)            = cabac.BACContexts_3D(contextNumberLeft, contextNumber2D_3DOnly + 1, 1) + 1;
        else
            cabac.BACContexts_3DT(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 2) = cabac.BACContexts_3DT(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 2) + 1;
            cabac.BACContexts_3D(contextNumberLeft, contextNumber2D_3DOnly + 1, 2)            = cabac.BACContexts_3D(contextNumberLeft, contextNumber2D_3DOnly + 1, 2) + 1;
        end
    end
    
else
    for k = 1:1:length(idx_i)
        y = idx_j(k);
        x = idx_i(k);        %It only encodes it IF the mask says so.
        
        currSymbol               = A(y,x);
        contextNumber2D          = get2DContext_v2(padA, [y x], contextVector2D,numberOfContexts);
        contextNumberLeft        = getContextLeft_v2(padYleft,[y x], w,contextVector3D,nC3D);
        contextNumber4D          = getContextFromImage_v2(padpA, [y x], w4D, contextVector4D,nC4D);
        
        %Updates the context.
        if (currSymbol == false)
            cabac.BACContexts_3DT(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 1) = cabac.BACContexts_3DT(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 1) + 1;            
        else
            cabac.BACContexts_3DT(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 2) = cabac.BACContexts_3DT(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 2) + 1;            
        end
    end    
end
