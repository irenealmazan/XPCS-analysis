% written assuming that the data mostly in similar path structure on 
%	various computers that CT maintains. (i.e., used for 1999-2009,

%% BASEroot is typically something that doesn't change except per computer
moth_ROOT 		= '/home/mocvd/DATA';
nisaba_ROOT 	= '/DATA/DATA';
irene_ROOT    = '/Volumes/srs/Data';%'./DATA';%   %<<< fix this ??? piece to point to Data in atoz

%% ENDroot is something that typically changes per run/experiment
ENDroot 	= '2017/2017_12_huber_sput_ZnO';  %%<< this allows some more pointing
%ENDroot_atoz = '2017/Cycle_3/huber';
ENDroot_atoz = '2018/Cycle_01_to_04/huber';

%%%% Usually, just need to change here to go between computers
%%%%		(helpful if have set up programs,, but want to run 
%%%%		them on another computer)
BASEroot 	= irene_ROOT;  %% <<< change here to irene_ROOT
BASErootFLAG = 'irene_ROOT';

%% If using beamline computers we don't have to change anything below
%%		unfortunately, atoz keeps changing directory structure
%%		so you may have to tweak  a different set each  run.
if ~strcmp(BASErootFLAG(1:5),'irene')   % 
	DATAroot 	= [BASEroot,filesep,ENDroot];
	DATApath 	= [DATAroot,filesep,'specdata'];
	AREApath	= [DATAroot,filesep,'areadata'];
	FLUORpath   = [DATAroot,filesep,'fluordata'];

	IMAGEPILpath 	= [AREApath,filesep,'Pilatus'];
	IMAGEPIXpath 	= [AREApath,filesep,'Pixirad'];
	IMAGEMEDiDEXpath 	= [AREApath,filesep,'medipix/ASI_Dexter'];
	IMAGEMPX3path 	= [AREApath,filesep,'MPX3'];
	%%% change below the 'else' to work with atoz, don't change above
else 
	ENDroot		= ENDroot_atoz;
	DATAroot	= [BASEroot,filesep,ENDroot];  %='/Volume/???/Data/2017/Cycle_3/huber';
	
	%AREApath	= [DATAroot,filesep,'AREA'];
    AREApath	= [DATAroot,filesep,'areadata'];
	%DATApath	= [DATAroot,filesep,'SPEC'];
    DATApath	= [DATAroot,filesep,'specdata'];
	FLUORpath 	= [];% I don't know how they usually save fluor data if it is collected 
	
	IMAGEPILpath	= [AREApath];
	IMAGEPIXpath	= [AREApath];   % I dont' think they keep them separate
end
	


%%%% the final place to change is here (if different area detectors used
%%%%  however, I don't think they keep track of it on atoz.
%AREApath = IMAGEPIXpath;
AREApath = IMAGEPILpath;
%AREApath = IMAGEMPX3path;







