% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function contextNumber = getContextFromImage(A,pixel, w, numberOfContexts)

if (nargin == 3)
    numberOfContexts = 9;
end

if (numberOfContexts == 9)
    %This is because image A has been padded with 1 pixel of border.
    py = pixel(1) + w;
    px = pixel(2) + w;
    
    contextNumber = 1;
    contextNumber = contextNumber + 256 * A(py-1,px-1);
    contextNumber = contextNumber + 128 * A(py-1,px  );
    contextNumber = contextNumber +  64 * A(py-1,px+1);
    contextNumber = contextNumber +  32 * A(py  ,px-1);
    contextNumber = contextNumber +  16 * A(py  ,px  );
    contextNumber = contextNumber +   8 * A(py  ,px+1);
    contextNumber = contextNumber +   4 * A(py+1,px-1);
    contextNumber = contextNumber +   2 * A(py+1,px  );
    contextNumber = contextNumber +       A(py+1,px+1);
elseif (numberOfContexts == 1)
    contextNumber = double(1 + A(pixel(1),pixel(2)));    
elseif (numberOfContexts == 2)
    py = pixel(1) + w;
    px = pixel(2) + w;
    
    contextNumber = 1 + 2 * A(py,px);
    
    temp = [A(py-1,px-1) A(py-1,px) A(py-1,px+1) A(py,px-1) A(py,px+1) A(py+1,px-1) A(py+1,px) A(py+1,px+1)];
    if (sum(temp) > 0)
        contextNumber = contextNumber + 1;
    end
    
end
