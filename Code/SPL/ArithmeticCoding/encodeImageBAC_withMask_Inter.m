% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function cabac_out = encodeImageBAC_withMask_Inter(A,mask,pA,cabac, testMode4D_3D, consider3DOnlyContexts)

%This function uses the contexts in:
% cabac.BACContexts_2DT_Masked

nC4D  = cabac.BACParams.numberOf4DContexts;
w4D   = cabac.BACParams.windowSizeFor4DContexts;
padpA = padarray(pA, [w4D w4D]);

A    = double(A);
padA = padarray(A,[3 3]);

maxValueContext = cabac.BACParams.maxValueContext;

currBACContext = getBACContext(false,maxValueContext/2,maxValueContext);

numberOfContexts       = cabac.BACParams.numberOfContextsMasked;
numberOfContexts3DOnly = cabac.BACParams.numberOfContexts3DOnly;

if (consider3DOnlyContexts == 1)
    nBitsStart = cabac.BACEngine.bitstream.size();
    nBits4D    = Inf;
    nBits3D    = Inf;
    
    
    [idx_i, idx_j] = find(mask');
    
    %1 encode it using 4D Contexts.
    if (testMode4D_3D(1) == 1)
        cabac4D = cabac;
        for k = 1:1:length(idx_i)
            y = idx_j(k);
            x = idx_i(k);        %It only encodes it IF the mask says so.
            
            currSymbol             = A(y,x);
            contextNumber          = get2DContext(padA, [y x], numberOfContexts);
            contextNumber4D        = getContextFromImage(padpA, [y x], w4D, nC4D);
            contextNumber2D_3DOnly = get2DContext(padA, [y x], numberOfContexts3DOnly);
            
            %Gets the current count for this context.
            currCount = cabac4D.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,:);
            
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
            cabac4D.BACEngine = encodeOneSymbolBAC(cabac4D.BACEngine,currBACContext,currSymbol);
            
            %Updates the context.
            if (currSymbol == false)
                cabac4D.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,1) = cabac4D.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,1) + 1;
                cabac4D.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,1)          = cabac4D.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,1) + 1;
            else
                cabac4D.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,2) = cabac4D.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,2) + 1;
                cabac4D.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,2)          = cabac4D.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,2) + 1;
            end
        end
        nBits4D = cabac4D.BACEngine.bitstream.size() - nBitsStart;
    end
    
    %2 encode it using 3D contexts.
    if (testMode4D_3D(2) == 1)
        cabac3D = cabac;
        for k = 1:1:length(idx_i)
            y = idx_j(k);
            x = idx_i(k);        %It only encodes it IF the mask says so.
            
            currSymbol             = A(y,x);
            contextNumber          = get2DContext(padA, [y x], numberOfContexts);
            contextNumber4D        = getContextFromImage(padpA, [y x], w4D, nC4D);
            contextNumber2D_3DOnly = get2DContext(padA, [y x], numberOfContexts3DOnly);
            
            %Gets the current count for this context.
            currCount = cabac3D.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,:);
            
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
            cabac3D.BACEngine = encodeOneSymbolBAC(cabac3D.BACEngine,currBACContext,currSymbol);
            
            %Updates the context.
            if (currSymbol == false)
                cabac3D.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,1) = cabac3D.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,1) + 1;
                cabac3D.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,1) = cabac3D.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,1) + 1;
            else
                cabac3D.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,2) = cabac3D.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,2) + 1;
                cabac3D.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,2) = cabac3D.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,2) + 1;
            end
        end
        nBits3D = cabac3D.BACEngine.bitstream.size() - nBitsStart;
    end
    
    %disp(['Number of Bits 3D = ' num2str(nBits3D) ' bits.']);
    %disp(['Number of Bits 4D = ' num2str(nBits4D) ' bits.']);
    
    if (nBits4D < nBits3D)
        cabac_out = cabac4D;
        cabac_out.StatInter(1) = cabac_out.StatInter(1) + 1;
        cabac_out = encodeParam(false,cabac_out);
    else
        cabac_out = cabac3D;
        cabac_out.StatInter(2) = cabac_out.StatInter(2) + 1;
        cabac_out = encodeParam(true,cabac_out);
    end
    
else
    
    [idx_i, idx_j] = find(mask');
    
    for k = 1:1:length(idx_i)
        y = idx_j(k);
        x = idx_i(k);        %It only encodes it IF the mask says so.
        
        currSymbol             = A(y,x);
        contextNumber          = get2DContext(padA, [y x], numberOfContexts);
        contextNumber4D        = getContextFromImage(padpA, [y x], w4D, nC4D);
        
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
        
        %Encodes the current symbol using the current context probability.
        cabac.BACEngine = encodeOneSymbolBAC(cabac.BACEngine,currBACContext,currSymbol);
        
        %Updates the context.
        if (currSymbol == false)
            cabac.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,1) = cabac.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,1) + 1;            
        else
            cabac.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,2) = cabac.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,2) + 1;            
        end
    end
    
    cabac_out = cabac;    
    cabac_out = encodeParam(false,cabac_out);
end
