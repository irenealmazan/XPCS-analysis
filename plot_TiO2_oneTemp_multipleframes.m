% In this script we choose a temperature, and we plot the integrated
% intensity at different times of the growth process (for each minimum of
% the specular intensity)

if ~exist('TiO2','var')
    load('./results_TiO2/TiO2_tempseries');
end

ini_row = 124;
fin_row = 130;
dq_invAperpix = 1.64e-3;

Temp_indx = 500;

% open ROIs counter file
hfig = openfig((['./results_TiO2/TiO2_30O2_70Ar_15mTorr_30W_' num2str(Temp_indx) 'C_ROIs as counters'])); 

haxis = hfig.Children;
dataObjs = get(haxis, 'Children');
objTypes = get(dataObjs, 'Type');
xdata = get(dataObjs, 'XData');



%frame = ones(numel(TiO2),1).*100; %array which can be costumized to pick-up the most appropriate frame for each temperature

