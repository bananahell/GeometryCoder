function params = initParams(cellargin)

if (nargin == 0)
    defaultParameters = 1;
elseif (nargin == 1)
    defaultParameters = 0;
    if (mod(length(cellargin),2) == 1)
        error('Wrong formatting for the input parameters');
    end
end

%--------------------------------------------------------------------------
%First, creates the default settings for the encoder.
%The input/output files are dealt with in the encoderFunction.
params = getEncoderParams();
params.sequence        = '';
params.workspaceFolder = '';
params.dataFolder      = '';
params.pointCloudFile  = '';
params.predictionFile  = '';
params.bitstreamFile   = '';
params.outputPlyFile   = '';
params.matlabFile      = '';
params.testMode        = [1 1];
params.verbose         = 0;
params.JBIGFolder      = '';

params.numberOfSlicesToTestSingleMode = 16;
params.useMEforPrevImageSingle        = 0;

cV = ones(1,24);

%Contexts used for entropy
contextVector2D = cV(1:6);
contextVector3D = cV(7:15);
contextVector4D = cV(16:24);

numberOf2DContexts = sum(contextVector2D);
numberOf3DContexts = sum(contextVector3D);
numberOf4DContexts = sum(contextVector4D);

params.BACParams.numberOfContextsIndependent = numberOf2DContexts;
params.BACParams.numberOfContextsMasked      = numberOf2DContexts;
params.BACParams.windowSizeFor3DContexts     = 1;
params.BACParams.numberOf3DContexts          = numberOf3DContexts;
params.BACParams.windowSizeFor4DContexts     = 1;
params.BACParams.numberOf4DContexts          = numberOf4DContexts;
params.BACParams.numberOfContexts3DOnly      = 6;
params.BACParams.numberOfContextsParams      = 4;
params.BACParams.contextVector2D             = contextVector2D; 
params.BACParams.contextVector3D             = contextVector3D;
params.BACParams.contextVector4D             = contextVector4D;
%--------------------------------------------------------------------------

if (defaultParameters == 0)
    for (k = 1:2:length(cellargin))
        value = cellargin{k+1};
        switch(cellargin{k})
            case 'numberOfSlicesToTestSingleMode'
                checkSizeAndValue('numberOfSlicesToTestSingleMode',value,[1 1],[0 1 2 4 8 16 32 64 128 256 512 1024]);
                params.numberOfSlicesToTestSingleMode = value;
                
        end
    end
else
    disp('Mode: S4D (default)')    
end
disp(' ')

end


function checkSizeAndValue(string,p,s,v)

[sy,sx] = size(p);

if ((sy ~= s(1)) || (sx ~= s(2)))
    error(['Parameter ' string ' must be a ' num2str(s(1)) 'x' num2str(s(2)) ' vector']);
end
for (y = 1:1:sy)
    for(x = 1:1:sx)
        idx = find(p(y,x) == v);
        if (isempty(idx))
            errorstring = ['Error parsing parameters. Possible values for parameter ' string ' are: ['];
            for (k = 1:1:(length(v) - 1))
                errorstring = [errorstring ' ' num2str(v(k)) ','];
            end
            errorstring = [errorstring ' ' num2str(v(end)) ' ].'];
            error(errorstring);
        end        
    end
end

end


