function H = calcH4D(countFinal)

countByContext = sum(countFinal,4);
pByContext = countByContext / sum(sum(sum(countByContext)));

HByContext = zeros(size(countByContext));

for w = 1:1:size(HByContext,1)
    for k = 1:1:size(HByContext,2)
        for u = 1:1:size(HByContext,3)
            if (countByContext(w,k,u) > 0)
                currP = countFinal(w,k,u,:) / countByContext(w,k,u);
                if ((currP(1) ~= 0) && (currP(2) ~= 0))
                    HByContext(w,k,u) = sum(- currP .* log2(currP));
                end
            end
        end
    end
end

H = sum(sum(sum(pByContext .* HByContext)));