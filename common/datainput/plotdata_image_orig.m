function [HL1,IY,X,H,K,L,Xname,LABELTEXT] = plotdata(DATA,SCNFLAGS,LABELS,RUNPARAMS,HKLinit,FORCE)
PRESET = 1;

if nargin<6, 
	FORCE.FLAG=0;FORCE.X='none';
	FORCE.FLAGdet=0;FORCE.det='none';
end



%FORCE.X would change 

% to get the current stuff needed for the run
% in way of names of channels, and normalization stuff
eval(RUNPARAMS);

% general data that is in all scans
detC 	= chan2col(LABELS,detname);
monC 	= chan2col(LABELS,monname);
secC	= chan2col(LABELS,timename);


%% took out all options of various ways to show I (that used to be yflag
%% started putting back in
	if ~isfield(FORCE,'FLAGdet');FORCE.FLAGdet=0;FORCE.det='none';end
	
	if FORCE.FLAGdet==1
	detC 	= chan2col(LABELS,FORCE.det);
	filtC	= chan2col(LABELS,filtername);
	IY = DATA(:,detC).*filter_correction(DATA(:,filtC),filter1,filtercorr)./(DATA(:,secC).*DATA(:,monC));
	YLABELTEXT = ['Int = ' pfilename(FORCE.det) '(filtercorrected )/(time*' pfilename(monname),')'];
	
	elseif FORCE.FLAGdet==2
	detC 	= chan2col(LABELS,FORCE.det);
	YLABELTEXT = ['Int = ' pfilename(detname) '/ ' pfilename(monname)];
	IY = DATA(:,detC)./DATA(:,monC);
	
	elseif FORCE.FLAGdet==3
	detC 	= chan2col(LABELS,FORCE.det);
	YLABELTEXT = ['Int = ' pfilename(detname)];
	IY = DATA(:,detC);	

	else
	YLABELTEXT = ['Int = ' pfilename(detname) '/(time*' pfilename(monname),')'];
	IY = DATA(:,detC)./(DATA(:,secC).*DATA(:,monC));
	end

%IY(find(IY<0))=zeros(size(find(IY<0)));

MaxI		= max(IY);
MinI		= min(IY);
if length(IY)>15;
    StartI		= mean(IY(1:5));
else 
    StartI  = mean(IY);
end

if 	~isempty(findstr(SCNFLAGS,'GROW'));

		etimeC	= chan2col(LABELS,etimename);
		X 	= DATA(:,etimeC); 
		H = HKLinit(1)*ones(size(X));
		K = HKLinit(2)*ones(size(X));
		L = HKLinit(3)*ones(size(X));
		HKLdocu = sprintf(': H=%7.4f K=%7.4f L=%7.4f',HKLinit(1),HKLinit(2),HKLinit(3));
		if ~FORCE.FLAG
			Xname = etimename;
			XLABELTEXT = [etimename,' [sec] at ',HKLdocu];
		else 
			Xname = FORCE.X;
			X = DATA(:,chan2col(LABELS,Xname));
			XLABELTEXT
		end
        


elseif 	~isempty(findstr(SCNFLAGS,'HKLS'));
		HC = chan2col(LABELS,hname);
		KC = chan2col(LABELS,kname);
		LC = chan2col(LABELS,lname);
		H = DATA(:,HC);
		K = DATA(:,KC);
		L = DATA(:,LC);
		HKL = [H K L];
		HKLdocu = [	'h'
				'k'
				'l'];
		if ~FORCE.FLAG | isempty(chan2col([hname '  ' kname '  ' lname],FORCE.X)) 
		%not forced to be a particular HKL 
			% here I am trying to make a way to figure out
			% which was most 'interesting' hkl from which
			% one varied the most
			DIFFH = max(H) - min(H);
			DIFFK = max(K) - min(K);
			DIFFL = max(L) - min(L);
			% can use SCNHKL to pick out correct xlabel
			% and the correct HKL column to plot

			[dum,SCNHKL] = max([DIFFH  DIFFK  DIFFL]);
			SCNHKL = SCNHKL(1);
			X = HKL(:,SCNHKL);
			Xname = [HKLdocu(SCNHKL)];
		else 
			Xname = FORCE.X;
			X = HKL(:,chan2col([hname '  ' kname '  ' lname],Xname));
		
		end
		XLABELTEXT = Xname;

else		% probably an ascan of some type

		if FORCE.FLAG 
			XC = chan2col(LABELS,FORCE.X);
			Xname = col2chan(LABELS,XC);
		else XC=1;
			% the following should work if in all other scans
			% the columns following the X will be H K L
			% that seems to be the case for most of the ascans
			% this documents all the moving motors
			Xname = LABELS(1:(findstr(LABELS,hname)-1));
			Xname = col2chan(LABELS,XC);
		end
		X = DATA(:,XC);
		H = DATA(:,chan2col(LABELS,hname));
		K = DATA(:,chan2col(LABELS,kname));
		L = DATA(:,chan2col(LABELS,lname));
		HKLdocu = sprintf(': [H=%7.4f K=%7.4f L=%7.4f]',H(1),K(1),L(1));
	
		XLABELTEXT = [Xname ' at ',HKLdocu];
		
end


% PLOTTING SEQUENCE
% separated out to make it easier to change and tweak
% or for later split of this program into data analysis and
% data plotting

if 	~isempty(findstr(SCNFLAGS,'GROW'));

	HL1 = line(X,IY);
	makecolor(HL1);


elseif 	~isempty(findstr(SCNFLAGS,'HKLS'));

	HL1 = line(X,IY);
	set(gca,'Yscale','log');
	makecolor(HL1);

else

	HL1 = line(X,IY);
	makecolor(HL1);

end

	makecolor(HL1);
	ylabel(YLABELTEXT);
	xlabel(XLABELTEXT);

LABELTEXT.X = XLABELTEXT;
LABELTEXT.Y = YLABELTEXT;

XLIM = [min(X) max(X)];	
YLIM = [min(IY) max(IY)];  TEST=diff(YLIM);  
    if TEST~=0; YLIM = YLIM.*[0.98 1.02];else YLIM = YLIM + [-1 1];end
set(gca,'Xlim',XLIM,'Ylim',YLIM);

end
%%%%%%%%%%  HELPER FUNCTIONS %%%%%%%%%%%%%
function [COLORS] = makecolor(HL)

COLORS = [1 1 1];
while mean(COLORS)>0.9;  % keep doing it until it is not too light colored)
COLORS = rand(1,3);
end
set(HL,'color',COLORS);

end
