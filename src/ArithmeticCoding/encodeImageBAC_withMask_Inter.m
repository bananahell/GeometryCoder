% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function cabac_out = encodeImageBAC_withMask_Inter(A,mask,pA,cabac, consider3DOnlyContexts)

%This function uses the contexts in:
% cabac.BACContexts_2DT_Masked

nC4D                    = cabac.BACParams.numberOfContexts4DTMasked;
w4D                     = cabac.BACParams.windowSizeFor4DContexts;
contextVector4D         = cabac.BACParams.contextVector4DTMasked;
padpA                   = padarray(pA, [w4D w4D]);

A    = double(A);
padA = padarray(A,[3 3]);

maxValueContext = cabac.BACParams.maxValueContext;

currBACContext = getBACContext(false,maxValueContext/2,maxValueContext);

numberOfContexts       = cabac.BACParams.numberOfContexts2DTMasked;
contextVector2D        = cabac.BACParams.contextVector2DTMasked;
numberOfContexts3DOnly = cabac.BACParams.numberOfContexts2DMasked;
contextVector3DOnly    = cabac.BACParams.contextVector2DMasked;


if (consider3DOnlyContexts == 1)
    nBitsStart = cabac.BACEngine.bitstream.size();
    %nBits4D = Inf;
    %nBits3D = Inf;
        
    [idx_i, idx_j] = find(mask');
    
    NPoints = length(idx_i);
    
    targetX   = zeros(NPoints,1,'logical');
    Prob_3D4D = zeros(NPoints,2);
    
    %Gather the context for all points.
    for k = 1:1:NPoints
        y = idx_j(k);
        x = idx_i(k);        %It only encodes it IF the mask says so.
        
        currSymbol             = A(y,x);
        contextNumber          = get2DContext_v2(padA, [y x], contextVector2D,numberOfContexts);
        contextNumber4D        = getContextFromImage_v2(padpA, [y x],w4D,contextVector4D, nC4D);
        contextNumber2D_3DOnly = get2DContext_v2(padA, [y x],contextVector3DOnly ,numberOfContexts3DOnly);
%         
%         contextNumber          = get2DContext(padA, [y x], numberOfContexts);
%         contextNumber4D        = getContextFromImage(padpA, [y x],w4D, nC4D);
%         contextNumber2D_3DOnly = get2DContext(padA, [y x],numberOfContexts3DOnly);
        
        %Gets the current count for this context.
        currCount4D = cabac.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,:);
        
        %Gets the current count for this context.
        currCount3D = cabac.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,:);
        
        %Gets the probabilities.
        Prob_3D4D(k,1) = currCount3D(2) / (sum(currCount3D));
        Prob_3D4D(k,2) = currCount4D(2) / (sum(currCount4D));
        targetX(k)     = currSymbol;
        
        %Updates the context.
        if (currSymbol == false)
            cabac.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,1) = cabac.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,1) + 1;
            cabac.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,1) = cabac.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,1) + 1;
        else
            cabac.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,2) = cabac.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,2) + 1;
            cabac.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,2) = cabac.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,2) + 1;
        end
    end
    
    %Actually encode it with the cabac 3D.
    cabac3D = cabac;
    for k = 1:1:NPoints
        
        if (Prob_3D4D(k,1) > 0.5)
            currBACContext.MPS = true;
            currBACContext.countMPS = floor(Prob_3D4D(k,1) * maxValueContext);
        else
            currBACContext.MPS = false;
            currBACContext.countMPS = floor((1 - Prob_3D4D(k,1)) * maxValueContext);
        end
        
        %Encodes the current symbol using the current context probability.
        cabac3D.BACEngine = encodeOneSymbolBAC(cabac3D.BACEngine,currBACContext,targetX(k));
    end
    nBits3D = cabac3D.BACEngine.bitstream.size() - nBitsStart;
    
    %Actually encode it with the cabac 3D.
    cabac4D = cabac;
    for k = 1:1:NPoints
        
        if (Prob_3D4D(k,2) > 0.5)
            currBACContext.MPS = true;
            currBACContext.countMPS = floor(Prob_3D4D(k,2) * maxValueContext);
        else
            currBACContext.MPS = false;
            currBACContext.countMPS = floor((1 - Prob_3D4D(k,2)) * maxValueContext);
        end
        
        %Encodes the current symbol using the current context probability.
        cabac4D.BACEngine = encodeOneSymbolBAC(cabac4D.BACEngine,currBACContext,targetX(k));
    end
    nBits4D = cabac4D.BACEngine.bitstream.size() - nBitsStart;

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
        contextNumber          = get2DContext_v2(padA, [y x], contextVector2D,numberOfContexts);
        contextNumber4D        = getContextFromImage_v2(padpA, [y x], w4D, contextVector4D,nC4D);
        
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
