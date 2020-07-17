function cabac = entropyFirstSilhouette(A, pA, cabac)

%This function uses the contexts in:
nC4D            = cabac.BACParams.numberOf4DContexts;
w4D             = cabac.BACParams.windowSizeFor4DContexts;
contextVector4D = cabac.BACParams.contextVector4D;
padpA           = padarray(pA, [w4D w4D]);

A = double(A);
padA = padarray(A,[3 3]);
numberOfContexts = cabac.BACParams.numberOfContextsIndependent;
[sy, sx] = size(A);

contextVector2D = cabac.BACParams.contextVector2D; 


for y = 1:1:sy
    for x = 1:1:sx
        currSymbol    = A(y,x);
        contextNumber   = get2DContext_v2(padA, [y x],contextVector2D,numberOfContexts);
        contextNumber4D = getContextFromImage_v2(padpA, [y x], w4D,contextVector4D,nC4D);   
        
        %Updates the context.
        if (currSymbol == false)
            cabac.BACContexts_2DT_Independent(contextNumber4D, contextNumber + 1,1) = cabac.BACContexts_2DT_Independent(contextNumber4D, contextNumber + 1,1) + 1;
        else
            cabac.BACContexts_2DT_Independent(contextNumber4D, contextNumber + 1,2) = cabac.BACContexts_2DT_Independent(contextNumber4D, contextNumber + 1,2) + 1;
        end
        
    end
end
