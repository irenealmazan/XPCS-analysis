% Two-time analysis of March 2018 TiO2 data
% Read and analyze dataset(s)
% March 17, 2018 GBS
% just use equil 2-time, average over a time range

% startup

% Flags to control behavior

skip = 0; % 0 means redo 2-time calc, smoothing, etc.; 1 means read previously saved

plotsmooth = 0; % use to control whether to plot smoothing results if skip = 0
% Note above will generate several plots per NRX, keep NRX small
plotall = 1; % use to control whether to plot every 2-time in Q loop
    plotorig = 1; % plot original normalization
    plotnew = 1; % plot new normalization
% Limit which ix to plot within 1:NRX
    ixplotmin = 25;
    ixplotmax = 50;
    ixplotmin = 1;
    ixplotmax = 5;
% max of clim for these plots
    CMAX = 0.02;
    %CMAX = 0.10;
pcolorCC2 = 0; % use to control whether to plot 2-time mean over ttroi regions
    plothalf = 1;
    plotfull = 0;
    posflag = 1; % average 2-time only on positive side

plotcorrorig = 0;
plotcorrnew = 0;
fitorig = 0;
fitnew = 0;

plotcontrast = 0;
pcolorextra = 0; %use to control whether to pcolor Per pixel counts in ROIs, contrast, excess contrast 

altnorm = 0; % control calc/plot of alternative normalizations

plotdeltat = 1; % control calc/plot of delta t analysis

%____________________________________________________________
% Set parameters that stay same for each run

DOCU0			= 'sput_180315a 110 TiO2';
DOCU1 = [''];
LOGFLAG = 1;   % 1 for log, 0 for lin need to change CLIM to match if using it
if 0
flimsd_flag = 0; % Use fixed value for fluctuating pixel removal
flimc = 100; % Fixed value
%flimsd_flag = 1; % Use multiple of Poisson noise for fluctuating pixel removal
flimsd = 15; % Multiple
end

% Pilatus detector on sevchex arm (X is del and Y is nu)
YWID = [-50 50];
YWID = [-30 30];
yy = [min(YWID):max(YWID)]'; % Pixel locations relative to center
delay = 3; % delay in frames of growth start after valve switch
CLIM = [-1.5 2];
XFRAC = 0.1; % use a range that is a fraction of xmax
%____________________________________________________________
% Set parameters that stay same for 2-time calculation

if 0
% The +/- 5 window seems good for the new SG smoothing

%jjj = 5; % X half-width of moving window
%iii = 5; % Y half-width of moving window

% Could try narrower jjj for central peaks
jjj = 10; % X half-width of moving window del
iii = 0; % Y half-width of moving window nu
% Smoothing method for getting average
% Use 2-D Savitzky-Golay smoothing filter
% Use even maxpd
maxpd = 2;

end

tbin = 10; % number of scans to bin together for 2-time calcs
% Note sumrois_wNaN doesn't work with single-pixel ROIs


CWID = 0.3; % Parameter for integer/half-integer ML integration

%____________________________________________________________


% Set parameters that varied for each scan

TCV = [700;
    800]; % Thermocouple (new heater)

nT = length(TCV);
nT = 1; % Do only first

iiT = 1:nT; % to plot all
iiT = 2; % to plot only one

specfilenameM = ['2018_0316_1';
        '2018_0317_1'];

SCNstrM = ['98'; % 700 C continuing 10W 30 mTorr 70/30 TiO2 only
           '55']; % 800 C equil 

% Center pixels from beamtime analysis
XCENV = [240; % del
         238];

YCENV = [118; % nu
         120];

%XCENV = XCENV - 1; % This shift was once needed

XWIDV = [30;
         30];
        
% Positions of CTRs for ROIS
ymax = [8;
        8];
    
% Min and max on time range for delta-time average    
tminv = [1000;
        1000];

tmaxv = [2800;
         2800];   

clrs = 'rgbcmkrgbcmk';

DXImin = 5;
DXImax = 15;

NRY = 75; % Number of small TTROIS
NRY = 5; % Number of small TTROIS

POINTSUMS = [];

