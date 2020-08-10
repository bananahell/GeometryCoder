function countContexts = addingContextTable(countContexts,contextVector,sumBits,type)

posBinInd = dec2bin(0:2^15-1);

contextVector = flip(contextVector);

contextVector2D = contextVector(19:24);
numberOfContexts2D = sum(contextVector2D);
maxNumberOfContexts2D = 2^length(contextVector2D);

contextVector3D = contextVector(10:18);
numberOfContexts3D = sum(contextVector3D);
maxNumberOfContexts3D = 2^length(contextVector3D);

contextVector4D = contextVector(1:9);
numberOfContexts4D = sum(contextVector4D);
maxNumberOfContexts4D = 2^length(contextVector4D);

idx2D = logical(contextVector2D);
posBinInd2D = posBinInd(1:2^size(contextVector2D,2),end-size(contextVector2D,2)+1:end);
posSel2D = bin2dec(posBinInd2D(:,idx2D));

idx3D = logical(contextVector3D);
posBinInd3D = posBinInd(1:2^sum(contextVector3D,2),end-size(contextVector3D,2)+1:end);
posSel3D = bin2dec(posBinInd3D(:,idx3D));

idx4D = logical(contextVector4D);
posBinInd4D = posBinInd(1:2^sum(contextVector4D,2),end-size(contextVector4D,2)+1:end);
posSel4D = bin2dec(posBinInd4D(:,idx4D));


value2D = 1/2^(log2(maxNumberOfContexts2D) - log2(numberOfContexts2D));
value3D = 1/2^(log2(maxNumberOfContexts3D));
value4D = 1/2^(log2(maxNumberOfContexts4D) - log2(numberOfContexts4D));

value = value4D*value3D*value2D;

sumBits = sumBits*value;

%Usa contextos 4D e 2D
if type == 2
    for w = 1:numberOfContexts4D
        for k = 1:numberOfContexts2D
            countContexts(w,:,k,1) = countContexts(w,:,k,1) + sumBits(w,k,1);
            countContexts(w,:,k,2) = countContexts(w,:,k,2) + sumBits(w,k,2);
        end
    end
end
