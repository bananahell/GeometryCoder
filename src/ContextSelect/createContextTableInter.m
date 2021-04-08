function [cabac_out,HData] = createContextTableInter(enc, currAxis,iStart,iEnd,useSingleMode,Y,entropyTables,HData,depth)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%These are the parameters.
testDyadicDecomposition = 1;
sparseM                 = false; % Use sparse matrices for images.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The first time this function is called I have to encode the first OR image
%that encompasses the whole geocube.
if (nargin == 5)
    
    entropyTables = getHTables();
    entropyTables = initHTables(entropyTables,enc.params.BACParams, 1, enc.params.test3DOnlyContextsForInter);
    
    %1 - Gets the main image.
    Y  = silhouetteFromCloud(enc.pointCloud.Location, enc.pcLimit+1, currAxis, iStart, iEnd, sparseM);
    
    pY = silhouetteFromCloud(enc.predictionPointCloud.Location, enc.pcLimit+1, currAxis, iStart, iEnd, sparseM);
    
    %Encodes the image Y.
    entropyTables = entropyFirstSilhouette(Y,pY,entropyTables);
    
    HData.numBitsIndependent = (enc.pcLimit+1).^2;
    HData.numBitsMasked = 0;
    HData.numBits4DT = 0;
    depth = 1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Testing the dyadic decomposition.

cabacDyadic = entropyTables;

if (testDyadicDecomposition)
    %Starts a new cabac option.
    
    %2 - Gets the two images.
    %Tests option 1: dyadic decomposition.
    mid = ((iEnd - iStart + 1) / 2) + iStart - 1;
    
    lStart = iStart;
    lEnd   = mid;
    NLeft  = lEnd - lStart + 1;
    
    rStart = mid + 1;
    rEnd   = iEnd;
    %NRight = rEnd - rStart + 1;
    
    Yleft  = silhouetteFromCloud(enc.pointCloud.Location, enc.pcLimit+1, currAxis, lStart, lEnd, sparseM);
    Yright = silhouetteFromCloud(enc.pointCloud.Location, enc.pcLimit+1, currAxis, rStart, rEnd, sparseM);
    
    pYleft  = silhouetteFromCloud(enc.predictionPointCloud.Location, enc.pcLimit+1, currAxis, lStart, lEnd, sparseM);
    pYright = silhouetteFromCloud(enc.predictionPointCloud.Location, enc.pcLimit+1, currAxis, rStart, rEnd, sparseM);
    
    %Encode the left using Y as mask.
    %left image represents the interval [lStart,lEnd]
    mask_Yleft       = Y;
    nSymbolsLeft     = sum(mask_Yleft(:));
    
    %Encode the right using Y and Yleft as mask
    mask_Yright      = and(Y,Yleft);
    nSymbolsRight    = sum(mask_Yright(:));
    
    encodeYleft  = (sum(Yleft(:))  ~= 0);
    encodeYright = (sum(Yright(:)) ~= 0);
    
    %I only need to encode this level if I have pixels in BOTH images!
    encodeThisLevel = encodeYleft && encodeYright;
    
    if (encodeThisLevel)
        %This can be inferred at the decoder, no need to signal this in the
        %bitstream.
        if (nSymbolsLeft > 0)
            %Test with new amazing 3D context
            if (lStart == 1)
                if(depth<5)
                    cabacDyadic = entropyWithMaskInterFast(Yleft,mask_Yleft,pYleft,cabacDyadic);
                end
                HData.numBitsMasked = HData.numBitsMasked+nSymbolsLeft;
            else
                if(depth<5)
                    Yleft_left  = silhouetteFromCloud(enc.pointCloud.Location, enc.pcLimit+1, currAxis, lStart - NLeft, lEnd - NLeft, sparseM);
                    cabacDyadic = entropyWithMask3DContextsOrImagesInterFast(Yleft,mask_Yleft,Yleft_left,pYleft,cabacDyadic);
                end
                HData.numBits4DT = HData.numBits4DT+nSymbolsLeft;
            end
            
        end
        
        %This can be inferred at the decoder, no need to signal this in the
        %bitstream.
        if (nSymbolsRight > 0 )
            %Test with new amazing 3D context
            if (depth<5)
                Yright_left = Yleft;
                cabacDyadic = entropyWithMask3DContextsOrImagesInterFast(Yright,mask_Yright,Yright_left, pYright, cabacDyadic);
            end
            HData.numBits4DT = HData.numBits4DT+nSymbolsRight;
            
        end
    end
    
    %Checks the left branch.
    %This can be inferred at the decoder, no need to signal this in the
    %bitstream.
    depth = depth + 1;
    if (encodeYleft && (lEnd > lStart))
        [cabacDyadic,HData] = createContextTableInter(enc, currAxis, lStart,lEnd, useSingleMode ,Yleft,cabacDyadic,HData,depth);
    end
    if (encodeYright && (rEnd > rStart))
        [cabacDyadic,HData] = createContextTableInter(enc,currAxis, rStart,rEnd, useSingleMode ,Yright,cabacDyadic,HData,depth);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ((useSingleMode==1) && (iEnd - iStart) <= 16)
    cabacDyadic = createContextTableInterSingle(enc, currAxis, cabacDyadic,iStart,iEnd,Y, sparseM);
end

cabac_out = cabacDyadic;
