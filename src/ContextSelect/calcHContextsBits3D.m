function H = calcHContextsBits3D(countContexts,contextVector,pos_bin_ind)

%contextVector = [1 1 zeros(1,4) 1 ones(1,8)];
contextVector = flip(contextVector);

contextVector2D = contextVector(end-5:end);
numberOfContexts2D = sum(contextVector2D);
maxNumberOfContexts2D = 2^length(contextVector2D);

contextVector3Dor4D = contextVector(1:end-6);
numberOfContexts3Dor4D = sum(contextVector3Dor4D);
maxnumberOfContexts3Dor4D = 2^length(contextVector3Dor4D);


idx2D = logical(contextVector2D);
posBinInd2D = pos_bin_ind(1:2^size(contextVector2D,2),end-size(contextVector2D,2)+1:end);
posSel2D = bin2dec(posBinInd2D(:,idx2D));

idx3Dor4D = logical(contextVector3Dor4D);
posBinInd3Dor4D = pos_bin_ind(1:2^size(contextVector3Dor4D,2),end-size(contextVector3Dor4D,2)+1:end);
posSel3Dor4D = bin2dec(posBinInd3Dor4D(:,idx3Dor4D));

counts2D = zeros(2^numberOfContexts2D,2);
counts3Dor4D = zeros(2^numberOfContexts3Dor4D,2^numberOfContexts2D,2);

if (numberOfContexts3Dor4D == 0)
    for u = 1:maxnumberOfContexts3Dor4D
        parcial_count = reshape(countContexts(u,:,:),[maxNumberOfContexts2D 2]);
        if (length(unique(posSel2D)) == maxNumberOfContexts2D)
            counts3Dor4D(u,:,:) = parcial_count;
        else
            for k = 1:2^numberOfContexts2D
                parcial_ind_sel = posSel2D == (k-1);
                counts2D(k,:) = sum(parcial_count(parcial_ind_sel,:));
            end
            counts3Dor4D(u,:,:) = counts2D;
        end
    end
    countFinal = reshape(sum(counts3Dor4D,1),[2^numberOfContexts2D 2]);
else
    for w = 1:2^numberOfContexts3Dor4D
        parcialIndSel3D = posSel3Dor4D == (w-1);
        parcial3D = sum(countContexts(parcialIndSel3D,:,:),1);
        
        if(numberOfContexts2D == 0)
            counts3Dor4D(w,:,:) = sum(parcial3D,2);
        else
            parcial_count = reshape(parcial3D,[maxNumberOfContexts2D 2]);
            if (length(unique(posSel2D)) == maxNumberOfContexts2D)
                counts3Dor4D(w,:,:) = parcial_count;
            else
                for k = 1:2^numberOfContexts2D
                    parcial_ind_sel = posSel2D == (k-1);
                    counts2D(k,:) = sum(parcial_count(parcial_ind_sel,:));
                end
                counts3Dor4D(w,:,:) = counts2D;
            end
        end
    end
    countFinal = counts3Dor4D;
end

if (numberOfContexts3Dor4D == 0)
    H = calcH2D(countFinal);
else
    H = calcH3D(countFinal);
end