%____________________________________________________________
if ~skip
    disp('Recalculating 2-time from experimental datasets.');
    
    for iT = iiT
        disp(['File index: ' num2str(iT)]);
        specfilename = specfilenameM(iT,:);
        SCNstr = SCNstrM(iT,:);
        
        %tamount = tamountv(iT);
        TC = TCV(iT);
        DOCUscan = [num2str(TC) 'C ' DOCU1];
    
        XCEN = XCENV(iT);
        YCEN = YCENV(iT);
        
        DXHmin= round(ymax(iT)*0.75);
        DXHmax= round(ymax(iT)*1.5);
        
        XWID = XWIDV(iT);
        
        xx = [-XWID:XWID]; % Pixel locations relative to center

        ROIS = [...
        (XCEN + [-XWID XWID]) (YCEN + YWID) 
        
        (XCEN + [-XWID XWID]) (YCEN + [-2 2]) 

        (XCEN + [-XWID XWID]) (YCEN - ymax(iT) + [-5 5])

        (XCEN + [-XWID XWID]) (YCEN + ymax(iT) + [-5 5])];
        
        % subrange for 2-time
        
        ixtt = XCEN + xx;
        iytt = YCEN + yy;
        Ncs = length(xx);
        Nrs = length(yy);
        
        
    
        AXISdet = [(XCEN + [-50 50]) (YCEN + YWID) ];
 
        TTROIS = [...
        (XCEN + [-XWID XWID]) (YCEN - mod(YCEN,4) + [-148 -145]) ];
        TTROIS = [...
        (XCEN + [-XWID XWID]) (YCEN + ymax(iT) + [-10 -7]) ];
        
        ttcroiout = [1]; % which TTROIs to use together to get 2-time outside X window
        DYavgwin = 25;
        ttcroiin = [1]; % which TTROIs to use together to get 2-time inside X window

        RYINC = 4; % Amount to increment ROI in X
      
        % Now call common code scripts
        
        warning('off','all');
        TTsput_read; % reads a dataset, makes IInormb
        warning('on','all');
             
        TTM_plot1; % makes some plots of scattering

        ittt = find(Xamount > tminv(iT) & Xamount < tmaxv(iT));
        Nts = length(ittt);
    
        TTsput_2time_eq; % calculates 2-time quantities below
        
        %CC2V{iT} = CC2;
        CCN2V{iT} = CCN2;
        
        timebV{iT} = timeb;
        TITLEstr2V{iT} = TITLEstr2;
        
        DXHminV(iT) = DXHmin;
        DXHmaxV(iT) = DXHmax;
        
        XamountbV{iT} = Xamountb;
        %IID2V{iT} = IID2;
        IIM2V{iT} = IIM2; % un-normalized
        
    end
    %save TTsput_2018_03_v2.mat CC2V CCN2V timebV TITLEstr2V XamountbV IID2V IIM2V DYavgV DXHminV DXHmaxV
    save TTsput_2018_03_v2.mat CCN2V timebV TITLEstr2V XamountbV IIM2V DXHminV DXHmaxV -v7.3
   
else
    disp('Loading previously calculated 2-time analysis.');
    load TTsput_2018_03_v2.mat
end

disp('Making plots.');
Nts = size(CCN2V{iiT},3);
Ncs = size(CCN2V{iiT},2);
Nrs = size(CCN2V{iiT},1);

TTsput_plot2;

if 0

TTM_plot2_HI;

TTM_plot2_contr;

end

if altnorm % plot normalization summary images
    TTM_plot2_altnorm;
end

if plotdeltat
    
% Delta-t analysis

for iT = iiT
    %timex = timebV{iT} - timebV{iT}(1);
    %idt = timex > tminv(iT) & timex < tmaxv(iT);
    Ndt = length(timex{iT});
    idt = 1:Ndt;
    timebD{iT} = timex{iT}(idt);
    timebD{iT} = timebD{iT} - timebD{iT}(1); % Delta in time from region start
    CCNdt = NaN*ones(Nrq,Ndt);
    for irq = 1:Nrq
        CCN2S = CCN2avg{iT}(idt,idt,irq);
        for ii = idt
            CCNdt(irq,ii) = mean(diag(CCN2S,ii-1));
        end
    end
    CCNdtV{iT} = CCNdt;
