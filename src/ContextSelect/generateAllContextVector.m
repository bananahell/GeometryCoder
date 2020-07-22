function structVector = generateAllContextVector(structTables)

posBinInd = dec2bin(0:2^15-1);
sizes_vectors2D = log2(size(structTables.BACContexts_2D_Masked,1));
sizes_vectors3D = log2(size(structTables.BACContexts_3D_ORImages,1)) + log2(size(structTables.BACContexts_3D_ORImages,2));
sizes_vectors4D = log2(size(structTables.BACContexts_3DT_ORImages,1)) + log2(size(structTables.BACContexts_3DT_ORImages,2))+ ...
    log2(size(structTables.BACContexts_3DT_ORImages,3));


structVector.context2DMasked         = generateSingleContextVector(structTables.BACContexts_2D_Masked,sizes_vectors2D,posBinInd);
structVector.context3DORImages       = generateSingleContextVector(structTables.BACContexts_3D_ORImages,sizes_vectors3D,posBinInd);
structVector.contexts2DTIndependent  = generateSingleContextVector(structTables.BACContexts_2DT_Independent,sizes_vectors3D,posBinInd);
structVector.contexts2DTMasked       = generateSingleContextVector(structTables.BACContexts_2DT_Masked,sizes_vectors3D,posBinInd);
structVector.contexts3DTORImages     = generateSingleContextVector(structTables.BACContexts_3DT_ORImages,sizes_vectors4D,posBinInd);
