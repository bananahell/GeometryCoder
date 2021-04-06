

prevPC = 'C:\Users\evari\Documents\PC_Dataset\longdress\Ply\longdress_vox10_1051.ply';
InPC = 'C:\Users\evari\Documents\PC_Dataset\longdress\Ply\longdress_vox10_1052.ply';

%prevPC = 'C:\Users\evari\Documents\PC_Dataset\ricardo9\ply\frame0000.ply';
%InPC = 'C:\Users\evari\Documents\PC_Dataset\ricardo9\ply\frame0001.ply';

finalFile = 'rec_file.out';
reconstructFile = 'rec.ply';
encodePointCloudGeometry_Inter(InPC,prevPC,finalFile);
decodePointCloudGeometry_Inter(finalFile,prevPC,reconstructFile);