end

POSITION = [.17 .10 .65 .8];
PAPERPOSITION = [1 1 5 4];
FONTSIZE = 10;

for iT = iiT
for irq = 1:Nrq
figure;
set(gcf,'Paperposition',PAPERPOSITION);
set(gcf,'Name','Mean at delta t using new norm.');
HS = line(timebD{iT},CCNdtV{iT}(irq,:));
hx = xlabel('Time Delta (s)');
hy = ylabel('Correlation');
ht = title(char(TITLEstr2V{iT},['Mean at delta t using new norm. ' num2str(irq)]));
set(gca,'position',POSITION);
set(gca,'FontSize',FONTSIZE);
set(hx,'FontSize',FONTSIZE);
set(hy,'FontSize',FONTSIZE);
set(ht,'FontSize',FONTSIZE);
end
end
    
return


for iT = iiT
    if 0
    figure;
    set(gcf,'Paperposition',PAPERPOSITION);
    set(gcf,'Name','Mean at delta t using orig. norm.');
    HS = pcolor(timebD{iT},DXavgV{iT},CCdtV{iT});
    shading flat;
    set(gca,'clim',[0 0.5]);
    hx = xlabel('Time Delta (s)');
    hy = ylabel('DXavg (pix)');
    ht = title(char(TITLEstr2V{iT},['Mean at delta t using orig. norm. ' num2str(TCV(iT))]));
    set(gca,'position',POSITION);
    %axis equal
    set(gca,'FontSize',FONTSIZE);
    set(hx,'FontSize',FONTSIZE);
    set(hy,'FontSize',FONTSIZE);
    set(ht,'FontSize',FONTSIZE);
    colorbar
    colormap 'jet';
    set(gca,'TickDir','out');
    end
    
    figure;
    set(gcf,'Paperposition',PAPERPOSITION);
    set(gcf,'Name','Mean at delta t using new norm.');
    HS = pcolor(timebD{iT},DXavgV{iT},CCNdtV{iT});
    shading flat;
    set(gca,'clim',[0 0.01]);
    hx = xlabel('Time Delta (s)');
    hy = ylabel('DXavg (pix)');
    ht = title(char(TITLEstr2V{iT},['Mean at delta t using new norm. ' num2str(TCV(iT))]));
    set(gca,'position',POSITION);
    %axis equal
    set(gca,'FontSize',FONTSIZE);
    set(hx,'FontSize',FONTSIZE);
    set(hy,'FontSize',FONTSIZE);
    set(ht,'FontSize',FONTSIZE);
    colorbar
    colormap 'jet';
    set(gca,'TickDir','out');
    
end

return

for iT = iiT
    % Choose Q region to plot and fit
    if posflag % average only on positive side
        idxh = DXavgV{iT} > abs(DXHminV(iT)) & DXavgV{iT} < abs(DXHmaxV(iT));
    else
        idxh = abs(DXavgV{iT}) > abs(DXHminV(iT)) & abs(DXavgV{iT}) < abs(DXHmaxV(iT));
        %idxh(57)=0; % This one is blank
    end

    
    figure;
    set(gcf,'Paperposition',PAPERPOSITION);
    set(gcf,'Name','C vs delta t using new norm.');
    hax = axes('Box','on');
    for ii = find(idxh)
        hl = line(timebD{iT}(2:end),CCNdtV{iT}(ii,2:end));
        set(hl,'Color',clrs(1+mod(ii,6)));
    end
    hx = xlabel('Time Delta (s)');
    hy = ylabel('Correlation');
    ht = title(char(TITLEstr2V{iT},['C vs delta t using new norm. ' num2str(TCV(iT))]));
    hleg = legend(num2str(DXavgV{iT}(idxh)'));
    set(gca,'position',POSITION);
    set(gca,'FontSize',FONTSIZE);
    set(hx,'FontSize',FONTSIZE);
    set(hy,'FontSize',FONTSIZE);
    set(ht,'FontSize',FONTSIZE);
end
end

return




