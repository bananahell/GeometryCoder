function enc = addContextVectors(enc,structVector)

if (nargin == 2)
    %% Contexts2DTIndependent
    enc.params.BACParams.contextVector4DTIndependent = structVector.contexts2DTIndependent(7:15);
    enc.params.BACParams.contextVector2DTIndependent = structVector.contexts2DTIndependent(1:6);
    
    %% Contexts2DTMasked
    enc.params.BACParams.contextVector4DTMasked = structVector.contexts2DTMasked(7:15);
    enc.params.BACParams.contextVector2DTMasked = structVector.contexts2DTMasked(1:6);
    
    
    %% Contexts2DMasked
    enc.params.BACParams.contextVector2DMasked = structVector.context2DMasked;
    
    %% BACContexts_3D
    enc.params.BACParams.contextVector3DSingle = structVector.contexts3D(7:15);
    enc.params.BACParams.contextVector2DSingle = structVector.contexts3D(1:6);
    
    %% BACContexts_3D_ORImages
    enc.params.BACParams.contextVector3DORImages = structVector.context3DORImages(7:15);
    enc.params.BACParams.contextVector2DORImages = structVector.context3DORImages(1:6);
    
    %% BACContexts_3DT
    enc.params.BACParams.contextVector4DT = structVector.contexts3DT(16:24);
    enc.params.BACParams.contextVector3DT = structVector.contexts3DT(7:15);
    enc.params.BACParams.contextVector2DT = structVector.contexts3DT(1:6);
    
    %% BACContexts_3DT_ORImages
    enc.params.BACParams.contextVector4DTORImages = structVector.contexts3DTORImages(16:24);
    enc.params.BACParams.contextVector3DTORImages = structVector.contexts3DTORImages(7:15);
    enc.params.BACParams.contextVector2DTORImages = structVector.contexts3DTORImages(1:6);
    
else
    %% Contexts2DTIndependent
    enc.params.BACParams.contextVector4DTIndependent = [0 0 0 0 1 0 0 0 0];
    enc.params.BACParams.contextVector2DTIndependent = [1 1 1 0 0 0];
    
    %% Contexts2DTMasked
    enc.params.BACParams.contextVector4DTMasked = [0 0 0 0 1 0 0 0 0];
    enc.params.BACParams.contextVector2DTMasked = [1 1 1 0 0 0];
    
    %% Contexts2DMasked
    enc.params.BACParams.contextVector2DMasked = [1 1 1 1 1 0];
    
    %% BACContexts_3D
    enc.params.BACParams.contextVector3DSingle = ones(1,9);
    enc.params.BACParams.contextVector2DSingle = [1 1 1 1 1 0];
    
    
    %% BACContexts_3D_ORImages
    enc.params.BACParams.contextVector3DORImages = ones(1,9);
    enc.params.BACParams.contextVector2DORImages = [1 1 1 1 1 0];
    
    
    %% BACContexts_3DT
    enc.params.BACParams.contextVector4DT = [0 0 0 0 1 0 0 0 0];
    enc.params.BACParams.contextVector3DT = ones(1,9);
    enc.params.BACParams.contextVector2DT = [1 1 1 0 0 0];
    
    
    %% BACContexts_3DT_ORImages
    enc.params.BACParams.contextVector4DTORImages = [0 0 0 0 1 0 0 0 0];
    enc.params.BACParams.contextVector3DTORImages = ones(1,9);
    enc.params.BACParams.contextVector2DTORImages = [1 1 1 0 0 0];
    
end

enc.params.BACParams.numberOfContexts4DTIndependent = sum(enc.params.BACParams.contextVector4DTIndependent);
enc.params.BACParams.numberOfContexts2DTIndependent = sum(enc.params.BACParams.contextVector2DTIndependent);

enc.params.BACParams.numberOfContexts4DTMasked = sum(enc.params.BACParams.contextVector4DTMasked);
enc.params.BACParams.numberOfContexts2DTMasked = sum(enc.params.BACParams.contextVector2DTMasked);

enc.params.BACParams.numberOfContexts2DMasked = sum(enc.params.BACParams.contextVector2DMasked);

enc.params.BACParams.numberOfContexts3D = sum(enc.params.BACParams.contextVector3DSingle);
enc.params.BACParams.numberOfContexts2D = sum(enc.params.BACParams.contextVector2DSingle);

enc.params.BACParams.numberOfContexts3DORImages = sum(enc.params.BACParams.contextVector3DORImages);
enc.params.BACParams.numberOfContexts2DORImages = sum(enc.params.BACParams.contextVector2DORImages);

enc.params.BACParams.numberOfContexts4DT = sum(enc.params.BACParams.contextVector4DT);
enc.params.BACParams.numberOfContexts3DT = sum(enc.params.BACParams.contextVector3DT);
enc.params.BACParams.numberOfContexts2DT = sum(enc.params.BACParams.contextVector2DT);


enc.params.BACParams.numberOfContexts4DTORImages = sum(enc.params.BACParams.contextVector4DTORImages);
enc.params.BACParams.numberOfContexts3DTORImages = sum(enc.params.BACParams.contextVector3DTORImages);
enc.params.BACParams.numberOfContexts2DTORImages = sum(enc.params.BACParams.contextVector2DTORImages);
