function PccAppRenderer(varargin)
%PCC App Renderer from Technicolor (MPEG)
%   PccAppRenderer() accepts as input parameters either a pointCloud object
%   or geometry (V) and color (C) (RGB uint8). Also some optional inputs can
%   be used in the name-value pair form. Examples:
%
%       PccAppRenderer(ptCloud) - renderers the ptCloud object.
%
%       PccAppRenderer(V, C) - renderers the point cloud from gemoetry V and
%       color C.
%
%       PccAppRenderer(ptCloud, ptCoud_ref) - renderers the ptCloud object
%       and the ptCloud_ref in the same place use 'q' to change views. When
%       using referecence point clouds, both must have the same depth in geometry.
%
%       PccAppRenderer(V, C, ptCoud_ref) - renderers point cloud from V and
%       C the ptCloud_ref object.
%
%       PccAppRenderer(ptCoud, V_ref, C_ref) - renderers the ptCloud object
%       and V_ref and C_ref.
%
%       PccAppRenderer(V, C, V_ref, C_ref) - renderers point cloud from V and
%       C and the reference from V_ref and C_ref.
%
%       PccAppRenderer(V, C, 'size', 0.5) - renderers the point cloud from 
%       gemoetry V and color C with size of voxels = 0.5 (half the distance
%       between two points).
%
%       Accepted options with default value:
%       OPTION                 DEFAULT     DESCRIPTION
%        INPUT FILE OPTIONS
%         'f', 'PlyFile'                   Ply input filename (only used if .PLY file already exists, this way V and C inputs won't be necessary)
%         'SrcFile'                        Source Ply filename (used for comparison, only used if .PLY file already exists)
%         'd', 'PlyDir'                    Ply input directory
%         'SrcDir'                         Source Ply directory (used for comparison only if PlyDir is used)
%         'n', 'FrameNumber'      1        Frame number (only if PlyDir is used)
%         'i', 'FrameIndex'       0        Frame index (only if PlyDir is used)
%         'b', 'binary'           0        Create temp binary files (supposedly faster)
%        CAMERA
%         'o', 'RgbFile'                   Output RGB 8bits filename (specify prefix file name)
%         'x', 'camera'                    Camera path filename (eg. .\camerapath.txt)
%         'y', 'viewpoint'                 Viewpoint filename (eg. .\viewpt.txt)
% 	      'ortho'                 0        Ortho/Perspective rendering
%         'spline'                0        Interpolate the camera path by splines
%         'a','align'             0        Align (0:X, 1:-X, 2:Y, 3:-Y 4:Z, 5:-Z)
%        WINDOW
%         'width'               2^L        Window width (if file is read from dir, default is 800)
%         'height'              2^L        Window height (if file is read from dir, default is 600)
%         'posx'                 -1        Window position X
%         'posy'                 -1        Window position Y
%         'monitor'               0        Monitor to display the window
%         'synchronize'           0        Synchronize multi-windows
%        RENDERER
%         'fps'                  30        Frames per second
%         'size'                  1        Point size
%         'type'                  0        Point type(0: cube, 1: circle, 2: point)
%         'background'            8        Window background index color [0~8]
%         'depthMap'              0        Display depth map (actually it gives a projection mask with no depth information)
%         'p', 'play'             0        Play the sequences
%         'r', 'rotate'           0        Auto-rotate (speed in [0~4])
%         'overlay'               1        Display overlay (aka texts: info and intial log)
%         'box'                 2^L        Bounding box size (if file is read from dir, default is 1024)
%         'dropdups'              2        Drop points with same coordinates (0:No, 1:drop, 2:average) 
%         'c', 'center'           0        Center the object in the bounding box. 
%         's', 'scale'            0        Scale mode  
%                                           0: disable,  
%                                           1: scale according to the object bounding box.  
%                                           2: scale according to the sequence bounding box.

%% check input options
%check system, get build
if isunix
    build = "PccAppRenderer";
elseif ispc
    build = "PccAppRenderer.exe";
else
   error('Platform not supported.')
end

path = mfilename('fullpath');
build = strrep(path,'PccAppRenderer',build);


allowedOptions = ["f","PlyFile","SrcFile", "d", "PlyDir","SrcDir", "n", "i", ...
                  "b", "o", "RgbFile","x", "camera", "y", "viewpoint", "ortho", ...
                  "spline", "a", "align", "width", "height", "pox", "posy", ...
                  "monitor", "synchronize", "fps", "size", "type", "background", ...
                  "depthMap", "p", "play", "r", "rotate", "overlay", "box", ...
                  "dropdups", "c", "center", "s", "scale"];
inputOptions = {varargin{cellfun(@(x) ischar(x), varargin)}};

% allowedStrOptions = ["f","PlyFile","SrcFile", "d", "PlyDir","SrcDir",...
%                      "o", "RgbFile","x", "camera", "y", "viewpoint"];
%                  
% allowedNumOptions = ["n", "i", "b", "ortho","spline", "a", "align", "width",...
%                      "height", "pox", "posy", "monitor", "synchronize", "fps",...
%                      "size", "type", "background", "depthMap", "p", "play",...
%                      "r", "rotate", "overlay", "box", "dropdups", "c", "center",...
%                      "s", "scale"];
%               
% allowedOptions = [allowedStrOptions, allowedNumOptions];

[b_opt,~] = cellfun(@(x) ismember(x,allowedOptions), inputOptions);
opt = 2*sum(b_opt);
% TODO: input verification?
% if ~all(b_opt)
%     e_idx = find(~idx)-1;
%     possiblyWrong = allowedOptions(idx(e_idx));
%     if ~all(ismember(possiblyWrong,allowedStrOptions))
%         wrongOptions = possiblyWrong;
%     error("Option input " + sprintf('''%s'' ', inputOptions{wrongOptions}) + "not allowed, check function documentation. Allowed options are:  " + sprintf('''%s'' ', allowedOptions) + "." );
%     end
% end



%default values empty means the default from PccAppRenderer is used
%input options
PlyFile      = '';
SrcFile      = '';
PlyDir       = '';
SrcDir       = '';
FrameNumber  = '';
FrameIndex   = '';
binary       = '';
%camera options
RgbFile      ='';
camera       ='';
viewpt       ='';
ortho        ='';
spline_path  ='';
align        ='';
%window options
width       = '';
height      = '';
posx        = '';
posy        = '';
monitor     = '';
synchronize = '';
%renderer options
fps         = '';
point_size  = '';
point_type  = '';
background  = " --background=8";
depthMap    = '';
play        = '';
rotate      = '';
overlay     = '';
boxsize     = '';
dropdups    = '';
center      = '';
scale       = '';


%% check input point clouds
ref = false;
FileFromDir = false;
check = nargin - opt;

% INPUT FILE OPTIONS
%  'f', 'PlyFile'                   Ply input filename
%  'SrcFile'                        Source Ply filename
%  'd', 'PlyDir'                    Ply input directory
%  'SrcDir'                         Source Ply directory (used for comparison only if PlyDir is used)
%  'n' ,'FrameNumber'      1        Frame number (only if PlyDir is used)
%  'i' ,'FrameIndex'       0        Frame index (only if PlyDir is used)
%  'b', 'binary'           0        Create temp binary files (supposedly faster)

if any(strcmp(varargin,'f')) || any(strcmp(varargin,'PlyFile'))
    PlyFile = varargin{find( strcmp(varargin,'f') | strcmp(varargin,'PlyFile') ) +1};
    PlyFile = " -f " + PlyFile;
    FileFromDir = true;
    check = -1;    
    if any(strcmp(varargin,'SrcFile'))
        SrcFile = varargin{find( strcmp(varargin,'SrcFile') ) +1};
        SrcFile = " --SrcFile=" + SrcFile;
    end
end

if any(strcmp(varargin,'d')) || any(strcmp(varargin,'PlyDir'))
    PlyDir = varargin{find( strcmp(varargin,'d') | strcmp(varargin,'PlyDir') ) +1};
    PlyDir = " -d " + PlyDir;
    FileFromDir = true;
    check = -1;    
    if any(strcmp(varargin,'SrcDir'))
        SrcDir = varargin{find( strcmp(varargin,'SrcDir') ) +1};
        SrcDir = " --SrcDir=" + SrcDir;
    end   
    if any(strcmp(varargin,'n')) || any(strcmp(varargin,'FrameNumber'))
        FrameNumber = varargin{find( strcmp(varargin,'n') | strcmp(varargin,'FrameNumber') ) + 1};
        FrameNumber = " -n " + num2str(FrameNumber);
    end
    if any(strcmp(varargin,'i')) || any(strcmp(varargin,'FrameIndex'))
        FrameIndex = varargin{find( strcmp(varargin,'i') | strcmp(varargin,'FrameIndex') ) + 1};
        FrameIndex = " -i " + num2str(FrameIndex);
    end
end

if any(strcmp(varargin,'b')) || any(strcmp(varargin,'binary'))
    binary = varargin{find(strcmp(varargin,'b') | strcmp(varargin,'FrameNumber') )+1};
    binary = " -b " + num2str(binary);
end

switch check
    case 1      
        if isa(varargin{1},'pointCloud')
            ptCloud = varargin{1};
        else
            V = varargin{1};
            ptCloud = pointCloud(V);
        end       
    case 2        
        if isa(varargin{1},'pointCloud') && isa(varargin{2},'pointCloud')
            ptCloud     = varargin{1};
            ptCloud_ref = varargin{2};
            ref = true;
        elseif ismatrix(varargin{1}) && ismatrix(varargin{2}) && isequal(size(varargin{1}),size(varargin{2}))
            V = varargin{1};
            C = uint8(varargin{2});
            ptCloud = pointCloud(V,'Color',C);
        end
    case 3 %ptcloud,Vrec,Cref ou V,C,ptcloud_ref
         if isa(varargin{1},'pointCloud')
            ptCloud     = varargin{1};
            Vref = varargin{2};
            Cref = uint8(varargin{3});
            ptCloud_ref = pointCloud(Vref,'Color',Cref);
            ref = true;
         else
            V = varargin{1};
            C = uint8(varargin{2});
            ptCloud = pointCloud(V,'Color',C);
            ptCloud_ref = varargin{3};
            ref = true;
         end
    case 4
        V = varargin{1};
        C = uint8(varargin{2});
        ptCloud = pointCloud(V,'Color',C);
        Vref = varargin{3};
        Cref = uint8(varargin{4});
        ptCloud_ref = pointCloud(Vref,'Color',Cref);
        ref = true;
end

if ~FileFromDir
    L = nextpow2(max(max(ptCloud.Location)));
    pcwrite(ptCloud,'PCtoBeRendered.ply');
    PlyFile = " -f PCtoBeRendered.ply";
    if ref
        pcwrite(ptCloud_ref,'PCtoBeRendered_ref.ply');
        SrcFile = " --SrcFile=PCtoBeRendered_ref.ply";
    end
end

FileOptions = strcat(PlyFile, SrcFile, PlyDir , SrcDir , FrameNumber , FrameIndex, binary);
%% Parse options
% CAMERA
%  'o', 'RgbFile'                   Output RGB 8bits filename (specify prefix file name)
%  'x', 'camera'                    Camera path filename (eg. .\camerapath.txt)
%  'y', 'viewpoint'                 Viewpoint filename (eg. .\viewpt.txt)
%  'ortho'                 0        Ortho/Perspective rendering
%  'spline'                0        Interpolate the camera path by splines
%  'a','align'             0        Align (0:X, 1:-X, 2:Y, 3:-Y 4:Z, 5:-Z)
if any(strcmp(varargin,'o')) || any(strcmp(varargin,'RgbFile'))
    RgbFile = varargin{find( strcmp(varargin,'o') | strcmp(varargin,'RgbFile') ) +1};
    RgbFile = " -o " + RgbFile;
end

if any(strcmp(varargin,'x')) || any(strcmp(varargin,'camera'))
    camera = varargin{find( strcmp(varargin,'x') | strcmp(varargin,'camera') ) +1};
    camera = " -x " + camera;
end

if any(strcmp(varargin,'y')) || any(strcmp(varargin,'viewpoint'))
    viewpt = varargin{find( strcmp(varargin,'y') | strcmp(varargin,'viewpoint') ) +1};
    viewpt = " -y " + viewpt;
end

if any(strcmp(varargin,'ortho'))
    ortho = varargin{find(strcmp(varargin,'ortho'))+1};
    ortho = " --ortho=" + num2str(ortho);
end

if any(strcmp(varargin,'spline'))
    spline_path = varargin{find(strcmp(varargin,'spline'))+1};
    spline_path = " --spline=" + num2str(spline_path);
end

if any(strcmp(varargin,'a')) || any(strcmp(varargin,'align'))
    align = varargin{find( strcmp(varargin,'a') | strcmp(varargin,'align') ) +1};
    align = " -a " + num2str(align);
end

cam_options = strcat(RgbFile , camera , viewpt , ortho , spline_path , align);

% WINDOW
%  'width'               2^L        Window width
%  'height'              2^L        Window height
%  'posx'                 -1        Window position X
%  'posy'                 -1        Window position Y
%  'monitor'               0        Monitor to display the window
%  'synchronize'           0        Synchronize multi-windows
if any(strcmp(varargin,'width'))
    width = varargin{find(strcmp(varargin,'width'))+1};
    width = " --width=" + num2str(width);
elseif ~FileFromDir
    width = " --width=" + num2str(2^L);
end

if any(strcmp(varargin,'height'))
    height = varargin{find(strcmp(varargin,'height'))+1};
    height = " --height=" + num2str(height);
elseif ~FileFromDir
    height = " --height=" + num2str(2^L);
end

if any(strcmp(varargin,'posx'))
    posx = varargin{find(strcmp(varargin,'posx'))+1};
    posx = " --posx=" + num2str(posx);
end

if any(strcmp(varargin,'posy'))
    posy = varargin{find(strcmp(varargin,'posy'))+1};
    posy = " --posy=" + num2str(posy);
end

if any(strcmp(varargin,'monitor'))
    monitor = varargin{find(strcmp(varargin,'monitor'))+1};
    monitor = " --monitor=" + num2str(monitor);
end

if any(strcmp(varargin,'synchronize'))
    synchronize = varargin{find(strcmp(varargin,'synchronize'))+1};
    synchronize = " --synchronize=" + num2str(synchronize);
end

window_options = strcat(width , height , posx , posy , monitor , synchronize);

% RENDERER
%  'fps'                  30        Frames per second
%  'size'                  1        Point size
%  'type'                  0        Point type(0: cube, 1: circle, 2: point)
%  'background'            8        Window background index color [0~8]
%  'depthMap'              0        Display depth map
%  'p', 'play'             0        Play the sequences
%  'r', 'rotate'           0        Auto-rotate (speed in [0~4])
%  'overlay'               1        Display overlay (aka texts: info and intial log)
%  'box'                 2^L        Bounding box size
%  'dropdups'              2        Drop points with same coordinates (0:No, 1:drop, 2:average)
%  'c', 'center'           0        Center the object in the bounding box.
%  's', 'scale'            0        Scale mode
if any(strcmp(varargin,'fps'))
    fps = varargin{find(strcmp(varargin,'fps'))+1};
    fps = " --fps=" + num2str(fps);    
end

if any(strcmp(varargin,'size'))
    point_size = varargin{find(strcmp(varargin,'size'))+1};
    point_size = " --size=" + num2str(point_size);
end

if any(strcmp(varargin,'type'))
    point_type = varargin{find(strcmp(varargin,'type'))+1};
    point_type = " --type=" + num2str(point_type);
end

if any(strcmp(varargin,'background'))
    background = varargin{find(strcmp(varargin,'background'))+1};
    background = " --background=" + num2str(background);    
end

if any(strcmp(varargin,'depthMap'))
    depthMap = varargin{find(strcmp(varargin,'depthMap'))+1};
    depthMap = " --depthMap=" + num2str(depthMap);
end

if any(strcmp(varargin,'p')) || any(strcmp(varargin,'play'))
    play = varargin{find( strcmp(varargin,'p') | strcmp(varargin,'play') ) +1};
    play = " --play=" + num2str(play);
end

if any(strcmp(varargin,'r')) || any(strcmp(varargin,'rotate'))
    rotate = varargin{find( strcmp(varargin,'r') | strcmp(varargin,'rotate') ) +1};
    rotate = " --rotate=" + num2str(rotate);    
end

if any(strcmp(varargin,'overlay'))
    overlay = varargin{find(strcmp(varargin,'overlay'))+1};
    overlay = " --overlay=" + num2str(overlay);
end

if any(strcmp(varargin,'box'))
    boxsize = varargin{find(strcmp(varargin,'box'))+1};
    boxsize = " --box=" + num2str(boxsize);    
elseif ~FileFromDir
    boxsize = " --box=" + num2str(2^L);
end  

if any(strcmp(varargin,'dropdups'))
    dropdups = varargin{find(strcmp(varargin,'dropdups'))+1};
    dropdups = " --dropdups=" + num2str(dropdups); 
end
    
if any(strcmp(varargin,'c')) || any(strcmp(varargin,'center'))
    center = varargin{find( strcmp(varargin,'c') | strcmp(varargin,'center') ) +1};
    center = " --center=" + num2str(center); 
end

if any(strcmp(varargin,'s')) || any(strcmp(varargin,'scale'))
    scale = varargin{find( strcmp(varargin,'s') | strcmp(varargin,'scale') ) +1};
    scale = " --scale=" + num2str(scale); 
end

renderer_options = strcat(fps , point_size , point_type , background , depthMap , ...
    play , rotate , overlay , boxsize , dropdups , center , scale);

%% save and render
cmd = strcat(build, FileOptions, cam_options, window_options, renderer_options, ' > NUL'); %< /dev/null for linux?

system(cmd);

if ~FileFromDir
    delete PCtoBeRendered.ply
    if ref
        delete PCtoBeRendered_ref.ply
    end
end
end