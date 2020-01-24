% [geoCube,cabac] = decodeSliceAsSingles(geoCube,cabac, iStart,iEnd, Y)
%  
% This decodes a range encoded with the single mode encoding.
%
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function [geoCube,cabac] = decodeSliceAsSingles(geoCube,cabac, iStart,iEnd, Y)

%Parameters for lossy compression
nUpsample = 1;
step = 2;
%Structure to improve morphologically the upsampled image 
if(nUpsample < 2)
    se = strel('disk',3);
else
    se = strel('disk',5);
end

Y_downsampled = imresize(logical(Y),1/nUpsample, 'Method', 'nearest', ...
    'Antialiasing', false);
% Y_downsampled = downsample(logical(Y),nUpsample);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Uses the parent as mask.
%mask = Y;
[sy, sx]  = size(Y_downsampled);
maskLast = zeros(sy,sx,'logical');

[idx_i, idx_j] = find(Y_downsampled');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% nones = sum(Y_downsampled(:));
% disp(['Single decoding: (' num2str(iStart) ',' num2str(iEnd) ') = ' num2str(nones) ' .'])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Iterates through all the slices
for i = iStart:step:(iEnd)
    %Reads if this slice was encoded.
    [cabac.ParamBitstream, bit] = cabac.ParamBitstream.read1Bit();
   
    %If it was not encoded, then I do not have to do anything.
    if (bit == 1)
        %Gets the slice for the 3D context.
        if (i == 1)
            Yleft_downsampled = zeros(sy,sx,'logical');
%             Yleft = imresize(Yleft_downsampled, nUpsample);
        else
            Yleft = geoCube(:,:,i-step);
            %Downsample from lossy compression
            Yleft_downsampled = imresize(logical(Yleft), 1/nUpsample, 'Method', 'nearest', ...
    'Antialiasing', false);
%             Yleft_downsampled = downsample(logical(Yleft), nUpsample);
        end   
        
        %Allocates the image
        A = zeros(sy,sx,'logical');
        
        %Decodes the current image.
        [A, cabac] = decodeImageBAC_withMask_3DContexts2(A, idx_i, idx_j, Yleft_downsampled, cabac);
%         disp(['Single decoding A: ' num2str(sum(A(:)))]);
%         disp(['Single decoding Yleft: ' num2str(sum(Yleft_downsampled(:)))]);
        %Upsample downsampled image to put in the cube
        A_upsampled = imresize(logical(A), nUpsample, 'Method', 'nearest', ...
    'Antialiasing', false);
%         A_upsampled = upsample(logical(A), nUpsample);
        %Puts it in the geoCube.
%         geoCube(:,:,i) = (A_upsampled & Y);
%         if (((i+step) <= iEnd) && nUpsample ~= 1)
%             A_upsampled = imclose(A_upsampled, se);
%             A_upsampled = and(A_upsampled, logical(Y));
%         end
        geoCube(:,:,i) = (A_upsampled);
        
        if((i ~= 1) && (step > 1))
%             inter_slices = morph_binary(geoCube(:,:,i), ...
%                 geoCube(:,:,i-step),step-1);
%             geoCube(:,:,(i-step+1):i-1) = inter_slices(:,:,2:step);
            
            inter_slices = improved_morph_binary(geoCube(:,:,i), ...
                geoCube(:,:,i-step),step-1,logical(Y));
            geoCube(:,:,(i-step+1):i-1) = inter_slices(:,:,2:step);
        end
        %Prepares for the last mask!        
        maskLast = or(A,maskLast);    
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Decodes the last image.
% %Reads if this slice was encoded.
% [cabac.ParamBitstream, bit] = cabac.ParamBitstream.read1Bit();
% 
% %If it is zero, it is done.
% if (bit == 1)    
%     %For the last slice, the mask is a bit different.
%     mask = and(Y_downsampled,maskLast);
%     
%     [idx_i, idx_j] = find(mask');
%     
%     %Gets the slice for the 3D context.
%     if (iEnd == 1)
%         Yleft_downsampled = zeros(sy,sx,'logical');
% %         Yleft = imresize(Yleft_downsampled, nUpsample);
%     else
%         Yleft = geoCube(:,:,iEnd-1 - mod(iEnd-iStart-1,step));
%         %Downsample from lossy compression
%         Yleft_downsampled = imresize(logical(Yleft), 1/nUpsample);
%     end
%     
%     %Allocates the image with the current information
% %     A = and(Y_downsampled,not(maskLast));
%     
%     %Allocates the image
%      A = zeros(sy,sx,'logical');
%     %Decodes the current image.
%     [A, cabac] = decodeImageBAC_withMask_3DContexts2(A, idx_i, idx_j, Yleft_downsampled, cabac);
%    
%     %Upsample downsampled image to put in the cube
%     A_upsampled = imresize(logical(A), nUpsample);
%     %Puts it in the geoCube.
%     geoCube(:,:,iEnd) = A_upsampled;
%     
%     % Interpolation for the last frame
%     if(mod(iEnd-iStart,step)~= 0)
%         inter_slices = morph_binary(geoCube(:,:,iEnd), ...
%                     geoCube(:,:,iEnd-1 - mod(iEnd-iStart-1,step)),mod(iEnd-iStart-1,step));
%         geoCube(:,:,iEnd - mod(iEnd-iStart-1,step):iEnd-1) = inter_slices(:,:,2:mod(iEnd-iStart-1,step)+1);
%     end
% end
