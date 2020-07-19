function H = calcHContextsBits(countContexts,contextVector,pos_bin_ind)

contextVector = flip(contextVector);
numberOfContexts = sum(contextVector);
final_count = zeros(2^numberOfContexts,2);

idx = contextVector == 1;
pos_sel = bin2dec(pos_bin_ind(:,idx));

if numberOfContexts == 16
    final_count = countContexts;
else
    for k = 1:2^numberOfContexts
        parcial_ind_sel = pos_sel == (k-1);
        final_count(k,:) = sum(countContexts(parcial_ind_sel,:));
    end
end

H = calcH2D(final_count);