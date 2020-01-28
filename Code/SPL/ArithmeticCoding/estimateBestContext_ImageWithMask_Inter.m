% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function bestChoice = estimateBestContext_ImageWithMask_Inter(A,mask,pA,cabac)

%This function uses the contexts in:
% cabac.BACContexts_2DT_Masked

nC4D  = cabac.BACParams.numberOf4DContexts;
w4D   = cabac.BACParams.windowSizeFor4DContexts;
padpA = padarray(pA, [w4D w4D]);

A    = double(A);
padA = padarray(A,[3 3]);

numberOfContexts       = cabac.BACParams.numberOfContextsMasked;
numberOfContexts3DOnly = cabac.BACParams.numberOfContexts3DOnly;

[idx_i, idx_j] = find(mask');

A_3D = zeros(size(A),'logical');
A_4D = zeros(size(A),'logical');

pSum3D = 0;
pSum4D = 0;

%Estimate the image with 3D and 4D contexts.
for k = 1:1:length(idx_i)
    y = idx_j(k);
    x = idx_i(k);        %It only encodes it IF the mask says so.
    
    currSymbol             = A(y,x);
    contextNumber          = get2DContext(padA, [y x], numberOfContexts);
    contextNumber4D        = getContextFromImage(padpA, [y x], w4D, nC4D);
    contextNumber2D_3DOnly = get2DContext(padA, [y x], numberOfContexts3DOnly);
    
    %Gets the current count for this context.
    currCount4D = cabac.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,:);
    
    %Gets the current BAC context for this context
    p1s4D = currCount4D(2) / (sum(currCount4D));
    A_4D(y,x) = (p1s4D >= 0.5);
        
    %Gets the current count for this context.
    currCount3D = cabac.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,:);
        
    %Gets the current BAC context for this context
    p1s3D = currCount3D(2) / (sum(currCount3D));
    A_3D(y,x) = (p1s3D >= 0.5);    
    
    if (currSymbol == false)
        pSum3D = pSum3D + (1 - p1s3D);
        pSum4D = pSum4D + (1 - p1s4D);
    else
        pSum3D = pSum3D + p1s3D;
        pSum4D = pSum4D + p1s4D;
    end
    
    %Updates the context.
    if (currSymbol == false)
        cabac.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,1) = cabac.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,1) + 1;
        cabac.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,1) = cabac.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,1) + 1;
    else
        cabac.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,2) = cabac.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,2) + 1;
        cabac.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,2) = cabac.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,2) + 1;
    end
    
end

diff3D = xor(and(mask,A_3D), and(mask,A));
nBitsDiff3D = sum(diff3D(:));

diff4D = xor(and(mask,A_4D), and(mask,A));
nBitsDiff4D = sum(diff4D(:));

avgPSum3D = pSum3D / length(idx_i);
avgPSum4D = pSum4D / length(idx_i);

%disp(['3D - ' num2str(nBitsDiff3D,'%5d') ' - ' num2str(avgPSum3D,'%1.4f') ' .'])
%disp(['4D - ' num2str(nBitsDiff4D,'%5d') ' - ' num2str(avgPSum4D,'%1.4f') ' .'])
%keyboard;

if (nBitsDiff3D < nBitsDiff4D)
    bestChoice = 0;
else
    bestChoice = 1;
end

end


