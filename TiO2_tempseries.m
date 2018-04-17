% this scripts call the datainput_AREA function for the different
% temperatures measured for TiO2 in Dec. 2017


Temp_vector = [300 400:50:700 ];

for jj = 1:numel(Temp_vector)
   Temp = Temp_vector(jj);
   
   [IInormb,HS_SoX,HSurf,HLine] = datainput_AREA_TempSeries('sput_dec0617a_TiO2',Temp);
   
   TiO2(jj).IInormb = IInormb;
   TiO2(jj).HS_SoX = HS_SoX;
   TiO2(jj).HSurf = HSurf;
   TiO2(jj).HLine = HLine;
   TiO2(jj).Temp = Temp;
   
   h =  findobj('type','figure');
   n = length(h);
   
   for jj_fig = n-4:n       
      hfig = figure(jj_fig);       
      savefig(['./results_TiO2/TiO2_30O2_70Ar_15mTorr_30W_' num2str(Temp) 'C_' hfig.Name]);
      %close;
   end
      
 
   
end

save('./results_TiO2/TiO2_tempseries.mat','TiO2','-v7.3');