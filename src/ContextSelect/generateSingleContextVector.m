function contextVector = generateSingleContextVector(countContexts)

%Binarize the image if is a colored one or have multiples tons of grey

%pos_bin_ind = dec2bin(0:2^6-1);
%currContextVector = [0 0 0 0 0 0];

pos_bin_ind = dec2bin(0:2^15-1);
currContextVector = zeros(1,15);

ok = 1;
best_H = Inf;
k = 0;

while (k< 5)
    
    if k ~= 0
        old_H = best_H;
    end
    
    %Makes the loop to select the best context to this iteration
    [currContextVector, best_H] = selectOneBitContext(currContextVector,countContexts,pos_bin_ind,best_H);
    
    %Verify the two conditions to stop
%     if k ~= 0
%         [ok, curr_dif] = verifyStopConditions(best_H,old_H,curr_dif);
%     else
%         curr_dif = Inf;
%     end
    
    k = k + 1;
    
end

%Return the final vector
contextVector = currContextVector;
