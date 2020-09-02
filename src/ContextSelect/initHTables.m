% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function entropyStruct = initHTables(entropyStruct,BACParams, interCoding, test3DOnlyContextsForInter)

if (nargin == 2)
    interCoding                = 0;
    test3DOnlyContextsForInter = 0;
end
    
entropyStruct.BACParams = BACParams;

nC_Independent = BACParams.numberOfContextsIndependent;
nC_2D          = BACParams.numberOfContextsMasked;
nC_3D          = BACParams.numberOf3DContexts;
nC_4D          = BACParams.numberOf4DContexts;
nC2D_3DOnly    = BACParams.numberOfContexts3DOnly;

if (interCoding == 0)
    %Initializes the 2D contexts.
     entropyStruct.BACContexts_2D_Masked      = zeros(2^nC_2D,2);

    %Initializes the 3D contexts.
     entropyStruct.BACContexts_3D_ORImages    = zeros(2^nC_3D , 2^nC_2D,2);
else
    %When interCoding is used, one dimension (time) is added to all
    %contexts.
    
    %These contexts are ALWAYS used (and, thus, initialized)
    %3D Contexts tables
     entropyStruct.BACContexts_2DT_Independent = zeros(2^nC_4D, 2^nC_Independent,2);
     entropyStruct.BACContexts_2DT_Masked      = zeros(2^nC_4D, 2^nC_2D,2);

%     
    %4D Contexts tables
     entropyStruct.BACContexts_3DT_ORImages    = zeros(2^nC_4D, 2^nC_3D, 2^nC_2D,2);
     entropyStruct.BACContexts_3DT = zeros(2^nC_4D, 2^nC_3D, 2^nC_2D,2);
    
    %These contexts are ONLY initialized IF they will be used
    if (test3DOnlyContextsForInter == 1)
        entropyStruct.BACContexts_3D             = zeros(2^nC_3D , 2^nC2D_3DOnly,2);
        entropyStruct.BACContexts_3D_ORImages    = zeros(2^nC_3D , 2^nC2D_3DOnly,2);
        entropyStruct.BACContexts_2D_Masked      = zeros(2^nC2D_3DOnly,2);
    end
    
end
