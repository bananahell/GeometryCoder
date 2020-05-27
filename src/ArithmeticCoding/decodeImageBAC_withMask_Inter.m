%The input A contains what I know about A.
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function [A, cabac] = decodeImageBAC_withMask_Inter(A, mask, pA, cabac)

%This function uses the contexts in:
% cabac.BACContexts_2DT_Masked

w4D   = cabac.BACParams.windowSizeFor4DContexts;
padpA = padarray(pA, [w4D w4D]);

padA = padarray(A,[3 3]);

maxValueContext = cabac.BACParams.maxValueContext;

currBACContext = getBACContext(false,maxValueContext/2,maxValueContext);

numberOfContexts = cabac.BACParams.numberOfContextsMasked;
numberOfContexts3DOnly = cabac.BACParams.numberOfContexts3DOnly;

%Look in the bitstream if this image was encoded using 4D or 3D contexts.
[cabac.ParamBitstream, bit] = cabac.ParamBitstream.read1Bit();

if (bit == 0) %4D Contexts were used!
    [idx_i, idx_j] = find(mask');
    for k = 1:1:length(idx_i)
        y = idx_j(k);
        x = idx_i(k);        %It only decodes it IF the mask says so.
        contextNumber = get2DContext(padA, [y x], numberOfContexts);
        contextNumber4D = getContextLeft(padpA, [y x], w4D);
        contextNumber2D_3DOnly = get2DContext(padA, [y x], numberOfContexts3DOnly);
        
        %Gets the current count for this context.
        currCount = cabac.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,:);
        
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
            cabac.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,1) = cabac.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,1) + 1;
            cabac.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,1)  = cabac.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,1) + 1;
        else
            cabac.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,2) = cabac.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,2) + 1;
            cabac.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,2)  = cabac.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,2) + 1;
        end
        
        
    end
else
    [idx_i, idx_j] = find(mask');
    for k = 1:1:length(idx_i)
        y = idx_j(k);
        x = idx_i(k);        %It only decodes it IF the mask says so.
        
        contextNumber = get2DContext(padA, [y x], numberOfContexts);
        contextNumber4D = getContextLeft(padpA, [y x], w4D);
        contextNumber2D_3DOnly = get2DContext(padA, [y x], numberOfContexts3DOnly);
        
        %Gets the current count for this context.
        currCount = cabac.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,:);
        
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
            cabac.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,1) = cabac.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,1) + 1;
            cabac.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,1)  = cabac.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,1) + 1;
        else
            cabac.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,2) = cabac.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,2) + 1;
            cabac.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,2)  = cabac.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,2) + 1;
        end
        
        
    end
end

