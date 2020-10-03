% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function cabac = createContextTableInterSingle(enc, currAxis, cabac,iStart,iEnd,Y, sparseM)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Uses the parent as mask.
[sy, sx]  = size(Y);
maskLast = zeros(sy,sx,'logical');

[idx_i, idx_j] = find(Y');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Iterates through all the slices
for i = iStart:1:(iEnd-1)
    %Gets the current slice to be encoded.
    A  = silhouetteFromCloud(enc.pointCloud.Location, enc.pcLimit+1, currAxis, i, i, sparseM);
    pA = silhouetteFromCloud(enc.predictionPointCloud.Location, enc.pcLimit+1, currAxis, i, i, sparseM);
    
    nSymbolsA = sum(A(:));
      
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Encodes the slice
    if (nSymbolsA ~= 0)
        %Prepares for the last mask! 
        if(iEnd == 1)
            mask = and(Y,maskLast);
            [idx_i, idx_j] = find(mask');
        else
            maskLast = or(A,maskLast);
        end
        
        %Gets the left slice for the 3D context.
        if (i == 1)
            Yleft = zeros(sy,sx,'logical');
        else
            Yleft = silhouetteFromCloud(enc.pointCloud.Location, enc.pcLimit+1, currAxis, i-1, i-1, sparseM);
        end
        
        cabac = entropyWithMaskInterSingle(A,idx_i, idx_j,Yleft,pA,cabac);
        
    end
end