% [geoCube,cabac] = decodeGeoCube(geoCube,cabac, iStart,iEnd, Y)
%  
% This decodes the dyadic decomposition or the single mode encoding,
% depending on what is found on the bitstream.
%
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function [geoCube,cabac,dec_Y] = decodeGeoCube(geoCube,cabac, iStart,iEnd, dec_Y,Y)

[sy,sx,sz] = size(geoCube);

if (nargin == 5)
    %Initializes the tag.
    cabac.BACEngineDecoder = initBACDecoder(cabac.BACEngineDecoder);
    
    Y = zeros(sy,sx,'logical');
    [Y,cabac] = decodeImageBAC(Y,cabac);
end

%Reads 1 bit from the param bitstream.
[cabac.ParamBitstream, bit] = cabac.ParamBitstream.read1Bit();

%Allocating Y from the encoder to a structure in order not to lose it (for
%lossy compression
nBits = log2(sz);
% disp(['values= ' num2str(size(dec_Y))]);
dec_Y{(nBits-log2(iEnd - iStart + 1)+1), ((iStart-1)/(iEnd-iStart+1))+1} = Y;

%Decodes the correct image.
if (bit == 0)
    %Variables for dividing the partition
    mid = ((iEnd - iStart + 1) / 2) + iStart - 1;
    
    lStart = iStart;
    lEnd   = mid;
    N      = lEnd - lStart + 1;
    
    rStart = mid + 1;
    rEnd   = iEnd;
    %NRight = rEnd - rStart + 1;
    
    %If this variable are to be used, they will be updated below.
    nSymbolsLeft  = 0;
    nSymbolsRight = 0;
    
    %Reads 2 more bits, indicating whether or not each image was encoded.
    [cabac.ParamBitstream, bit] = cabac.ParamBitstream.read1Bit();
    encodeYleft  = bit;
    [cabac.ParamBitstream, bit] = cabac.ParamBitstream.read1Bit();
    encodeYright = bit;
    
    %This level was encoded only if it had pixels in both images.
    encodeThisLevel = encodeYleft && encodeYright;
    if (encodeThisLevel)
        %Attempts to decode the left image.
        Yleft        = zeros(sy,sx,'logical');
        mask_Yleft   = Y;
        nSymbolsLeft = sum(mask_Yleft(:));
        
        if (nSymbolsLeft > 0)
            if (lStart == 1)
                [Yleft, cabac] = decodeImageBAC_withMask2(Yleft, mask_Yleft, cabac);
            else
                %This means I already have enough images for a 3D context.
%                 Yleft_left = silhouette(geoCube,lStart - N, lEnd - N);
                %Getting Yleft_left from the structure of storage of Y's
                %(for lossy compression)                
%                 disp(['i = (' num2str(iStart) ',' num2str(iEnd) '): ' num2str(sum(Y(:)))]);
                Yleft_left = dec_Y{(nBits-log2(N)+1), ((lStart-N-1)/N)+1};
%                 disp(['Y left left ' num2str(sum(Yleft_left(:)))]);
%                 disp(['values= ' num2str((nBits-log2(N)+1)) ' and ' ...
%                      num2str(((lStart-N-1)/N)+1)]);
                if(isempty(Yleft_left))
                    Yleft_left = zeros(sy,sx,'logical');
                end
                [Yleft, cabac] = decodeImageBAC_withMask_3DContexts_ORImages2(Yleft, mask_Yleft, Yleft_left, cabac);
%                 disp(['Y left ' num2str(sum(Yleft(:)))]);
            end
        end
        
%         disp(['i = (' num2str(iStart) ',' num2str(iEnd) ')'])
        %Attempts to decode the right image.
        %I already know something about the right image.
        Yright           = and(Y,not(Yleft));
        mask_Yright      = and(Y,Yleft);
        nSymbolsRight    = sum(mask_Yright(:));
        
        if (nSymbolsRight > 0)
            %For the right image, I always have enough images for the 3D
            %context.
            Yright_left = Yleft;
            [Yright, cabac] = decodeImageBAC_withMask_3DContexts_ORImages2(Yright, mask_Yright, Yright_left, cabac);            
%             disp(['Y right: ' num2str(sum(Yright(:)))]);
        end               
    else
        %If only one side had pixels, I have to do something else. 
        if ((encodeYleft == 1) && (encodeYright == 0))
            %This means only the left image had pixels.
            %Thus:
            Yleft  = Y;
            Yright = zeros(sy,sx,'logical');
        elseif ((encodeYleft == 0) && (encodeYright == 1))
            %This means only the right image had pixels.
            %Thus:
            Yright = Y;
            Yleft  = zeros(sy,sx,'logical');
        else
            %This means that neither image had pixels, and thus this
            %function should NOT have been called.
            error('Bitstream parsing error.');
        end
    end
    
    %Check if Yleft and Yright are already the slices, so they are inserted
    %into the geocube.    
    if (N == 1)
        %This means I have reached a leaf.
        %Write the decoded images in the geoCube.
        geoCube(:,:,lStart) = Yleft;
        geoCube(:,:,rStart) = Yright;
    else
        %Then I have to call this function recursively
        if (encodeYleft && (lEnd > lStart))            
            [geoCube,cabac,dec_Y] = decodeGeoCube(geoCube,cabac, lStart,lEnd, dec_Y, Yleft);
        end
        
        if (encodeYright && (rEnd > rStart))
            [geoCube,cabac,dec_Y] = decodeGeoCube(geoCube,cabac, rStart,rEnd, dec_Y, Yright);
        end        
    end
        
else
    %Decode this range using the single mode encoding.
    [geoCube,cabac] = decodeSliceAsSingles(geoCube,cabac, iStart,iEnd, Y);
end