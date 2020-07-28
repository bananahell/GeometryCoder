function cabac_out = createContextTableInter(enc, currAxis,iStart,iEnd,Y,entropyTables)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%These are the parameters.
testDyadicDecomposition = 1;
sparseM                 = false; % Use sparse matrices for images.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The first time this function is called I have to encode the first OR image
%that encompasses the whole geocube.
if (nargin == 4)
    
    entropyTables = getHTables();
    entropyTables = initHTables(entropyTables,enc.params.BACParams, 1, enc.params.test3DOnlyContextsForInter);
    
    %1 - Gets the main image.
    Y  = silhouetteFromCloud(enc.pointCloud.Location, enc.pcLimit+1, currAxis, iStart, iEnd, sparseM);
    
    pY = silhouetteFromCloud(enc.predictionPointCloud.Location, enc.pcLimit+1, currAxis, iStart, iEnd, sparseM);
    
    %Encodes the image Y.
    entropyTables = entropyFirstSilhouette(Y,pY,entropyTables);    
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Testing the dyadic decomposition.
if (testDyadicDecomposition)
    %Starts a new cabac option.
    cabacDyadic = entropyTables;
    
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
                if (enc.params.test3DOnlyContextsForInter == 1)
                    if ( enc.params.fastChoice3Dvs4D == 1)
                        cabacDyadic = entropyWithMaskInterFast(Yleft,mask_Yleft,pYleft,cabacDyadic); 
                    else
                        cabacDyadic = entropyWithMaskInter(Yleft,mask_Yleft,pYleft,cabacDyadic, 1);
                    end
                else
                    cabacDyadic = entropyWithMaskInter(Yleft,mask_Yleft,pYleft,cabacDyadic, 0);                    
                end                
            else
                Yleft_left  = silhouetteFromCloud(enc.pointCloud.Location, enc.pcLimit+1, currAxis, lStart - NLeft, lEnd - NLeft, sparseM);
                
                if (enc.params.test3DOnlyContextsForInter == 1)
                    if ( enc.params.fastChoice3Dvs4D == 1)
                        cabacDyadic = entropyWithMask3DContextsOrImagesInterFast(Yleft,mask_Yleft,Yleft_left,pYleft,cabacDyadic);
                    else
                        cabacDyadic = entropyWithMask3DContextsOrImagesInter(Yleft,mask_Yleft,Yleft_left,pYleft,cabacDyadic, 1);
                    end
                else
                    cabacDyadic = entropyWithMask3DContextsOrImagesInter(Yleft,mask_Yleft,Yleft_left,pYleft,cabacDyadic, 0);
                end
            end
                        
        end
        
        %This can be inferred at the decoder, no need to signal this in the
        %bitstream.
        if (nSymbolsRight > 0)            
            %Test with new amazing 3D context
            Yright_left = Yleft;
            
            if (enc.params.test3DOnlyContextsForInter == 1)
                if ( enc.params.fastChoice3Dvs4D == 1)
                    cabacDyadic = entropyWithMask3DContextsOrImagesInterFast(Yright,mask_Yright,Yright_left, pYright, cabacDyadic);
                else
                    cabacDyadic = entropyWithMask3DContextsOrImagesInter(Yright,mask_Yright,Yright_left, pYright, cabacDyadic, 1);
                end
            else
                cabacDyadic = entropyWithMask3DContextsOrImagesInter(Yright,mask_Yright,Yright_left, pYright, cabacDyadic, 0);
            end            
        end
    end
    
    %Checks the left branch.
    %This can be inferred at the decoder, no need to signal this in the
    %bitstream.
    if (encodeYleft && (lEnd > lStart))
        cabacDyadic = createContextTableInter(enc, currAxis, lStart,lEnd, Yleft,cabacDyadic);    
    end
    if (encodeYright && (rEnd > rStart))                
        cabacDyadic = createContextTableInter(enc,currAxis, rStart,rEnd, Yright,cabacDyadic);  
    end    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Testing the second option - encoding as singles.
% if ((testEncodeAsSingles == 1) && ((iEnd - iStart) <= 16))
%     cabacSingle = cabac;
%     
%     %Add a flag to the bitstream indicating that the single method will be
%     %used.    
%     cabacSingle = entropySliceAsSinglesInter(enc, currAxis, cabacSingle,iStart,iEnd,Y, sparseM);
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Deciding the best option.
% if (nBitsDyadic <= nBitsSingle)
     cabac_out = cabacDyadic;
% else
%    cabac_out = cabacSingle;
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%