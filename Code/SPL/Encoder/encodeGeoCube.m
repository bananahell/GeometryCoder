%function cabac_out = encodeGeoCube(enc,cabac_in, iStart,iEnd, Y)
%
% This is the main algorithm.
%  This testes both the dyadic decomposition and, if the number of images
%  in the range is small enough (less than 16), also tests the single mode
%  encoding. It then chooses the best mode for this range.
%
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function [enc, cabac_out] = encodeGeoCube(geoCube, enc,cabac_in, currAxis, iStart,iEnd, Y)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%These are the parameters.
testDyadicDecomposition = 1;
testEncodeAsSingles     = 0;
nBitsDyadic             = Inf;
nBitsSingle             = Inf;
sparseM                 = false; % Use sparse matrices for images.
flagTriggerLossyProcessing = false;
global toggleSlicesFlags;
global currentIndex;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% flagLastLevel indica que eu estou no ultimo nivel.
flagLastLevel = iEnd == (iStart + 1);
% Aqui eu checo se eu vou fazer o processamento da slice ou nao
% if flagLastLevel == true
%     if toggleSlicesFlags(currentIndex) == 1
%         flagTriggerLossyProcessing = true;
%     end
%     currentIndex = currentIndex + 1;
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The first time this function is called I have to encode the first OR image
%that encompasses the whole geocube.
if (nargin == 6)
    %1 - Gets the main image.
    %Y = silhouette(geoCube,iStart,iEnd);
    Y = silhouetteFromCloud(enc.pointCloud.Location, enc.pcLimit+1, currAxis, iStart, iEnd, sparseM);
    
    %if(not(isequal(Y, YY)))
    %    display('Y silhouttes not equal...');
    %    display([iStart iEnd]);
    %end
    
    %nBitsY   = 0;
    %Encodes the image Y.
    cabac_in = encodeImageBAC(Y,cabac_in);
    %nBitsY   = cabac_in.BACEngine.bitstream.size();
    
    %disp(['Rate Y(' num2str(iStart) ',' num2str(iEnd) ') = ' num2str(nBitsY) '.'])  
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%keyboard;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Testing the dyadic decomposition.
if (testDyadicDecomposition)
    %Starts a new cabac option.
    cabacDyadic = cabac_in;
    nBitsDyadic = 0;
    
    %2 - Gets the two images.
    %Tests option 1: dyadic decomposition.
    mid = ((iEnd - iStart + 1) / 2) + iStart - 1;
    
    lStart = iStart;
    lEnd   = mid;
    NLeft  = lEnd - lStart + 1;
    
    rStart = mid + 1;
    rEnd   = iEnd;
    %NRight = rEnd - rStart + 1;
    
    %Yleft  = silhouette(geoCube,lStart,lEnd);
    %Yright = silhouette(geoCube,rStart,rEnd);
    
    %EDUARDO: Estou ligando o lossy processing para um par espec�fico. 
    if (flagLastLevel && ((iStart == 71) || (iStart == 111)))
        flagTriggerLossyProcessing = true;
    end
    
    if flagTriggerLossyProcessing
        Yleft = Y;
        Yright = Y;
        
        %Add these points to the point cloud.
        enc.pointCloud.Location = expandPointCloud(Y, enc.pointCloud.Location, currAxis, iStart);
        enc.pointCloud.Location = expandPointCloud(Y, enc.pointCloud.Location, currAxis, iEnd);
        
    else
        Yleft  = silhouetteFromCloud(enc.pointCloud.Location, enc.pcLimit+1, currAxis, lStart, lEnd, sparseM);
        Yright = silhouetteFromCloud(enc.pointCloud.Location, enc.pcLimit+1, currAxis, rStart, rEnd, sparseM);
    end
    
    %if(not(isequal(Yleft, YYleft)))
    %    display('Yleft silhouttes not equal...');
    %    display([lStart lEnd]);
    %end
    %if(not(isequal(Yright, YYright)))
    %    display('Yright silhouttes not equal...');
    %    display([rStart rEnd]);
    %end
    
    
    %Encode the left using Y as mask.
    %left image represents the interval [lStart,lEnd]
    mask_Yleft       = Y;
    nSymbolsLeft     = sum(mask_Yleft(:));
    nBitsLeft        = 0;
    
    %Encode the right using Y and Yleft as mask
    mask_Yright      = and(Y,Yleft);
    nSymbolsRight    = sum(mask_Yright(:));
    nBitsRight       = 0;
    
    %if (flagLastLevel)
    %    disp(['Yleft(' num2str(lStart) ':' num2str(lEnd) ') = ' num2str(nSymbolsLeft) ' symbols.'])
    %    disp(['Yright(' num2str(rStart) ':' num2str(rEnd) ') = ' num2str(nSymbolsRight) ' symbols.'])
    %end
    
    %At this moment I know which images I need to encode.    
    %Add a flag to the bitstream indicating that a Dyadic decomposition
    %will be used.
    cabacDyadic = encodeParam(false,cabacDyadic);
    nBitsDyadic = nBitsDyadic + 1;
    
    %Add a flag to the bitstream indicating if I am encoding image left.
    %I need to encode Yleft IF it has any symbol.
    %I need to encode Yright IF 
    encodeYleft  = (sum(Yleft(:))  ~= 0);
    encodeYright = (sum(Yright(:)) ~= 0);
    
    %EDUARDO: A flag flagTriggerLossyProcessing s� deveria ser verdadeira
    %se estivermos no LastLevel, mas eu coloquei o teste aqui para
    %verificar. 
    if (flagLastLevel && flagTriggerLossyProcessing)
        %EDUARDO: Se o lossyprocessing for usado, eu n�o codifico os dois
        %filhos, bypassando a codifica��o. Por�m, como tem s�mbolos nas
        %silhuetas, ele calcularia as flags encodeYleft e encodeYright como
        %verdadeiras (veja as linhas 128 e 129). 
        
        %Eu estou for�ando os dois para ser falsos.
        encodeYleft = false;
        encodeYright = false;        
    end

    
    %Add these flags to the bitstream.
    cabacDyadic = encodeParam(encodeYleft,cabacDyadic);
    cabacDyadic = encodeParam(encodeYright,cabacDyadic);
    nBitsDyadic = nBitsDyadic + 2;
    
    %I only need to encode this level if I have pixels in BOTH images!
    encodeThisLevel = encodeYleft && encodeYright;
    
        
    if (encodeThisLevel)
        %This can be inferred at the decoder, no need to signal this in the
        %bitstream.
        if (nSymbolsLeft > 0)
            nBits = cabacDyadic.BACEngine.bitstream.size();
            
            %Test with new amazing 3D context
            if (lStart == 1)
                cabacDyadic = encodeImageBAC_withMask2(Yleft,mask_Yleft,cabacDyadic);
            else
                %Yleft_left = silhouette(geoCube,lStart - NLeft, lEnd - NLeft);
                Yleft_left  = silhouetteFromCloud(enc.pointCloud.Location, enc.pcLimit+1, currAxis, lStart - NLeft, lEnd - NLeft, sparseM);
                
                cabacDyadic = encodeImageBAC_withMask_3DContexts_ORImages2(Yleft,mask_Yleft,Yleft_left,cabacDyadic);
            end
                        
            nBitsLeft = cabacDyadic.BACEngine.bitstream.size() - nBits;
        end
        %disp(['Rate Yleft(' num2str(lStart) ',' num2str(lEnd) ') = ' num2str(nBitsLeft) '.'])
        nBitsDyadic = nBitsDyadic + nBitsLeft;
        
        
        
        
        %This can be inferred at the decoder, no need to signal this in the
        %bitstream.
        if (nSymbolsRight > 0)
            nBits = cabacDyadic.BACEngine.bitstream.size();
            
            %Test with new amazing 3D context
            Yright_left = Yleft;
            cabacDyadic = encodeImageBAC_withMask_3DContexts_ORImages2(Yright,mask_Yright,Yright_left,cabacDyadic);
            
            nBitsRight = cabacDyadic.BACEngine.bitstream.size() - nBits;
        end
        %disp(['Rate Yright(' num2str(rStart) ',' num2str(rEnd) ') = ' num2str(nBitsRight) '.'])
        nBitsDyadic = nBitsDyadic + nBitsRight;
    end
    
    %disp(['i = (' num2str(iStart) ',' num2str(iEnd) ')'])
    %disp(['l = (' num2str(lStart) ',' num2str(lEnd) ')'])
    %disp(['r = (' num2str(rStart) ',' num2str(rEnd) ')'])
    %keyboard;
    
    %Checks the left branch.
    %This can be inferred at the decoder, no need to signal this in the
    %bitstream.
    %if (encodeYleft && (nSymbolsLeft > 0) && (lEnd > lStart))
    if (encodeYleft && (lEnd > lStart))
        nBits      = cabacDyadic.BACEngine.bitstream.size();
        nBitsParam = cabacDyadic.ParamBitstream.size();
        
        [enc, cabacDyadic] = encodeGeoCube(geoCube, enc,cabacDyadic, currAxis, lStart,lEnd, Yleft);    
        
        nBitsLeftBranch      = cabacDyadic.BACEngine.bitstream.size() - nBits;
        nBitsLeftBranchParam = cabacDyadic.ParamBitstream.size() - nBitsParam;
        
        nBitsDyadic = nBitsDyadic + nBitsLeftBranch + nBitsLeftBranchParam;
    end
    
    %Checks the rights branch.
    %This can be inferred at the decoder, no need to signal this in the
    %bitstream.
    %if (encodeYright && (nSymbolsRight > 0) && (rEnd > rStart))
    if (encodeYright && (rEnd > rStart))
        nBits      = cabacDyadic.BACEngine.bitstream.size();
        nBitsParam = cabacDyadic.ParamBitstream.size();
                
        [enc, cabacDyadic] = encodeGeoCube(geoCube, enc,cabacDyadic, currAxis, rStart,rEnd, Yright);  
        
        nBitsRightBranch      = cabacDyadic.BACEngine.bitstream.size() - nBits;
        nBitsRightBranchParam = cabacDyadic.ParamBitstream.size() - nBitsParam;
        
        nBitsDyadic = nBitsDyadic + nBitsRightBranch + nBitsRightBranchParam;
    end    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Testing the second option - encoding as singles.
