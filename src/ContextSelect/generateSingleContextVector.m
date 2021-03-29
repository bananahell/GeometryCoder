function contextVector = generateSingleContextVector(countContexts,posBinInd,PCSize)

nDimensions = length(size(countContexts));

if nargin == 2
    PCSize = 512;
end

if nDimensions == 3
    currContextVector = zeros(1,15);
    nContexts = 8;
elseif nDimensions == 4
    currContextVector = zeros(1,24);
    if PCSize <= 512
        nContexts = 13;
    elseif PCSize >= 1024
        nContexts = 15;
    end
else
    error('Wrong number of dimensions')
end

ok = 1;
bestH = Inf;
k = 0;

while (ok)    
    oldH = bestH;
    
    %Makes the loop to select the best context to this iteration
    oldVector = currContextVector;
    [currContextVector, bestH] = selectOneBitContext(currContextVector,countContexts,posBinInd,bestH);
    
    k = k + 1;
    
    if oldVector == currContextVector
        break
    end
    
    % If the algorithm were being used to select contexts for
    % 2DTIndependent or 2DTMasked, this condition will apply
%     if nDimensions == 3 && k == 7
%         ok = 0;
%     end
    
    % Verify the condition to stop
%     if nDimensions == 4 && k > 6
%         ok = verifyStopConditions(bestH,oldH);
%     end
    if k == nContexts
        ok = 0;
    end
    
    % if condition achieves, the new context selected will be prejudicial
%     if ok == 0
%         currContextVector = oldVector;
%     end
end

%Return the final vector
contextVector = currContextVector;
