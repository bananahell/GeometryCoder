% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function cabac = createContextTableInterSingle(enc, currAxis, cabac,iStart,iEnd,Y, sparseM)

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
    %Encodes the slice
    if (nSymbolsA ~= 0)
        %Prepares for the last mask!        
        maskLast = or(A,maskLast);
        
        %Gets the left slice for the 3D context.
        if (i == 1)
            Yleft = zeros(sy,sx,'logical');
        else
            Yleft = silhouetteFromCloud(enc.pointCloud.Location, enc.pcLimit+1, currAxis, i-1, i-1, sparseM);
        end
        
        cabac = entropyWithMaskInterSingle(A,idx_i, idx_j,Yleft,pA,cabac);
        
    end
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
    
    cabac = entropyWithMaskInterSingle(A,idx_i, idx_j,Yleft,pA,cabac);
end