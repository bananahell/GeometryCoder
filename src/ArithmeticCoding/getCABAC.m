% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function cabac = getCABAC()

cabac = struct('BACParams',[],...
               'BACEngine',[],...
               'BACEngineDecoder',[],...
               'BACContexts_2D_Independent',[],...
               'BACContexts_2D_Masked',[],...
               'BACContexts_3D',[],...
               'BACContexts_3D_ORImages',[],...
               'BACContexts_2DT_Independent',[],...
               'BACContexts_2DT_Masked',[],...
               'BACContexts_3DT',[],...  
               'BACContexts_3DT_ORImages',[],...  
               'ParamBitstream',[],...
               'StatInter',[0 0]);