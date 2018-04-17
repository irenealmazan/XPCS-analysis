% this scripts loads the experimental data of TiO2 for different
% temperatures, integrates the intensity of the nu-pixel rows between
% 124:130 and plots the integrated intensity as a function of the del-pixel
% converted into inverse Angstroms (conversion factor is 1.64e-3 invAngs per
% pixel (see ZnO_vs_GaN_spreedsheet)





if ~exist('TiO2','var')
    load('./results_TiO2/TiO2_tempseries');
end


ini_row = 124;
fin_row = 130;
frame = [ ones(numel(TiO2),1).*100;ones(numel(TiO2),1).*100]; %array which can be costumized to pick-up the most appropriate frame for each temperature
dq_invAperpix = 1.64e-3;
%legend_str = [];


figure;
hold on;
for jj = [ 6:numel(TiO2)]
    Integ_Int = sum(TiO2(jj).HSurf.Iwin(ini_row:fin_row,:,frame(jj)),1);
    CTR_pixel = find(max(Integ_Int) == Integ_Int);
    q_del = ([1:size(TiO2(jj).HSurf.Iwin,2)] - CTR_pixel).*dq_invAperpix;
    plot(q_del,log10(sum(TiO2(jj).HSurf.Iwin(124:130,:,100),1)))
    legend_str{jj} = [num2str(TiO2(jj).Temp) 'C'];
end

legend_index = [1:4 6:numel(TiO2)];

legend(legend_str{legend_index});
title(['TiO2 Integrated signal between rows[' num2str(ini_row) ':' num2str(fin_row) '], frame ' num2str(frame) ' @ 30 O2/ 70 Ar, 15 mTorr, 30 W']);
xlabel('q [1/Angstroms]');
xlim([q_del(1) q_del(225)]); % the sensitive part of the chip in del goes up to pixel 225