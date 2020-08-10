%A = addingContextTable(B);
load valua
B = structTables.BACContexts_3DT_ORImages;
C = [ones(1,6) ones(1,9) ones(1,9)];
D = dec2bin(0:2^15-1);
countFinal = reduceTable(B,C,D);