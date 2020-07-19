function H = calcH2D(countFinal)

countByContext = sum(countFinal,2);
pByContext = countByContext / sum(countByContext);

HByContext = zeros(size(countByContext));
for k = 1:1:length(HByContext)
    if (countByContext(k) > 0)
        currP = countFinal(k,:) / countByContext(k);
        if ((currP(1) ~= 0) && (currP(2) ~= 0))
            HByContext(k) = sum(- currP .* log2(currP));
        end
    end
end

H = sum(pByContext .* HByContext);