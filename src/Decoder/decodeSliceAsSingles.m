% [geoCube,cabac] = decodeSliceAsSingles(geoCube,cabac, iStart,iEnd, Y)
%  
% This decodes a range encoded with the single mode encoding.
%
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function [locations, geoCube,cabac] = decodeSliceAsSingles(geoCube, dec, locations, cabac, iStart,iEnd, Y)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Uses the parent as mask.
%mask = Y;
[sy, sx]  = size(Y);
maskLast = zeros(sy,sx,'logical');

[idx_i, idx_j] = find(Y');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Iterates through all the slices
for i = iStart:1:(iEnd-1)
    %Reads if this slice was encoded.
    [cabac.ParamBitstream, bit] = cabac.ParamBitstream.read1Bit();
   
    %If it was not encoded, then I do not have to do anything.
    if (bit == 1)
        %Gets the slice for the 3D context.
        if (i == 1)
            Yleft = zeros(sy,sx,'logical');
        else
            %Yleft = geoCube(:,:,i-1);
            Yleft = silhouetteFromCloud(locations, dec.pcLimit+1, dec.dimensionSliced, i-1, i-1, false);
        end   
        
        %Allocates the image
        A = zeros(sy,sx,'logical');
        
        %Decodes the current image.
        [A, cabac] = decodeImageBAC_withMask_3DContexts2(A, idx_i, idx_j, Yleft, cabac);
        
        %Puts it in the geoCube.
        %geoCube(:,:,i) = A;
        locations = expandPointCloud(A, locations, dec.dimensionSliced, i);
%         [x,y] = find(A);
%         if(dec.dimensionSliced == 'x')
%             locations = [locations; padarray([x y], [0 1], i, 'pre') - 1];
%         elseif(dec.dimensionSliced == 'y')
%             temp = padarray([x y], [0 1], i, 'pre');
%             temp(:,[1 2]) = temp(:,[2 1]);
%             locations = [locations; temp - 1];
%         elseif(dec.dimensionSliced == 'z')
%             locations = [locations; padarray([x y], [0 1], i, 'post') - 1];
%         end
        
        %Prepares for the last mask!        
        maskLast = or(A,maskLast);    
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Decodes the last image.
%Reads if this slice was encoded.
[cabac.ParamBitstream, bit] = cabac.ParamBitstream.read1Bit();

%If it is zero, it is done.
if (bit == 1)    
    %For the last slice, the mask is a bit different.
    mask = and(Y,maskLast);
    
    [idx_i, idx_j] = find(mask');
    
    %Gets the slice for the 3D context.
    if (iEnd == 1)
        Yleft = zeros(sy,sx,'logical');
    else
        %Yleft = geoCube(:,:,iEnd-1);
        Yleft = silhouetteFromCloud(locations, dec.pcLimit+1, dec.dimensionSliced, iEnd-1, iEnd-1, false);
    end
    
    %Allocates the image with the current information
    A = and(Y,not(maskLast));
    
    %Decodes the current image.
    [A, cabac] = decodeImageBAC_withMask_3DContexts2(A, idx_i, idx_j, Yleft, cabac);
   
    %Puts it in the geoCube.
    %geoCube(:,:,iEnd) = A;   
    locations = expandPointCloud(A, locations, dec.dimensionSliced, iEnd);
%     [x,y] = find(A);
%     if(dec.dimensionSliced == 'x')
%         locations = [locations; padarray([x y], [0 1], iEnd, 'pre') - 1];
%     elseif(dec.dimensionSliced == 'y')
%         temp = padarray([x y], [0 1], iEnd, 'pre');
%         temp(:,[1 2]) = temp(:,[2 1]);
%         locations = [locations; temp - 1];
%     elseif(dec.dimensionSliced == 'z')
%         locations = [locations; padarray([x y], [0 1], iEnd, 'post') - 1];
%     end
end
