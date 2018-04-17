% Poor mans GUI

RUN_name = '12id-d mocvd Huber and CRL (42) and Pilatus detector ZnO homoepitaxy';
APS_params = 'User Operations 24 singlets, Reduced Horizontal Beam Lattice , top-up for week;';
COLLABORATORS = 'IA,MH,JAE,CT';
STARTDATE = '05-Dec-2017';ENDDATE ='12-Dec-2017';  

%% at present, the following are not 'used' but at least document
%CHAMBER = 'oxide' or 'nitride' of 'sputter' or 'enviro' etc
%SCNFUNC = 'caxis' or 'zaxis' or 'sevchex' of 'sevchub'
CHAMBER = 'sputter';
SCNFUNC = 'caxis';
TCFUNC = 'none';

% reading spec helper - different for different diffractometers
% This is pointer to the helper function to find information from headers for particular spec
%readspechelper = str2func('readspec_sevc_v6_helper');
readspechelper = str2func('readspec_caxis_v4_helper');

% calibrated Logbook XXX, page XXX to 
% we will be 
Energy = 18000;   % put dowb logbook

 
% Normalizations:
% Counts in monitor (pind) per second at 100mA in ring
mon100mA = 1; % approx not checked
monoffset = 0;   % approx not checked
detoffset = 0;

% Tau values used for deadtime corrections for scint detector  
tau = 0; % no scint detectore

% absorption correction is filter1^filternumb
% Ireal = Iexpt * filter1^filternumb   filter1 = absorption of one filter

% 16000 keV Moly filters (2016-03 oxide sputtering experiment
%filter1 = 3.3516; filter2corr=0.023695;filter4corr=0.061066;filter8corr=0.2414;  %
% 28000 keV Sn filters (2016-03 AlN sputtering experiment
% 2.2984	5.3009	27.4574	746.6764 << corrections according to  PHF (but pilatus_monitor_on
% 2.3011	5.3009	27.4351	746.6764  << corrected (don't use ones that are not using the changed filters
%filter1 = 2.3011; filter2corr=0.0013224; filter4corr=-0.026069; filter8corr=-0.061756;
%filter1 = 1;filter2corr =0;filter4corr=0;filter8corr=0;

% filtercorr parameters are used when there are thickness variations or materials variations for foil sets used for filters. Can keep all at 0 for 12id-d MOCVD run because it is same foils, 
% If correction is needed, it is used as a correction to the exponent of filter1^(filternumber+filtercorr)
%filter2corr = 0.0237;
%%filter4corr = -0.083;  % used for Sn foils 4th foil seems a little off
%filter4corr = 0.06106;
%filter8corr = 0;

% 10keV Pink beam focused with CRL using ion chambers Oct 2016 run
% Filters = 1 (150um Al) 2 (25um Mo) 4 (50um Mo) 8 (100um Mo
% filter1 = 3.0476;filter2corr=0.1498;filter4corr=0.0265;filter8corr=-3.3213; not mon normalized or darks
% 2016/10/13 Book # 195  (hexmon dark corrected, monitor used) 50 um Al	25 um Mo 50 um Mo 100 um Mo
 filter1 = 3.0547;filter2corr=0.1879;filter4corr=0.3862;filter8corr=-1.2564; 

% guesstimate for 0.125 um Sn and 24.6keV pink beam;
filter1 = 2.477;filter2corr = 0;filter4corr=0;filter8corr=0;

filtercorr = [filter2corr,filter4corr,filter8corr];


% #L ...  H  K  L  Epoch  Sec  ion1  ion2  hubmon  scan_bar  Filters  Correct  Qmag  Energy  Graze  p_peak  p_point  p_del_s  p_nu_s  p_image  p_xcen  p_xsig  p_ycen  p_ysig  power  tempsp  gun_on  setpw1  fwpw1  repw1  DCV1  setpw2  fwpw2  repw2  DCV2  Gamry_V  Gamry_I  vortot  ion0  p_total

% Enter the name that datatype is known in spec. This allows some crazy person to change the names in spec (or to be used on some other systems. Within progams, user hname, etc as variables. It may be most useful when trying different detectors or useing different detector names for monitor or detector
% #L Phi  H  K  L  Epoch  Seconds  ion1  ion2  hubmon  hexmon  laser  tempC  filters  correct  p_point  p_image  p_peak  p_small  p_med  p_lar  p_xcen  p_ycen  p_xsig  p_ysig  valve_p  valve_v  crltemp  ion0  p_total
% #L Time  Epoch  Seconds  ion1  ion2  hubmon  hexmon  laser  tempC  filters  correct  p_image  p_total  p_peak  p_small  p_med  p_lar  p_xcen  p_ycen  p_xsig  p_ysig  valve_p  valve_v  crltemp  ion0  p_point
hname		= 'H';		
kname		= 'K';		
lname		= 'L';		
mon0name	= 'ion0';  % upstream
detname     = 'p_point';	% p_small, etc
etimename	= 'Time';	% elapsed time in tseries
epochtimename  = 'Epoch';	% elapsed time since 0 at start of file (True epoch since start of spec freshstart)

%if SCNFUNC sevchex
if 0
	filtername = 'filters'; % absorber number  (filters for mocvd, Filters for caxis
	monname = 'hexmon';	% <<<monitor to use, pind in this case  hexmon, pind, hexmon
	timename = 'Seconds'; 	% time per point (called Seconds mocvd, Sec in huber)
	Tname = 'tempC';   	% if before a certain date, 'temp' (converted with sca2temp)
	valvename = 'valve_p';   % there is also a valve_v
	imagepointnum	= 'p_image';	% I hate this (not point num), but at least we have unique names in root
	diffvalve = 1;
end

% on Huber caxis
% #L Time  Epoch  Sec  ion0  ion1  ion2  scan_bar  Trans  Filters  Correct  Qmag  Energy  Graze  p_peak  p_total  p_med  p_large  p_image  p_xcen  p_xsig  p_ycen  p_ysig  power  tempsp  sTemp  gun_on  setpw1  fwpw1  repw1  DCV1  setpw2  fwpw2  repw2  DCV2  vortot  mirbd_s  mirbu_s  hubmon  p_point

%if SCNFUNC caxis
if 1
	filtername = 'Filters';
	monname = 'hubmon';
	timename = 'Sec';
	Tname = 'sTemp';
	valvename	= 'none';%'DCV2';   % there is also a DCV1
	diffvalve = 50;  % difference of valve signal to say that valve off/onn
	imagepointnum	= 'p_image';	% I hate this (not point num), but at least we have unique names in root
end

