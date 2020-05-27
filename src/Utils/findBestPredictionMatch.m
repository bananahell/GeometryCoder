function [bestPy, d1, d2, d3] = findBestPredictionMatch(Y, enc, currAxis, iStart, iEnd)

n = 3;
countMatch = Inf;

for ( k = (-n):1:n )
    
    kStart = iStart + k;
    kEnd   = iEnd + k;
    
    if (kStart < 1)
        kStart = 1;
    end
    if (kEnd > enc.pcLimit + 1)
        kEnd = enc.pcLimit + 1;
    end
    
    pY = silhouetteFromCloud(enc.predictionPointCloud.Location, enc.pcLimit+1, currAxis, kStart, kEnd, false);
    
    for (i = (-n):1:n )
        for (j = (-n):1:n)
            pYShift = imtranslate(pY,[i j]);
            
            diff = xor(Y,pYShift);
            count = sum(diff(:));
            
            %disp(['Count = ' num2str(count) '' ])
            
            if (count < countMatch)
                countMatch = count;
                d1 = k;
                d2 = i;
                d3 = j;
                bestPy = pYShift;
            end
            
        end
    end
end