H = calcEntropyPC('frame0001.ply', 'frame0000.ply');


for k = 1:24
    enc = encodePointCloudGeometry_Inter(k,'frame0001.ply', 'frame0000.ply','1.out');
    value(k) = enc.rate_bpov;
end