function H = calcHContextsBits(countContexts,contextVector,pos_bin_ind)

contextVector2D = flip(contextVector);
numberOfContexts2D = sum(contextVector);
final_count = zeros(2^numberOfContexts2D,2);
maxNumberOfContexts2D = length(contextVector);

idx = contextVector == 1;
posBinInd2D = pos_bin_ind(1:2^size(contextVector2D,2),end-size(contextVector2D,2)+1:end);
pos_sel = bin2dec(posBinInd2D(:,idx));

if numberOfContexts2D == maxNumberOfContexts2D
    final_count = countContexts;
else
    for k = 1:2^numberOfContexts2D
        parcial_ind_sel = pos_sel == (k-1);
        final_count(k,:) = sum(countContexts(parcial_ind_sel,:));
    end
end

H = calcH2D(final_count);