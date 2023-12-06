function result = checkPlyBpovs(plyName)

    global bitsPercentage;
    global encodeMode;  % 0 = nBits; 1 = msePerBit
    global bpovResult;
    global preEncodeDone;  % 0 if needs to pass, 1 if already passed, to avoid costy function
    global nBitsDyadicVector;
    global mseDyadicVector;
    global totalTries;
    global totalGoods;
    global toggleSlicesFlags;

    disp(" ");
    disp("################################################################################");
    disp("################################################################################");
    disp("################################################################################");
    disp(convertStringsToChars("[PLY START] Choosing " + plyName + ".ply"));

    nBitsDyadicVector = [];
    mseDyadicVector = [];
    plyDir = "../Results/" + plyName + "/";

    result = struct;
    pcIn = pcread(convertStringsToChars(plyDir + plyName + ".ply"));

    totalTries = totalTries + 1;
    try
        inputPly = convertStringsToChars(plyDir + plyName + ".ply");
        binaryFile = convertStringsToChars(plyDir + plyName + "_nBits09_enc.bin");
        outputPly = convertStringsToChars(plyDir + plyName + "_nBits09_dec.ply");
        bitsPercentage = 0.9;
        encodeMode = 0;
        preEncodeDone = 0;
        testEncoderDecoder(inputPly, binaryFile, outputPly);
        disp(" ");
        disp(convertStringsToChars("[END] " + plyName + "_nBits09 good!"));
        result.nBits09Bpov = bpovResult;
        pcOut = pcread(convertStringsToChars(plyDir + plyName + "_nBits09_dec.ply"));
        pointMetricsResult = point_metrics(pcIn.Location, pcOut.Location);
        result.nBits09Mse = pointMetricsResult.p2point_mse(2);
        result.nBits09Psnr = pointMetricsResult.p2point_psnr;
        result.nBits09toggleSlicesFlags = toggleSlicesFlags;
        result.nBitsDyadicVector = nBitsDyadicVector;
        result.mseDyadicVector = mseDyadicVector;
        totalGoods = totalGoods + 1;
    catch err
        result.nBits09Err = err;
        disp(" ");
        disp(convertStringsToChars("[BAD END] " + plyName + "_nBits09 bad!"));
    end

    save(convertStringsToChars(plyDir + plyName + "Vars.mat"));

    disp(" ");
    disp("--------------------------------------------------------------------------------");

    totalTries = totalTries + 1;
    try
        inputPly = convertStringsToChars(plyDir + plyName + ".ply");
        binaryFile = convertStringsToChars(plyDir + plyName + "_msePerBit09_enc.bin");
        outputPly = convertStringsToChars(plyDir + plyName + "_msePerBit09_dec.ply");
        bitsPercentage = 0.9;
        encodeMode = 1;
        preEncodeDone = 1;
        testEncoderDecoder(inputPly, binaryFile, outputPly);
        disp(" ");
        disp(convertStringsToChars("[END] " + plyName + "_msePerBit09 good!"));
        result.msePerBit09Bpov = bpovResult;
        pcOut = pcread(convertStringsToChars(plyDir + plyName + "_msePerBit09_dec.ply"));
        pointMetricsResult = point_metrics(pcIn.Location, pcOut.Location);
        result.msePerBit09Mse = pointMetricsResult.p2point_mse(2);
        result.msePerBit09Psnr = pointMetricsResult.p2point_psnr;
        result.msePerBit09toggleSlicesFlags = toggleSlicesFlags;
        totalGoods = totalGoods + 1;
    catch err
        result.msePerBit09Err = err;
        disp(" ");
        disp(convertStringsToChars("[BAD END] " + plyName + "_msePerBit09 bad!"));
    end

    save(convertStringsToChars(plyDir + plyName + "Vars.mat"));

    disp("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    disp("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");

    totalTries = totalTries + 1;
    try
        inputPly = convertStringsToChars(plyDir + plyName + ".ply");
        binaryFile = convertStringsToChars(plyDir + plyName + "_nBits08_enc.bin");
        outputPly = convertStringsToChars(plyDir + plyName + "_nBits08_dec.ply");
        bitsPercentage = 0.8;
        encodeMode = 0;
        preEncodeDone = 1;
        testEncoderDecoder(inputPly, binaryFile, outputPly);
        disp(" ");
        disp(convertStringsToChars("[END] " + plyName + "_nBits08 good!"));
        result.nBits08Bpov = bpovResult;
        pcOut = pcread(convertStringsToChars(plyDir + plyName + "_nBits08_dec.ply"));
        pointMetricsResult = point_metrics(pcIn.Location, pcOut.Location);
        result.nBits08Mse = pointMetricsResult.p2point_mse(2);
        result.nBits08Psnr = pointMetricsResult.p2point_psnr;
        result.nBits08toggleSlicesFlags = toggleSlicesFlags;
        totalGoods = totalGoods + 1;
    catch err
        result.nBits08Err = err;
        disp(" ");
        disp(convertStringsToChars("[BAD END] " + plyName + "_nBits08 bad!"));
    end

    save(convertStringsToChars(plyDir + plyName + "Vars.mat"));

    disp(" ");
    disp("--------------------------------------------------------------------------------");

    totalTries = totalTries + 1;
    try
        inputPly = convertStringsToChars(plyDir + plyName + ".ply");
        binaryFile = convertStringsToChars(plyDir + plyName + "_msePerBit08_enc.bin");
        outputPly = convertStringsToChars(plyDir + plyName + "_msePerBit08_dec.ply");
        bitsPercentage = 0.8;
        encodeMode = 1;
        preEncodeDone = 1;
        testEncoderDecoder(inputPly, binaryFile, outputPly);
        disp(" ");
        disp(convertStringsToChars("[END] " + plyName + "_msePerBit08 good!"));
        result.msePerBit08Bpov = bpovResult;
        pcOut = pcread(convertStringsToChars(plyDir + plyName + "_msePerBit08_dec.ply"));
        pointMetricsResult = point_metrics(pcIn.Location, pcOut.Location);
        result.msePerBit08Mse = pointMetricsResult.p2point_mse(2);
        result.msePerBit08Psnr = pointMetricsResult.p2point_psnr;
        result.msePerBit08toggleSlicesFlags = toggleSlicesFlags;
        totalGoods = totalGoods + 1;
    catch err
        result.msePerBit08Err = err;
        disp(" ");
        disp(convertStringsToChars("[BAD END] " + plyName + "_msePerBit08 bad!"));
    end

    save(convertStringsToChars(plyDir + plyName + "Vars.mat"));

    disp(" ");
    disp("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    disp("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");

    totalTries = totalTries + 1;
    try
        inputPly = convertStringsToChars(plyDir + plyName + ".ply");
        binaryFile = convertStringsToChars(plyDir + plyName + "_nBits07_enc.bin");
        outputPly = convertStringsToChars(plyDir + plyName + "_nBits07_dec.ply");
        bitsPercentage = 0.7;
        encodeMode = 0;
        preEncodeDone = 1;
        testEncoderDecoder(inputPly, binaryFile, outputPly);
        disp(" ");
        disp(convertStringsToChars("[END] " + plyName + "_nBits07 good!"));
        result.nBits07Bpov = bpovResult;
        pcOut = pcread(convertStringsToChars(plyDir + plyName + "_nBits07_dec.ply"));
        pointMetricsResult = point_metrics(pcIn.Location, pcOut.Location);
        result.nBits07Mse = pointMetricsResult.p2point_mse(2);
        result.nBits07Psnr = pointMetricsResult.p2point_psnr;
        result.nBits07toggleSlicesFlags = toggleSlicesFlags;
        totalGoods = totalGoods + 1;
    catch err
        result.nBits07Err = err;
        disp(" ");
        disp(convertStringsToChars("[BAD END] " + plyName + "_nBits07 bad!"));
    end

    save(convertStringsToChars(plyDir + plyName + "Vars.mat"));

    disp(" ");
    disp("--------------------------------------------------------------------------------");

    totalTries = totalTries + 1;
    try
        inputPly = convertStringsToChars(plyDir + plyName + ".ply");
        binaryFile = convertStringsToChars(plyDir + plyName + "_msePerBit07_enc.bin");
        outputPly = convertStringsToChars(plyDir + plyName + "_msePerBit07_dec.ply");
        bitsPercentage = 0.7;
        encodeMode = 1;
        preEncodeDone = 1;
        testEncoderDecoder(inputPly, binaryFile, outputPly);
        disp(" ");
        disp(convertStringsToChars("[END] " + plyName + "_msePerBit07 good!"));
        result.msePerBit07Bpov = bpovResult;
        pcOut = pcread(convertStringsToChars(plyDir + plyName + "_msePerBit07_dec.ply"));
        pointMetricsResult = point_metrics(pcIn.Location, pcOut.Location);
        result.msePerBit07Mse = pointMetricsResult.p2point_mse(2);
        result.msePerBit07Psnr = pointMetricsResult.p2point_psnr;
        result.msePerBit07toggleSlicesFlags = toggleSlicesFlags;
        totalGoods = totalGoods + 1;
    catch err
        result.msePerBit07Err = err;
        disp(" ");
        disp(convertStringsToChars("[BAD END] " + plyName + "_msePerBit07 bad!"));
    end

    save(convertStringsToChars(plyDir + plyName + "Vars.mat"));

    disp(" ");
    disp("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    disp("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");

    totalTries = totalTries + 1;
    try
        inputPly = convertStringsToChars(plyDir + plyName + ".ply");
        binaryFile = convertStringsToChars(plyDir + plyName + "_nBits06_enc.bin");
        outputPly = convertStringsToChars(plyDir + plyName + "_nBits06_dec.ply");
        bitsPercentage = 0.6;
        encodeMode = 0;
        preEncodeDone = 1;
        testEncoderDecoder(inputPly, binaryFile, outputPly);
        disp(" ");
        disp(convertStringsToChars("[END] " + plyName + "_nBits06 good!"));
        result.nBits06Bpov = bpovResult;
        pcOut = pcread(convertStringsToChars(plyDir + plyName + "_nBits06_dec.ply"));
        pointMetricsResult = point_metrics(pcIn.Location, pcOut.Location);
        result.nBits06Mse = pointMetricsResult.p2point_mse(2);
        result.nBits06Psnr = pointMetricsResult.p2point_psnr;
        result.nBits06toggleSlicesFlags = toggleSlicesFlags;
        totalGoods = totalGoods + 1;
    catch err
        result.nBits06Err = err;
        disp(" ");
        disp(convertStringsToChars("[BAD END] " + plyName + "_nBits06 bad!"));
    end

    save(convertStringsToChars(plyDir + plyName + "Vars.mat"));

    disp(" ");
    disp("--------------------------------------------------------------------------------");

    totalTries = totalTries + 1;
    try
        inputPly = convertStringsToChars(plyDir + plyName + ".ply");
        binaryFile = convertStringsToChars(plyDir + plyName + "_msePerBit06_enc.bin");
        outputPly = convertStringsToChars(plyDir + plyName + "_msePerBit06_dec.ply");
        bitsPercentage = 0.6;
        encodeMode = 1;
        preEncodeDone = 1;
        testEncoderDecoder(inputPly, binaryFile, outputPly);
        disp(" ");
        disp(convertStringsToChars("[END] " + plyName + "_msePerBit06 good!"));
        result.msePerBit06Bpov = bpovResult;
        pcOut = pcread(convertStringsToChars(plyDir + plyName + "_msePerBit06_dec.ply"));
        pointMetricsResult = point_metrics(pcIn.Location, pcOut.Location);
        result.msePerBit06Mse = pointMetricsResult.p2point_mse(2);
        result.msePerBit06Psnr = pointMetricsResult.p2point_psnr;
        result.msePerBit06toggleSlicesFlags = toggleSlicesFlags;
        totalGoods = totalGoods + 1;
    catch err
        result.msePerBit06Err = err;
        disp(" ");
        disp(convertStringsToChars("[BAD END] " + plyName + "_msePerBit06 bad!"));
    end

    save(convertStringsToChars(plyDir + plyName + "Vars.mat"));

    disp(" ");
    disp("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    disp("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");

    totalTries = totalTries + 1;
    try
        inputPly = convertStringsToChars(plyDir + plyName + ".ply");
        binaryFile = convertStringsToChars(plyDir + plyName + "_nBits05_enc.bin");
        outputPly = convertStringsToChars(plyDir + plyName + "_nBits05_dec.ply");
        bitsPercentage = 0.5;
        encodeMode = 0;
        preEncodeDone = 1;
        testEncoderDecoder(inputPly, binaryFile, outputPly);
        disp(" ");
        disp(convertStringsToChars("[END] " + plyName + "_nBits05 good!"));
        result.nBits05Bpov = bpovResult;
        pcOut = pcread(convertStringsToChars(plyDir + plyName + "_nBits05_dec.ply"));
        pointMetricsResult = point_metrics(pcIn.Location, pcOut.Location);
        result.nBits05Mse = pointMetricsResult.p2point_mse(2);
        result.nBits05Psnr = pointMetricsResult.p2point_psnr;
        result.nBits05toggleSlicesFlags = toggleSlicesFlags;
        totalGoods = totalGoods + 1;
    catch err
        result.nBits05Err = err;
        disp(" ");
        disp(convertStringsToChars("[BAD END] " + plyName + "_nBits05 bad!"));
    end

    save(convertStringsToChars(plyDir + plyName + "Vars.mat"));

    disp(" ");
    disp("--------------------------------------------------------------------------------");

    totalTries = totalTries + 1;
    try
        inputPly = convertStringsToChars(plyDir + plyName + ".ply");
        binaryFile = convertStringsToChars(plyDir + plyName + "_msePerBit05_enc.bin");
        outputPly = convertStringsToChars(plyDir + plyName + "_msePerBit05_dec.ply");
        bitsPercentage = 0.5;
        encodeMode = 1;
        preEncodeDone = 1;
        testEncoderDecoder(inputPly, binaryFile, outputPly);
        disp(" ");
        disp(convertStringsToChars("[END] " + plyName + "_msePerBit05 good!"));
        result.msePerBit05Bpov = bpovResult;
        pcOut = pcread(convertStringsToChars(plyDir + plyName + "_msePerBit05_dec.ply"));
        pointMetricsResult = point_metrics(pcIn.Location, pcOut.Location);
        result.msePerBit05Mse = pointMetricsResult.p2point_mse(2);
        result.msePerBit05Psnr = pointMetricsResult.p2point_psnr;
        result.msePerBit05toggleSlicesFlags = toggleSlicesFlags;
        totalGoods = totalGoods + 1;
    catch err
        result.msePerBit05Err = err;
        disp(" ");
        disp(convertStringsToChars("[BAD END] " + plyName + "_msePerBit05 bad!"));
    end

    save(convertStringsToChars(plyDir + plyName + "Vars.mat"));

    disp(" ");
    disp(convertStringsToChars("[PLY END] End of " + plyName + ".ply"));
    disp("################################################################################");
    disp("################################################################################");
    disp("################################################################################");
    disp(" ");

end
