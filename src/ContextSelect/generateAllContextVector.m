function structVector = generateAllContextVector(structTables)

posBinInd = dec2bin(0:2^15-1);

structVector.contexts2DTIndependent  = generateSingleContextVector(structTables.BACContexts_2DT_Independent,posBinInd);
structVector.contexts2DTMasked       = generateSingleContextVector(structTables.BACContexts_2DT_Masked,posBinInd);
structVector.contexts3DTORImages     = generateSingleContextVector(structTables.BACContexts_3DT_ORImages,posBinInd);
structVector.contexts3DT             = generateSingleContextVector(structTables.BACContexts_3DT,posBinInd);
% structVector.contexts3DT     = structVector.contexts3DTORImages;
