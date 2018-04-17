
[SPECpath,AREApath,COMMONpath,HOMEpath] = pathdisplay;
eval(RUNPARAMS);

%specfilename = '2016_1015_2';
HDFfilename = specfilename;
%DOCU0  = 'n161012a (AH1385.10.2) m-plane GaN';

%clear Iwin Iwinnorm;
HLine=[];HSurf=[];HS_SoX=[];

if HDF5==1   % not really used, but legacy for when using pixirad with windows
	STR.scanflag=1;
	STR.imname=[];
	STR.SPECpath=DATApath;
	STR.AREApath=AREApath;
	STR.p_image=[];
	STR.ending='.h5';
else  % medipix, pilatus, all saved in tif thus far (usually)
	STR.scanflag=1;
	STR.imname=[];      % image names use standard unique naming schemes
%	STR.imname='pil_';  % caxis non-unique naming scheme for images (sigh) 
	STR.SPECpath=DATApath;
	STR.AREApath=AREApath;   % need to change pathdisplay if need pilatus
	STR.p_image=['p_image'];   %% STR.p_image=[] if it uses the preferred points instead
	STR.ending='.tif';
end

ImageJ = 0; %Irene has change this% true - using imageJ indexing [start at 0] when denoting ROIs and when plotting pixels
%	This applies to AXISdet and ROI values so must be consistent.

% FORCE only one scan at a time
SCNs = eval(SCNstr);SCNs = SCNs(1); 

if strncmp('caxis',SCNFUNC,min([length('caxis') length(SCNFUNC)]));  % which diffractometer
	readspechelp = str2func('readspec_caxis_v4_helper');
	INFOinterest = ['Sam_Z  stemp  Chi  Eta'];     %!!! put 2 spaces between each!!!!
	STR.imname='pil_';  % caxis non-unique naming scheme for images (sigh) 
else
	readspechelp = str2func('readspec_sevc_v6_helper');
	INFOinterest = ['s6vgap  s6hgap  Phi  TZ  TY  Chi  Eta  Delta  Nu  TX'];     %!!! put 2 spaces between each!!!!
	STR.imname=[];  % standard unique naming scheme for images
end

%----------  Make the matrix of the names for the images, note sdata holds information from spec file
[NameMatrix,sdata]	= make_imnames_2017_07(HDFfilename,SCNs,STR);
FullNameHDF 		= addnames2matrix([STR.AREApath,filesep],NameMatrix.fullfilenames);

%----------  At this point can pull out quite a bit from the spec file (in sdata)
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
	
	secperpoint		= sdata.DATA(:,chan2col(sdata.collabels,timename));
	timestampSpec	= sdata.DATA(:,chan2col(sdata.collabels,etimename));
	timestampEpoch  = sdata.DATA(:,chan2col(sdata.collabels,epochtimename));
	filterpoint  	= sdata.DATA(:,chan2col(sdata.collabels,filtername));
	Monitor			= sdata.DATA(:,chan2col(sdata.collabels,monname));
	MONave 			= mean(Monitor(:,1));  %% occasionally counters in more than one column
	mon100mA 		= MONave./mean(secperpoint);  %do not use RUNPARAM- since slit size changes a lot
	meansecperpoint = mean(secperpoint);

	%---- get the normalization corrections ready
	if NORMFLAG == 1;	
	Norm = MONave .* meansecperpoint .* filter_correction(filterpoint,filter1,filtercorr)./(secperpoint.*Monitor(:,1));
	NORMdoc = ['Norm = monave*secperpointave*filtercorrection/(sec per point * Monitor per point): WITH filter correction'];
	else 
	Norm = MONave .* meansecperpoint ./(secperpoint.*Monitor(:,1));
	NORMdoc = ['Norm = monave*secperpointave*meansecperpoint/(sec per point * Monitor per point): No filter correction'];
	end
	disp(char('* *','Normalization that is used is as follows',NORMdoc,'* *'));


%---------   Read the images
if HDF5~=0;  % assume HDF5 was pixirad in windowing form
	[Iwin,timestampX,IColors] = loadhdf5_CT(FullNameHDF,[LOWHIGH]);
	timestampX_flag = 1;  % time stamp flag has good time resolution and is precise
	% also cannot be changed by resaving file
	THRESHusedoc = [' {',THRESHuse, '} '];
