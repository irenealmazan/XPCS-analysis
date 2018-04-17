function [LEGEND,A,Agrid]=datainput_run(samplename)
%%   If you want to get at the data that is plotted, 
%%     there will be a structure called A in the workspace after running this script
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	FORCE.FLAG=0;FORCE.X='none';		%%% do not change these initialization lines
	FORCE.FLAGdet=1;FORCE.det='p_point';	%%% do not change these initialization lines
	
%	FORCE.FLAGdet=	0  whatever is in runparams as the det/(mon*time)
%			1  FORCE.det with monitor, absorption, time corrections
%			2  FORCE.det/mon
%			3  FORCE.det  no corrections
%
%	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RUNPARAMS='runparams_2017_12_huber_sput_ZnO';
MYLEGEND = [];

%fixfile;

if nargin<1;samplename='user_datainput';end

% Initialize - do not change here these are things that must be defined in sample
DOCU0 = 'a sample name ';DOCUscan = 'under these conditions';
specfilename = ['2017_1004_1']; 
FORCE.FLAG=0;  
	FORCE.X='none';   %note - there is option for 'specpoint' which then just plots point
FORCE.FLAGdet=1;
	FORCE.det=char('p_point')
SCNstr = '[15]';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%
eval(samplename);
%%%%%%%%%%%%


LEGEND0 = int2str(eval(SCNstr)');
LEGEND.scnnum = char([ones(length(eval(SCNstr)),1)*'#' LEGEND0     ]);
if length(specfilename(:,1))>1;
	LEGEND.filename = char([pfilename(specfilename) ones(length(eval(SCNstr)),1)*' ' LEGEND.scnnum MYLEGEND]);
else LEGEND.filename = [LEGEND.scnnum MYLEGEND];
end

clf
DOCU = [DOCU0,' ',DOCUscan];
[LABELS,A]=load_scans_spec_nPLOT(specfilename,SCNstr,RUNPARAMS,DOCU,FORCE);

%% likely if trying to ask for another x parameter we are trying to plot a I(L) and want log)
if ~strcmp(FORCE.X,'none')
	set(gca,'yscale','log');
end

legend(LEGEND.filename);

if nargout==3
	Agrid = A;
	LS = length(A.IY)./length(A.HL);
	Agrid.IY = reshape(A.IY,LS,length(A.HL));
	Agrid.X = reshape(A.X,LS,length(A.HL));
	Agrid.H = reshape(A.H,LS,length(A.HL));
	Agrid.K = reshape(A.K,LS,length(A.HL));
	Agrid.L = reshape(A.L,LS,length(A.HL));
	Agrid.EPOCH = reshape(A.EPOCH,LS,length(A.HL));
	figure; surface(eval(SCNS),[1:LS],log(Agrid.IY));
		xlabel('scan number'),ylabel('point in scan'),zlabel('log(I)');
		  TITLEt = pfilename(char([(specfilename),' : # ',SCNstr],[DOCU0,' ; log(',FORCE.det(1,:),'[allcorr])' ]))
		title((TITLEt));
		prettyplot(gca);
		shading flat;axis tight;
	
end




