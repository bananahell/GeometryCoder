function [interpMask] = improved_morph_binary(Img1,Img2,n, mask)
    [sx, sy] = size(Img1);
    if(sx > 512)
        se = strel('disk',5);
    else
        se = strel('disk',3);
    end
    
    interpMask = zeros(sx, sy, n+2);
    interpMask(:,:,1) = Img1;
    interpMask(:,:,size(interpMask,3)) = Img2;
    
    bestPos = [0 0];
    bestCost = Inf;
    
    for i = -3:1:3
        for j = -3:1:3
            New_Img1 = imtranslate(Img1, [i j]);
            diff = xor(New_Img1, Img2);
            cost = sum(diff(:));
            
            if (cost < bestCost)
                bestPos = [i j];
                bestCost = cost;
            end
        end
    end
    
    for i = 1:n
        interpMask(:,:,i+1) = imtranslate(Img1, (i/(n+1))*bestPos);
        interpMask(:,:,i+1) = imclose(interpMask(:,:,i+1), se);
        interpMask(:,:,i+1) = bwmorph(interpMask(:,:,i+1), 'bridge');
        interpMask(:,:,i+1) = and(interpMask(:,:,i+1), mask);
    end
    
    

end