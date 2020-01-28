function params = initParams(cellargin)

if (nargin == 0)
    defaultParameters = 1;
elseif (nargin == 1)
    defaultParameters = 0;
    if (mod(length(cellargin),2) == 1)
        error('Wrong foramatting for the input parameters');
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
params.test3DOnlyContextsForInter     = 0;
params.fastChoice3Dvs4D               = 0;
params.use4DContextsOnSingle          = 1;
params.useMEforPrevImageSingle        = 0;

params.BACParams.numberOfContextsIndependent = 3;
params.BACParams.numberOfContextsMasked      = 3;
params.BACParams.windowSizeFor3DContexts     = 1;
params.BACParams.numberOf3DContexts          = 9;
params.BACParams.windowSizeFor4DContexts     = 0;
params.BACParams.numberOf4DContexts          = 1;
params.BACParams.numberOfContexts3DOnly      = 5;
params.BACParams.numberOfContextsParams      = 4;
%--------------------------------------------------------------------------

if (defaultParameters == 0)
    for (k = 1:2:length(cellargin))
        value = cellargin{k+1};
        switch(cellargin{k})
            case 'testMode'
                checkSizeAndValue('testMode',value,[1 2],[0 1]);
                params.testMode = value;
                if (sum(value) < 1)
                    error('Error parsing parameter testMode. At least one mode should be tested.')
                end
                
            case 'verbose'
                checkSizeAndValue('verbose',value,[1 1],[0 1]);
                params.verbose = value;
                
            case 'numberOfSlicesToTestSingleMode'
                checkSizeAndValue('numberOfSlicesToTestSingleMode',value,[1 1],[0 1 2 4 8 16 32 64 128 256 512 1024]);
                params.numberOfSlicesToTestSingleMode = value;
                
            case 'test3DOnlyContextsForInter'
                checkSizeAndValue('test3DOnlyContextsForInter',value,[1 1],[0 1]);
                params.test3DOnlyContextsForInter = value;
                
            case 'fastChoice3Dvs4D'
                checkSizeAndValue('fastChoice3Dvs4D',value,[1 1],[0 1]);
                params.fastChoice3Dvs4D = value;
                
            case 'use4DContextsOnSingle'
                checkSizeAndValue('use4DContextsOnSingle',value,[1 1],[0 1]);
                params.use4DContextsOnSingle = value;
                
            case 'useMEforPrevImageSingle'
                checkSizeAndValue('useMEforPrevImageSingle',value,[1 1],[0 1]);
                params.useMEforPrevImageSingle = value;
                
            case 'numberOfContextsIndependent'
                checkSizeAndValue('numberOfContextsIndependent',value,[1 1],[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16]);
                params.BACParams.numberOfContextsIndependent = value;
                
            case 'numberOfContextsMasked'
                checkSizeAndValue('numberOfContextsMasked',value,[1 1],[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16]);
                params.BACParams.numberOfContextsMasked = value;
                
            case 'numberOf3DContexts'
                checkSizeAndValue('numberOf3DContexts',value,[1 1],[1 9]);
                params.BACParams.numberOf3DContexts = value;
                if (value == 1)
                    params.BACParams.windowSizeFor3DContexts     = 0;
                else
                    params.BACParams.windowSizeFor3DContexts     = 1;
                end
                
            case 'numberOf4DContexts'
                checkSizeAndValue('numberOf4DContexts',value,[1 1],[1 2 9]);
                params.BACParams.numberOf4DContexts = value;
                if (value == 1)
                    params.BACParams.windowSizeFor4DContexts     = 0;
                else
                    params.BACParams.windowSizeFor4DContexts     = 1;
                end
                
            case 'numberOfContexts3DOnly'
                checkSizeAndValue('numberOfContexts3DOnly',value,[1 1],[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16]);
                params.BACParams.numberOfContexts3DOnly = value;
                
            case 'numberOfContextsParams'
                checkSizeAndValue('numberOfContextsParams',value,[1 1],[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16]);
                params.BACParams.numberOfContextsParams = value;
                
        end
    end
    
end

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


