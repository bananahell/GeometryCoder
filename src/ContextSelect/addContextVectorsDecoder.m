function dec = addContextVectorsDecoder(dec,fullContextVector)

%% Contexts2DTIndependent 

dec.params.BACParams.contextVector4DTIndependent = fullContextVector(1:9);
dec.params.BACParams.contextVector2DTIndependent = fullContextVector(10:15);
%dec.params.BACParams.contextVector4DTIndependent = [0 0 0 0 1 0 0 0 0];
%dec.params.BACParams.contextVector2DTIndependent = [1 1 1 0 0 0];

dec.params.BACParams.numberOfContexts4DTIndependent = sum(dec.params.BACParams.contextVector4DTIndependent);
dec.params.BACParams.numberOfContexts2DTIndependent = sum(dec.params.BACParams.contextVector2DTIndependent);

%% Contexts2DTMasked 
dec.params.BACParams.contextVector4DTMasked = fullContextVector(16:24);
dec.params.BACParams.contextVector2DTMasked = fullContextVector(25:30);
%dec.params.BACParams.contextVector4DTMasked = [0 0 0 0 1 0 0 0 0];
%dec.params.BACParams.contextVector2DTMasked = [1 1 1 0 0 0];

dec.params.BACParams.numberOfContexts4DTMasked = sum(dec.params.BACParams.contextVector4DTMasked);
dec.params.BACParams.numberOfContexts2DTMasked = sum(dec.params.BACParams.contextVector2DTMasked);

%% Contexts2DMasked
dec.params.BACParams.contextVector2DMasked = fullContextVector(31:36);
%dec.params.BACParams.contextVector2DMasked = [1 1 1 1 1 0];

dec.params.BACParams.numberOfContexts2DMasked = sum(dec.params.BACParams.contextVector2DMasked);

%% BACContexts_3D
dec.params.BACParams.contextVector3DSingle = fullContextVector(37:45);
dec.params.BACParams.contextVector2DSingle = fullContextVector(46:51);
%dec.params.BACParams.contextVector3DSingle = ones(1,9);
%dec.params.BACParams.contextVector2DSingle = [1 1 1 1 1 0];

dec.params.BACParams.numberOfContexts3D = sum(dec.params.BACParams.contextVector3DSingle);
dec.params.BACParams.numberOfContexts2D = sum(dec.params.BACParams.contextVector2DSingle);

%% BACContexts_3D_ORImages
dec.params.BACParams.contextVector3DORImages = fullContextVector(37:45);
dec.params.BACParams.contextVector2DORImages = fullContextVector(46:51);
%dec.params.BACParams.contextVector3DORImages = ones(1,9);
%dec.params.BACParams.contextVector2DORImages = [1 1 1 1 1 0];

dec.params.BACParams.numberOfContexts3DORImages = sum(dec.params.BACParams.contextVector3DORImages);
dec.params.BACParams.numberOfContexts2DORImages = sum(dec.params.BACParams.contextVector2DORImages);


%% BACContexts_3DT
dec.params.BACParams.contextVector4DT = fullContextVector(52:60);
dec.params.BACParams.contextVector3DT = fullContextVector(61:69);
dec.params.BACParams.contextVector2DT = fullContextVector(70:75);
%dec.params.BACParams.contextVector4DT = [0 0 0 0 1 0 0 0 0];
%dec.params.BACParams.contextVector3DT = ones(1,9);
%dec.params.BACParams.contextVector2DT = [1 1 1 0 0 0];

dec.params.BACParams.numberOfContexts4DT = sum(dec.params.BACParams.contextVector4DT);
dec.params.BACParams.numberOfContexts3DT = sum(dec.params.BACParams.contextVector3DT);
dec.params.BACParams.numberOfContexts2DT = sum(dec.params.BACParams.contextVector2DT);


%% BACContexts_3DT_ORImages
dec.params.BACParams.contextVector4DTORImages = fullContextVector(52:60);
dec.params.BACParams.contextVector3DTORImages = fullContextVector(61:69);
dec.params.BACParams.contextVector2DTORImages = fullContextVector(70:75);
%dec.params.BACParams.contextVector4DTORImages = [0 0 0 0 1 0 0 0 0];
%dec.params.BACParams.contextVector3DTORImages = ones(1,9);
%dec.params.BACParams.contextVector2DTORImages = [1 1 1 0 0 0];

dec.params.BACParams.numberOfContexts4DTORImages = sum(dec.params.BACParams.contextVector4DTORImages);
dec.params.BACParams.numberOfContexts3DTORImages = sum(dec.params.BACParams.contextVector3DTORImages);
dec.params.BACParams.numberOfContexts2DTORImages = sum(dec.params.BACParams.contextVector2DTORImages);