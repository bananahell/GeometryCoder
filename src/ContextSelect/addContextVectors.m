function enc = addContextVectors(enc,structVector)

%% Contexts2DTIndependent 
enc.params.BACParams.contextVector4DTIndependent = structVector.contexts2DTIndependent(7:15);
enc.params.BACParams.contextVector2DTIndependent = structVector.contexts2DTIndependent(1:6);

enc.params.BACParams.numberOfContexts4DTIndependent = sum(structVector.contexts2DTIndependent(7:15));
enc.params.BACParams.numberOfContexts2DTIndependent = sum(structVector.contexts2DTIndependent(1:6));

%% Contexts2DTMasked 
enc.params.BACParams.contextVector4DTMasked = structVector.contexts2DTMasked(7:15);
enc.params.BACParams.contextVector2DTMasked = structVector.contexts2DTMasked(1:6);

enc.params.BACParams.numberOfContexts4DTMasked = sum(structVector.contexts2DTMasked(7:15));
enc.params.BACParams.numberOfContexts2DTMasked = sum(structVector.contexts2DTMasked(1:6));

%% Contexts2DMasked
enc.params.BACParams.contextVector2DMasked = structVector.context2DMasked;

enc.params.BACParams.numberOfContexts2DMasked = sum(structVector.context2DMasked);

%% BACContexts_3D_ORImages
enc.params.BACParams.contextVector3DORImages = structVector.context3DORImages(7:15);
enc.params.BACParams.contextVector2DORImages = structVector.context3DORImages(1:6);

enc.params.BACParams.numberOfContexts3DORImages = sum(structVector.context3DORImages(7:15));
enc.params.BACParams.numberOfContexts2DORImages = sum(structVector.context3DORImages(1:6));

%% BACContexts_3DT_ORImages
enc.params.BACParams.contextVector4DTORImages = structVector.contexts3DTORImages(16:24);
enc.params.BACParams.contextVector3DTORImages = structVector.contexts3DTORImages(7:15);
enc.params.BACParams.contextVector2DTORImages = structVector.contexts3DTORImages(1:6);

enc.params.BACParams.numberOfContexts4DTORImages = sum(structVector.contexts3DTORImages(16:24));
enc.params.BACParams.numberOfContexts3DTORImages = sum(structVector.contexts3DTORImages(7:15));
enc.params.BACParams.numberOfContexts2DTORImages = sum(structVector.contexts3DTORImages(1:6));

