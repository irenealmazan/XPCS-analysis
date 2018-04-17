% Two-time analysis of March TiO2 sputtering
% This script contains common part for calculating 2-time correlations
% called by TTsput_2018_03_v2.m
% 17MAR18 just use time averages

disp('Calculating 2-time correlations, please wait.');

% Use sub-range of pixels and time

IInormbs = IInormb(iytt,ixtt,ittt);
timestampXs = timestampX(ittt);
Xamounts = Xamount(ittt);
   
% First bin scans in time
if tbin > 1
    tbin = floor(tbin);
    Ntb = floor(Nts/tbin);
    IInormbe = reshape(IInormbs(:,:,1:Ntb*tbin),Nrs,Ncs,tbin,Ntb);
    IInormbb = squeeze(sum(IInormbe,3));
    Xamounte = reshape(Xamounts(1:Ntb*tbin),tbin,Ntb);
    Xamountb = squeeze(mean(Xamounte,1));
    timestampe = reshape(timestampXs(1:Ntb*tbin),tbin,Ntb);
    timeb = squeeze(mean(timestampe,1));
    POINTSUMSB(:,1) = floor((POINTSUMS(:,1)-1+ImageJ)/tbin)+1-ImageJ;
    POINTSUMSB(:,2) = floor((POINTSUMS(:,2)+ImageJ)/tbin) - ImageJ;
else
    Ntb = Nts;
    IInormbb = IInormbs;
    Xamountb = Xamounts;
    timeb = timestampXs;
    POINTSUMSB = POINTSUMS;
end

if isempty(POINTSUMSB); POINTSB=[1 Ntb]-ImageJ;
else POINTSB = POINTSUMSB;
end

dI = IInormbb - mean(IInormbb,3);
dlnI = IInormbb./mean(IInormbb,3) - 1;
    
% Calc 2-time using time average mean, no ensemble

IIM2 = NaN*ones(Nrs,Ncs,Ntb,Ntb);
CCN2 = NaN*ones(Nrs,Ncs,Ntb,Ntb);  
for ii = 1:Ntb
    for jj = 1:ii
        IIM2(:,:,ii,jj) = dI(:,:,ii).*dI(:,:,jj);
        IIM2(:,:,jj,ii) = IIM2(:,:,ii,jj);
        CCN2(:,:,ii,jj) = dlnI(:,:,ii).*dlnI(:,:,jj);
        CCN2(:,:,jj,ii) = CCN2(:,:,ii,jj);
    end
end
%IID2 = diag(IIM2);
%CC2 = IIM2./sqrt(IID2*IID2'); % Normalized to make diagonal unity

return

