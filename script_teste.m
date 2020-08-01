enc = encodePointCloudGeometry_Inter('frame0001.ply', 'frame0000.ply','1.out');

dec = decodePointCloudGeometry_Inter('1.out', 'frame0000.ply', 'exit.ply');
