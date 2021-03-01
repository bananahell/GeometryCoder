

prevPC = 'frame0000.ply';
InPC = 'frame0001.ply';

finalFile = 'rec_file.out';
reconstructFile = 'rec.ply';
encodePointCloudGeometry_Inter(InPC,prevPC,finalFile);
% decodePointCloudGeometry_Inter(finalFile,prevPC,reconstructFile);
