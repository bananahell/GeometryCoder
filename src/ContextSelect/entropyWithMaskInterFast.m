% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function cabac = entropyWithMaskInterFast(A,mask,pA,cabac)

nC4D                    = cabac.BACParams.numberOf4DContexts;
w4D                     = cabac.BACParams.windowSizeFor4DContexts;
contextVector4D         = cabac.BACParams.contextVector4D;
padpA                   = padarray(pA, [w4D w4D]);

A    = double(A);
padA = padarray(A,[3 3]);

numberOfContexts       = cabac.BACParams.numberOfContextsMasked;
%numberOfContexts3DOnly = cabac.BACParams.numberOfContexts3DOnly;
contextVector2D        = cabac.BACParams.contextVector2D;

[idx_i, idx_j] = find(mask');

NPoints = length(idx_i);

%Estimate the image with 3D and 4D contexts.
for k = 1:1:NPoints
    y = idx_j(k);
    x = idx_i(k);        %It only encodes it IF the mask says so.
    
    currSymbol             = A(y,x);
    contextNumber          = get2DContext_v2(padA, [y x],contextVector2D ,numberOfContexts);
    contextNumber4D        = getContextFromImage_v2(padpA, [y x], w4D, contextVector4D,nC4D);
    %contextNumber2D_3DOnly = get2DContext_v2(padA, [y x],contextVector2D ,numberOfContexts);
    
    %Updates the context.
    if (currSymbol == false)
        cabac.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,1) = cabac.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,1) + 1;
%         cabac.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,1) = cabac.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,1) + 1;
    else
        cabac.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,2) = cabac.BACContexts_2DT_Masked(contextNumber4D, contextNumber + 1,2) + 1;
%         cabac.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,2) = cabac.BACContexts_2D_Masked(contextNumber2D_3DOnly + 1,2) + 1;
    end
    
end

end


