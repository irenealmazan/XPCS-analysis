function [LABELS,INTEREST] = load_scans_spec(filenames,sSCNNUMS,RUNPARAMS,DOCU,FORCE);
% all the scans must have the same number of points or there is trouble

if nargin<5;FORCE.FLAG=0;FORCE.X='X';FORCE.Y=etimename;FORCE.Z=detname;end

eval(RUNPARAMS);
SCNNUMS = eval(sSCNNUMS);
[DATApath,IMAGEpath] = pathdisplay;    

if length(filenames(:,1))==1;
	filenamematrix = char(ones(length(SCNNUMS),1)*filenames);
else
	filenamematrix = filenames;
end

IY=[];X=[];H=[];K=[];L=[];EPOCH=[];SCNPTS=[];

for ii = 1:length(SCNNUMS);

fullname = [DATApath,filesep,filenamematrix(ii,:)];
[DATA, outpts, SCNTYPE, SCNDATE, ncols, LABELS,fileheader,scnheader,surroundingcomments] = ...
	readspecscan(fullname,SCNNUMS(ii));
	
%% specific to headers from this spectrometer (pointer to appropriate function file in RUNPARAMS
[OM,scninfo,OMspecial] = readspechelper(scnheader,fileheader,surroundingcomments);
		% note    HKL at start of scan is    scninfo.HKL_i	
    
    % I use SCNFLAG here, so that I can tweak here if 
	% I want to make more complicated, and here it
	% is easier to add whether I want h or l scan if it
	% says hklscan

%	HKLdocu = sprintf(': H=%7.4f K=%7.4f L=%7.4f',HKLinit(1),HKLinit(2),HKLinit(3));
	[IYii,Xii,Hii,Kii,Lii,Xname,Ylabeltext] ... 
		= plotdata_grid(DATA,SCNFLAG,LABELS,RUNPARAMS,scninfo.HKL_i,FORCE);
	
	SCNPTSii = length(IYii);
	IY	= [IY, IYii];
	X 	= [X, Xii];
	H	= [H, Hii];
	K	= [K, Kii];
	L	= [L, Lii];
	SCNPTS  = [SCNPTS, SCNPTSii];
	EPOCH	= [EPOCH, DATA(:,chan2col(LABELS,'Epoch'))];

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

INTEREST.Z =IY;
INTEREST.X = X;
INTEREST.Y = Y;
INTEREST.SCNPTS = SCNPTS;
INTEREST.HL = [];
INTEREST.title = TITLESTRING;
INTEREST.Xname = Xname;
INTEREST.LABELS = Ylabeltext;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
surf(X,Y,IY)
shading interp;
%axis image;
xlabel (XDOCU,'FontSize',14);
ylabel (YDOCU,'FontSize',14);
set(gca,'Userdata',[X H K L]);  % this is used in findpoint
colormap jet;
% the following adjusts paper size of the plot, and
% adjusts other prettiness, so that the three lines
% in the title will appear on the plot
plotstuff_forrun(gca);
set(gca,'layer','top');
title(DOCU);set(gcf,'paperposition',[2 2 4 4]);

figure(gcf+1);clf

% Regular intensity is II, log(II) is JJ
contourf(X,Y,IY,10);
%axis image;
xlabel (XDOCU,'FontSize',14);
ylabel (YDOCU,'FontSize',14);
set(gca,'Userdata',[X H K L]);  % this is used in findpoint
plotstuff_forrun(gca)
set(gca,'layer','top');
title(DOCUgrid);set(gcf,'paperposition',[2 2 4 4]);
%ylabel (col2chan(LABELS,1),'FontSize',14);

HKLdocu = sprintf(': H=%7.4f K=%7.4f L=%7.4f',HKLinit(1),HKLinit(2),HKLinit(3));

end
%%%%%%%%%%  HELPER FUNCTION %%%%%%%%%%%%
function [HLii,IYii,Xii,Hii,Kii,Lii,Xname,Ylabeltext] ... 
		= plotdata_grid(DATA,SCNFLAG,LABELS,RUNPARAMS,scninfo.HKL_i,FORCE);
