%Verify if it�s ok to stop the entropy loop

function [ok, curr_dif] = verifyStopConditions(best_H,old_H,curr_dif)

    previous_dif = curr_dif;
    curr_dif = abs(best_H-old_H)/old_H;
    %Need to be adjusted
    if (previous_dif < curr_dif || abs(best_H-old_H)<0.005)
        ok = 0;
    else
        ok = 1;
    end

end
