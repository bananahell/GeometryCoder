% Function cabac = encodeSliceAsSingles(geoCube,cabac,iStart,iEnd,Y)
%  This tests the single mode encoding. 
%  Encodes all images in the range iStart to iEnd, using the received Y as
%  mask (except for the last image, which uses a different mask).
%
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function cabac = encodeSliceAsSingles(~, enc, currAxis, cabac,iStart,iEnd,Y, sparseM)

%Parameters for lossy compression
nDownsample = enc.params.lossyParams.nDownsample;
step = enc.params.lossyParams.step;
%Structure to improve morphologically the upsampled image 
% if(nDownsample < 2)
%     se = strel('disk',3);
% else
%     se = strel('disk',5);
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Downsampling Y for lossy compression
Y_downsampled = imresize(logical(Y), 1/nDownsample, 'Method', 'nearest', ...
    'Antialiasing', false);
% Y_downsampled = downsample(logical(Y), nDownsample);

%Uses the parent as mask.
[sy, sx]  = size(Y_downsampled);
maskLast = zeros(sy,sx,'logical');

[idx_i, idx_j] = find(Y_downsampled');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% nones = sum(Y_downsampled(:));
% disp(['Single encoding: (' num2str(iStart) ',' num2str(iEnd) ') = ' num2str(nones) ' .'])
% kernel = ones(3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Iterates through all the slices
for i = iStart:step:(iEnd)
    %Gets the current slice to be encoded.
    %A = geoCube(:,:,i);
    A = silhouetteFromCloud(enc.pointCloud.Location, enc.pcLimit+1, currAxis, i, i, sparseM);
    
    %Downsampling A for lossy compression
    A_downsampled = imresize(logical(A), 1/nDownsample, 'Method', 'nearest', ...
    'Antialiasing', false);
%     A_downsampled = downsample(logical(A), nDownsample);
    
%     countImage = conv2(A, kernel, 'full');
%     countImage = countImage(2:(end-1), 2:(end-1)); 
%     
%     for conv_idx = 1:size(A_downsampled,1)
%         for j = 1:size(A_downsampled,2)
%             if(A_downsampled(conv_idx,j) == 0)
%                 if(countImage(floor(conv_idx*nDownsample), floor(j*nDownsample)) >= 5)
%                     A_downsampled(conv_idx,j) = 1;
%                 end
%             end
%         end
%     end
    %if(not(isequal(A,AA)))
    %    display('Slices are not equal...')
    %    display(['Axis: ' currAxis]);
    %    display(['Slice index: ' i]);
    %end
    
    nSymbolsA = sum(A_downsampled(:));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %First, I have to signal if this slice will be encoded.
    if (nSymbolsA == 0)
        cabac = encodeParam(false,cabac);
    else
        cabac = encodeParam(true,cabac);
    end
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Encodes the slice
    %nBits = cabac.BACEngine.bitstream.size();   
    if (nSymbolsA ~= 0)
        %Prepares for the last mask!        
        maskLast = or(A_downsampled,maskLast);
        
        %Gets the left slice for the 3D context.
        if (i == 1)
            Yleft_downsampled = zeros(sy,sx,'logical');
%             Yleft = imresize(Yleft_downsampled, nDownsample);
        else
            %Yleft = geoCube(:,:,i-1);
            Yleft = silhouetteFromCloud(enc.pointCloud.Location, enc.pcLimit+1, currAxis, i-step, i-step, sparseM);
            Yleft_downsampled = imresize(logical(Yleft), 1/nDownsample, 'Method', 'nearest', ...
    'Antialiasing', false);
%             countImage = conv2(Yleft, kernel, 'full');
%             countImage = countImage(2:(end-1), 2:(end-1)); 
% 
%             for conv_idx = 1:size(Yleft_downsampled,1)
%                 for j = 1:size(Yleft_downsampled,2)
%                     if(Yleft_downsampled(conv_idx,j) == 0)
%                         if(countImage(floor(conv_idx*nDownsample), floor(j*nDownsample)) >= 5)
%                             Yleft_downsampled(conv_idx,j) = 1;
%                         end
%                     end
%                 end
%             end
%             if (i ~= iStart && nDownsample ~= 1)
%                 Yleft_downsampled = imresize(Yleft_downsampled, nDownsample, 'Method', 'nearest', ...
%         'Antialiasing', false);
%                 Yleft_downsampled = imclose(Yleft_downsampled, se);
%                 Yleft_downsampled = and(Yleft_downsampled, logical(Y));
%                 Yleft_downsampled = imresize(Yleft_downsampled, 1/nDownsample, 'Method', 'nearest', ...
%         'Antialiasing', false);
%             end
%             Yleft_downsampled = downsample(logical(Yleft), nDownsample);
        end
%         disp(['Single encoding A: ' num2str(sum(A_downsampled(:)))]);
%         disp(['Single encoding Yleft: ' num2str(sum(Yleft_downsampled(:)))]);

        %Actually encodes the image.
        cabac = encodeImageBAC_withMask_3DContexts2(A_downsampled,idx_i, idx_j,Yleft_downsampled,cabac);
    end
    
    %nBitsImage = cabac.BACEngine.bitstream.size() - nBits + 1;
    %disp(['  Single (' num2str(i) ') - Rate = ' num2str(nBitsImage) ''])    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Encodes the last image.
% % A = geoCube(:,:,iEnd);
% A = silhouetteFromCloud(enc.pointCloud.Location, enc.pcLimit+1, currAxis, iEnd, iEnd, sparseM);
% 
% %Downsampling A for lossy compression
% A_downsampled = imresize(logical(A), 1/nDownsample);
% nSymbolsA = sum(A_downsampled(:));
%     
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %First, I have to signal if this slice will be encoded.
% if (nSymbolsA == 0)
%     cabac = encodeParam(false,cabac);
% else
%     cabac = encodeParam(true,cabac);
% end
% 
% %nBits = cabac.BACEngine.bitstream.size();
% %For the last slice, the mask is a bit different. 
% if (nSymbolsA ~= 0)
%     mask = and(Y_downsampled,maskLast);
%     
%     [idx_i, idx_j] = find(mask');
%     
%     %%%%%%%%%%%%%%%%%%%
%     %Encodes the slice
%     if (iEnd == 1)
%         Yleft_downsampled = zeros(sy,sx,'logical');
% %         Yleft = imresize(Yleft_downsampled, nDownsample);
%     else
%         %Yleft = geoCube(:,:,iEnd-1);
%         Yleft = silhouetteFromCloud(enc.pointCloud.Location, enc.pcLimit+1, ...
%             currAxis, iEnd-1 - mod(iEnd-iStart-1,step), iEnd-1 - mod(iEnd-iStart-1,step), sparseM);
%         Yleft_downsampled = imresize(logical(Yleft), 1/nDownsample);
%     end
%     
%     %Actually encodes the image.
%     cabac = encodeImageBAC_withMask_3DContexts2(A_downsampled,idx_i, idx_j,Yleft_downsampled,cabac);
% end
% %nBitsImage = cabac.BACEngine.bitstream.size() - nBits + 1;
% %disp(['  Single (' num2str(i) ') - Rate = ' num2str(nBitsImage) ''])    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
