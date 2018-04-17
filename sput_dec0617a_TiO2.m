%%% %%% EDIT THIS FILE - BUT RUN >> datainput_AREA(filename)
%%% where filename is string variable with name of this file, e.g., 'sput_dec1617a.m'
%%% ONLY ONE SCAN AT A TIME IS ALLOWED FOR 
%%%
%%% it is also possible to just plot the 'spec' file data using information in this filee
%%%			run >> datainput_run(filename)
%%%		   (more than one scan OK for using  with >> datainput_run which just plots spec files
%%%
%%% 2017_12 run CT I have taken even more standard options and hardwired 
%%%		into the datainput_AREA function, since for the most part they are
%%%		much less likely to be changed much for the caxis ZnO run


%%% These following options are left in as it is more possible that
%%% 	a typical user might want to change them occasionally

%%  These options are set and used during >> datainput_run(filename) 
FORCE.det = char('p_point');   % mostly 
FORCE.det = char('Filters');
FORCE.FLAG=0;   % = 0 plot versus the first DATA column in the spec file

%%  These options about what to use as the 'x' variable of a plot version scan point
%%		are used in datainput_run and for some options in datainput_AREA 
%FORCE.FLAG=1   % = 1 plot versus a different column (then specify that column name with FORCE.X 
%FORCE.X='L';  %%% for example, note 'specpoint' is also an option instead of a real data column
				% There can be errors if column name is duplicated (as sometimes
				% happens with the monitor or detector names in spec
				
%%	These options are set and used during >> datainput_AREA(filename)		
LOGFLAG = 1;   	% 1 for log, 0 for lin need to change CLIM to match it
N_ROIS_SUM = [1 ];% [1 2 3];   % which ROI to sum over Y X to plot images as function of scan

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% The Following are 'per sample' and where most of the edits occur %%%%%%%
%%%%%%%%     To change ROIS - go to bottom of this file  %%%%%%%%%%%%%%%%%%%%%%%%


DOCU0 = 'sput_TiO2_dec1517b (11-28-2017_1 TiO2 110)';  % <<< change rarely

% temperature series

switch  Temp
    case 300
        specfilename	= ['2017_1216_1'];SCNstr = '[89]';DOCUscan = ['300C/30%O70%Ar/15mTorr/40W'];SINGLE=89;CLIM = [0 5];
        
    case 400
        specfilename	= ['2017_1216_1'];SCNstr = '[85]';DOCUscan = ['400C/30%O70%Ar/15mTorr/40W'];SINGLE=89;CLIM = [0 5];
        
    case 450
        specfilename	= ['2017_1217_1'];SCNstr = '[162]';DOCUscan = ['450C/30%O70%Ar/15mTorr/40W'];SINGLE=89;CLIM = [0 5];
        
    case 500
        specfilename	= ['2017_1216_1'];SCNstr = '[77]';DOCUscan = ['500C/30%O70%Ar/15mTorr/40W'];SINGLE=556;CLIM = [0 5];
        
    %case 550
     %   specfilename	= ['2017_1216_1'];SCNstr = '[170]';DOCUscan = ['550C/30%O70%Ar/15mTorr/40W'];SINGLE=556;CLIM = [0 5];
        
    case 600
        specfilename	= ['2017_1217_1'];SCNstr = '[9]';DOCUscan = ['600C/30%O70%Ar/15mTorr/40W'];SINGLE=556;CLIM = [0 5];
        
    case 650
        specfilename	= ['2017_1217_1'];SCNstr = '[176]';DOCUscan = ['650C/30%O70%Ar/15mTorr/40W'];SINGLE=125;CLIM = [0 5];
        
    case 700
        specfilename	= ['2017_1217_1'];SCNstr = '[183]';DOCUscan = ['700C/30%O70%Ar/15mTorr/40W'];SINGLE=110;CLIM = [0 5];
        
    otherwise
       display('What is the temperature?')
end
        





% Massive set of growths
if 0
	specfilenameall = char([...
			ones(4,1)*'2017_1206_2';
			ones(4,1).*'2017_1207_1';
			ones(6,1)*'2017_1208_1';
			ones(2,1)*'2017_1209_1';
			ones(2,1)*'2017_1209_2';
			]);
	SCNstr = '[8 16 20 29 6 14 19 29 113 121 126 133 141 148 5 14 14]';
		DOCUscan = ['Multiple parameters'];
		
		specfilename = specfilenameall(1:5,:);SCNstr = '[8 16 20 29 6]';
		specfilename = specfilenameall(5:10,:);SCNstr = '[6 14 19 29 113 121]';
		specfilename = specfilenameall(10:end,:);SCNstr = '[121 126 133 141 148 5 14]';
		specfilename = specfilenameall(end,:);SCNstr = '[14]';
end
%specfilename = '2017_1210_3';SCNstr='[96 97]';

%WhatToDo = [5];  %%% simply plot the image associated with the SINGLE point
%WhatToDo = [0 1];%% Plot the image associated with SINGLE point and graphics input ROI choices
%%%%		note [0 2] are required for asking for 4, 5, or 6 options
%%%%		4, 5, and 6 can be added singly or in any combination
%WhatToDo = [0 2 5]; %%% (5) To plot the ROIS as counters 
%WhatToDo = [0 2 4 ];%%% (4) To plot the ROI slices (summed over X or Y of detector) as function of 'x' of scan
%%%			note, to change 'x' of scan, see information about FORCE.FLAG=1 and FORCE.X above 
%WhatToDo = [0 2 6 ]; %%% (6) To plot a single image, but summed over over all points in scan 
%%%			note - or a selection of points in scan, but that requires setting POINTSUMS (see datainput_AREA)
%WhatToDo = [0 2 4 5];	%%% it is possible to choose any combination of 4, 5, and 6
%WhatToDo = [0 2 4 5 6]; %%% it is possible to choose any combination of 4, 5, and 6
%%
%WhatToDo = [3];  %% movie; (do not ask for other options with movie)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		

%%% To use defaults, use below	
if 0	   %%% if 1  (to start with defaults)		
 CLIM=[];POINTSUMS=[];SINGLE=0;   
end



%% How to use 'WhatToDo'  (need to use as the following combinations)
%%			you can usually add more, but you cannot add less
%   [ 0]    just to see the image
%	[0 1]   (to figure out ROIS from single image) (put desired ones in ROIS)
%				Note that 1st row is used in [4] (sum over Delta) to see diffuse) 
%	[0 2] 	(to see those ROIS on a sample image)
%   [0 2 4]  adds 1st ROI summed over one direction (delta) to highlight diffuse
%	[0 2 4 5]  or [0 2 5] adds line plot of ROI vs scanpoint (like counters)
%	[6]		image plots (each plot summed over the POINTSUMS given)
%	[3] 	makes movie (saves as file M1.avi which you can play over or rename)
%   [8]		historgram/speckle (NOT WORKING WITH UP TO DATE PROGRAMS

% [0 1] to get the stuff to do the ROIS
% [0 2 5]  to plot the ROIs as funtion of 
WhatToDo = [0 2 4 5 ];%2 4 5 6];%0 1 2 5 6 ];   % can be vector, order is fixed to when in program



%AXISdet = [1 487 1 195]-1;   % show full detector Pilatus
XCEN = 153;YCEN = 125;  % Where to put center of ROIS  2017_1207 #14, 29
AXISdet = [XCEN+[-110 50] YCEN+[-60 60]];


if 1   %sput_ZnO_dec1617a good for growths in 2017_1207_1 (from 350C growth checking)
ROIS = [...
XCEN+[-153 60] YCEN+[-5 5]   % Long slice along L for nice sumover Y
XCEN+[-45 -15] YCEN+[-3 3]  % DIF along L
XCEN+[15 45] YCEN+[-3 3]    %DIF along L
XCEN+[-15 15] YCEN+[-20 -5]		%DIF along HK
XCEN+[-15 15] YCEN+[+5 +20]	%DIF along HK
XCEN+[-2 2] YCEN+[-4 4]	%original p_point
];
end



% [0] Just plot one SINGLE (spec point) image (Iwin) background subtracted and norm
% [1] Use as [0 1] to figure out ROIs to apply to image
% [2] Use as [0 2] to show the ROIS that are applied (ROIS below)
% [3] Make movie of Iwin (normed and log if chosen in flags sometimes you just
%			have to keep trying (close all figures) a few times to not get
%			the size error, it is inconsistent.
% [4] Use as [0 2 4] Image and line plots - Image summed over X and over Y  and 
%			also summed over the POINTSUMS if not empty)
% [5] Use as [0 2 5] ROIS (summed as counters, lines) VS Scan variable
% [6] Plots a 'single' image, but summed over %% POINTSUMS 
%		 It will make a new  figure for each POINTSUMS range
