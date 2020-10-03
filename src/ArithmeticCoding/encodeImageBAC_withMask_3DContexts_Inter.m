% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function cabac_out = encodeImageBAC_withMask_3DContexts_Inter(A,idx_i, idx_j,Yleft,pA,cabac, consider3DOnlyContexts)

%This function uses the contexts in:
% cabac.BACContexts_3DT

nC4D  = cabac.BACParams.numberOfContexts4DT;
w4D   = cabac.BACParams.windowSizeFor4DContexts;
contextVector4D = cabac.BACParams.contextVector4DT;
padpA = padarray(pA, [w4D w4D]);

A = double(A);
%mask = double(mask);
w               = cabac.BACParams.windowSizeFor3DContexts;
nC3D            = cabac.BACParams.numberOfContexts3DT;
contextVector3D = cabac.BACParams.contextVector3DT;

padYleft  = padarray(Yleft,[w w]);
padA      = padarray(A,[3 3]);

numberOfContexts = cabac.BACParams.numberOfContexts2DT;
contextVector2D = cabac.BACParams.contextVector2DT;


maxValueContext = cabac.BACParams.maxValueContext;
currBACContext = getBACContext(false,maxValueContext/2,maxValueContext);

if (consider3DOnlyContexts == 1)
    
    contextVector3D3DOnly = cabac.BACParams.contextVector3DSingle;
    numberOfContexts3D3DOnly = cabac.BACParams.numberOfContexts3D;
    
    contextVector2D3DOnly = cabac.BACParams.contextVector2DSingle;
    numberOfContexts2D3DOnly = cabac.BACParams.numberOfContexts2D;
    
    nBitsStart = cabac.BACEngine.bitstream.size();
    %nBits4D    = Inf;
    %nBits3D    = Inf;
    
    NPoints = length(idx_i);
    
    targetX   = zeros(NPoints,1,'logical');
    Prob_3D4D = zeros(NPoints,2);
    
    for k = 1:1:length(idx_i)
        y = idx_j(k);
        x = idx_i(k);        %It only encodes it IF the mask says so.
        
        currSymbol               = A(y,x);
        contextNumber2D          = get2DContext_v2(padA, [y x], contextVector2D,numberOfContexts);
        contextNumberLeft        = getContextLeft_v2(padYleft,[y x], w,contextVector3D,nC3D);
        contextNumber4D          = getContextFromImage_v2(padpA, [y x], w4D, contextVector4D,nC4D);
        contextNumber2D_3DOnly   = get2DContext_v2(padA, [y x], contextVector2D3DOnly,numberOfContexts2D3DOnly);
        contextNumberLeft_3DOnly   = getContextLeft_v2(padYleft, [y x], contextVector3D3DOnly,numberOfContexts3D3DOnly);
        
%     contextNumber2D          = get2DContext(padA, [y x], numberOfContexts);
%     contextNumberLeft        = getContextLeft(padYleft,[y x], w);
    % contextNumber4D          = getContextFromImage(padpA, [y x], w4D, nC4D);
%     contextNumber2D_3DOnly   = get2DContext(padA, [y x], numberOfContexts3DOnly);
        
        %Gets the current count for this context.
        currCount4D = [0 0];
        currCount4D(1) = cabac.BACContexts_3DT(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 1);
        currCount4D(2) = cabac.BACContexts_3DT(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 2);
        
        %Gets the current count for this context.
        currCount3D = [0 0];
        currCount3D(1) = cabac.BACContexts_3D(contextNumberLeft_3DOnly, contextNumber2D_3DOnly + 1, 1);
        currCount3D(2) = cabac.BACContexts_3D(contextNumberLeft_3DOnly, contextNumber2D_3DOnly + 1, 2);
        
        %Gets the probabilities.
        Prob_3D4D(k,1) = currCount3D(2) / (sum(currCount3D));
        Prob_3D4D(k,2) = currCount4D(2) / (sum(currCount4D));
        targetX(k)     = currSymbol;
        
        %Updates the context.
        if (currSymbol == false)
            cabac.BACContexts_3DT(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 1) = cabac.BACContexts_3DT(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 1) + 1;
            cabac.BACContexts_3D(contextNumberLeft_3DOnly, contextNumber2D_3DOnly + 1, 1)            = cabac.BACContexts_3D(contextNumberLeft_3DOnly, contextNumber2D_3DOnly + 1, 1) + 1;
        else
            cabac.BACContexts_3DT(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 2) = cabac.BACContexts_3DT(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 2) + 1;
            cabac.BACContexts_3D(contextNumberLeft_3DOnly, contextNumber2D_3DOnly + 1, 2)            = cabac.BACContexts_3D(contextNumberLeft_3DOnly, contextNumber2D_3DOnly + 1, 2) + 1;
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
    nBits4D = cabac4D.BACEfngine.bitstream.size() - nBitsStart;    
    
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
    
    for k = 1:1:length(idx_i)
        y = idx_j(k);
        x = idx_i(k);        %It only encodes it IF the mask says so.
        
        currSymbol               = A(y,x);
        contextNumber2D          = get2DContext_v2(padA, [y x], contextVector2D,numberOfContexts);
        contextNumberLeft        = getContextLeft_v2(padYleft,[y x], w,contextVector3D,nC3D);
        contextNumber4D          = getContextFromImage_v2(padpA, [y x], w4D, contextVector4D,nC4D);
        
        %Gets the current count for this context.
        currCount = [0 0];
        currCount(1) = cabac.BACContexts_3DT(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 1);
        currCount(2) = cabac.BACContexts_3DT(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 2);
        
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
            cabac.BACContexts_3DT(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 1) = cabac.BACContexts_3DT(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 1) + 1;            
        else
            cabac.BACContexts_3DT(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 2) = cabac.BACContexts_3DT(contextNumber4D, contextNumberLeft, contextNumber2D + 1, 2) + 1;            
        end
    end
    
    cabac_out = cabac;    
    cabac_out = encodeParam(false,cabac_out);    
end