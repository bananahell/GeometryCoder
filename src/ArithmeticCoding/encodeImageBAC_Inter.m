% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function cabac = encodeImageBAC_Inter(A, pA, cabac)

%This function uses the contexts in:
% cabac.BACContexts_2DT_Independent

nC4D            = cabac.BACParams.numberOfContexts4DTIndependent;
w4D             = cabac.BACParams.windowSizeFor4DContexts;
contextVector4D = cabac.BACParams.contextVector4DTIndependent;
padpA           = padarray(pA, [w4D w4D]);

A = double(A);
[sy, sx] = size(A);
padA = padarray(A,[3 3]);

maxValueContext = cabac.BACParams.maxValueContext;
currBACContext = getBACContext(false,maxValueContext/2,maxValueContext);

numberOfContexts = cabac.BACParams.numberOfContexts2DTIndependent;
contextVector2D = cabac.BACParams.contextVector2DTIndependent;

for y = 1:1:sy
    for x = 1:1:sx
        currSymbol    = A(y,x);
        contextNumber   = get2DContext_v2(padA, [y x],contextVector2D,numberOfContexts);
        contextNumber4D = getContextFromImage_v2(padpA, [y x], w4D,contextVector4D,nC4D);
                
        %Gets the current count for this context.
        currCount = cabac.BACContexts_2DT_Independent(contextNumber4D, contextNumber + 1,:);        
        
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
            cabac.BACContexts_2DT_Independent(contextNumber4D, contextNumber + 1,1) = cabac.BACContexts_2DT_Independent(contextNumber4D, contextNumber + 1,1) + 1;
        else
            cabac.BACContexts_2DT_Independent(contextNumber4D, contextNumber + 1,2) = cabac.BACContexts_2DT_Independent(contextNumber4D, contextNumber + 1,2) + 1;
        end
        
    end
end
% sumBits = auxTable - reshape(sum(cabac.BACContexts_3DT_ORImages,2),[2^nC4D 2^numberOfContexts 2]);
% 
% cabac.BACContexts_3DT_ORImages = addingContextTable(cabac.BACContexts_3DT_ORImages,[contextVector2D zeros(1,9) contextVector4D],sumBits,2);



