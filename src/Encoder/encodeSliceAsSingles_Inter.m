% Function cabac = encodeSliceAsSingles(geoCube,cabac,iStart,iEnd,Y)
%  This tests the single mode encoding. 
%  Encodes all images in the range iStart to iEnd, using the received Y as
%  mask (except for the last image, which uses a different mask).
%
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function cabac = encodeSliceAsSingles_Inter(~, enc, currAxis, cabac,iStart,iEnd,Y, sparseM)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Uses the parent as mask.
[sy, sx]  = size(Y);
maskLast = zeros(sy,sx,'logical');

[idx_i, idx_j] = find(Y');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Iterates through all the slices
for i = iStart:1:(iEnd-1)
    %Gets the current slice to be encoded.
    A  = silhouetteFromCloud(enc.pointCloud.Location, enc.pcLimit+1, currAxis, i, i, sparseM);
    
    %Testing the motion estimation.
    if (enc.params.useMEforPrevImageSingle == 1)
        [pA, d1, d2, d3]  = findBestPredictionMatch(A , enc, currAxis, i, i);
    else
        pA = silhouetteFromCloud(enc.predictionPointCloud.Location, enc.pcLimit+1, currAxis, i, i, sparseM);
    end
    
    nSymbolsA = sum(A(:));
    
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
        maskLast = or(A,maskLast);
        
        %Gets the left slice for the 3D context.
        if (i == 1)
            Yleft = zeros(sy,sx,'logical');
        else
            Yleft = silhouetteFromCloud(enc.pointCloud.Location, enc.pcLimit+1, currAxis, i-1, i-1, sparseM);
        end
        
        if (enc.params.test3DOnlyContextsForInter == 1)
            if ( enc.params.fastChoice3Dvs4D == 1)
                cabac = encodeImageBAC_withMask_3DContexts_Inter_Fast(A,idx_i, idx_j,Yleft,pA,cabac);
            else
                cabac = encodeImageBAC_withMask_3DContexts_Inter(A,idx_i, idx_j,Yleft,pA,cabac, 1);
            end
        else
            cabac = encodeImageBAC_withMask_3DContexts_Inter(A,idx_i, idx_j,Yleft,pA,cabac, 0);
        end
        
    end
    
    %nBitsImage = cabac.BACEngine.bitstream.size() - nBits + 1;    
    %disp(['  Single (' num2str(i) ') - Rate = ' num2str(nBitsImage) ''])    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Encodes the last image.
A  = silhouetteFromCloud(enc.pointCloud.Location, enc.pcLimit+1, currAxis, iEnd, iEnd, sparseM);

%Testing the motion estimation.
if (enc.params.useMEforPrevImageSingle == 1)
    [pA, d1, d2, d3]  = findBestPredictionMatch(A , enc, currAxis, iEnd, iEnd);
else
    pA = silhouetteFromCloud(enc.predictionPointCloud.Location, enc.pcLimit+1, currAxis, iEnd, iEnd, sparseM);
end

nSymbolsA = sum(A(:));
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%First, I have to signal if this slice will be encoded.
if (nSymbolsA == 0)
    cabac = encodeParam(false,cabac);
else
    cabac = encodeParam(true,cabac);
end

%nBits = cabac.BACEngine.bitstream.size();
%For the last slice, the mask is a bit different. 
if (nSymbolsA ~= 0)
    mask = and(Y,maskLast);
    
    [idx_i, idx_j] = find(mask');
    
    %%%%%%%%%%%%%%%%%%%
    %Encodes the slice
    if (iEnd == 1)
        Yleft = zeros(sy,sx,'logical');
    else
        Yleft = silhouetteFromCloud(enc.pointCloud.Location, enc.pcLimit+1, currAxis, iEnd-1, iEnd-1, sparseM);
    end
    
    if (enc.params.test3DOnlyContextsForInter == 1)
        if ( enc.params.fastChoice3Dvs4D == 1)
            cabac = encodeImageBAC_withMask_3DContexts_Inter_Fast(A,idx_i, idx_j,Yleft,pA,cabac);
        else
            cabac = encodeImageBAC_withMask_3DContexts_Inter(A,idx_i, idx_j,Yleft,pA,cabac, 1);
        end        
    else
        cabac = encodeImageBAC_withMask_3DContexts_Inter(A,idx_i, idx_j,Yleft,pA,cabac, 0);
    end
    
end
% nBitsImage = cabac.BACEngine.bitstream.size() - nBits + 1;

%disp(['  Single (' num2str(i) ') - Rate = ' num2str(nBitsImage) ''])    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
