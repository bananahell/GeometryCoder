%The input A contains what I know about A.
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function [A, cabac] = decodeImageBAC_withMask_3DContexts_ORImages_Inter(A, mask, Yleft, pA, cabac)

%This function uses the contexts in:
% cabac.BACContexts_3DT

nC4D            = cabac.BACParams.numberOfContexts4DTORImages;
w4D             = cabac.BACParams.windowSizeFor4DContexts;
contextVector4D = cabac.BACParams.contextVector4DTORImages;
padpA           = padarray(pA, [w4D w4D]);

w                     = cabac.BACParams.windowSizeFor3DContexts;
nC3D                  = cabac.BACParams.numberOfContexts3DTORImages;
contextVector3D       = cabac.BACParams.contextVector3DTORImages;
% nC3DOnly              = cabac.BACParams.numberOfContexts3DORImages;
% contextVector3D3DOnly = cabac.BACParams.contextVector3DORImages;

A = double(A);
padYleft  = padarray(Yleft,[w w]);
padA      = padarray(A,[3 3]);

numberOfContexts       = cabac.BACParams.numberOfContexts2DTORImages;
contextVector2D        = cabac.BACParams.contextVector2DTORImages;

maxValueContext = cabac.BACParams.maxValueContext;

currBACContext = getBACContext(false,maxValueContext/2,maxValueContext);

%Look in the bitstream if this image was encoded using 4D or 3D contexts.
[cabac.ParamBitstream, bit] = cabac.ParamBitstream.read1Bit();


[idx_i, idx_j] = find(mask');
for k = 1:1:length(idx_i)
    y = idx_j(k);
    x = idx_i(k);        %It only decodes it IF the mask says so.
    
    contextNumber2D          = get2DContext_v2(padA, [y x], contextVector2D, numberOfContexts);
    contextNumberLeft        = getContextLeft_v2(padYleft,[y x], w,contextVector3D,nC3D);
    contextNumber4D          = getContextFromImage_v2(padpA, [y x], w4D,contextVector4D ,nC4D);
    
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
    
    %Decodes the current symbol using the current context probability
    [cabac.BACEngineDecoder, currSymbol] = decodeOneSymbolBAC(cabac.BACEngineDecoder,currBACContext);
    
    A(y,x)        = currSymbol;          %Fills the decoded matrix.
    padA(y+3,x+3) = double(currSymbol);  %Fills the padded image to keep the context correct.
    
    %Updates the context.
    if (currSymbol == false)
        cabac.BACContexts_3DT_ORImages(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 1) = cabac.BACContexts_3DT_ORImages(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 1) + 1;
    else
        cabac.BACContexts_3DT_ORImages(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 2) = cabac.BACContexts_3DT_ORImages(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 2) + 1;
    end
    
end

