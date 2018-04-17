% Two-time analysis of August 2017 m-plane LBL data
% Created from SG2017_0817_1_42_test
% Split sections into different scripts
% This script contains common part for first plots
% called by TTM_2017_08XX_X_XX
% 26AUG17 GBS GJ

% choose some individual pixels to plot vs time
PIX = [...
    XCEN YCEN
    ];

% Choose which summed directions to plot
SoXFLAG = 0;
SoYFLAG = 1;

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
         set(gca,'position',[.17 .10 .65 .68]);
	     prettyplot(gca)
         %makexline(ROIS(3,3:4));
	 	 makeyline(Xsteps(lastframes));
         colormap 'jet';
 
  end
	
  if SoYFLAG  % don't plot if SoY flag 0
	figure;clf
	set(gcf,'Name',['SoY ROIs #' int2str(ii)]);
	
	 if ~LOGFLAG;
	 HS = pcolor(Xsteps,SoY.ndx{ii},((SoY.images{ii})));
		
	 else
	 HS = pcolor(Xsteps,SoY.ndx{ii},log10(fixlogimage(SoY.images{ii})));
	 end

	 HPC.SoY_ROIS(ii) = HS;
	 shading flat; 
	 xlabel(SCNXLABEL);ylabel(XCOL);
	 title(char(TITLEstr1,[DOCUInt ' summed over Y in ROI #' int2str(ii)]));
	 if ~isempty(AXISdet); set(gca,'Ylim',AXISdet(1:2));end
     set(gca,'position',[.17 .10 .65 .68]);
     prettyplot(gca)
	 makeyline(Xsteps(lastframes));
     %makexline(ROIS(3,1:2));
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

if 0 %% plot individual pixels vs time 
	 
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


return