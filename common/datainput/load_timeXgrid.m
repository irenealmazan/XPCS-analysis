% script to load th scans grids scans and look at it
% run from the datainput.m file, but this has the guts
% Altered 07-14-02 Paul Fuoss to try to allow scp done on fly 
% Moved the scp on fly code to its own function (scpreadspecscan
% and added capability of checking whether file exists in that code
% CT 07-21-02
% also made sure that if kscans go backwards and forwards, that they
% are put in the final matrix in ascending order, so plots come out OK
% User still needs to make sure that L values go in consistent order
% CT 11/05 works with new scheme of getting data paths
% CT 11/05 added way for time to get 
% CT 11/06 used to make load_tablegrid  % this was was altered to 
% be able to have Z as fluoresence
% CT 11/06 overwrote old load_timeXgrid to use work existing in load_tablegrid
% which has some ability to plot different things for Z, and
% CT 2/08 changed plotdata to plotdata_image which will use detoffset
% CT 2/08 changed so uses SCNDOCU instead of printing out min max scan



% add extra documentation about TEL, temp, etc
docuextra
eval(RUNPARAMS)
% find DATApath from current use
[DATApath,ANALYSISpath,COMMONpath,HOMEpath,CURRENTpath] = pathdisplay;                                

% do this in calling program in case want to add several plots on each
%figure(gcf);clf
%HA = axes;

% to read in growth or hklscans scan
% if the scans are the same type (all hklscans, or all tseries)
% it is possible to enter several scan numbers at once to be plotted on
% top of each other

if length(filename(:,1))==1;
	filenamematrix = char(ones(length(SCNNUMS),1)*filename);
else
	filenamematrix = filename;
end

IY=[];X=[];H=[];K=[];L=[];eT=[];FLD=[];NNDX=[];FLUOR=[];
clear XX HH KK JJ LL II eTeT NNDXNNDX FF XXX YYY III;

for ii = 1:length(SCNNUMS);

% scpreadspecscan will see if file exists or if scans are up to date
% NOTE, for plotting fluor, can only do one at a time, it will pick whatever if first if there is more than one
[DATA,dum,SCNTYPE,SCNDATE,dum,LABELS] =  ...
		scpreadspecscan(DATApath,filenamematrix(ii,:),SCNNUMS(ii));
        if ~isempty(FLUORname) & plotfluorflag==2
        FLUORii = DATA(:,chan2col(LABELS,FLUORname(1,:)));
        elseif ~isempty(FLUORname) & plotfluorflag==3
        FLUORii = DATA(:,chan2col(LABELS,FLUORname(1,:)))./(DATA(:,chan2col(LABELS,monname)));        
        else  %(just to keep the program running without faulting but no useful into
        FLUORii = DATA(:,chan2col(LABELS,monname));
        end
	% I use SCNFLAG here, so that I can tweak here if 
	% I want to make more complicated, and here it
	% is easier to add wheterh I want h or l scan if it
	% says hklscan
    % Note, in the following there are scans made, but they are 
    % overwritten at the end

	if ~isempty(findstr(SCNTYPE,'tseries')|findstr(SCNTYPE,'loopscan'));
	
	SCNFLAG = 'GROW';
	[IYii,Xii,Hii,Kii,Lii] = plotdata_image(DATA,SCNFLAG,LABELS,RUNPARAMS,PLOT);
	NNDXii=SCNNUMS(ii)*ones(size(IYii));
	elseif ~isempty(findstr(SCNTYPE,'hklscan'));
	
	SCNFLAG = 'HKLS';
	[IYii,Xii,Hii,Kii,Lii] = plotdata_image(DATA,SCNFLAG,LABELS,RUNPARAMS,PLOT);
	NNDXii=SCNNUMS(ii)*ones(size(IYii));
	else	
	SCNFLAG = 'NONE';
	[IYii,Xii,Hii,Kii,Lii] = plotdata_image(DATA,SCNFLAG,LABELS,RUNPARAMS,PLOT);
	NNDXii=SCNNUMS(ii)*ones(size(IYii));
	end

% This sorts in K so that if scans go positive or negative they
% will plot OK in pcolor
[Xii,INDEXsort] = sort(Xii);
eTii = DATA(INDEXsort,chan2col(LABELS,epochtimename));
FLUOR = [FLUOR;FLUORii(INDEXsort)];    
IY 	= [IY;IYii(INDEXsort)];
X 	= [X;Xii];
H	= [H;Hii(INDEXsort)];
K	= [K;Kii(INDEXsort)];
L	= [L;Lii(INDEXsort)];
eT  = [eT;eTii(INDEXsort)];
NNDX = [NNDX;NNDXii(INDEXsort)];
FLD=[FLD;DATA];
end

SSSIZE = length(Xii);
for j = 1:length(SCNNUMS);
  for ik=1:SSSIZE
    HH(ik,j) = H(ik + SSSIZE*(j-1));
    KK(ik,j) = K(ik + SSSIZE*(j-1));
    LL(ik,j) = L(ik + SSSIZE*(j-1));
    II(ik,j) = IY(ik + SSSIZE*(j-1));
    eTeT(ik,j) = eT(ik + SSSIZE*( j-1));
    XX(ik,j) = X(ik+SSSIZE*(j-1));
    NNDXNNDX(ik,j) = NNDX(ik+SSSIZE*(j-1));
    FF(ik,j) = FLUOR(ik + SSSIZE*(j-1));
  end;
end;

% for quick changes of whether to plot log intensity or not, this is best place to change
% please do not change XXX and YYY as right now we are kluging them each with different load_file
        XXX=eTeT; XDOCU = ['elapsed time [sec]'] ;
        YYY=XX;  YDOCU = col2chan(LABELS,1);

% do in do loop because there may be more than one FLUOR to be plotted
    if ~isempty(FLUORname)&(plotfluorflag==2|plotfluorflag==3)
        III=FF;         ZDOCU = ['Z= ',FLUORname(1,:)];
    else
        %III=II;         ZDOCU = 'Z= Int';
        III=log(II);   ZDOCU = 'Z= log(Int)'; 
    end

DOCUgrid = strvcat(DOCU,[pfilename(filename(1,:)),' #',SCNDOCU]);
DOCUgrid = strvcat(DOCUgrid,ZDOCU);

% Regular intensity is II, log(II) is JJ
clf
%pcolor(XXX,YYY,III);
surf(XXX,YYY,III)
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
title(DOCUgrid);set(gcf,'paperposition',[2 2 4 4]);

figure(gcf+1);clf

% Regular intensity is II, log(II) is JJ
contourf(XXX,YYY,III,10);
%axis image;
xlabel (XDOCU,'FontSize',14);
ylabel (YDOCU,'FontSize',14);
set(gca,'Userdata',[X H K L]);  % this is used in findpoint
plotstuff_forrun(gca)
set(gca,'layer','top');
title(DOCUgrid);set(gcf,'paperposition',[2 2 4 4]);
%ylabel (col2chan(LABELS,1),'FontSize',14);


