% InPC = 'frame0001.ply';
% prevPC = 'frame0000.ply';

% prevPC = 'C:\Users\evari\Documents\PC_Dataset\sarah9\ply\frame0000.ply';
% InPC = 'C:\Users\evari\Documents\PC_Dataset\sarah9\ply\frame0001.ply';

% prevPC = 'C:\Users\evari\Documents\PC_Dataset_1024\longdress\Ply\longdress_vox10_1051.ply';
% InPC = 'C:\Users\evari\Documents\PC_Dataset_1024\longdress\Ply\longdress_vox10_1052.ply';

% prevPC = 'C:\Users\evari\Documents\PC_Dataset_1024\loot\Ply\loot_vox10_1000.ply';
% InPC = 'C:\Users\evari\Documents\PC_Dataset_1024\loot\Ply\loot_vox10_1001.ply';

prevPC = 'C:\Users\evari\Documents\PC_Dataset_1024\redandblack\Ply\redandblack_vox10_1450.ply';
InPC = 'C:\Users\evari\Documents\PC_Dataset_1024\redandblack\Ply\redandblack_vox10_1451.ply';

% prevPC = 'C:\Users\evari\Documents\PC_Dataset_1024\soldier\Ply\soldier_vox10_0536.ply';
% InPC = 'C:\Users\evari\Documents\PC_Dataset_1024\soldier\Ply\soldier_vox10_0537.ply';

finalFile = '1.out';
reconstructFile = 'rec.ply';
encodePointCloudGeometry_Inter(InPC,prevPC,finalFile);
% decodePointCloudGeometry_Inter(finalFile,prevPC,reconstructFile);