else
	%[Iwin,timestampX] = load_MPX3(FullNameHDF);
    [Iwin,timestampX] = load_MPX3_singletiff(FullNameHDF,[],[],SINGLE);
    %[Iwin,timestampX] = load_MPX3_Irenetest(FullNameHDF);
	% The following are not used for tifs, only for pixirad in window mode
	% Note the timestamp for the medipix is only to 1 second, not to milliseconds
	% So need to use the spec information for time.
	% timestamp for medipix also weird in 2017-08
	Icolors = [];
	THRESHuse = [];   %% hardwiring to not use the pixirad high low, etc
	THRESHusedoc = [];
	timestampX_flag = 0;   % timestamp flag from tif is not great, keep using spec
end

HSurf.Iwin = Iwin;

if ~LOGFLAG
	DOCUInt = ['Inorm',THRESHusedoc];
else
	DOCUInt = ['log10(Inorm',THRESHusedoc,')'];
end

if FLATFIELDFLAG
	DOCUInt = [DOCUInt,'[FF]'];
end

TITLEstr1 = char(...
		[pfilename(HDFfilename),' #', SCNstr,' : ', sdata.SCNDATE],...
		[pfilename(sdata.SCNTYPE)],...
		[pfilename(DOCU0),' ',pfilename(DOCUscan)]);

TITLEstrshort = char(...
		[pfilename(HDFfilename),' #',SCNstr,' : ',DOCUInt],...
		[pfilename(sdata.SCNTYPE)]);
		

