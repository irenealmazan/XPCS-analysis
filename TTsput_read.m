% Two-time analysis of August 2017 m-plane LBL data
% Created from SG2017_0817_1_42_test
% Split sections into different scripts
% This script contains common part for reading scans
% called by TTM_2017_08XX_X_XX
% 26AUG17 GBS GJ


ImageJ = 1; % use imageJ indexing [start at 0] when denoting ROIs and when plotting pixels
%	This applies to AXISdet and ROI values so must be consistent.
% Also in time, first image is 0

%%%%%%%  ROIS and AXISdet (using ImageJ (SPEC) pixel conventions  %%%%%
%%%%  that is, start from [0,0] indexing, 
%AXISdet = [1 516 1 516]-ImageJ;


%Xstepcol=[];	% Xstepcol empty, uses first column in SPEC datafile as scan variable
Xstepcol = 0; % use pt number

%%% SPEC POINT CONVENTION HERE  %%%%%%%%%%%
SINGLE 		= 5;	% required for [0,1,2]
										   
BKG			= [];	% =[] no background subtracted,
					% = [n1 n3] (1st scan is n1=0) takes mean images n1:n3

XCOL = 'pix(X)';YROW = 'pix(Y)';DOCUclim=[];  
	
disp('[ Using no flatfield] ');
%load flatfield_MPX3_2017_08

% For MPX used flatfield / per-pixel normalization
% Run flatfield_analysis_MPX3.m to make flatfield_MPX3.mat
% contains 2 images: 
% Badimage (bad pixels); 
% imnormnan (pixel normalization, bad = NaN)

% Fix up extra bad pixels

% Pixels with high counts
% i is y (row), j is x (col)
%ibpe = [251 256 261 261 261 261 261 261 261 261 256 327 261 261 261 261 261 261 261 261 256 261 261 261 261 235 290 261 348 261 277 285 295 298 372 378 388 409 420 428 457 464 494 513 250 252 262 268 287 305 306 308 310 311 312 313 315 316 317 325 326 328 330 331 332 343 358 367 406 325 330 256 329 320 335 256 309 261 256 261 256 256 256 411   3 256 261 419 307 256 261   3   8 256 516 511];
%jbpe = [  7  31  33  42  47  55  62  64  71  76  88  94 108 118 136 137 140 141 148 152 155 159 183 184 223 233 238 240 254 256 256 256 256 256 256 256 256 256 256 256 256 256 256 256 261 261 261 261 261 261 261 261 261 261 261 261 261 261 261 261 261 261 261 261 261 261 261 261 261 262 262 263 263 264 264 270 270 278 280 315 316 355 358 359 393 391 395 398 401 424 424 435 446 499 502 505];
% Can find these by e.g.
% bp = find(max(IInormb,[],3)>1500)
% [ii,jj] = ind2sub([516 516],bp)

% Pixels with zero counts
%load zero_pixels
% Can find these by e.g.
% bp = find(mean(IInormb,3)==0)
% [ii,jj] = ind2sub([516 516],bp)
% too many to type in (149)

%ibpe = [ibpe izpe];
%jbpe = [jbpe jzpe];

%for ii = 1:length(ibpe)
%    Badimage(ibpe(ii),jbpe(ii)) = 1;
%    imnormnan(ibpe(ii),jbpe(ii)) = NaN;
%end

[SPECpath,AREApath,COMMONpath,HOMEpath] = pathdisplay;

% normally should be done in parameters but we aren't carrying them through yet
% it changes per diffractometer - allows some easy ways to pull out information from headers relevant to diffractometer
%readspechelp = str2func('readspec_sevc_v6_helper');
%INFOinterest = ['s6vgap  s6hgap  Eta  Chi  sam_x  sam_y  sam_z'];     %!!! put 2 spaces between each!!!!

HLine=[];HSurf=[];

STR.scanflag=1;
STR.imname=['pil_'];
STR.SPECpath=SPECpath;
STR.AREApath=AREApath;   % need to change pathdisplay if need pilatus
STR.p_image=['p_image'];   %% [] if it uses the preferred points instead
STR.ending='.tif';

% FORCE only one scan at a time
SCNs = eval(SCNstr); SCNs = SCNs(1); 

[NameMatrix,sdata] = make_imnames_2017_07(specfilename,SCNs,STR);
FullNameArea = addnames2matrix([STR.AREApath,filesep],NameMatrix.fullfilenames);

[II,timestampX] = load_MPX3(FullNameArea);

Nr = size(II,1); % detector size (rows), 195 Pixirad (nu)
Nc = size(II,2); % detector size (rows), 487 Pixirad (del)
Nt = size(II,3); % number of images in scan

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

TITLEstr2 = char(...
		[pfilename(specfilename),' #',SCNstr]);

% Pulling out information from scan header of the spec scan to document some motor positions
% See top of file for MOTORS (list what is desired to keep track of		
%[OM,scninfo,OMspecial]	= readspechelp(sdata.scnheader,sdata.fileheader,sdata.comments);
%INFOndx 				= chan2col(scninfo.allangles_label,INFOinterest);
%INFOpositions 			= scninfo.allangles_i(INFOndx);
%DUM=[];
	
% put into a line
%for ii=1:length(INFOpositions);
%	DUM = [DUM,pdigit(INFOpositions(ii)) ' : '];
%end
	
%INFOstr = char(INFOinterest,DUM);   % currently added onto 0 and 5
 INFOstr = [];    % turn this off quickly if desired 
	
hubmon	= sdata.DATA(:,chan2col(sdata.collabels,'hubmon'));
MONave 	= mean(hubmon);
%valve_p	= sdata.DATA(:,chan2col(sdata.collabels,'valve_p'));
%valve_v	= sdata.DATA(:,chan2col(sdata.collabels,'valve_v'));
%secperpoint	= sdata.DATA(:,chan2col(sdata.collabels,'Seconds'));
secperpoint	= sdata.DATA(:,chan2col(sdata.collabels,'Sec'));
timestampSpec	= sdata.DATA(:,chan2col(sdata.collabels,'Time'));
timestampEpoch  = sdata.DATA(:,chan2col(sdata.collabels,'Epoch'));

% for norm use mean hexmon - since slit size changes a lot
% we do not use the stated hex100mA from run params
hex100mA = MONave./mean(secperpoint); 
	
if timestampX_flag==0
	timestampX = timestampSpec + timestampEpoch(1);
end

timeX = timestampX - timestampX(1); % from start of scan

% I = Iraw * Norm	
Norm	= hex100mA .* secperpoint ./ hubmon(:,1);   % sometimes extra columns appear with hexmon

if 1
% Find valve switch points  (note that this output 
%		1st point is 0th point (like spec)
%lastframes = find(diff(valve_p)~=0);
lastframes = [];
%disp(['Last frames (Spec point number convention) before valve switches: ' num2str(lastframes')]);
if numel(lastframes) == 0
    %lastframes = [1 length(valve_p)-1];
    lastframes = [1 length(hubmon)-1];
end
if numel(lastframes) == 1
    %lastframes = [lastframes length(valve_p)-1];
    lastframes = [lastframes length(hubmon)-1];
end
end

if isempty(Xstepcol); Xstepcol=1;end   % use scan variable
	 
if Xstepcol<1
	SCNXLABEL = 'spec point # ';
else
	SCNXLABEL	= col2chan(sdata.collabels,Xstepcol);  
end
	
if strncmp(SCNXLABEL,'Time',4) 
	SCNXLABEL	= [SCNXLABEL,' [\Delta sec] from SpecFile '];  % in pixirad, 
	Xsteps	= timeX;
elseif Xstepcol<1
	Xsteps	= [0:length(timestampX)-ImageJ];  
else
	Xsteps	= sdata.DATA(:,Xstepcol);
end
	
% Express time axis in sec from start

% Xamount = tamount*(Xsteps - (lastframes(1) + delay))/(diff(lastframes) - delay);
Xamount = timeX;

if isempty(POINTSUMS)
    POINTSUMS=[1 Nt] - ImageJ;
end

SPECpts = [1:Nt] - ImageJ;
YROWpts = [1:Nr] - ImageJ;  
XCOLpts = [1:Nc] - ImageJ;
	
% normalize, bkg, flatfield

IInorm = NaN*ones(size(II));
for ii=1:Nt % could be Nt
	IInorm(:,:,ii)	= II(:,:,ii) .* Norm(ii);
end
% Calculate mean background image
if isempty(BKG)
	IIimbkg = 0;
else
	IIimbkg	= mean(IInorm(:,:,[BKG(1):BKG(2)]+ImageJ),3);
end
		
% correct for bkg and flatfield
if 0
IInormb = NaN*ones(size(II));
for ii=1:Nt;		
	IInormb(:,:,ii)	= (IInorm(:,:,ii)- IIimbkg)./imnormnan;
end
end
IInormb = IInorm;

DOCUInt = '[No FF]';

if 0
% Getting some pixels that fluctuate high for a single time point, e.g.
% 414 232
% Locate by looking for big changes in time
disp('Fixing single-point fluctuations');
dI = diff(IInormb,1,3);
if flimsd_flag
% Could assume pattern fairly stable in time, normal fluctuations are counting
% statistics
    mI = mean(IInormb,3);
    flim = flimsd*sqrt(mI);
else
% Alternately, just look for big ones
flim = flimc;
end
Nfluct = 0;
for ii = 1:Nt
    if ii == 1
        fluct = dI(:,:,1)<-flim;
        Ibase = IInormb(:,:,1);
        Ifix = IInormb(:,:,2);
        Ibase(fluct) = Ifix(fluct);
        IInormb(:,:,1) = Ibase;
    elseif ii == Nt
        fluct = dI(:,:,Nt-1)>flim;
        Ibase = IInormb(:,:,Nt);
        Ifix = IInormb(:,:,Nt-1);
        Ibase(fluct) = Ifix(fluct);
        IInormb(:,:,Nt) = Ibase;
    else
        fluct = dI(:,:,ii)<-flim | dI(:,:,ii-1)>flim;
        Ibase = IInormb(:,:,ii);
        Ifix = (IInormb(:,:,ii-1)+IInormb(:,:,ii+1))/2;
        Ibase(fluct) = Ifix(fluct);
        IInormb(:,:,ii) = Ibase;
    end
    Nfluct = Nfluct + sum(fluct(:)); 
end
disp([num2str(Nfluct) ' found.']);
end

return

