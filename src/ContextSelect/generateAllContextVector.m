function [structVector,FinalH] = generateAllContextVector(structTables,useSingleModeContSel,numberOfOcVox,PCDimension,HData)

posBinInd = dec2bin(0:2^15-1);

structVector.contexts2DTIndependent  = generateSingleContextVector(structTables.BACContexts_2DT_Independent,posBinInd,PCDimension);
structVector.contexts2DTMasked       = generateSingleContextVector(structTables.BACContexts_2DT_Masked,posBinInd,PCDimension);
structVector.contexts3DTORImages     = generateSingleContextVector(structTables.BACContexts_3DT_ORImages,posBinInd,PCDimension);

if(useSingleModeContSel)
    structVector.contexts3DT             = generateSingleContextVector(structTables.BACContexts_3DT,posBinInd,PCDimension);
end

if (nargin == 5)
    H3DT = calcHContextsBits4D(structTables.BACContexts_3DT_ORImages,structVector.contexts3DTORImages,posBinInd);
    HMasked = calcHContextsBits3D(structTables.BACContexts_2DT_Masked,structVector.contexts2DTMasked,posBinInd);
    HIndependent = calcHContextsBits3D(structTables.BACContexts_2DT_Independent,structVector.contexts2DTIndependent,posBinInd);

    FinalH = (H3DT*HData.numBits4DT + HMasked*HData.numBitsMasked + HIndependent*HData.numBitsIndependent)/numberOfOcVox;
end