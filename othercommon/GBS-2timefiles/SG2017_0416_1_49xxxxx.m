% Analysis of April 2017 m-plane LBL data
% Created from datainput_MPX3.m, leaving out unneeded parts
% and making a single script
% Use new flatfield with bad pixels from flatfield_analysis_MPX3
% 29APR17 GBS
% 3May17  GJU
% 20MAY17 GBS uses SG smoothing
% 23JUN17 GBS added integer and half-integer C integration
% 27JUN17 GBS added loop to calc C as f(Q)
% xxx 27JUN17 GBS GJU change regions for integer and half-integer
% xxxx 30JUN17 GBS GJU added fit of ttc results (decay analysis)
% xxxxx 13JUL17 GBS GJU changed use of ttroiin, ttrouout, added loglog plot
% of half-integer time constant


startup
LOGFLAG = 1;   % 1 for log, 0 for lin need to change CLIM to match if using it

% First set parameters that change in analysis (filename, ROIS, POINTSUMS, etc.)

DOCU0			= 'n170414a (AH1928-1.2.3)? m-plane Kyma sample';  % <<< change rarely

% detector on diffractometer arm (X is del and Y is nu)
specfilename	= ['2017_0415_1'];SCNstr = '[8]';DOCUscan = ['600C rotate phi'];CLIM = [0 10]; 
% after this, put detector back on back wall (X is nu and Y is del
specfilename	= ['2017_0415_1'];SCNstr = '[11]';DOCUscan = ['600C scan TY'];CLIM = [-1.5 2]; 
specfilename	= ['2017_0415_1'];SCNstr = '[13]';DOCUscan = ['600C is it static'];CLIM = [-1.5 2]; 
specfilename	= ['2017_0415_1'];SCNstr = '[16]';DOCUscan = ['600C 4x10 micron slits TEG 6-10sccm'];CLIM = [-1.5 2]; 
%specfilename	= ['2017_0415_1'];SCNstr = '[17]';DOCUscan = ['600C coarsening'];CLIM = [-1.5 2]; 
%specfilename	= ['2017_0415_1'];SCNstr = '[27]';DOCUscan = ['550C 4x10 micron slits TEG 6-10 sccm'];CLIM = [-1.5 2]; 
%specfilename	= ['2017_0415_1'];SCNstr = '[32]';DOCUscan = ['650C 4x10 micron slits TEG 6-10 sccm'];CLIM = [-1.5 2]; 
%specfilename	= ['2017_0415_1'];SCNstr = '[36]';DOCUscan = ['700C 4x10 micron slits TEG 6-10 sccm'];CLIM = [-1.5 2]; 
%specfilename	= ['2017_0415_1'];SCNstr = '[40]';DOCUscan = ['675C 4x10 micron slits TEG 6-10 sccm'];CLIM = [-1.5 2]; 
%specfilename	= ['2017_0416_1'];SCNstr = '[14]';DOCUscan = ['RT NH3 stable?'];CLIM = [-1.5 2]; 
specfilename	= ['2017_0416_1'];SCNstr = '[19]';DOCUscan = ['650C 4x10 micron slits TEG 3-10 sccm'];CLIM = [-1.5 2]; 
%specfilename	= ['2017_0416_1'];SCNstr = '[22]';DOCUscan = ['625C 5deg phi scan'];CLIM = [-1.5 2]; 
%specfilename	= ['2017_0416_1'];SCNstr = '[30]';DOCUscan = ['625C long phi scan'];CLIM = [-1.5 2]; 
%specfilename	= ['2017_0416_1'];SCNstr = '[35]';DOCUscan = ['625C 4x10 micron slits TEG 3-10 sccm'];CLIM = [-1.5 2];
%specfilename	= ['2017_0416_1'];SCNstr = '[45]';DOCUscan = ['625C 3 micron slits TEG 3-10 sccm'];CLIM = [-1.5 2];
specfilename	= ['2017_0416_1'];SCNstr = '[49]';DOCUscan = ['625C 2.5x2.5 micron slits TEG 3-10 sccm'];CLIM = [-1.5 2];
%specfilename	= ['2017_0416_1'];SCNstr = '[58]';DOCUscan = ['650C 3x3 micron slits TEG 3-10 sccm'];CLIM = [-1.5 2];
specfilename	= ['2017_0416_1'];SCNstr = '[49]';DOCUscan = ['625C 2.5x2.5 micron slits TEG 3-10 sccm'];CLIM = [-1.5 2];


% The +/- 5 window seems good for the new SG smoothing
% Used +/- 10 to evalauate contrast

jjj = 10; % X half-width of moving window 
iii = 10; % Y half-width of moving window

jjj = 5; % X half-width of moving window
iii = 5; % Y half-width of moving window

%jjj = 3; % X half-width of moving window
%iii = 3; % Y half-width of moving window

tbin = 1; % number of scans to bin together for 2-time calcs
tbin = 3; % number of scans to bin together for 2-time calcs

% Center is 226 281
XCEN = 226;
YCEN = 281;

ImageJ = 1; % use imageJ indexing [start at 0] when denoting ROIs and when plotting pixels
%	This applies to AXISdet and ROI values so must be consistent.
% Also in time, first image is 0

%%%%%%%  ROIS and AXISdet (using ImageJ (SPEC) pixel conventions  %%%%%
%%%%  that is, start from [0,0] indexing, 

AXISdet = [1 516 1 516]-ImageJ;

AXISdet = [(XCEN + [-100 100]) (YCEN + [-200 200])];

SoXFLAG = 1;
SoYFLAG = 1;

% Note sumrois_wNaN doesn't work with single-pixel ROIs
% also can get some other error at line 368 with 1x2 pixel
if 1 

ROIS = [...
(XCEN + [-100 100]) (YCEN + [-10 10])  %1st ROI

(XCEN + [-22  -19]) (YCEN + [-10 10])    %2nd ROI

%3rd ROI Used for 2-time
%Symmetric
%(XCEN + [-61 -31]) (YCEN + [30 100])    % left top
%(XCEN + [ 31  61]) (YCEN + [30 100])    % right top
%(XCEN + [ 31  61]) (YCEN + [-100 -30])  % right bottom
%(XCEN + [-61 -31]) (YCEN + [-100 -30])  % left bottom

%(XCEN + [-61 -31]) (YCEN + [50 115])  % left top
%(XCEN + [-61 -31]) (YCEN + [50 180])  % left top

%------------------------------------------------------
%(XCEN + [-56 -31]) (YCEN + [30 100])  % left top (narrow)
%(XCEN + [-50 -31]) (YCEN + [30 100])   % left top (narrow)
%(XCEN + [-50 -31]) (YCEN + [-10 100])   % left top (long narrow)
%(XCEN + [-50 -31]) (YCEN + [-10 10])   % left center

(XCEN + [-50 -31]) (YCEN + [10 30])  % left up
(XCEN + [-50 -31]) (YCEN + [-30 -10])   % left down
(XCEN + [ 31  50]) (YCEN + [10 30])  % right up
(XCEN + [ 31  50]) (YCEN + [-30 -10])   % right down
%------------------------------------------------------

%(XCEN + [-61 -31]) (YCEN + [-100 -21])% left bottom
%(XCEN + [ 37  71]) (YCEN + [  41 111]) % right top
 
%(XCEN + [-91 -31]) (YCEN + [30 100])    % left top

%extra ROI 1
(XCEN + [-61 -31]) (YCEN + [-10 10])

%extra ROI 2
(XCEN + [-3 3]) (YCEN + [-142 -107])

%extra ROI 3
(XCEN + [-3 3]) (YCEN + [107 175])    

%extra ROI 4
(XCEN + [17  22]) (YCEN + [-10 10])    

%extra ROI 5
(XCEN + [-14  -10]) (YCEN + [30 49])]   
end

% Use a different ROI list for 2-time:

TTROIS = [...
(XCEN + [-98 -95]) (YCEN + [-10 10])]; % Initial ROI
TTROIS = [...
(XCEN + [-98 -95]) (YCEN + [11 30])]; % Initial ROI
%TTROIS = [...
%(XCEN + [-98 -95]) (YCEN + [-30 -11])]; % Initial ROI
TTROIS = [...
(XCEN + [-98 -95]) (YCEN + [-40 40])]; % Initial ROI

TTROIS = [...
(XCEN + [-98 -95]) (YCEN + [-10 10])
(XCEN + [-98 -95]) (YCEN + [11 40])
(XCEN + [-98 -95]) (YCEN + [-40 -11])]; % Initial ROI

RXINC = 4; % Amount to increment ROI in X
NRX = 50; % Number of increments

ttcroiout = [1:3]; % which TTROIs to use together to get 2-time outside X window
DXavgwin = 22;
ttcroiin = [2:3]; % which TTROIs to use together to get 2-time inside X window


plotsmooth = 0; % use to control whether to plot smoothing results
plotall = 0; % use to control whether to plot every 2-time in Q loop

CWID = 0.3; % Parameter for integer/half-integer ML integration


% choose some individual pixels to plot vs time
PIX = [...
    XCEN YCEN
    ];

%Xstepcol=[];	% Xstepcol empty, uses first column in SPEC datafile as scan variable
Xstepcol = 0; % use pt number
%CLIMXP = [];
%CLIMXA =[];

% if you desire to have the 'summed' plots only over a particular set of points
% ImageJ = 1: first image is image 0 in POINTSUMS
%POINTSUMS = [0 10;SINGLE-5 SINGLE+5]; % scan 22
POINTSUMS=[];

%%% SPEC POINT CONVENTION HERE  %%%%%%%%%%%
SINGLE 		= 5;	% required for [0,1,2]
										   
BKG			= [];	% =[] no background subtracted,
					% = [n1 n3] (1st scan is n1=0) takes mean images n1:n3

XCOL = 'pix(X)';YROW = 'pix(Y)';DOCUclim=[];  
	
disp('[ Using the Flatfield with alt thresholds] ');

% Use flatfield / per-pixel normalization
% Run flatfield_analysis_MPX3.m to make flatfield_MPX3.mat
% contains 2 images: 
% Badimage (bad pixels); 
% imnormnan (pixel normalization, bad = NaN)

load flatfield_MPX3

% Fix up extra bad pixels
ibpe = [261 261]; % y values
jbpe = [176 250]; % x values

for ii = 1:length(ibpe)
    Badimage(ibpe(ii),jbpe(ii)) = 1;
    imnormnan(ibpe(ii),jbpe(ii)) = NaN;
end


if LOGFLAG
	CLIMlog = CLIM;
	CLIMlin = 10.^(CLIMlog);
else
	CLIMlin = CLIM;
	if ~isempty(CLIM);
		CLIMlog = [-1 log10(CLIM(2))];
	else
		CLIMlog = CLIM;
	end
end

[SPECpath,AREApath,COMMONpath,HOMEpath] = pathdisplay;

% normally should be done in parameters but we aren't carrying them through yet
% it changes per diffractometer - allows some easy ways to pull out information from headers relevant to diffractometer
readspechelp = str2func('readspec_sevc_v6_helper');
INFOinterest = ['s6vgap  s6hgap  Phi  Chi  TY  TX  TZ'];     %!!! put 2 spaces between each!!!!

HLine=[];HSurf=[];

STR.scanflag=1;
STR.imname=[];
STR.SPECpath=SPECpath;
STR.AREApath=AREApath;   % need to change pathdisplay if need pilatus
STR.p_image=['p_image'];   %% [] if it uses the preferred points instead
STR.ending='.tif';

% FORCE only one scan at a time
SCNs = eval(SCNstr); SCNs = SCNs(1); 

[NameMatrix,sdata] = make_imnames_2016_07(specfilename,SCNs,STR);
FullNameArea = addnames2matrix([STR.AREApath,filesep],NameMatrix.fullfilenames);

[II,timestampX] = load_MPX3(FullNameArea);

Nr = size(II,1); % detector size (rows), 516 for MPX3
Nc = size(II,2); % detector size (rows), 516 for MPX3
Nt = size(II,3); % number of images in scan

%AXISdet = [1 Nc 1 Nr] - ImageJ;
ROISfull = [1 Nc 1 Nr] - ImageJ;


% Note the timestamp for the medipix is only to 1 second, not to milliseconds
% So need to use the spec information for time.

timestampX_flag = 0;   % timestamp flag from tif is not great, keep use spec

TITLEstr1 = char(...
		[pfilename(specfilename),' #', SCNstr,' : ', sdata.SCNDATE],...
		[sdata.SCNTYPE],...
		[DOCU0,' ',DOCUscan]);

TITLEstrshort = char(...
		[pfilename(specfilename),' #',SCNstr, ' : ',sdata.SCNTYPE]);
		
% Pulling out information from scan header of the spec scan to document some motor positions
% See top of file for MOTORS (list what is desired to keep track of		
[OM,scninfo,OMspecial]	= readspechelp(sdata.scnheader,sdata.fileheader,sdata.comments);
INFOndx 				= chan2col(scninfo.allangles_label,INFOinterest);
INFOpositions 			= scninfo.allangles_i(INFOndx);
DUM=[];
	
% put into a line
for ii=1:length(INFOpositions);
	DUM = [DUM,pdigit(INFOpositions(ii)) ' : '];
end
	
INFOstr = char(INFOinterest,DUM);   % currently added onto 0 and 5
% INFOstr = [];    % turn this off quickly if desired 
	
hexmon	= sdata.DATA(:,chan2col(sdata.collabels,'hexmon'));
MONave 	= mean(hexmon);
valve_p	= sdata.DATA(:,chan2col(sdata.collabels,'valve_p'));
valve_v	= sdata.DATA(:,chan2col(sdata.collabels,'valve_v'));
secperpoint	= sdata.DATA(:,chan2col(sdata.collabels,'Seconds'));
timestampSpec	= sdata.DATA(:,chan2col(sdata.collabels,'Time'));
timestampEpoch  = sdata.DATA(:,chan2col(sdata.collabels,'Epoch'));

% for norm use mean hexmon - since slit size changes a lot
% we do not use the stated hex100mA from run params
hex100mA = MONave./mean(secperpoint); 
	
if timestampX_flag==0;
	timestampX = timestampSpec + timestampEpoch(1);
end
	
% I = Iraw * Norm	
Norm	= hex100mA .* secperpoint ./ hexmon(:,1);   % sometimes extra columns appear with hexmon

% Find valve switch points  (note that this output 
%		1st point is 0th point (like spec)
lastframes = find(diff(valve_p)~=0);
disp(['Last frames (Spec point number convention) before valve switches: ' num2str(lastframes')]);
		
if isempty(Xstepcol); Xstepcol=1;end   % use scan variable
	 
if Xstepcol<1;
	SCNXLABEL = 'spec point # ';
else
	SCNXLABEL	= col2chan(sdata.collabels,Xstepcol);  
end
	
if strncmp(SCNXLABEL,'Time',4); 
	SCNXLABEL	= [SCNXLABEL,' [\Delta sec] from SpecFile '];  % in pixirad, 
	Xsteps	= timestampX-timestampX(1);
elseif Xstepcol<1;
	Xsteps	= [0:length(timestampX)-ImageJ];  
else
	Xsteps	= sdata.DATA(:,Xstepcol);
end
	
% Express time axis in growth amount (ML)
delay = 3; % delay in frames of growth start after valve switch
%tamount = 4.5; % total ML of growth
tamount = 4.6; % total ML of growth
Xamount = tamount*(Xsteps - (lastframes(1) + delay))/(diff(lastframes) - delay);

POINTSUMS=[1 Nt;
            40 70; % 1/2 ML
            71 100; % 1 ML
            lastframes(2)+delay Nt] - ImageJ;
POINTSUMS=[1 Nt;
            40 70; % 1/2 ML
            169 176; % 2.5 ML
            1 10; % 0 ML
            lastframes(2)+delay Nt] - ImageJ;
POINTSUMS=[1 Nt;
            1 10] - ImageJ; % 0 ML


%SPECpts = [1:Nt] - ImageJ;
%YROWpts = [1:Nr] - ImageJ;  
%XCOLpts = [1:Nc] - ImageJ;

%	Here we are being consistent with enumeration in SPEC points and ImageJ
%		ImageJ convention is used in the SPEC ROI's and EPICS ROIs images
%		SPEC convention is used in its points when we 'write' down a data point
% ImageJ = 1 % using ImageJ convention, ImageJ=0 use matlab convention
%		matlab convention numbering starts from 1, not 0 
%			from the screen	
SPECpts = [1:(length(Xsteps))]-ImageJ;
YROWpts = [1:(length(II(:,1,1)))]-ImageJ;  
XCOLpts = [1:(length(II(1,:,1)))]-ImageJ;
	
% normalize, bkg, flatfield
		
for ii=1:length(II(1,1,:)); % could be Nt
	IInorm(:,:,ii)	= II(:,:,ii) .* Norm(ii);
end
% Calculate mean background image
if isempty(BKG)
	IIimbkg = 0;
else
	IIimbkg	= mean(IInorm(:,:,[BKG(1):BKG(2)]+ImageJ),3);
end
		
% correct for bkg and flatfield
for ii=1:length(II(1,1,:));		
	IInormb(:,:,ii)		= (IInorm(:,:,ii)	- IIimbkg)./imnormnan;
end

DOCUInt = '[FF]';



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Figure1
% Plot full detector summed over all points
if 0
    POINTS=[1 length(Xsteps)]-ImageJ;
	
for ii = 1:length(POINTS(:,1))
	Ni = [POINTS(ii,1): POINTS(ii,2)]+ImageJ;
	NP = length(Ni);

	
	figure;clf;
	set(gcf,'Name','Image summed over points/Num Points');	
	if ~LOGFLAG

		HS = surf(XCOLpts,YROWpts,sum(IInormb(:,:,Ni),3)./(NP));

			%if ~isempty(AXISdet); axis(AXISdet);end
			
			if ~isempty(CLIMlin); 
				set(gca,'clim',CLIMlin);
				DOCUclim = mDOCUclim(CLIMlin);
			else 
				CLIMtemp = get(gca,'clim');
				DOCUclim = mDOCUclim(CLIMtemp);
			end;
			DOCUInt6 = [DOCUInt, ' SUMMED over SPEC scan pts [',int2str(POINTS(ii,:)),']'];
	else
	
		HS = surf(XCOLpts,YROWpts,log10(fixlogimage(sum(IInormb(:,:,Ni),3)./(NP))));
			%if ~isempty(AXISdet), axis(AXISdet);end
			if ~isempty(CLIMlog); 
				set(gca,'clim',CLIMlog);
				DOCUclim = mDOCUclim(CLIMlog);
			else 
				CLIMtemp = get(gca,'clim');
				DOCUclim = mDOCUclim(CLIMtemp);
			end;
			DOCUInt6 = [DOCUInt, ' SUMMED over SPEC scan pts) [',int2str(POINTS(ii,:)),'])'];
	end
	
	view(0,90);shading flat;
	
	DOCUlast = char(DOCUInt6, INFOstr);
	title(char(TITLEstr1,DOCUlast));xlabel(XCOL);ylabel(YROW);
	prettyplot(gca,[2 2 4 3]);
    set(gca,'position',[.17 .10 .65 .68]);
	axis square;
    axis ([0 516 0 516]);
    set(gca,'xgrid','off');
    set(gca,'ygrid','off');
    colorbar;
	colormap 'jet';
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Figure2
if 1; % show axisdet region with rois 

	if ~LOGFLAG
		figure;clf
		set(gcf,'Name',['Lin Image',' Spec # ' int2str(SINGLE)]);
		HS = pcolor(XCOLpts,YROWpts,(IInormb(:,:,SINGLE+ImageJ)));
		shading interp
		HSurf.IInormb = HS;

			if ~isempty(AXISdet); axis(AXISdet);end
			if ~isempty(CLIMlin); 
				set(gca,'clim',CLIMlin);
				DOCUclim = mDOCUclim(CLIMlin);
			end;
	else
		figure;clf
		set(gcf,'Name',['Log10 Image',' Spec #' int2str(SINGLE)]);
		HS = pcolor(XCOLpts,YROWpts,log10(fixlogimage((IInormb(:,:,SINGLE+ImageJ)))));
		shading flat
		HSurf.IInormb = HS;

			if ~isempty(AXISdet), axis(AXISdet);end
			if ~isempty(CLIMlog); 
				set(gca,'clim',CLIMlog);
				DOCUclim = mDOCUclim(CLIMlog);
			end;
	end
	
	DOCUlast = ['(Spec pt #',int2str(SINGLE),') ', DOCUInt, DOCUclim];
	title(char(TITLEstr1,DOCUlast,INFOstr));
	xlabel(XCOL);ylabel(YROW);
    set(gca,'position',[.17 .1 .65 .68]);
	prettyplot(gca,[2 2 2 3.8]);
    [HROI,COLORORDER] = showrois(ROIS,gcf);
    colormap 'jet';
end	


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if 0; % show rois only
		
		figure;clf;
		set(gcf,'Name','Enumeration of ROIs colors');
		if ~isempty(AXISdet); axis(AXISdet);end
		prettyplot(gca);    % put here or it clobbers the showROIS colororder 		
		showrois(ROIS,gcf);
		title('Enumeration of the ROIs and their colors');
		if ~isempty(AXISdet); 
			axis(AXISdet);
		else
			axis([min(XCOLpts) max(XCOLpts) min(YROWpts) max(YROWpts)]);
		end

			LEGEND = [char([ones(length(HROI),1)*'ROI #']) int2str([1:length(HROI)]')];
			legend(LEGEND);
		
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Figure345678
if 1 %% make summed images 
%	ImageJ = 1; use	ImageJ indexing (start (0,0)) in ROI indexing
	 
	 [SoY,SoX] = slicesumrois(IInormb,ROIS,ImageJ);%(1,:));
%	Note - This does not 'normalize' the slices to the number of pixels summed
%			However, after using function, use SoY.image{i}./SoY.norm{i} 
%				for ROI {i} 

	for ii=1%:length(ROIS(:,1));

  if SoXFLAG
	figure;clf
	set(gcf,'Name',['SoX ROIs #' int2str(ii)]);

	 if ~LOGFLAG;
	 HS = pcolor(Xsteps,SoX.ndx{ii},((SoX.images{ii})));
	 else
	 HS = pcolor(Xsteps,SoX.ndx{ii},log10(fixlogimage(SoX.images{ii})));
	 end

	 HPC.SoX_ROIS(ii) = HS;
	 shading flat; 
	 xlabel(SCNXLABEL);ylabel(YROW);
	 title(char(TITLEstr1,[DOCUInt, ' summed over X in ROI #' int2str(ii)]));
	 			if ~isempty(AXISdet); set(gca,'Ylim',AXISdet(3:4));end
%	 			if ~isempty(AXISdet); set(gca,'Ylim',ROIS(ii,[3:4]));end
         set(gca,'position',[.17 .10 .65 .68]);
	     prettyplot(gca)
         makexline(ROIS(3,3:4));
	 	 makeyline(Xsteps(lastframes));
         colormap 'jet';
 
  end
	
  if SoYFLAG  % don't plot if SoY flag 0
	figure;clf
	%set(gcf,'Name',['SoY ROIs #' int2str(ii)]');
	
	 if ~LOGFLAG;
	 HS = pcolor(Xsteps,SoY.ndx{ii},((SoY.images{ii})));
		
	 else
	 HS = pcolor(Xsteps,SoY.ndx{ii},log10(fixlogimage(SoY.images{ii})));
	 end

	 HPC.SoY_ROIS(ii) = HS;
	 shading flat; 
	 xlabel(SCNXLABEL);ylabel(XCOL);
	 title(char(TITLEstr1,[DOCUInt ' summed over Y in ROI #' int2str(ii)]));
	 % Note Ylim in this context is on output plot not the since we put the time etc on X axis
%	 			if ~isempty(AXISdet); set(gca,'Ylim',AXISdet(1:2));end
	 			if ~isempty(AXISdet); set(gca,'Ylim',ROIS(ii,[1:2]));end
     set(gca,'position',[.17 .10 .65 .68]);
     prettyplot(gca)
	 makeyline(Xsteps(lastframes));
     makexline(ROIS(3,1:2));
	 colormap 'jet';
  end
    end


if  1 
	if SoXFLAG
	figure; clf
	set(gcf,'Name','SoX and Sum Points ');
	 HL = semilogy(SoX.ndx{1},sum(SoX.images{1}'));
		for jj = 2:length(SoX.images);
			HL(jj) = line(SoX.ndx{jj},sum(SoX.images{jj}'));
		end


	 xlabel(YROW),ylabel('Int (arb)'),
	 title(char(TITLEstr1,['summed over XCOLS in all ROI and scan pts']));
	 prettyplot(gca);  %
     set(gca,'position',[.17 .10 .65 .68]);
		for ii=1:length(ROIS(:,1));
		set(HL(ii),'Color',COLORORDER(ii,:),'LineWidth',2);
		end
		
		HLine.SoX_SPts = HL;clear HL;

	end
	if SoYFLAG	
	figure; clf
	set(gcf,'Name','SoY and Sum Points ');
	 HL = semilogy(SoY.ndx{1},sum(SoY.images{1}'));
		for jj = 2:length(SoY.images);
			HL(jj) = line(SoY.ndx{jj},sum(SoY.images{jj}'));
		end

	 xlabel(XCOL),ylabel('Int (arb)'),
	 title(char(TITLEstr1,['summed over Y in all ROI and scan pts']));
	 prettyplot(gca);  % 
     set(gca,'position',[.17 .10 .65 .68]);
     colormap 'jet';
		for ii=1:length(ROIS(:,1));
		set(HL(ii),'Color',COLORORDER(ii,:),'LineWidth',2);
		end
	 
		HLine.SoY_SPts = HL;clear HL;

	end

	if ~isempty(POINTSUMS)   % sum over points sets in POINTSUMS
	
		if SoXFLAG
		figure; clf;
		set(gcf,'Name','SoX 1st ROI and Sum select points');
		for ii=1:length(POINTSUMS(:,1));
			Ni = [POINTSUMS(ii,1): POINTSUMS(ii,2)]+ImageJ;  %use as matlab
			HL(ii) = line(SoX.ndx{1},sum(SoX.images{1}(:,Ni)'));
		end
		
		
			set(gca,'Yscale','log')
			xlabel(YROW),ylabel('Int (arb)'),
            %colormap 'jet';
			title(char(TITLEstr1,['summed over X in 1st ROI and between selected Spec Points']));
			prettyplot(gca);
            set(gca,'position',[.17 .10 .65 .68]);
            legend(addnames2matrix('sum between [', int2str(POINTSUMS),']'))
		HLine.SoX_SoSelectPt = HL;clear HL;

		end
		
		if SoYFLAG

		figure; clf;
		set(gcf,'Name','SoY 1st ROI and Sum selected points');
		for ii=1:length(POINTSUMS(:,1));
			Ni = [POINTSUMS(ii,1): POINTSUMS(ii,2)]+ImageJ;
			HL(ii) = line(SoY.ndx{1},sum(SoY.images{1}(:,Ni)'));
		end
			set(gca,'Yscale','log')
			xlabel(XCOL),ylabel('Int (arb)'),
            set(gca,'position',[.17 .10 .65 .68]);
            colormap 'jet';
			title(char(TITLEstr1,['summed over Y in 1st ROI and between selected Spec Points']));
			prettyplot(gca);legend(addnames2matrix('sum between [', int2str(POINTSUMS),']'));
		HLine.SoY_SoSelectPt = HL;clear HL;

		end
	end
	end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%figure9

if 0 %% plot idividual pixels vs time 
%	ImageJ = 1; use	ImageJ indexing (start (0,0)) in ROI indexing
	 

	for ii=1:length(PIX(:,1));

        figure;clf
        set(gcf,'Name',['Pixel X = ' int2str(PIX(ii,1)) ', Y = ' int2str(PIX(ii,2))]);

        HS = line(Xsteps,squeeze(IInormb(PIX(ii,2)+ImageJ,PIX(ii,1)+ImageJ,:)));
	 
        xlabel(SCNXLABEL);ylabel('Intensity');
        title(char(TITLEstr1,[DOCUInt, 'Pixel X = ' int2str(PIX(ii,1)) ', Y = ' int2str(PIX(ii,2))]));			
        prettyplot(gca)
	 	makeyline(Xsteps(lastframes));
        colormap 'jet';
    end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%figure10

if 1
	figure;clf
	set(gcf,'Name','ROIs as counters');
	 
	 [sumROIS,sumROISnormed] = sumrois_wNaN(IInormb,ROIS,ImageJ);
%	 [sumROIS,sumROISnormed] = sumrois(IInormb,ROIS,ImageJ);
	 %	Isum	Array  : each column for each ROI. Length of vectors (rows) num of images
	 %HL = semilogy(Xsteps,sumROIS);
	 HL = plot(Xsteps,sumROIS(:,2:length(ROIS(:,1)))); YLABEL = 'Inorm(summed over ROI)';
%	 HL = plot(Xsteps,sumROISnormed); YLABEL = 'Inorm(summed over ROI)/ROIsize';
     legend(num2str(ROIS(2:length(ROIS(:,1)),:)));
    

	 makeyline(Xsteps(lastframes)); % need to turn these into colors so do before prettyplot
	 xlabel(SCNXLABEL);ylabel(YLABEL);
	 title(char(TITLEstr1,INFOstr,YLABEL));
	 prettyplot(gca);
     set(gca,'position',[.17 .10 .65 .68]);
     colormap 'jet';
     set(gca,'xgrid','on');
	 
	 for ii=1:length(ROIS(:,1))-1;
		set(HL(ii),'Color',COLORORDER(ii+1,:),'LineWidth',2);
     end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% figure11,12,13,14
if 1;   % plot summed images
	if isempty(POINTSUMS); POINTS=[1 length(Xsteps)]-ImageJ;
	else POINTS = POINTSUMS;
	end
	
for ii = 1:length(POINTS(:,1))
	Ni = [POINTS(ii,1): POINTS(ii,2)]+ImageJ;
	NP = length(Ni);

	
	figure;clf;
	set(gcf,'Name','Image summed over points/Num Points');	
	if ~LOGFLAG

		HS = pcolor(XCOLpts,YROWpts,sum(IInormb(:,:,Ni),3)./(NP));

			if ~isempty(AXISdet); axis(AXISdet);end
			
			if ~isempty(CLIMlin); 
				set(gca,'clim',CLIMlin);
				DOCUclim = mDOCUclim(CLIMlin);
			else 
				CLIMtemp = get(gca,'clim');
				DOCUclim = mDOCUclim(CLIMtemp);
			end;
			DOCUInt6 = [DOCUInt, ' SUMMED over SPEC scan pts [',int2str(POINTS(ii,:)),']'];
	else
	
		HS = pcolor(XCOLpts,YROWpts,log10(fixlogimage(sum(IInormb(:,:,Ni),3)./(NP))));
			if ~isempty(AXISdet), axis(AXISdet);end
			if ~isempty(CLIMlog); 
				set(gca,'clim',CLIMlog);
				DOCUclim = mDOCUclim(CLIMlog);
			else 
				CLIMtemp = get(gca,'clim');
				DOCUclim = mDOCUclim(CLIMtemp);
			end;
			DOCUInt6 = [DOCUInt, ' SUMMED over SPEC scan pts) [',int2str(POINTS(ii,:)),'])'];
	end
	
	view(0,90);
    shading flat;
	set(gca,'ydir','Normal');
	DOCUlast = char(DOCUInt6, INFOstr);
	title(char(TITLEstr1,DOCUlast));xlabel(XCOL);ylabel(YROW);
	prettyplot(gca,[2 2 4 3.8]);
    set(gca,'position',[.17 .1 .65 .68]);
	axis square;
    hold on
    [HROI,COLORORDER] = showrois(ROIS,gcf);
	 colormap 'jet';

end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0; % plot flat field

	figure;clf
	set(gcf,'Name',['Flat Field']);
	HS = pcolor(XCOLpts,YROWpts,imnormnan);
	shading flat
	view(0,90);
    %HSurf.IInormb = HS;
    if ~isempty(AXISdet); axis(AXISdet);end
	title('Flat Field');
	xlabel(XCOL);ylabel(YROW);
    prettyplot(gca,[2 2 4 3.8]);
    set(gca,'position',[.17 .1 .65 .68]);
	axis square;
    %[HROI,COLORORDER] = showrois(ROIS,gcf);
    colormap 'jet';
end	


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate 2-time correlations

disp('Calculating 2-time correlations, please wait.');
tic;
   
% First bin scans in time
if tbin > 1
    tbin = floor(tbin);
    Ntb = floor(Nt/tbin);
    IInormbe = reshape(IInormb(:,:,1:Ntb*tbin),Nr,Nc,tbin,Ntb);
    IInormbb = squeeze(sum(IInormbe,3));
    Xamounte = reshape(Xamount(1:Ntb*tbin),tbin,Ntb);
    Xamountb = squeeze(mean(Xamounte,1));
    POINTSUMSB(:,1) = floor((POINTSUMS(:,1)-1+ImageJ)/tbin)+1-ImageJ;
    POINTSUMSB(:,2) = floor((POINTSUMS(:,2)+ImageJ)/tbin) - ImageJ;
else
    Ntb = Nt;
    IInormbb = IInormb;
    Xamountb = Xamount;
    POINTSUMSB = POINTSUMS;
end

if isempty(POINTSUMSB); POINTSB=[1 Ntb]-ImageJ;
else POINTSB = POINTSUMSB;
end

% Correct for bad pixels and threshold variation, for input to smoothing
%Icorr = NaN*ones(size(IInormbb));
%for kk = 1:Ntb    
%    Icorr(:,:,kk) = IInormbb(:,:,kk)./imnormnanall; % normalize and set bad pixels = NaN
%end

Icorr = IInormbb; % already corrected

dIroiv = []; % vector to hold deviations from average, all good pixels in ROIs used

tic;
disp('Calculating mean for 2-time correlations, please wait.');

% Smoothing method for getting average

dj = -jjj:jjj;
di = -iii:iii;

% Calculate CC2 averages over integer and half-integer correlation regions
% Base on ML values in Xamountb

% For integer and half-integer during growth, use only values between 0 and 4.5 ML
Xn = Xamountb;
Xn(Xn<0) = NaN;
Xn(Xn>4.5) = NaN;
% Make into matrices, size of CC2
Xnc = ones(size(Xn'))*Xn;
Xnr = Xn'*ones(size(Xn));
% Set diagonal and lower triangle to NaN
an = 1 + tril(NaN*ones(size(Xnc)),0);
Xnc2 = an.*Xnc;
Xnr2 = an.*Xnr;
% Make sum and difference of rows and columns
Xns = Xnc2 + Xnr2;
Xnd = Xnc2 - Xnr2;
% Round to digitize
Xnsi = round(Xns);
Xndi = round(Xnd);

% Make matrices showing regions to check logic
CCIK = zeros(Ntb,Ntb);
CCHK = zeros(Ntb,Ntb);

%for ii = 1:5
%    for jj = ii:5
%        CCIK(Xnsi == ii+jj-2 & Xndi == jj-ii) = 5*(ii-1) + jj;
%        CCHK(Xnsi == ii+jj-1 & Xndi == jj-ii) = 5*(ii-1) + jj;
%    end
%end

for ii = 1:5
    for jj = ii:5
        CCIK(abs(Xns - (ii+jj-2)) < CWID & abs(Xnd - (jj-ii)) < CWID) = 5*(ii-1) + jj;
        CCHK(abs(Xns - (ii+jj-1)) < CWID & abs(Xnd - (jj-ii)) < CWID) = 5*(ii-1) + jj;
    end
end

% Plot logic checks
figure;
set(gcf,'Paperposition',[1 1 4 3]);
set(gcf,'Name','integer check');
HS = pcolor(Xamountb,Xamountb,CCIK);
shading flat;
%set(gca,'clim',[0 0.10]);
hx = xlabel('Growth Amount (ML)');
hy = ylabel('Growth Amount (ML)');
set(gca,'position',[.17 .15 .65 .8]);
axis equal
colorbar
colormap 'jet';

figure;
set(gcf,'Paperposition',[1 1 4 3]);
set(gcf,'Name','half integer check');
HS = pcolor(Xamountb,Xamountb,CCHK);
shading flat;
%set(gca,'clim',[0 0.10]);
hx = xlabel('Growth Amount (ML)');
hy = ylabel('Growth Amount (ML)');
set(gca,'position',[.17 .15 .65 .8]);
axis equal
colorbar
colormap 'jet';

% Loop over a sequence of ROIs for 2-time
% Use a different ROI list for 2-time

% Variables to save values for each step:

CC2M = NaN*ones(Ntb,Ntb,NRX);
CHM = NaN*ones(5,5,NRX);
CIM = NaN*ones(5,5,NRX);
CS0M = NaN*ones(1,NRX);
CSM = NaN*ones(5,NRX);
CE0M = NaN*ones(1,NRX);
CEM = NaN*ones(5,NRX);
CSEM = NaN*ones(1,NRX);
CCHM = NaN*ones(1,NRX);
CCIM = NaN*ones(1,NRX);

DXavg = NaN*ones(1,NRX);
    
for ix = 1:NRX
    TTROISI = TTROIS;
    TTROISI(:,1) = TTROISI(:,1) + (ix-1)*RXINC;
    TTROISI(:,2) = TTROISI(:,2) + (ix-1)*RXINC;
    
    DXavg(ix) = mean(TTROISI(1,1:2)) - XCEN;
    
    if abs(DXavg(ix)) < DXavgwin
        ttcroi = ttcroiin;
    else
        ttcroi = ttcroiout;
    end
    
    dIroiv = [];

% Use ROIs in ttcroi
    for iroi = ttcroi

% ROI indices
        ROIi = [TTROISI(iroi,3):TTROISI(iroi,4)]+ImageJ;
        ROIj = [TTROISI(iroi,1):TTROISI(iroi,2)]+ImageJ;

% expanded ROI subscripts to include window range around ROI
        ROIPi = [(TTROISI(iroi,3)-iii):(TTROISI(iroi,4)+iii)]+ImageJ;
        ROIPj = [(TTROISI(iroi,1)-jjj):(TTROISI(iroi,2)+jjj)]+ImageJ;

% first fix up NaN's, then use conv
% data in expanded ROI
        IcorrER = Icorr(ROIPi,ROIPj,:);

% bad pixels in expanded ROI
        ROIPnans = Badimage(ROIPi,ROIPj);

% Matrix subscripts of bad pixels in expanded ROI
        [nani,nanj] = find(ROIPnans);

% Correct to be subscripts in whole image
        naniw = nani + ROIPi(1) - 1;
        nanjw = nanj + ROIPj(1) - 1;

% Replace bad pixel values by local mean of good pixels
        IcorrER2 = IcorrER;
        for ii = 1:length(nani)   
            for kk = 1:Ntb    
                III = Icorr(naniw(ii)+di,nanjw(ii)+dj,kk);
                III(isnan(III))=[]; % remove bad pixels
                IcorrER2(nani(ii),nanj(ii),kk) = mean(III(:));  
            end
        end

% convolute - return only ROI:

%clear Iconv
%for kk = 1:Ntb
%    Iconv(:,:,kk) = conv2(IcorrER2(:,:,kk),ones(length(di),length(dj)),'valid')./(length(di)*length(dj));
%end

% Use 2-D Savitzky-Golay smoothing filter, cubic
        filt = sgsf_2d(di,dj,3,3,0);
        clear Iconv;
        for kk = 1:Ntb
            Iconv(:,:,kk) = conv2(IcorrER2(:,:,kk),filt,'valid');
        end

% Calculate difference from mean
        dIroi = Icorr(ROIi,ROIj,:) - Iconv;
% Loop for each time step
        BadimageROI = Badimage(ROIi,ROIj);
        clear dIroivj
        for jj = 1:Ntb
            dIroij = dIroi(:,:,jj); 
            dIroij(BadimageROI)=[]; % remove bad pixels
            dIroivj(:,jj) = dIroij(:);
        end

 % append to multi-roi list
        dIroiv = [dIroiv; dIroivj];
 
 % make some plots of smoothing results
 % ----------------------
        if plotsmooth
        for ii = 1:length(POINTSB(:,1))
            Ni = [POINTSB(ii,1): POINTSB(ii,2)]+ImageJ;
            NP = length(Ni);
	
            figure;clf;
            set(gcf,'Name','Iconv mean over scan pts');	
	
            HS = imagesc(sum(Iconv(:,:,Ni),3)./NP);
            %if ~isempty(AXISdet), axis(AXISdet);end
            DOCUInt = ['Iconv mean over SPEC scan pts [',int2str(POINTS(ii,:)),'])'];
            title(char(TITLEstr1,DOCUInt));
            %xlabel(XCOL);ylabel(YROW);
        	(gca);
            colorbar;
            colormap 'jet';
            set(gca,'ydir','Normal');
        end    

        % Plot intensity distributions in ROI, in POINTSUM

        if ~isempty(POINTSUMSB)   % sum over points sets in POINTSUMS
	
            figure; clf;
            set(gcf,'Name','SoX 1st ROI and Sum select points');
            for ii=1:length(POINTSUMSB(:,1));
                Ni = [POINTSUMSB(ii,1): POINTSUMSB(ii,2)]+ImageJ;
                HL(ii) = line(ROIi-ImageJ,sum(sum(IcorrER2(iii+1:end-iii,jjj+1:end-jjj,Ni),3),2)','color','b');
                line(ROIi-ImageJ,sum(sum(Iconv(:,:,Ni),3),2)','color','r');    
            end
            set(gca,'Yscale','lin')
            xlabel(YROW),ylabel('Int (sum)'),
            title(char(TITLEstr1,['summed over X in 1st ROI and over sel frames']));
            prettyplot(gca);
            legend(addnames2matrix('sum between [', int2str(POINTSUMS),']'))
            HLine.SoX_SoSelectPt = HL;clear HL;
            colormap 'jet';
            set(gca,'ydir','Normal');
    
            figure; clf;
            set(gcf,'Name','SoY 1st ROI and Sum selected points');
            for ii=1:length(POINTSUMSB(:,1));
                Ni = [POINTSUMSB(ii,1): POINTSUMSB(ii,2)]+ImageJ;
                HL(ii) = line(ROIj-ImageJ,sum(sum(IcorrER2(iii+1:end-iii,jjj+1:end-jjj,Ni),3),1)','color','b');
                line(ROIj-ImageJ,sum(sum(Iconv(:,:,Ni),3),1)','color','r');    
            end
            set(gca,'Yscale','lin')
            xlabel(XCOL),ylabel('Int (sum)'),
            title(char(TITLEstr1,['summed over Y in 1st ROI and between selected Spec Points']));
            prettyplot(gca);
            %legend(addnames2matrix('sum between [', int2str(POINTSUMS),']'));
            HLine.SoY_SoSelectPt = HL;clear HL;
            colormap 'jet';	
            set(gca,'ydir','Normal');
        end


        for ii = 1:length(POINTSB(:,1))
            Ni = [POINTSB(ii,1): POINTSB(ii,2)]+ImageJ;
            NP = length(Ni);
	
            figure;clf;
            set(gcf,'Name','dIroi mean over scan pts');	
	
            HS = imagesc(sum(dIroi(:,:,Ni),3)./NP);
            %if ~isempty(AXISdet), axis(AXISdet);end
            DOCUInt = ['dIroi mean over scan pts [',int2str(POINTS(ii,:)),'])'];
            title(char(TITLEstr1,DOCUInt));
            %xlabel(XCOL);ylabel(YROW);
        	(gca);
            colorbar;
            colormap 'jet';
            set(gca,'ydir','Normal');
	
        end  
        end
%----------------------------------------------------------

    toc;

    end

% Calc 2-time using this mean
% Mean is different for each pixel and time

    IIM2 = NaN*ones(Ntb,Ntb);
    for ii = 1:Ntb
        for jj = 1:ii
            IIM2(ii,jj) = mean(dIroiv(:,ii).*dIroiv(:,jj));
            IIM2(jj,ii) = IIM2(ii,jj);
        end
    end
    IID2 = diag(IIM2);
    CC2 = IIM2./sqrt(IID2*IID2'); % Normalized to make diagonal unity

    toc

%--------------------------------------------------------
    if 0 % Plot vs frame number
    figure;
    set(gcf,'Paperposition',[1 1 4 3]);
    set(gcf,'Name','2-time 2nd method');
    HS = pcolor(CC2);
    shading flat;
    %set(gca,'clim',[0 0.03]);	
    xlabel('Frame 1');
    ylabel('Frame 2');
    DOCUlast = ['2nd method 2-time correlation'];
    %title(char(TITLEstr1,[DOCUlast]));
    set(gca,'position',[.17 .11 .65 .8]);
    %prettyplot(gca);
    colorbar
    colormap 'jet';
    end
%--------------------------------------------------------
% Plot vs growth amount
    if plotall
    figure;
    set(gcf,'Paperposition',[1 1 4 3]);
    set(gcf,'Name','2-time 2nd method');
    HS = pcolor(Xamountb,Xamountb,CC2);
    shading flat;
    set(gca,'clim',[0 0.30]);
    hx = xlabel('Growth Amount (ML)');
    hy = ylabel('Growth Amount (ML)');
    DOCUlast = ['2-time correlation 2nd method'];
    title(['DXavg = ' num2str(DXavg(ix))]);
    %set(gca,'position',[.17 .12 .65 .68]);
    set(gca,'position',[.17 .15 .65 .8]);
    axis equal
    %set(gca,'FontSize',12);
    %set(hx,'FontSize',12);
    %set(hy,'FontSize',12);
    colorbar
    colormap 'jet';
    % Put some lines showing start and end of growth
    LW = 1.5;
    LC = 'w';
    pa = axis;
    hl = line(0*[1,1],pa(3:4));
    set (hl,'color',LC,'LineWidth',LW);
    hl = line(4.5*[1,1],pa(3:4));
    set (hl,'color',LC,'LineWidth',LW);
    hl = line(pa(1:2),0*[1,1]);
    set (hl,'color',LC,'LineWidth',LW);
    hl = line(pa(1:2),4.5*[1,1]);
    set (hl,'color',LC,'LineWidth',LW);
    set(gca,'Xtick',[0:4]);
    set(gca,'Ytick',[0:4]);
    axis([min(Xamountb) max(Xamountb) min(Xamountb) max(Xamountb)]);
    set(gca,'TickDir','out');
    if 0
    % CTR (0-1ML)
    ROIS_show  = [...                
    4.5  5.04  min(Xamountb)  max(Xamountb)];    % #49
    [HROI,COLORORDER] = showrois(ROIS_show,gcf);
    end
    end
%--------------------------------------------------------
% Calculate some metrics of the CC2 matrix

% Horizontal and vertical means of upper off-diagonal

    CX2 = sum(triu(CC2,1),1)./[0:Ntb-1];

    CY2 = sum(triu(CC2,1),2)./[Ntb-1:-1:0]';

% Radial and transverse averages

    for ii = 1:Ntb
        CR2(ii) = mean(diag(CC2,ii-1));
        CT2(ii) = mean(diag(flipud(CC2-diag(ones(Ntb,1))),ii-1))/2;
    end
%--------------------------------------------------------
    if 0
    P=[97:112];  %#49
    [row,column]=size(CC2);
    CCs = sum(CC2(:,P),2);
    for ii = P
        CCs(ii) = CCs(ii) - 1;
    end

    figure;
    hax=axes('Box','on');
    HL=plot(Xamountb, CCs);
    set(HL,'Marker','o','LineStyle','-');
    xlabel('Growth Amount (ML)'); ylabel('Intensity');
    title(char(TITLEstr1,['Summed over 2-time correlation']));
    xlim([min(Xamountb) max(Xamountb)]);
    set(gca,'position',[.17 .10 .65 .68]);
    prettyplot(gca)
    end

% --------------------------------------------------------


% Get integer and half-integer regions to average
    CI = NaN*ones(5,5);
    CH = NaN*ones(5,5);
    %for ii = 1:5
    %    for jj = ii:5
    %        CI(ii,jj) = mean(CC2(Xnsi == ii+jj-2 & Xndi == jj-ii));
    %        CH(ii,jj) = mean(CC2(Xnsi == ii+jj-1 & Xndi == jj-ii));
    %   end
    %end

    for ii = 1:5
        for jj = ii:5
            CI(ii,jj) = mean(CC2(abs(Xns - (ii+jj-2)) < CWID & abs(Xnd - (jj-ii)) < CWID));
            CH(ii,jj) = mean(CC2(abs(Xns - (ii+jj-1)) < CWID & abs(Xnd - (jj-ii)) < CWID));
        end
    end

% Also calculate correlations with regions before growth start and after end

    Xsi = Xamountb<0;
    % Upper triangle pre-growth
    CS0 = sum(sum(triu(CC2(Xsi,Xsi),1)))./(0.5*sum(Xsi)*(sum(Xsi)-1));
    % Integer correlations with pre-growth
    CS = NaN*ones(1,5);
    for ii = 1:5
        Xii = Xamountb>0 & round(Xamountb) == ii - 1;
        CS(ii) = mean(mean(CC2(Xsi,Xii)));
    end

    Xei = Xamountb>4.5;
    % Upper triangle post-growth
    CE0 = sum(sum(triu(CC2(Xei,Xei),1)))./(0.5*sum(Xei)*(sum(Xei)-1));
    % Half-integer correlations with post-growth
    CE = NaN*ones(1,5);
    for ii = 1:5
        Xii = Xamountb<4.5 & round(4.5 - Xamountb) == ii - 1;
        CE(ii) = mean(mean(CC2(Xii,Xei)));
    end

    % correlation of pre- and post-growth
    CSE = mean(mean(CC2(Xsi,Xei)));

% create a single mean value for half-integer, leave out first ML and diag
    CCH = 0;
    for ii = 2:4
        for jj = ii+1:5
            CCH = CCH + CH(ii,jj);
        end
    end
    CCH = CCH/6;

% create a single mean value for integer, leave out diag
    CCI = 0;
    for ii = 1:4
        for jj = ii+1:5
            CCI = CCI + CI(ii,jj);
        end
    end
    CCI = CCI/10;

    CC2M(:,:,ix) = CC2;
    CHM(:,:,ix) = CH;
    CIM(:,:,ix) = CI;
    CS0M(ix) = CS0;
    CSM(:,ix) = CS;
    CE0M(ix) = CE0;
    CEM(:,ix) = CE;
    CSEM(ix) = CSE;
    CCHM(ix) = CCH;
    CCIM(ix) = CCI;

end

% Summary 2-time plots over main Q regions

DXHmin = 32;
DXHmax = 56;

idxh = abs(DXavg) > DXHmin & abs(DXavg) < DXHmax;

CC2H = mean(CC2M(:,:,idxh),3);

DXImin = 3;
DXImax = 21;

idxi = abs(DXavg) > DXImin & abs(DXavg) < DXImax; 

CC2I = mean(CC2M(:,:,idxi),3);

figure;
set(gcf,'Paperposition',[1 1 4 3]);
set(gcf,'Name',['DX ' num2str(DXHmin) ' to ' num2str(DXHmax)]);
HS = pcolor(Xamountb,Xamountb,CC2H);
shading flat;
set(gca,'clim',[0 0.30]);
hx = xlabel('Growth Amount (ML)');
hy = ylabel('Growth Amount (ML)');
DOCUlast = ['2-time correlation'];
title(['DX ' num2str(DXHmin) ' to ' num2str(DXHmax)]);
%set(gca,'position',[.17 .12 .65 .68]);
set(gca,'position',[.17 .15 .65 .8]);
axis equal
%set(gca,'FontSize',12);
%set(hx,'FontSize',12);
%set(hy,'FontSize',12);
colorbar
colormap 'jet';
% Put some lines showing start and end of growth
LW = 1.5;
LC = 'w';
pa = axis;
hl = line(0*[1,1],pa(3:4));
set (hl,'color',LC,'LineWidth',LW);
hl = line(4.5*[1,1],pa(3:4));
set (hl,'color',LC,'LineWidth',LW);
hl = line(pa(1:2),0*[1,1]);
set (hl,'color',LC,'LineWidth',LW);
hl = line(pa(1:2),4.5*[1,1]);
set (hl,'color',LC,'LineWidth',LW);
set(gca,'Xtick',[0:4]);
set(gca,'Ytick',[0:4]);
axis([min(Xamountb) max(Xamountb) min(Xamountb) max(Xamountb)]);
set(gca,'TickDir','out');
    
figure;
set(gcf,'Paperposition',[1 1 4 3]);
set(gcf,'Name',['DX ' num2str(DXImin) ' to ' num2str(DXImax)]);
HS = pcolor(Xamountb,Xamountb,CC2I);
shading flat;
set(gca,'clim',[0 0.30]);
hx = xlabel('Growth Amount (ML)');
hy = ylabel('Growth Amount (ML)');
DOCUlast = ['2-time correlation'];
title(['DX ' num2str(DXImin) ' to ' num2str(DXImax)]);
%set(gca,'position',[.17 .12 .65 .68]);
set(gca,'position',[.17 .15 .65 .8]);
axis equal
%set(gca,'FontSize',12);
%set(hx,'FontSize',12);
%set(hy,'FontSize',12);
colorbar
colormap 'jet';
% Put some lines showing start and end of growth
LW = 1.5;
LC = 'w';
pa = axis;
hl = line(0*[1,1],pa(3:4));
set (hl,'color',LC,'LineWidth',LW);
hl = line(4.5*[1,1],pa(3:4));
set (hl,'color',LC,'LineWidth',LW);
hl = line(pa(1:2),0*[1,1]);
set (hl,'color',LC,'LineWidth',LW);
hl = line(pa(1:2),4.5*[1,1]);
set (hl,'color',LC,'LineWidth',LW);
set(gca,'Xtick',[0:4]);
set(gca,'Ytick',[0:4]);
axis([min(Xamountb) max(Xamountb) min(Xamountb) max(Xamountb)]);
set(gca,'TickDir','out');
  

figure;
hax = axes('Box','on');
HL = line(DXavg, CCHM);
set(HL,'Marker','o','LineStyle','-');
xlabel('DX (pixels)'); 
ylabel('Half Integer Correlation');
title(char(TITLEstr1,['Half integer correlation']));
set(gca,'position',[.17 .10 .65 .68]);
set(gca,'Xlim',[-100 100]);
prettyplot(gca)

figure;
hax = axes('Box','on');
HL = line(DXavg, CCIM);
set(HL,'Marker','o','LineStyle','-');
xlabel('DX (pixels)'); 
ylabel('Integer Correlation');
title(char(TITLEstr1,['Integer correlation']));
set(gca,'position',[.17 .10 .65 .68]);
set(gca,'Xlim',[-100 100]);
prettyplot(gca)

% Fit CIM, CHM at each Q

% Fitting routine variables 
global verbose;
verbose = [0 0];
stol = 0.000001;
niter = 100;
%       const slope decay size
pin = [1   0   2   5]'; % Zero fixes parameter
dp =   [1   1   1   0]'.*0.0001; % Fraction to vary for deriv

for ix = 1:NRX
    
    CH = CHM(:,:,ix);
    xfit = find(~isnan(CH));
    if isempty(xfit)
        pouthm(:,ix) = NaN;
        covphm(:,ix) = NaN;
        xisqh(ix) = NaN;
    else
        
        yfit = CH(xfit);

    % Choose weights
        wfit = ones(size(xfit));
    
        [ffit,pout,kvg,iter,corp,covp,covr,stdresid,Z,r2]=leasqr(xfit,yfit,pin,'cc_fn',stol,niter,wfit,dp);
        xisqh(ix) = sum((wfit.*(ffit-yfit)).^2);
        pouthm(:,ix) = pout;
        sighm(:,ix) = sqrt(diag(covp));
    end
    
    CI = CIM(:,:,ix);
    xfit = find(~isnan(CI));
    if isempty(xfit)
        poutim(:,ix) = NaN;
        covpim(:,ix) = NaN;
        xisqi(ix) = NaN;
    else
        
        yfit = CI(xfit);

    % Choose weights
        wfit = ones(size(xfit));
    
        [ffit,pout,kvg,iter,corp,covp,covr,stdresid,Z,r2]=leasqr(xfit,yfit,pin,'cc_fn',stol,niter,wfit,dp);
        xisqi(ix) = sum((wfit.*(ffit-yfit)).^2);
        poutim(:,ix) = pout;
        sigim(:,ix) = sqrt(diag(covp));
    end
end

figure;
hax = axes('Box','on');
%HL = line(DXavg, pouthm(1,:) + 10*pouthm(2,:));
HL = errorbar(DXavg, pouthm(1,:) + 10*pouthm(2,:),sighm(1,:) + 10*sighm(2,:));
set(HL,'Marker','o','LineStyle','-');
xlabel('DX (pixels)'); 
ylabel('Half Integer Diag at 4.5 ML');
title(char(TITLEstr1,['Half integer correlation']));
set(gca,'position',[.17 .10 .65 .68]);
set(gca,'Xlim',[-100 100]);
prettyplot(gca)

figure;
hax = axes('Box','on');
%HL = line(DXavg, pouthm(2,:));
HL = errorbar(DXavg, pouthm(2,:), sighm(2,:));
set(HL,'Marker','o','LineStyle','-');
xlabel('DX (pixels)'); 
ylabel('Half Integer Diag Slope');
title(char(TITLEstr1,['Half integer correlation']));
set(gca,'position',[.17 .10 .65 .68]);
set(gca,'Xlim',[-100 100]);
prettyplot(gca)

figure;
hax = axes('Box','on');
%HL = line(DXavg, pouthm(3,:));
HL = errorbar(DXavg, pouthm(3,:), sighm(3,:));
set(HL,'Marker','o','LineStyle','-');
xlabel('DX (pixels)'); 
ylabel('Half Integer Decay Const');
title(char(TITLEstr1,['Half integer correlation']));
set(gca,'position',[.17 .10 .65 .68]);
axis([-100 100 0 10]);
prettyplot(gca)

figure;
hax = axes('Box','on');
%HL = line(DXavg, poutim(1,:) + 2*poutim(2,:));
HL = errorbar(DXavg, poutim(1,:) + 2*poutim(2,:), sigim(1,:) + 2*sigim(2,:));
set(HL,'Marker','o','LineStyle','-');
xlabel('DX (pixels)'); 
ylabel('Integer Diag at 1 ML');
title(char(TITLEstr1,['Integer correlation']));
set(gca,'position',[.17 .10 .65 .68]);
set(gca,'Xlim',[-100 100]);
prettyplot(gca)

figure;
hax = axes('Box','on');
%HL = line(DXavg, poutim(2,:));
HL = errorbar(DXavg, poutim(2,:), sigim(2,:));
set(HL,'Marker','o','LineStyle','-');
xlabel('DX (pixels)'); 
ylabel('Integer Diag Slope');
title(char(TITLEstr1,['Integer correlation']));
set(gca,'position',[.17 .10 .65 .68]);
set(gca,'Xlim',[-100 100]);
prettyplot(gca)

figure;
hax = axes('Box','on');
%HL = line(DXavg, poutim(3,:));
HL = errorbar(DXavg, poutim(3,:), sigim(3,:));
set(HL,'Marker','o','LineStyle','-');
xlabel('DX (pixels)'); 
ylabel('Integer Decay Const');
title(char(TITLEstr1,['Integer correlation']));
set(gca,'position',[.17 .10 .65 .68]);
axis([-100 100 0 30]);
prettyplot(gca)

figure;
hax = axes('Box','on');
%HL = line(DXavg, pouthm(3,:));
HL = errorbar(abs(DXavg), pouthm(3,:), sighm(3,:));
set(HL,'Marker','o','LineStyle','none');
set(gca,'Xscale','log','Yscale','log');
xlabel('DX (pixels)'); 
ylabel('Half Integer Decay Const');
title(char(TITLEstr1,['Half integer correlation']));
set(gca,'position',[.17 .10 .65 .68]);
axis([10 100 1 10]);
prettyplot(gca)


return
