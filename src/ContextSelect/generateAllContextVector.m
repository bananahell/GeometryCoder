function structVector = generateAllContextVector(structTables)

posBinInd = dec2bin(0:2^15-1);

% structVector.context2DMasked         = generateSingleContextVector_v2(structTables.BACContexts_2D_Masked,posBinInd);
% structVector.context3DORImages       = generateSingleContextVector_v2(structTables.BACContexts_3D_ORImages,posBinInd);
% structVector.contexts2DTIndependent  = generateSingleContextVector_v2(structTables.BACContexts_2DT_Independent,posBinInd);
% structVector.contexts2DTMasked       = generateSingleContextVector_v2(structTables.BACContexts_2DT_Masked,posBinInd);
% structVector.contexts3DTORImages     = generateSingleContextVector_v2(structTables.BACContexts_3DT_ORImages,posBinInd);

sizes_vectors2D = log2(size(structTables.BACContexts_2D_Masked,1));
sizes_vectors3D = log2(size(structTables.BACContexts_3D_ORImages,1)) + log2(size(structTables.BACContexts_3D_ORImages,2));
sizes_vectors4D = log2(size(structTables.BACContexts_3DT_ORImages,1)) + log2(size(structTables.BACContexts_3DT_ORImages,2))+ ...
    log2(size(structTables.BACContexts_3DT_ORImages,3));

structVector.context2DMasked         = generateSingleContextVector(structTables.BACContexts_2D_Masked,sizes_vectors2D,posBinInd);
structVector.context3DORImages       = generateSingleContextVector(structTables.BACContexts_3D_ORImages,sizes_vectors3D,posBinInd);
structVector.contexts2DTIndependent  = generateSingleContextVector(structTables.BACContexts_2DT_Independent,sizes_vectors3D,posBinInd);
structVector.contexts2DTMasked       = generateSingleContextVector(structTables.BACContexts_2DT_Masked,sizes_vectors3D,posBinInd);
structVector.contexts3DTORImages     = generateSingleContextVector(structTables.BACContexts_3DT_ORImages,sizes_vectors4D,posBinInd);
structVector.contexts3D              = generateSingleContextVector(structTables.BACContexts_3D,sizes_vectors3D,posBinInd);
structVector.contexts3DT             = generateSingleContextVector(structTables.BACContexts_3DT,sizes_vectors4D,posBinInd);
