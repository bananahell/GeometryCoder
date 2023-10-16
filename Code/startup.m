%Putting the source folder in the matlab path.
close all;
clear;
clc;

version = 'SPL';
disp(['Initializing Point Cloud Geometry coder version ' version ''])

% Check if this is a Window$ or a Unix machine because paths
% work diffferently
comp = computer();
if isequal(comp, 'PCWIN64')
    barChar = '\';
else
    barChar = '/';
end

% Build folder to add to path.
home = pwd;
src = [home barChar version];
disp(['Adding ' src ' to the Matlab Path'])
addpath(src);

src = [home barChar version barChar 'ArithmeticCoding'];
disp(['Adding ' src ' to the Matlab Path'])
addpath(src);

src = [home barChar version barChar 'Structs'];
disp(['Adding ' src ' to the Matlab Path'])
addpath(src);

src = [home barChar version barChar 'Bitstream'];
disp(['Adding ' src ' to the Matlab Path'])
addpath(src);

src = [home barChar version barChar 'Encoder'];
disp(['Adding ' src ' to the Matlab Path'])
addpath(src);

src = [home barChar version barChar 'Decoder'];
disp(['Adding ' src ' to the Matlab Path'])
addpath(src);

src = [home barChar version barChar 'Utils'];
disp(['Adding ' src ' to the Matlab Path'])
addpath(src);

src = genpath([home barChar version barChar 'PlyTools']);
disp(['Adding ' home barChar version barChar 'PlyTools to the Matlab Path'])
addpath(src);

clear home;
clear src;

% Move workspace to where code is.
cd(version);
