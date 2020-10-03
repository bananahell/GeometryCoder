%Verify if it´s ok to stop the entropy loop

function ok  = verifyStopConditions(actualH,oldH)

    %Need to be adjusted
    threshold = 0.03;
    relDrop = (oldH - actualH)/oldH;
    if (relDrop<threshold)
        ok = 0;
    else
        ok = 1;
    end

end
