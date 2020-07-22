function contextVector = generateSingleContextVector(countContexts,sizeContextVector,posBinInd)

%Binarize the image if is a colored one or have multiples tons of grey

currContextVector = zeros(1,sizeContextVector);

if(length(size(countContexts)) == 2)
    val = 3;
elseif(length(size(countContexts)) == 3)
    val = 8;
else
    val = 12;
end
ok = 1;
best_H = Inf;
k = 0;

while (k<val)
    %while (ok)
%     if k ~= 0
%         old_H = best_H;
%     end
    %
    %Makes the loop to select the best context to this iteration
    
    [currContextVector, best_H] = selectOneBitContext(currContextVector,countContexts,posBinInd,best_H);
    
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
