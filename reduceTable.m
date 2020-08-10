function countFinal = reduceTable(countContexts,contextVector)


pos_bin_ind = dec2bin(0:2^15-1);

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
posBinInd2D = pos_bin_ind(1:2^size(contextVector2D,2),end-size(contextVector2D,2)+1:end);
posSel2D = bin2dec(posBinInd2D(:,idx2D));
L_uniqueposSel2D = length(unique(posSel2D));

idx3D = logical(contextVector3D);
posBinInd3D = pos_bin_ind(1:2^size(contextVector3D,2),end-size(contextVector3D,2)+1:end);
posSel3D = bin2dec(posBinInd3D(:,idx3D));
L_uniqueposSel3D = length(unique(posSel3D));

idx4D = logical(contextVector4D);
posBinInd4D = pos_bin_ind(1:2^size(contextVector4D,2),end-size(contextVector4D,2)+1:end);
posSel4D = bin2dec(posBinInd4D(:,idx4D));
L_uniqueposSel4D = length(unique(posSel4D));

counts2D = zeros(2^numberOfContexts2D,2);
counts3D = zeros(2^numberOfContexts3D,2^numberOfContexts2D,2);
counts4D = zeros(2^numberOfContexts4D,2^numberOfContexts3D,2^numberOfContexts2D,2);


if (numberOfContexts3D == 0 && numberOfContexts4D == 0)
    parcialCount2D = reshape(sum(sum(countContexts,1),2),[maxNumberOfContexts2D 2]);
    if (L_uniqueposSel2D == maxNumberOfContexts2D)
        countFinal = parcialCount2D;
    else
        
        for k = 1:2^numberOfContexts2D
            parcialIndSel2D = posSel2D == (k-1);
            counts2D(k,:) = sum(parcialCount2D(parcialIndSel2D,:));
        end
        countFinal = counts2D;
    end
    
elseif (numberOfContexts4D == 0 && numberOfContexts3D ~= 0)
    if (L_uniqueposSel3D == maxNumberOfContexts3D...
            && L_uniqueposSel2D == maxNumberOfContexts2D)
        countFinal = sum(countContexts,1);
        
    else
        parcialCount3D = reshape(sum(countContexts,1),[maxNumberOfContexts3D maxNumberOfContexts2D 2]);
        for u = 1:2^numberOfContexts3D
            
            parcialIndSel3D = posSel3D == (u-1);
            parcial3D = sum(parcialCount3D(parcialIndSel3D,:,:),1);
            
            if(numberOfContexts2D == 0)
                counts3D(u,:,:) = sum(parcial3D,2);
            else
                
                parcialCount2D = reshape(parcial3D,[maxNumberOfContexts2D 2]);
                
                if (L_uniqueposSel2D == maxNumberOfContexts2D)
                    counts3D(u,:,:) = parcialCount2D;
                else
                    
                    for k = 1:2^numberOfContexts2D
                        parcialIndSel2D = posSel2D == (k-1);
                        counts2D(k,:) = sum(parcialCount2D(parcialIndSel2D,:),1);
                    end
                    
                    counts3D(u,:,:) = counts2D;
                end
            end
        end
        
        countFinal = reshape(counts3D,[2^numberOfContexts3D 2^numberOfContexts2D 2]);
        
    end
    
else
    if(L_uniqueposSel4D == maxNumberOfContexts4D ...
            && L_uniqueposSel3D == maxNumberOfContexts3D ...
            && L_uniqueposSel2D == maxNumberOfContexts2D)
        countFinal = countContexts;
    else
        for w = 1:2^numberOfContexts4D
            
            parcialIndSel4D = posSel4D == (w-1);
            parcial4D = sum(countContexts(parcialIndSel4D,:,:,:),1);
            
            if (numberOfContexts2D == 0 && numberOfContexts3D == 0)
                counts4D(w,:,:,:) = sum(sum(parcial4D,2),3);
            elseif (numberOfContexts2D ~= 0 && numberOfContexts3D == 0)
                parcialCount2D = reshape(sum(parcial4D,2),[maxNumberOfContexts2D 2]);
                if(L_uniqueposSel2D == maxNumberOfContexts2D)
                    counts4D(w,1,:,:) = parcialCount2D;
                else
                    for k = 1:2^numberOfContexts2D
                        parcialIndSel = posSel2D == (k-1);
                        counts2D(k,:) = sum(parcialCount2D(parcialIndSel,:));
                    end
                    counts4D(w,1,:,:) = counts2D;
                end
                
            elseif(numberOfContexts2D == 0 && numberOfContexts3D ~= 0)
                parcialCount3D = reshape(sum(parcial4D,3),[maxNumberOfContexts3D 1 2]);
                for u = 1:2^numberOfContexts3D
                    parcialIndSel3D = posSel3D == (u-1);
                    counts3D(u,1,:) = sum(parcialCount3D(parcialIndSel3D,1,:));
                end
                counts4D(w,:,1,:) = counts3D;
            else
                parcialCount3D = reshape(parcial4D,[maxNumberOfContexts3D maxNumberOfContexts2D 2]);
                for u = 1:2^numberOfContexts3D
                    parcialIndSel3D = posSel3D == (u-1);
                    parcialCount2D = reshape(sum(parcialCount3D(parcialIndSel3D,:,:),1),[maxNumberOfContexts2D 2]);
                    if (L_uniqueposSel2D == maxNumberOfContexts2D)
                        counts3D(u,:,:) = parcialCount2D;
                    else
                        for k = 1:2^numberOfContexts2D
                            parcialIndSel2D = posSel2D == (k-1);
                            counts2D(k,:) = sum(parcialCount2D(parcialIndSel2D,:));
                        end
                        counts3D(u,:,:) = counts2D;
                    end
                end
                counts4D(w,:,:,:) = counts3D;
            end
            countFinal = counts4D;
        end
    end
end

end