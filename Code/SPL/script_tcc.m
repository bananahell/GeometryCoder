global totalTries;
global totalGoods;

totalTries = 0;
totalGoods = 0;

tempTries = totalTries;
tempGoods = totalGoods;
queiroz0000 = checkPlyBpovs('queiroz0000');
save("../Results/allVars.mat");
disp(convertStringsToChars("[TRIES] queiroz0000 tries = " + (totalTries - tempTries)));
disp(convertStringsToChars("[GOODS] queiroz0000 goods = " + (totalGoods - tempGoods)));

tempTries = totalTries;
tempGoods = totalGoods;
queiroz0032 = checkPlyBpovs('queiroz0032');
save("../Results/allVars.mat");
disp(convertStringsToChars("[TRIES] queiroz0032 tries = " + (totalTries - tempTries)));
disp(convertStringsToChars("[GOODS] queiroz0032 goods = " + (totalGoods - tempGoods)));

tempTries = totalTries;
tempGoods = totalGoods;
phil0000 = checkPlyBpovs('phil0000');
save("../Results/allVars.mat");
disp(convertStringsToChars("[TRIES] phil0000 tries = " + (totalTries - tempTries)));
disp(convertStringsToChars("[GOODS] phil0000 goods = " + (totalGoods - tempGoods)));

tempTries = totalTries;
tempGoods = totalGoods;
soldier0618 = checkPlyBpovs('soldier0618');
save("../Results/allVars.mat");
disp(convertStringsToChars("[TRIES] soldier0618 tries = " + (totalTries - tempTries)));
disp(convertStringsToChars("[GOODS] soldier0618 goods = " + (totalGoods - tempGoods)));

tempTries = totalTries;
tempGoods = totalGoods;
redandblack1450 = checkPlyBpovs('redandblack1450');
save("../Results/allVars.mat");
disp(convertStringsToChars("[TRIES] redandblack1450 tries = " + (totalTries - tempTries)));
disp(convertStringsToChars("[GOODS] redandblack1450 goods = " + (totalGoods - tempGoods)));

tempTries = totalTries;
tempGoods = totalGoods;
phil0024 = checkPlyBpovs('phil0024');
save("../Results/allVars.mat");
disp(convertStringsToChars("[TRIES] phil0024 tries = " + (totalTries - tempTries)));
disp(convertStringsToChars("[GOODS] phil0024 goods = " + (totalGoods - tempGoods)));

tempTries = totalTries;
tempGoods = totalGoods;
soldier0679 = checkPlyBpovs('soldier0679');
save("../Results/allVars.mat");
disp(convertStringsToChars("[TRIES] soldier0679 tries = " + (totalTries - tempTries)));
disp(convertStringsToChars("[GOODS] soldier0679 goods = " + (totalGoods - tempGoods)));

disp(" ");
disp(convertStringsToChars("[TOTAL TRIES] total tries = " + totalTries));
disp(convertStringsToChars("[TOTAL GOODS] total goods = " + totalGoods));
disp(" ");