%------------   If keeping track of valves to plot
if ~strncmp('caxis',SCNFUNC,min([length('caxis') length(SCNFUNC)]));  % which diffractometer

	valve_p	= sdata.DATA(:,chan2col(sdata.collabels,'valve_p'));
	valve_v	= sdata.DATA(:,chan2col(sdata.collabels,'valve_v'));
	lastframes = find(diff(valve_p)~=0);
	disp(['Last frames (Spec point number convention) before valve switches: ' num2str(lastframes')]);
else valve = sdata.DATA(:,chan2col(sdata.collabels,valvename));
	lastframes = find(abs(diff(valve))>=diffvalve);
	disp(['Last frames (Spec point number convention) before valve switches: ' num2str(lastframes')]);
end  
	
		if timestampX_flag==0;
			timestampX = timestampSpec + timestampEpoch(1);
		end
	

%	if isempty(Xstepcol); Xstepcol=1;end   % use scan variable
%	 
%		if Xstepcol<1;
%			SCNXLABEL = 'spec point # ';
%		else
%			SCNXLABEL	= col2chan(sdata.collabels,Xstepcol);  
%		end
%	
%		if strncmp(SCNXLABEL,'Time',4); 
%			SCNXLABEL	= [SCNXLABEL,' [\Delta sec] from SpecFile '];  % in pixirad, 
%			Xsteps	= timestampX-timestampX(1);
%		elseif Xstepcol<1;
%			Xsteps	= [0:length(timestampX)-ImageJ];  
%		else
%			Xsteps	= sdata.DATA(:,Xstepcol);
%		end

	if FORCE.FLAG; %Xstepcol=1;end   % use scan variable	 
		if strfind(FORCE.X,'specpoint')
			SCNXLABEL = 'spec point # ';
			Xstepcol=-1;
		else
			SCNXLABEL	= FORCE.X;
			Xstepcol = chan2col(sdata.collabels,FORCE.X); 
				if isempty(Xstepcol);disp('ERROR: asking for Xaxis not present in file');end
		end	
	else
		Xstepcol = 1;
		SCNXLABEL = col2chan(sdata.collabels,1); 
	end
	
	if strncmp(SCNXLABEL,etimename,4); %usually the elapsed time name is 'Time'
		SCNXLABEL	= [SCNXLABEL,' [\Delta sec] from SpecFile '];  % in pixirad, 
		Xsteps	= timestampX-timestampX(1);
	elseif Xstepcol<1;
		Xsteps	= [1:length(timestampX)]-ImageJ;     
	else
		Xsteps	= sdata.DATA(:,Xstepcol);
	end

	

%	Here we are being consistent with enumeration in SPEC points and ImageJ
%		ImageJ convention is used in the SPEC ROI's and EPICS ROIs images
%		SPEC convention is used in its points when we 'write' down a data point
% ImageJ = 1 % using ImageJ convention, ImageJ=0 use matlab convention
%		matlab convention numbering starts from 1, not 0 
%			from the screen	
	SPECpts = [1:(length(Xsteps))]-ImageJ;
	YROWpts = [1:(length(Iwin(:,1,1)))]-ImageJ;  
	XCOLpts = [1:(length(Iwin(1,:,1)))]-ImageJ;
	
	Nr = length(YROWpts);Nc = length(XCOLpts);Nt = length(SPECpts);
	
% make some of the images to be ready for other work, some is legacy from pixirad windowing

		if strncmp(THRESHuse,'low',3)
			II = IColors.low;
		elseif strncmp(THRESHuse,'hig',3)
			II = IColors.high;
		else
			II = Iwin;
			%THRESHuse = 'win';  % default if pixirad in windowed versoin
			THRESHuse = [];
		end
				
		for ii=1:length(Iwin(1,1,:));
			IInorm(:,:,ii)		= II(:,:,ii) .* Norm(ii);
			Iwinnorm(:,:,ii)	= Iwin(:,:,ii) .* Norm(ii);
		end
		% Calculate mean background image
		if isempty(BKG)
			IIimbkg = 0;
			Iwinimbkg = 0;
		else
			IIimbkg		= mean(IInorm(:,:,[BKG(1):BKG(2)]+ImageJ),3);
			Iwinimbkg	= mean(Iwinnorm(:,:,[BKG(1):BKG(2)]+ImageJ),3);
		end
		
		% note if FLATFIELDflag=0; then user_input should make FLATFIELD=1;
		for ii=1:length(Iwin(1,1,:));		
			IInormb(:,:,ii)		= (IInorm(:,:,ii)	- IIimbkg)./FLATFIELD;
			Iwinnormb(:,:,ii)	= (Iwinnorm(:,:,ii)	- Iwinimbkg)./FLATFIELD;
		end



%%%%  CT took out the minus flags choices(used for the pixirad and windowing) %%%
%%%% and put in them in a separate script, I will comment it out as we are not using it
%%%% for the medipix anyway but it helps clean up this frankenstein file

%user_input_guts_MPX3_minusflags

%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if any(WhatToDo==0); 

	if ~LOGFLAG
		figure;clf
		set(gcf,'Name',['Lin Image',THRESHusedoc,' Spec # ' int2str(SINGLE)]);
		HS = pcolor(XCOLpts,YROWpts,(IInormb(:,:,SINGLE+ImageJ)));
		shading interp
		HSurf.IInormb = HS;
        
        
		
			
			if ~ASPECTflag
			axis equal;
			else
			HA = gca;
			daspect(gca,ASPECT);   %this might not be in earlier version
			HA = gca;
			set(HA,'DataAspectRatioMode','manual','DataAspectRatio',[ASPECT]);
			end
			
			if ~isempty(AXISdet); axis(AXISdet);end
			if ~isempty(CLIMlin); 
				set(gca,'clim',CLIMlin);
				DOCUclim = mDOCUclim(CLIMlin);
			end;
    else
        for ii = 1:numel(SINGLE)
            figure;clf
            set(gcf,'Name',['Log10 Image',THRESHusedoc,' Spec #' int2str(SINGLE(ii))]);  % assumes SINGLE in spec/ImageJ
            HS = pcolor(XCOLpts,YROWpts,log10(fixlogimage((IInormb(:,:,ii+ImageJ)))));
            shading flat
            HSurf.IInormb = HS;
            
            
            if ~ASPECTflag
                axis equal;
            else
                HA = gca;
                daspect(gca,ASPECT);   %this might not be in earlier version
                HA = gca;
                set(HA,'DataAspectRatioMode','manual','DataAspectRatio',[ASPECT]);
            end
            
            
            if ~isempty(AXISdet), axis(AXISdet);end
            if ~isempty(CLIMlog);
                set(gca,'clim',CLIMlog);
                DOCUclim = mDOCUclim(CLIMlog);
            end;
        end
	end
	
	DOCUlast = ['(Spec pt #',int2str(SINGLE),') ', DOCUInt, DOCUclim];
	title(char(TITLEstr1,DOCUlast,pfilename(INFOstr)));
	xlabel(XCOL);ylabel(YROW);
	prettyplot(gca,[2 2 4 3.8]);
end	


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if any(WhatToDo==1) %& ~isempty(ROIS) %% open up make ROIS
	myROIS = makerois(4,gcf);
	xlabel(XCOL);ylabel(YROW);  % must have done the WhattoDo =0
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if any(WhatToDo==2)

	[HROI,COLORORDER] = showrois(ROIS,gcf);
		
		figure;clf;
		set(gcf,'Name','Enumeration of ROIs colors');

		prettyplot(gca);    % put here or it clobbers the showROIS colororder 		
		showrois(ROIS,gcf,2,COLORORDER);
		title('Enumeration of the ROIs and their colors');

		axis equal;
		if ~isempty(AXISdet); 
			axis(AXISdet);
		else
			axis([min(XCOLpts) max(XCOLpts) min(YROWpts) max(YROWpts)]);
		end

			LEGEND = [char([ones(length(HROI),1)*'ROI #']) int2str([1:length(HROI)]')];
			legend(LEGEND);
			xlabel(XCOL);ylabel(YROW);  % must have done the WhattoDo =0
		
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if any(WhatToDo==3)  %% make movie  (frame must be 560x413?)
	figure;clf;figure(gcf);
	set(gcf,'Name',['MOVIE ' THRESHusedoc]);
	% set up initial size and image and climits  (Default SINGLE is 0 (spec point + ImageJ = matlab point)
	%	
	% Note that video get upset if size changes of image some of this is to 
	% try to make sure this doesn't happen but it still happens and I 
	% don't know how to fix at times except to keep trying again (magic)
	%clear HS;
	HS = pcolor(XCOLpts,YROWpts,log10(fixlogimage(IInormb(:,:,SINGLE+ImageJ))));  
	DOCUInt3 = [' log10(Inorm) '];
	shading flat
		HT = title(...
			char([TITLEstrshort],...
			['Spec Pt # [ 00000 ] : step =  [0000000]',mDOCUclim(CLIMlog)]));	

		if ~ASPECTflag
		axis equal;
		else
			HA = gca;
			daspect(gca,ASPECT);   %this might not be in earlier version
			HA = gca;,
			set(HA,'DataAspectRatioMode','manual','DataAspectRatio',[ASPECT]);
		end
			
		
		xlabel(XCOL);ylabel(YROW);
		
		if MOVIEROIFLAG
			MAA = ROIS(1,:);
		else
			if ~isempty(AXISdet);
				MAA = AXISdet;
			else
				MAA = [XCOLpts(1) XCOLpts(end) YROWpts(1) YROWpts(end)];
			end
		end	

		set(gca,'xlim',MAA([1 2]),'ylim',MAA([3 4]));
		
		if ~isempty(CLIMlog); 
			set(gca,'clim',CLIMlog);
		end;
		prettyplot(gca);
		
		if any(WhatToDo==2);
			if exist('COLORORDER','var')%length(ROIS(:,1))<length(COLORORDER(:,1))
				showrois(ROIS,gcf,0.5,COLORORDER);
			else
				[HROI,COLORORDER]=showrois(ROIS,gcf,0.5);
			end
		end		
		

	% Prepare the new file.
		if exist('M1.avi')==2; delete('M1.avi'); end  
		vidObj = VideoWriter('M1.avi');
		vidObj.FrameRate = 5;		% default 30 fps


		open(vidObj);


%	for ii=1:length(timestampX)  % CT
	for ii=1:length(Xsteps);
		PTstr = int2str(ii-1+10000);PTstr = PTstr(2:end);
		
		if ~LOGFLAG
			set(HS,'CData',((IInormb(:,:,ii))));
			if ~isempty(CLIMlin); set(gca,'clim',CLIMlin);end;
		else
			set(HS,'CData',(log10(fixlogimage(IInormb(:,:,ii)))));
			if ~isempty(CLIMlog); set(gca,'clim',CLIMlog);end;
		end		
		set(HT,'String',...
			char([TITLEstrshort],...
			['Spec Pt # [',PTstr,'] : step = [',num2str(Xsteps(ii)),']',mDOCUclim(gca)]));
		currFrame = getframe(gcf);
		writeVideo(vidObj,currFrame);
	end
	
	% have short pause at end of movie while sitting on the end point
	for ii=1:3;
		currFrame = getframe(gcf);
		writeVideo(vidObj,currFrame);
	end
	
	disp('*');
	%Mov_n160208a_intval=M;
	close(vidObj);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if any(WhatToDo==4) %% make summed images 
%	ImageJ = 1;  % this must be set and be consistent earlier! 
%	ImageJ indexing (start (0,0)) in ROI indexing
	 [SIZE1,SIZE2,SIZE3]=size(IInormb);  % in case whole scan not complete
     [SoY,SoX] = slicesumrois(IInormb,ROIS,1);%(1,:));
	 %[SoY,SoX] = slicesumrois(IInormb,ROIS,ImageJ);%(1,:));
%	Note - This does not 'normalize' the slices to the number of pixels summed
%			However, after using function, use SoY.image{i}./SoY.norm{i} 
%				for ROI {i} 

    HSurf.SoY = SoY;
    HSurf.SoX = SoX;
    
for ii=N_ROIS_SUM; %1%:length(ROIS(:,1));


  if SoXFLAG
	figure;clf
	set(gcf,'Name',['SoX ROIs #' int2str(ii)]);

	 if ~LOGFLAG;
	 HS = pcolor(Xsteps,SoX.ndx{ii},((SoX.images{ii})));
	 else
	 HS = pcolor(Xsteps,SoX.ndx{ii},log10(fixlogimage(SoX.images{ii})));
     end

     HSurf.SoX_ROIS(ii) = HS;
	 HPC.SoX_ROIS(ii) = HS;
	 shading flat; 
	 xlabel(SCNXLABEL);ylabel(YROW);
	 title(char(TITLEstr1,[DOCUInt, ' summed over XCOL in ROI #' int2str(ii)]));
%	 			if ~isempty(AXISdet); set(gca,'Ylim',AXISdet(3:4));end
	 			if ~isempty(AXISdet); set(gca,'Ylim',ROIS(ii,[3:4]));end
	 prettyplot(gca)
	 	 makeyline(Xsteps(lastframes));
  end
	
  if SoYFLAG  % don't plot if SoY flag 0
	figure;clf
	set(gcf,'Name',['SoY ROIs #' int2str(ii)]');
	
	%%%% Irene change: 
    if ~LOGFLAG;
     %HS = pcolor(Xsteps,SoY.ndx{ii},((SoY.images{ii})));	
        HS =imagesc(Xsteps,SoY.ndx{ii},((SoY.images{ii})));	
     else
    % HS = pcolor(Xsteps,SoY.ndx{ii},log10(fixlogimage(SoY.images{ii})));
        HS = imagesc(Xsteps,SoY.ndx{ii},log10(fixlogimage(SoY.images{ii})));
    end
    
     HSurf.SoY_ROIS(ii).CData = HS.CData;
	 HPC.SoY_ROIS(ii) = HS;
	 shading flat; 
	 xlabel(SCNXLABEL);ylabel(XCOL);
	 title(char(TITLEstr1,[DOCUInt ' summed over YROW in ROI #' int2str(ii)]));
	 % Note Ylim in this context is on output plot not the since we put the time etc on X axis
%	 			if ~isempty(AXISdet); set(gca,'Ylim',AXISdet(1:2));end
	 			if ~isempty(AXISdet); set(gca,'Ylim',ROIS(ii,[1:2]));end
	 prettyplot(gca) 
	 	 makeyline(Xsteps(lastframes));
	 
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
	 title(char(TITLEstr1,['summed over XCOLS in all ROI and ',int2str(SIZE3),' scan pts']));
	 prettyplot(gca);  % 
		for ii=1:length(ROIS(:,1));
		set(HL(ii),'Color',COLORORDER(ii,:),'LineWidth',2);
		end
		
		HLine.SoX_SPts = HL;clear HL;
	
	end
	
% 	if SoYFLAG	
% 	figure; clf
% 	set(gcf,'Name','SoY and Sum Points ');
% 	 HL = semilogy(SoY.ndx{1},sum(SoY.images{1}'));
% 		for jj = 2:length(SoY.images);
% 			HL(jj) = line(SoY.ndx{jj},sum(SoY.images{jj}'));
% 		end
% 
% 	 xlabel(XCOL),ylabel('Int (arb)'),
% 
% 	 title(char(TITLEstr1,['summed over YROWS in all ROI and ',int2str(SIZE3),' scan pts']));
% 	 prettyplot(gca);  % 
% 		for ii=1:length(ROIS(:,1));
% 		set(HL(ii),'Color',COLORORDER(ii,:),'LineWidth',2);
% 		end
% 	 
% 		HLine.SoY_SPts = HL;clear HL;
% 	end

	if ~isempty(POINTSUMS)   % sum over points sets in POINTSUMS
	
	for jj=N_ROIS_SUM;
	
		if SoXFLAG
		figure; clf;
		set(gcf,'Name',['SoX 1st ROI and Sum select points']);
		for ii=1:length(POINTSUMS(:,1));
			Ni = [POINTSUMS(ii,1): POINTSUMS(ii,2)]+ImageJ;  %use as matlab
%			HL(ii) = line(SoX.ndx{1},sum(SoX.images{1}(:,Ni)'));
			HL(ii) = line(SoX.ndx{jj},sum(SoX.images{jj}(:,Ni)'./length(Ni)));
		end
		
		
			set(gca,'Yscale','log')
			xlabel(YROW),ylabel('Int (arb)'),
			title(char(TITLEstr1,['1st ROI summed over X, then summed over Spec Point Range']));
			prettyplot(gca);legend(addnames2matrix('sumX between [', int2str(POINTSUMS),']/Npts'))
		HLine.SoX_SoSelectPt = HL;clear HL;
		set(HLine.SoX_SoSelectPt,'linewidth',1.5);
		end
		
		if SoYFLAG

		figure; clf;
		set(gcf,'Name',['SoY 1st ROI and Sum selected points']);
		for ii=1:length(POINTSUMS(:,1));
			Ni = [POINTSUMS(ii,1): POINTSUMS(ii,2)]+ImageJ;
%			HL(ii) = line(SoY.ndx{1},sum(SoY.images{1}(:,Ni)'));
			HL(ii) = line(SoY.ndx{jj},sum(SoY.images{jj}(:,Ni)'./length(Ni)));
		end
			set(gca,'Yscale','log')
			xlabel(XCOL),ylabel('Int (arb)'),
			title(char(TITLEstr1,['1st ROI summed over Y, then summed over Spec Point Range']));
			prettyplot(gca);legend(addnames2matrix('sumY between [', int2str(POINTSUMS),']/Npts'));
		HLine.SoY_SoSelectPt = HL;clear HL;
		set(HLine.SoY_SoSelectPt,'linewidth',1.5);
		end
	end   % end of if jj
	
	end
	end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% note if the ROI has NaN in any of the pixels, this will mess up and give NaN
%%% need to fix sumrois to fix that
if any(WhatToDo==5)  %% make summed lines of ROI's on images
	figure;clf
	set(gcf,'Name','ROIs as counters');
	 
	 [sumROIS,sumROISnormed] = sumrois_wNaN(IInormb,ROIS,ImageJ);
	 %  sumROIS sums over the ROI, sumROISnormed divides by the number of pixels
%	 [sumROIS,sumROISnormed] = sumrois(IInormb,ROIS,ImageJ);
	 %	Isum	Array  : each column for each ROI. Length of vectors (rows) num of images
	 %HL = semilogy(Xsteps,sumROIS);
	 HL = plot(Xsteps,sumROISnormed); YLABEL = '[Inorm(summed over ROI)/ROIsize]';
%	 HL = plot(Xsteps,log10(sumROISnormed)); YLABEL = 'log10[Inorm(summed over ROI)/ROIsize]';


	 xlabel(SCNXLABEL);ylabel(YLABEL);
	 title(char(TITLEstr1,pfilename(INFOstr),YLABEL));
	 prettyplot(gca)
% mocvd
	 makeyline(Xsteps(lastframes),'b',gca);   % want colored lines on this plot, not white	 
	 for ii=1:length(ROIS(:,1));
		set(HL(ii),'Color',COLORORDER(ii,:),'LineWidth',2);
	 end
	 
	 
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if any(WhatToDo==6);   %to make it automatic for summs   % ? is Xsteps missing one point
	if isempty(POINTSUMS); 
		POINTS=[1 : length(Xsteps)]-ImageJ;
	else 
		POINTS = POINTSUMS;
	end

for ii = 1:length(POINTS(:,1))
	Ni = [POINTS(ii,1): POINTS(ii,end)]+ImageJ;
	NP = length(Ni);
	POINTstr = ['[ ' int2str(Ni(1)-ImageJ) ':' int2str(Ni(end)-ImageJ) ']'];
	
	figure;clf;
	set(gcf,'Name','Image summed over points/Num Points');	
	if ~LOGFLAG

		HS = pcolor(XCOLpts,YROWpts,sum(Iwinnorm(:,:,Ni),3)./(NP));
		
			if ~ASPECTflag
				axis equal;
			else
				HA = gca;
				daspect(gca,ASPECT);   %this might not be in earlier version
				HA = gca;,
				set(HA,'DataAspectRatioMode','manual','DataAspectRatio',[ASPECT]);
			end

			if ~isempty(AXISdet); axis(AXISdet);end		
			if ~isempty(CLIMlin); 
				set(gca,'clim',CLIMlin);
				DOCUclim = mDOCUclim(CLIMlin);
			else 
				CLIMtemp = get(gca,'clim');
				DOCUclim = mDOCUclim(CLIMtemp);
			end;
			DOCUInt6 = [DOCUInt, ' SUMMED over SPEC scan pts ',POINTstr];
	else
	
		HS = pcolor(XCOLpts,YROWpts,log10(fixlogimage(sum(IInormb(:,:,Ni),3)./(NP))));
			
			if ~ASPECTflag
				axis equal;
			else
				HA = gca;
				daspect(gca,ASPECT);   %this might not be in earlier version
				HA = gca;,
				set(HA,'DataAspectRatioMode','manual','DataAspectRatio',[ASPECT]);
			end
			
			if ~isempty(AXISdet), axis(AXISdet);end
			if ~isempty(CLIMlog); 
				set(gca,'clim',CLIMlog);
				DOCUclim = mDOCUclim(CLIMlog);
			else 
				CLIMtemp = get(gca,'clim');
				DOCUclim = mDOCUclim(CLIMtemp);
			end;
			DOCUInt6 = [DOCUInt, ' SUMMED over SPEC scan pts ', POINTstr];
	end
	
	shading flat;
	
	if FLATFIELDFLAG
		DOCUInt = [DOCUInt,' [FF]'];
	end
	
	DOCUlast = char(DOCUInt6,pfilename(INFOstr));
	title(char(TITLEstr1,DOCUlast));xlabel(XCOL);ylabel(YROW);
	prettyplot(gca,[2 2 4 3.8]);
		% only put ROIs on if we did something like option 2
		if any(WhatToDo==2);
			if exist('COLORORDER','var')%length(ROIS(:,1))<length(COLORORDER(:,1))
				showrois(ROIS,gcf,1.5,COLORORDER);
			else
				[HROI,COLORORDER]=showrois(ROIS,gcf,1.5);
			end
		end
	
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if any(WhatToDo==7);  % plot flatfield FLATFIELDFLAG

	figure
	set(gcf,'Name',['Flat Field']);
	HS = pcolor(XCOLpts,YROWpts,FLATFIELD);
	shading flat
	axis equal;
    if ~isempty(AXISdet); axis(AXISdet);end
	title(['Flat Field: from ' pfilename(FlatField.filenameroot) ' [' FLATFIELDinfo ']']);
	xlabel(XCOL);ylabel(YROW);
    prettyplot(gca,[2 2 4 3.8]);
    %set(gca,'position',[.17 .1 .65 .68]);

			if exist('COLORORDER','var')%length(ROIS(:,1))<length(COLORORDER(:,1))
				showrois(ROIS,gcf,1,COLORORDER);
			else
				[HROI,COLORORDER]=showrois(ROIS,gcf,1);
			end	
 
end	

%---------------------  GBS sections WhattoDo 8 and above
 % user_input_guts_2timesection
%---------------------------




