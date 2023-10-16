% Lossy Modifier Checker
%
% Gets the error data (mse and psnr) from different manipulation situations done
%     in a slice of a point cloud
%
% pcSlices - matrices list from the pc (silhouetteFromCloud())
%
% originalPointList - original point list used to compare (expandPointCloud())
%
% currAxis - current axis
%
% mode - manipulation mode:
%     addNothing - turn the slice into zeros
%     addParentOnce - turn the slice into its parent
%     addParentTwice - turn neighbor slices into their parent (effectively only
%         using the parent then)
%
% Returns the error struct, containing data like the mse and psnr.
%

function result = lossyModifierChecker(pcSlices, origPointList, origPc, currAxis, slice, mode)

    addNothing = 'add_nothing';
    addParentOnce = 'add_parent_once';
    addParentTwice = 'add_parent_twice';

    % Define the limits (magic numbers from Peixoto)
    boundlimits = [0 1 3 7 15 31 63 127 255 511 1023 2047 4095];
    bound = max([max(origPc.XLimits) max(origPc.YLimits) max(origPc.ZLimits)]);
    limit = boundlimits(bound <= boundlimits);
    pcLimit = limit(1);

    if (strcmp(mode, addNothing))
        reconstructedPC = [];
        % Always remakes the whole pc (costy!)
        for i = 1:1:512
            if (slice ~= i)
                reconstructedPC = expandPointCloud(pcSlices{i}, reconstructedPC, currAxis, i);
            end
        end
        % Returns the point_metrics data
        result = point_metrics(origPointList, reconstructedPC);
    elseif (strcmp(mode, addParentOnce))
        reconstructedPC = [];
        % Always remakes the whole pc (costy!)
        for i = 1:1:512
            % Let all slices pass but the one we want
            if (slice ~= i)
                reconstructedPC = expandPointCloud(pcSlices{i}, reconstructedPC, currAxis, i);
            else
                % Slice we actually want to check
                if (mod(slice,2) == 0)
                    % Even slice, so expand previous and current into them,
                    % which means effectively expanding the parent into them
                    reconstructedPC = expandPointCloud(pcSlices{i-1}, reconstructedPC, currAxis, i);
                    reconstructedPC = expandPointCloud(pcSlices{i}, reconstructedPC, currAxis, i);
                else
                    % Odd slice, so expand next and current into them,
                    % which means effectively expanding the parent into them
                    reconstructedPC = expandPointCloud(pcSlices{i}, reconstructedPC, currAxis, i);
                    reconstructedPC = expandPointCloud(pcSlices{i+1}, reconstructedPC, currAxis, i);
                end
            end
        end
        result = point_metrics(origPointList, reconstructedPC);
    elseif (strcmp(mode, addParentTwice))
        reconstructedPC = [];
        % Always remakes the whole pc (costy!)
        for i = 1:1:512
            % Checking for even and odd slices. This in theory helps with
            % performance...
            if (mod(slice,2) == 0)
                % Let all slices pass but the one we want
                if (slice ~= i && slice ~= i-1)
                    reconstructedPC = expandPointCloud(pcSlices{i}, reconstructedPC, currAxis, i);
                else
                    % Even slice, so previous and current need previous and
                    % current
                    if (slice == i)
                        reconstructedPC = expandPointCloud(pcSlices{i}, reconstructedPC, currAxis, i);
                        reconstructedPC = expandPointCloud(pcSlices{i-1}, reconstructedPC, currAxis, i);
                        reconstructedPC = expandPointCloud(pcSlices{i}, reconstructedPC, currAxis, i-1);
                        reconstructedPC = expandPointCloud(pcSlices{i-1}, reconstructedPC, currAxis, i-1);
                    end
                end
            else
                % Let all slices pass but the one we want
                if (slice ~= i && slice ~= i+1)
                    reconstructedPC = expandPointCloud(pcSlices{i}, reconstructedPC, currAxis, i);
                else
                    % Odd slice, so next and current need next and current
                    if (slice == i)
                        reconstructedPC = expandPointCloud(pcSlices{i}, reconstructedPC, currAxis, i);
                        reconstructedPC = expandPointCloud(pcSlices{i+1}, reconstructedPC, currAxis, i);
                        reconstructedPC = expandPointCloud(pcSlices{i}, reconstructedPC, currAxis, i+1);
                        reconstructedPC = expandPointCloud(pcSlices{i+1}, reconstructedPC, currAxis, i+1);
                    end
                end
            end
        end
        result = point_metrics(origPointList, reconstructedPC);
    end

end
