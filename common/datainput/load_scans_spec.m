function [LABELS,INTEREST] = load_scans_spec(filenames,sSCNNUMS,RUNPARAMS,DOCU,FORCE);
eval(RUNPARAMS);
SCNNUMS = eval(sSCNNUMS);

if nargin<5;FORCE.FLAG=0;FORCE.X='none';end

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
% runparams sets the correct one for readspechelper via a str2func
[OM,scninfo,OMspecial] = readspechelper(scnheader,fileheader,surroundingcomments);
		% note    HKL at start of scan is    scninfo.HKL_i	
    
    % I use SCNFLAG here, so that I can tweak here if 
	% I want to make more complicated, and here it
	% is easier to add whether I want h or l scan if it
	% says hklscan

	if ~isempty(findstr(SCNTYPE,'tseries'))|~isempty(findstr(SCNTYPE,'loopscan'));
	
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
IY	= [IY, IYii];
HL	= [HL;HLii];
X 	= [X;Xii];
H	= [H;Hii];
K	= [K, Kii];
L	= [L, Lii];
SCNPTS  = [SCNPTS;SCNPTSii];
EPOCH	= [EPOCH;DATA(:,chan2col(LABELS,'Epoch'))];

end
% in case people put scnnums in column
SCNNUMS = reshape(SCNNUMS,1,length(SCNNUMS));

TITLESTRING = strvcat(...
	[pfilename(filenames(1,:)),' #',(sSCNNUMS),' at ',SCNDATE],...
	[pfilename(SCNTYPE)],...
	[pfilename(DOCU)]);
title(TITLESTRING)

% the following adjusts paper size of the plot, and
% adjusts other prettiness, so that the three lines
% in the title will appear on the plot
plotstuff_forrun(gca,1);
set(gca,'Userdata',[X H K L]);

INTEREST.IY =IY;
INTEREST.X = X;
INTEREST.H = H;
INTEREST.K = K;
INTEREST.L = L;
INTEREST.SCNPTS = SCNPTS;
INTEREST.HL = HL;
INTEREST.title = TITLESTRING;
INTEREST.Xname = Xname;
INTEREST.LABELS = Ylabeltext;

