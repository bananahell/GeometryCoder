function [currContextVector, best_H] = selectOneBitContext(currContextVector,countContexts,pos_bin_ind,best_H)

idx = find(currContextVector == 0);
sizeContextVector = length(currContextVector);
Curr_HByContext = zeros(1,sizeContextVector);
currBestContext = 0;

for (j = 1:1:length(idx))
    candidate_ContextVector = currContextVector;
    candidate_ContextVector(idx(j)) = 1;
    
    if (sizeContextVector == 24)
        Curr_HByContext(j) = calcHContextsBits4D(countContexts,candidate_ContextVector,pos_bin_ind);
    elseif (sizeContextVector == 15)
        Curr_HByContext(j) = calcHContextsBits3D(countContexts,candidate_ContextVector,pos_bin_ind);
    else
        Curr_HByContext(j) = calcHContextsBits(countContexts,candidate_ContextVector,pos_bin_ind);
    end
    
    if (Curr_HByContext(j) < best_H)
        best_H = Curr_HByContext(j);
        currBestContext = idx(j);
    end
end

if (currBestContext ~= 0)
    currContextVector(currBestContext) = 1;
end
% disp(currBestContext)

