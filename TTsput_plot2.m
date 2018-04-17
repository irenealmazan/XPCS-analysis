% Two-time analysis of March TiO2

% Choose some pixels to average

hwttr = 1; % row half width (pixels)
hwttc = 5; % col half width (pixels)

offttc = 0; % col offset (pixels)


ittccen = 1 + (Ncs - 1)/2; % index of col center
ittc = ittccen + offttc + [-hwttc:hwttc];

POSITION = [.17 .10 .65 .8];
PAPERPOSITION = [1 1 5 4];
FONTSIZE = 10;

wrq = 9;
Nrq = 2*wrq + 1;
for irq = 1:Nrq
    offttr = (irq - wrq - 1)*(2*hwttr+1);
    ittrcen = 1 + (Nrs - 1)/2; % index of row center
    ittr = ittrcen + offttr + [-hwttr:hwttr];

    if plotall
    for iT = iiT
        CCN2avg{iT}(:,:,irq) = squeeze(mean(mean(CCN2V{iT}(ittr,ittc,:,:),1),2));
        timex{iT} = timebV{iT} - timebV{iT}(1); 
        
    if plotnew
        figure;
        set(gcf,'Paperposition',PAPERPOSITION);
        set(gcf,'Name','2-time using new norm.');
        HS = pcolor(timex{iT},timex{iT},CCN2avg{iT}(:,:,irq));
        shading flat;
        set(gca,'clim',[0 CMAX]);
        hx = xlabel('Time (s)');
        hy = ylabel('Time (s)');
        ht = title(char(TITLEstr2V{iT},['2-time using new norm. ' num2str(irq)]));
        set(gca,'position',POSITION);
        axis equal
        set(gca,'FontSize',FONTSIZE);
        set(hx,'FontSize',FONTSIZE);
        set(hy,'FontSize',FONTSIZE);
        set(ht,'FontSize',FONTSIZE);
        colorbar
        colormap 'jet';
        axis([min(timex{iT}) max(timex{iT}) min(timex{iT}) max(timex{iT})]);
        set(gca,'TickDir','out');
    end
    end
end
end    

return

for iT = iiT
    
    if posflag % average only on positive side
            idxh = DXavgV{iT} > abs(DXHminV(iT)) & DXavgV{iT} < abs(DXHmaxV(iT));
            idxh(57)=0; % This one is blank
        else
            idxh = abs(DXavgV{iT}) > abs(DXHminV(iT)) & abs(DXavgV{iT}) < abs(DXHmaxV(iT));
            idxh(57)=0; % This one is blank
        end
        
        CC2H = mean(CC2MV{iT}(:,:,idxh),3);
        CC2HV{iT}=CC2H;
        
        CCN2H = mean(CCN2MV{iT}(:,:,idxh),3);
        CCN2HV{iT}=CCN2H;

        if posflag % average only on positive side
            idxi = DXavgV{iT} > abs(DXImin) & DXavgV{iT} < abs(DXImax);
        else
            idxi = abs(DXavgV{iT}) > abs(DXImin) & abs(DXavgV{iT}) < abs(DXImax); 
        end

        CC2I = mean(CC2MV{iT}(:,:,idxi),3);
        CC2IV{iT}=CC2I;
        
        CCN2I = mean(CCN2MV{iT}(:,:,idxi),3);
        CCN2IV{iT}=CCN2I;

end

