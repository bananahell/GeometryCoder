function img = read_rgb_video(filename, w, h)
%Read Raw RGB video from PccAppRenderer
% Given a .RGB file recorded from PccAppRenderer using 'RgbFile' input
% option, this function separates each frame of the video in an cell of
% images.
%
%  Usage:
%    img = read_rgb_video(filename, w, h)
%
%    INPUTS:
%     filename: .RGB file from PccAppRenderer,
%     w: width of the window used when the video was recorded
%     h: height of the window used when the video was recorded
%
%    OUTPUT:
%     img: a cell of images with the which size is equal to number of
%     frames from the .RGB file.

fileID = fopen(filename);
frames = fread(fileID,'*uint8');
nframes = length(frames)/(w*h*3);
img = cell(1,nframes);

for i=1:nframes
    frame = frames((w*h*3)*(i-1)+1:(w*h*3)*i);
    R = reshape(frame(1:3:end),[w, h])';
    G = reshape(frame(2:3:end),[w, h])';
    B = reshape(frame(3:3:end),[w, h])';

    img{i} = cat(3,R,G,B);
%     imshow(img{i});
%     pause;
end
fclose(fileID);

end %function
