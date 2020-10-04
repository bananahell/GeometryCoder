% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function cabac = initCABACDecoder(cabac, BACParams, interCoding)
    
if (nargin == 2)
    interCoding = 0;
end

%Gets the parameters.
cabac.BACParams = BACParams;

%Initializes the engine
cabac.BACEngineDecoder = getBACDecoder(BACParams.m);

nC_Independent2D = BACParams.numberOfContexts2DTIndependent;
nC_Independent4D = BACParams.numberOfContexts4DTIndependent;

nC_Masked4DT = BACParams.numberOfContexts4DTMasked;
nC_Masked2DT = BACParams.numberOfContexts2DTMasked;


% nC_3DOr = BACParams.numberOfContexts3DORImages;
% nC_2DOr = BACParams.numberOfContexts2DORImages;

% nC_3D   = BACParams.numberOfContexts3D;
% nC_2D   = BACParams.numberOfContexts2D;

nC_4DTOr = BACParams.numberOfContexts4DTORImages;
nC_3DTOr = BACParams.numberOfContexts3DTORImages;
nC_2DTOr = BACParams.numberOfContexts2DTORImages;

nC_4DT = BACParams.numberOfContexts4DT;
nC_3DT = BACParams.numberOfContexts3DT;
nC_2DT = BACParams.numberOfContexts2DT;

% nC_2DM = BACParams.numberOfContexts2DMasked;


if (interCoding == 0)
    %Initializes the 2D contexts.
    cabac.BACContexts_2D_Independent = initCountContexts_2D(nC_Independent);
    cabac.BACContexts_2D_Masked      = initCountContexts_2D(nC_2DT);
    
    %Initializes the 3D contexts.
    cabac.BACContexts_3D             = initCountContexts_3D(nC_3D , nC_2D);
    cabac.BACContexts_3D_ORImages    = initCountContexts_3D(nC_3DOr , nC_2DOr);
else
    %When interCoding is used, one dimension (time) is added to all
    %contexts.
    
    %These contexts are ALWAYS used (and, thus, initialized)
    %2D Contexts are now 3D
    cabac.BACContexts_2DT_Independent = initCountContexts_3D(nC_Independent4D, nC_Independent2D);
    cabac.BACContexts_2DT_Masked      = initCountContexts_3D(nC_Masked4DT, nC_Masked2DT);
    
    %And 3D Contexts are now 4D
    cabac.BACContexts_3DT             = initCountContexts_4D(nC_4DT, nC_3DT, nC_2DT);
    cabac.BACContexts_3DT_ORImages    = initCountContexts_4D(nC_4DTOr, nC_3DTOr, nC_2DTOr);
    
%     cabac.BACContexts_3D             = initCountContexts_3D(nC_3D, nC_2D);
%     cabac.BACContexts_3D_ORImages    = initCountContexts_3D(nC_3DOr , nC_2DOr);
%     cabac.BACContexts_2D_Masked      = initCountContexts_2D(nC_2DM);
    
end

%Initializes the Parameter Contexts
cabac.ParamBitstream = Bitstream(1024);