if pcolorCC2
if plothalf  
    for iT = iiT
        timex = timebV{iT} - timebV{iT}(1);
        figure;
        set(gcf,'Paperposition',PAPERPOSITION);
        set(gcf,'Name',['DX ' num2str(DXHminV(iT)) ' to ' num2str(DXHmaxV(iT))]);
        HS = pcolor(timex,timex,CC2HV{iT});
        shading flat;
        set(gca,'clim',[0 0.30]);
        hy = xlabel('Time (s)');
        hy = ylabel('Time (s)');
        ht = title(char(TITLEstr2V{iT},['2-time using orig. norm. ' num2str(TCV(iT))],['DXavg = ' num2str(DXavgV{iT}(ix))]));
        set(gca,'position',POSITION);
        axis equal
        set(gca,'FontSize',FONTSIZE);
        set(hx,'FontSize',FONTSIZE);
        set(hy,'FontSize',FONTSIZE);
        set(ht,'FontSize',FONTSIZE);
        colorbar
        colormap 'jet';
        axis([min(timex) max(timex) min(timex) max(timex)]);
        set(gca,'TickDir','out');     
    end
 
    for iT = iiT
        timex = timebV{iT} - timebV{iT}(1);
        figure;
        set(gcf,'Paperposition',PAPERPOSITION);
        set(gcf,'Name',['DX ' num2str(DXHminV(iT)) ' to ' num2str(DXHmaxV(iT))]);
        HS = pcolor(timex,timex,CCN2HV{iT});
        shading flat;
        set(gca,'clim',[0 0.30]);
        hy = xlabel('Time (s)');
        hy = ylabel('Time (s)');
        ht = title(char(TITLEstr2V{iT},['2-time using new norm. ' num2str(TCV(iT))],['DXavg = ' num2str(DXavgV{iT}(ix))]));
        set(gca,'position',POSITION);
        axis equal
        set(gca,'FontSize',FONTSIZE);
        set(hx,'FontSize',FONTSIZE);
        set(hy,'FontSize',FONTSIZE);
        set(ht,'FontSize',FONTSIZE);
        colorbar
        colormap 'jet';
        axis([min(timex) max(timex) min(timex) max(timex)]);
        set(gca,'TickDir','out');     
    end
 
end

if plotfull  
    for iT = iiT
        timex = timebV{iT} - timebV{iT}(1);
        figure;
        set(gcf,'Paperposition',PAPERPOSITION);
        set(gcf,'Name',['DX ' num2str(DXImin) ' to ' num2str(DXImax)]);
        HS = pcolor(timex,timex,CC2IV{iT});
        shading flat;
        set(gca,'clim',[0 0.30]);
        hy = xlabel('Time (s)');
        hy = ylabel('Time (s)');
        ht = title(char(TITLEstr2V{iT},['2-time using orig. norm. ' num2str(TCV(iT))],['DX ' num2str(DXImin) ' to ' num2str(DXImax)]));
        set(gca,'position',POSITION);
        axis equal
        set(gca,'FontSize',FONTSIZE);
        set(hx,'FontSize',FONTSIZE);
        set(hy,'FontSize',FONTSIZE);
        set(ht,'FontSize',FONTSIZE);
        colorbar
        colormap 'jet';
        axis([min(timex) max(timex) min(timex) max(timex)]);
        set(gca,'TickDir','out');     
    end
 
    for iT = iiT
        timex = timebV{iT} - timebV{iT}(1);
        figure;
        set(gcf,'Paperposition',PAPERPOSITION);
        set(gcf,'Name',['DX ' num2str(DXImin) ' to ' num2str(DXImax)]);
        HS = pcolor(timex,timex,CCN2IV{iT});
        shading flat;
        set(gca,'clim',[0 0.30]);
        hy = xlabel('Time (s)');
        hy = ylabel('Time (s)');
        ht = title(char(TITLEstr2V{iT},['2-time using new norm. ' num2str(TCV(iT))],['DX ' num2str(DXImin) ' to ' num2str(DXImax)]));
        set(gca,'position',POSITION);
        axis equal
        set(gca,'FontSize',FONTSIZE);
        set(hx,'FontSize',FONTSIZE);
        set(hy,'FontSize',FONTSIZE);
        set(ht,'FontSize',FONTSIZE);
        colorbar
        colormap 'jet';
        axis([min(timex) max(timex) min(timex) max(timex)]);
        set(gca,'TickDir','out');     
    end
 
end

end

return