if ((testEncodeAsSingles == 1) && ((iEnd - iStart) <= 16))
    cabacSingle = cabac_in;
    
    nBitsSingleAC    = cabacSingle.BACEngine.bitstream.size();
    nBitsSingleParam = cabacSingle.ParamBitstream.size();
    
    %Add a flag to the bitstream indicating that the single method will be
    %used.
    cabacSingle = encodeParam(true,cabacSingle);
    
    % TODO!
    % Remove geoCube from the next line!
    cabacSingle = encodeSliceAsSingles(geoCube, enc, currAxis, cabacSingle,iStart,iEnd,Y, sparseM);
    
    
    nBitsSingleAC    = cabacSingle.BACEngine.bitstream.size() - nBitsSingleAC;
    nBitsSingleParam = cabacSingle.ParamBitstream.size() - nBitsSingleParam;
    
    nBitsSingle = nBitsSingleAC + nBitsSingleParam;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Deciding the best option.
if (nBitsDyadic <= nBitsSingle)
    cabac_out = cabacDyadic;
    %disp(['  For interval (' num2str(iStart) ',' num2str(iEnd) ') = OPTION 1 - DYADIC DECOMPOSITION ' num2str(nBitsDyadic) '.'])
else
    cabac_out = cabacSingle;
    %disp(['  For interval (' num2str(iStart) ',' num2str(iEnd) ') = OPTION 2 - ENCODING AS SINGLE ' num2str(nBitsSingle) '.'])
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%