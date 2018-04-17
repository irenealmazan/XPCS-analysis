
%%% this one is sample template - however, sometimes there are tweaks 
%%% that don't get into here
%%% EDIT THIS FILE - BUT RUN >> datainput_AREA
%%% ONLY ONE SCAN AT A TIME IS ALLOWED
%%% There may be some things that you want to edit in datainput_AREA
%%%		but it is designed that you shouldn't normally do that
LOGFLAG = 1;   % 1 for log, 0 for lin need to change CLIM to match if using it

DOCU0			= 'sput_ZnO_dec1617a (11-28-2017_1 '''Zn'''pol) (+c)';  % <<< change rarely

%%% ONLY ONE SCAN AT A TIME %%%%%
%% detector on diffractometer arm (X is del and Y is nu)
specfilename	= ['2017_1207_1'];SCNstr = '[7]';DOCUscan = ['FlatField'];%CLIM = [0 10]; 

WhatToDo = [0];
%WhatToDo =  [0 1];%% to get the stuff to figure out rois the ROIS						% [0 2 4 5 6]  to plot the ROIs as funtion of 
WhatToDo = [0 2 5];
%WhatToDo = [0 2 4 5 6];%2 4 5 6];%0 1 2 5 6 ];   % can be vector, order is fixed to when in program
WhatToDo = [3];  %% movie


Xstepcol=[1];	% Xstepcol empty, uses first column in SPEC datafile as scan variable
%Xstepcol=0;	% Xstepcol = 0 uses SPEC points 
				% Xstepcol = 1 2 3, etc (use other column, e.g., 'L')
				
MOVIEROIFLAG = 0;  % [1] use ROI#1 to frame movie, [0] use AXISdet (if defined) or whole image'
				
%CLIM = ([0 3.5]);	

%%% SPEC POINT CONVENTION HERE  %%%%%%%%%%%
SINGLE 		= 15;	%% required for [0,1,2] it is the frame that is shown

%% if you desire to have the 'summed' plots only over a particular set of points
%POINTSUMS = [0 10;SINGLE-5 SINGLE+5]; % scan 22
POINTSUMS=[];

					%% optional for  [4 5 6 8]
					%% POINTSUMS are [i1 j1;i2 j2;...] where each row are


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
%WhatToDo = [0 1 ];%2 4 5 6];%0 1 2 5 6 ];   % can be vector, order is fixed to when in program



%ASPECTflag=1;ASPECT = round([1./sind(2.4) 1 1]); % use a forshortening based on q
%ASPECTflag=1;ASPECT = round([1 1./sind(2.4) 1]); % use a forshortening based on q back wall
%			 to calculate on specular type rods, use 1./sind(2theta/2) on the X or Y that is delta 
%%%%%%%  ROIS and AXISdet (using ImageJ (SPEC) pixel conventions  %%%%%
%%%%  that is, start from [0,0] indexing
%%%% Medipix [516x516 pixels] 0 515 1 515   or [1 516 1 516]-1   
%%%% Pilatus 0 486 0 194   or [1 487 1 195]-1
AXISdet = [1 487 1 195]-1;   % to put it into spec like
%AXISdet = [1 270 200 516]-1;

SoXFLAG = 1;
SoYFLAG = 1;

% These are the normal plots
%#CR ROI  1: MinX=   1  SizeX= 487 MinY=   1  SizeY= 195
%#CR ROI  2: MinX= 151  SizeX=   4 MinY= 121  SizeY=   8
%#CR ROI  3: MinX= 131  SizeX=  44 MinY= 113  SizeY=  24
%#CR ROI  4: MinX= 111  SizeX=  84 MinY=  81  SizeY=  88

if 0  %% 
ROIS = [...
185  185+7	340 340+7
176  176+25	331 331+25
163	 163+51	318 318+51
138	 138+101 293 293+101
];
end

