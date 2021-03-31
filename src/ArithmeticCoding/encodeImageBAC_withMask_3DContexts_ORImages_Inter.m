% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function cabac_out = encodeImageBAC_withMask_3DContexts_ORImages_Inter(A,mask,Yleft,pA,cabac)

%This function uses the contexts in:
% cabac.BACContexts_3DT

nC4D            = cabac.BACParams.numberOfContexts4DTORImages;
w4D             = cabac.BACParams.windowSizeFor4DContexts;
contextVector4D = cabac.BACParams.contextVector4DTORImages;
padpA           = padarray(pA, [w4D w4D]);

w                     = cabac.BACParams.windowSizeFor3DContexts;
nC3D                  = cabac.BACParams.numberOfContexts3DTORImages;
contextVector3D       = cabac.BACParams.contextVector3DTORImages;
A = double(A);
padYleft  = padarray(Yleft,[w w]);
padA      = padarray(A,[3 3]);

contextVector2D        = cabac.BACParams.contextVector2DTORImages;
numberOfContexts       = cabac.BACParams.numberOfContexts2DTORImages;

maxValueContext = cabac.BACParams.maxValueContext;
currBACContext = getBACContext(false,maxValueContext/2,maxValueContext);


[idx_i, idx_j] = find(mask');

%1 encode it using 4D Contexts.
for k = 1:1:length(idx_i)
    y = idx_j(k);
    x = idx_i(k);        %It only encodes it IF the mask says so.
    
    currSymbol               = A(y,x);
    contextNumber2D          = get2DContext_v2(padA, [y x],contextVector2D,numberOfContexts);
    contextNumberLeft        = getContextLeft_v2(padYleft,[y x], w,contextVector3D,nC3D);
    contextNumber4D          = getContextFromImage_v2(padpA, [y x],w4D,contextVector4D, nC4D);
    
    %Gets the current count for this context.
    currCount = [0 0];
    currCount(1) = cabac.BACContexts_3DT_ORImages(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 1);
    currCount(2) = cabac.BACContexts_3DT_ORImages(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 2);
    
    %Gets the current BAC context for this context
    p1s = currCount(2) / (sum(currCount));
    
    if (p1s > 0.5)
        currBACContext.MPS = true;
        currBACContext.countMPS = floor(p1s * maxValueContext);
    else
        currBACContext.MPS = false;
        currBACContext.countMPS = floor((1 - p1s) * maxValueContext);
    end
    
    %Encodes the current symbol using the current context probability.
    cabac.BACEngine = encodeOneSymbolBAC(cabac.BACEngine,currBACContext,currSymbol);
    
    %Updates the context.
    if (currSymbol == false)
        cabac.BACContexts_3DT_ORImages(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 1) = cabac.BACContexts_3DT_ORImages(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 1) + 1;
    else
        cabac.BACContexts_3DT_ORImages(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 2) = cabac.BACContexts_3DT_ORImages(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 2) + 1;
    end
end

cabac_out = cabac;
cabac_out = encodeParam(false,cabac_out);


