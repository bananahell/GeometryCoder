function H = calcH3D(countFinal)

countByContext = sum(countFinal,3);
pByContext = countByContext / sum(sum(countByContext));

HByContext = zeros(size(countByContext));

for w = 1:1:size(HByContext,1)
    for k = 1:1:size(HByContext,2)
        if (countByContext(w,k) > 0)
            currP = countFinal(w,k,:) / countByContext(w,k);
            if ((currP(1) ~= 0) && (currP(2) ~= 0))
                HByContext(w,k) = sum(- currP .* log2(currP));
            end
        end
    end
end

H = sum(sum(pByContext .* HByContext));