function [LABELS,INTEREST] = load_scans_nplot(filenames,sSCNNUMS,RUNPARAMS,DOCU,FORCE);
eval(RUNPARAMS);
SCNNUMS = eval(sSCNNUMS);
% note - this one needs readspechelper (see helper file pointer in RUNPARAMS to extract info out of headers of spec)

if nargin<5;
	FORCE.FLAG=0;FORCE.X='none';
	FORCE.FLAGdet=0;FORCE.det='none';
end

[DATApath,IMAGEpath] = pathdisplay;                                

if length(filenames(:,1))==1;
	filenamematrix = char(ones(length(SCNNUMS),1)*filenames);
else
	filenamematrix = filenames;
end

IY=[];X=[];H=[];K=[];L=[];EPOCH=[];SCNPTS=[];HL=[];

for ii = 1:length(SCNNUMS);

fullname = [DATApath,filesep,filenamematrix(ii,:)];
[DATA, outpts, SCNTYPE, SCNDATE, ncols, LABELS,fileheader,scnheader,surroundingcomments] = ...
	readspecscan(fullname,SCNNUMS(ii));
	
%% specific to headers from this spectrometer 
%% (in princinple, this has pointer set up in RUNPARAMS to point to helper file for 
%% particular spectrometer (CT has ones for caxis, and for sevchex, and for zaxis)
[OM,scninfo,OMspecial] = readspechelper(scnheader,fileheader,surroundingcomments);
		% note    HKL at start of scan is    scninfo.HKL_i	
    
    % I use SCNFLAG here, so that I can tweak here if 
	% I want to make more complicated, and here it
	% is easier to add whether I want h or l scan if it
	% says hklscan

	if ~isempty(findstr(SCNTYPE,'tseries'))|~isempty(findstr(SCNTYPE,'loopscan'))|~isempty(findstr(SCNTYPE,'trigger'));
	
	SCNFLAG = 'GROW';
	[HLii,IYii,Xii,Hii,Kii,Lii,Xname,Ylabeltext] = plotdata_image(DATA,SCNFLAG,LABELS,RUNPARAMS,scninfo.HKL_i,FORCE);
	
	elseif ~isempty(findstr(SCNTYPE,'hklscan'));
	
	SCNFLAG = 'HKLS';
	[HLii,IYii,Xii,Hii,Kii,Lii,Xname,Ylabeltext] = plotdata_image(DATA,SCNFLAG,LABELS,RUNPARAMS,scninfo.HKL_i,FORCE);
	
	else	
	SCNFLAG = 'NONE';
	[HLii,IYii,Xii,Hii,Kii,Lii,Xname,Ylabeltext] = plotdata_image(DATA,SCNFLAG,LABELS,RUNPARAMS,scninfo.HKL_i,FORCE);
	
	end
	
SCNPTSii = length(IYii);


HL	= [HL;HLii];
SCNPTS  = [SCNPTS;SCNPTSii];
X 	= [X;Xii];
IY	= [IY;IYii];
H	= [H;Hii];
K	= [K;Kii];
L	= [L;Lii];
EPOCH	= [EPOCH; DATA(:,chan2col(LABELS,'Epoch'))];



end

% if all SCNPTS same then likely may want a grid, then put in grid instead for output
% This needs to be fixed to use if we return multiple columns of IY (say for multiple detectors)
% I think right now I am not using this for grids
if 0
if all(diff(SCNPTS)==0)
	IY = reshape(IY,SCNPTS(1),length(SCNPTS));
	H = reshape(H,SCNPTS(1),length(SCNPTS));
	K = reshape(K,SCNPTS(1),length(SCNPTS));
	L = reshape(L,SCNPTS(1),length(SCNPTS));
	EPOCH = reshape(EPOCH,SCNPTS(1),length(SCNPTS));
	X = reshape(X,SCNPTS(1),length(SCNPTS));
end

% in case people put scnnums in column
SCNNUMS = reshape(SCNNUMS,1,length(SCNNUMS));

end

TITLESTRING = strvcat(...
	[pfilename(filenames(1,:)),' #',(sSCNNUMS),' at ',SCNDATE],...
	[pfilename(SCNTYPE)],...
	[pfilename(DOCU)]);
title(TITLESTRING)

% the following adjusts paper size of the plot, and
% adjusts other prettiness, so that the three lines
% in the title will appear on the plot
plotstuff_forrun(gca,1);
%set(gca,'Userdata',[X H K L]);

INTEREST.IY =IY;
INTEREST.X = X;
INTEREST.H = H;
INTEREST.K = K;
INTEREST.L = L;
INTEREST.EPOCH = EPOCH;
INTEREST.SCNPTS = SCNPTS;
INTEREST.HL = HL;
INTEREST.title = TITLESTRING;
INTEREST.Xname = Xname;
INTEREST.LABELS = Ylabeltext;

