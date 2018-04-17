% this scripts processes scans taken from different files (to compare the
% scattered intensity at different tempereatures for instance


[SPECpath,AREApath,COMMONpath,HOMEpath] = pathdisplay;
eval(RUNPARAMS);

%specfilename = '2016_1015_2';
HDFfilename = specfilename;
%DOCU0  = 'n161012a (AH1385.10.2) m-plane GaN';

%clear Iwin Iwinnorm;
HLine=[];HSurf=[];HS_SoX=[];


% medipix, pilatus, all saved in tif thus far (usually)
STR.scanflag=1;
STR.imname=[];      % image names use standard unique naming schemes
%	STR.imname='pil_';  % caxis non-unique naming scheme for images (sigh) 
STR.SPECpath=DATApath;
STR.AREApath=AREApath;   % need to change pathdisplay if need pilatus
STR.p_image=['p_image'];   %% STR.p_image=[] if it uses the preferred points instead
STR.ending='.tif';


ImageJ = 0; %Irene has change this% true - using imageJ indexing [start at 0] when denoting ROIs and when plotting pixels
%	This applies to AXISdet and ROI values so must be consistent.

% DO Multiple scans at a time
SCNs = eval(SCNstr);

% information about diffractometers:
if strncmp('caxis',SCNFUNC,min([length('caxis') length(SCNFUNC)]));  % which diffractometer
	readspechelp = str2func('readspec_caxis_v4_helper');
	INFOinterest = ['Sam_Z  stemp  Chi  Eta'];     %!!! put 2 spaces between each!!!!
	STR.imname='pil_';  % caxis non-unique naming scheme for images (sigh) 
else
	readspechelp = str2func('readspec_sevc_v6_helper');
	INFOinterest = ['s6vgap  s6hgap  Phi  TZ  TY  Chi  Eta  Delta  Nu  TX'];     %!!! put 2 spaces between each!!!!
	STR.imname=[];  % standard unique naming scheme for images
end

%----------Loop through all the scans

for jj=1:numel(SCNs)
    
    %---------- Make the matrix of the names for the images, note sdata holds information from spec file

    
    [NameMatrix,sdata]	= make_imnames_2017_07(HDFfilename,SCNs(jj),STR);
    FullNameHDF 		= addnames2matrix([STR.AREApath,filesep],NameMatrix.fullfilenames);
    NameStruct.SCN(jj).NameMatrix = NameMatrix;
    NameStruct.SCN(jj).sdata = sdata;
    NameStruct.SCN(jj).FullNameHDF = FullNameHDF;
    NameStruct.SCN(jj).SCNnumber = SCNs(jj); 
    
    
    
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
	
	NameStruct.SCN(jj).secperpoint		= sdata.DATA(:,chan2col(sdata.collabels,timename));
	NameStruct.SCN(jj).timestampSpec	= sdata.DATA(:,chan2col(sdata.collabels,etimename));
	NameStruct.SCN(jj).timestampEpoch  = sdata.DATA(:,chan2col(sdata.collabels,epochtimename));
	NameStruct.SCN(jj).filterpoint  	= sdata.DATA(:,chan2col(sdata.collabels,filtername));
	NameStruct.SCN(jj).Monitor			= sdata.DATA(:,chan2col(sdata.collabels,monname));
	NameStruct.SCN(jj).MONave 			= mean(NameStruct.SCN(jj).Monitor(:,1));  %% occasionally counters in more than one column
	NameStruct.SCN(jj).mon100mA 		= NameStruct.SCN(jj).MONave./mean(NameStruct.SCN(jj).secperpoint);  %do not use RUNPARAM- since slit size changes a lot
	NameStruct.SCN(jj).meansecperpoint = mean(NameStruct.SCN(jj).secperpoint);
    
    secperpoint = NameStruct.SCN(jj).secperpoint;
    timestampSpec = NameStruct.SCN(jj).timestampSpec;
    timestampEpoch = NameStruct.SCN(jj).timestampEpoch;
    filterpoint  = NameStruct.SCN(jj).filterpoint;
    Monitor = NameStruct.SCN(jj).Monitor;
    MONave = NameStruct.SCN(jj).MONave;
    mon100mA = NameStruct.SCN(jj).mon100mA;
    meansecperpoint = NameStruct.SCN(jj).meansecperpoint;
    
    
    %---- get the normalization corrections ready
	if NORMFLAG == 1;	
	Norm = MONave .* meansecperpoint .* filter_correction(filterpoint,filter1,filtercorr)./(secperpoint.*Monitor(:,1));
	NORMdoc = ['Norm = monave*secperpointave*filtercorrection/(sec per point * Monitor per point): WITH filter correction'];
	else 
	Norm = MONave .* meansecperpoint ./(secperpoint.*Monitor(:,1));
	NORMdoc = ['Norm = monave*secperpointave*meansecperpoint/(sec per point * Monitor per point): No filter correction'];
	end
	disp(char('* *','Normalization that is used is as follows',NORMdoc,'* *'));
    
    NameStruct.SCN(jj).Norm = Norm;
    
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
    NameStruct.SCN(jj).HSurf.Iwin = Iwin;
    
    NameStruct.SCN(jj).timestampX = timestampX;
    NameStruct.SCN(jj).Icolors = Icolors;
    NameStruct.SCN(jj).THRESHuse = THRESHuse; 
    NameStruct.SCN(jj).THRESHusedoc = THRESHusedoc;
    NameStruct.SCN(jj).timestampX_flag = timestampX_flag; 
    
    %	Here we are being consistent with enumeration in SPEC points and ImageJ
%		ImageJ convention is used in the SPEC ROI's and EPICS ROIs images
%		SPEC convention is used in its points when we 'write' down a data point
%       ImageJ = 1 % using ImageJ convention, ImageJ=0 use matlab convention
%		matlab convention numbering starts from 1, not 0 
%			from the screen	

% Irene: I have changed ImageJ = 0, not because of the convention, but
% because if I want to analyze single frames I was having trouble with the
% plots and the index exceeding the size of the image
    
    
    SPECpts = [1:(length(Xsteps))]-ImageJ;
	YROWpts = [1:(length(Iwin(:,1,1)))]-ImageJ;  
	XCOLpts = [1:(length(Iwin(1,:,1)))]-ImageJ;
	
    NameStruct.SCN(jj).SPECpts = SPECpts;
    NameStruct.SCN(jj).YROWpts = YROWpts;
    NameStruct.SCN(jj).XCOLpts = XCOLpts;
    
    
	Nr = length(YROWpts);Nc = length(XCOLpts);Nt = length(SPECpts);
    
    NameStruct.SCN(jj).Nr = Nr;
    NameStruct.SCN(jj).Nc = Nc;
    NameStruct.SCN(jj).Nt = Nt;
    
    % Normalization:
    
    NORM_FLAG = 0;
    
    if NORM_FLAG
        for ii=1:length(Iwin(1,1,:))
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
        for ii=1:length(Iwin(1,1,:))
            IInormb(:,:,ii)		= (IInorm(:,:,ii)	- IIimbkg)./FLATFIELD;
            Iwinnormb(:,:,ii)	= (Iwinnorm(:,:,ii)	- Iwinimbkg)./FLATFIELD;
        end
        
    else
        
       for ii=1:length(Iwin(1,1,:)) 
        IInorm(:,:,ii)		= II(:,:,ii);
        Iwinnorm(:,:,ii)	= Iwin(:,:,ii);
       end
    end
    
    NameStruct.SCN(jj).IInorm = IInorm;
    
    
    % --------- Do the plotting
    
    % Plot the image in the detector
    
    figure;clf
    set(gcf,'Name',['Lin Image',THRESHusedoc,' Spec # ' int2str(SINGLE)]);
    HS = pcolor(XCOLpts,YROWpts,(IInormb(:,:,SINGLE+ImageJ)));
    shading interp
    HSurf.IInormb = HS;
    
    NameStruct.SCN(jj).HSurf.IInormb = HS;
    
    % Show the ROIS
    
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


        %---------- Integrate the intensity in the ROIS
        
        
        [SIZE1,SIZE2,SIZE3]=size(IInormb);  % in case whole scan not complete
        [SoY,SoX] = slicesumrois(IInormb,ROIS,1);%(1,:));
        %[SoY,SoX] = slicesumrois(IInormb,ROIS,ImageJ);%(1,:));
        %	Note - This does not 'normalize' the slices to the number of pixels summed
        %			However, after using function, use SoY.image{i}./SoY.norm{i}
        %				for ROI {i}
        
        for ii=N_ROIS_SUM; %1%:length(ROIS(:,1));
            
            
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

    
end




