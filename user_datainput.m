%% EDIT THIS FILE FOR PLOTS OF 'simple' SPEC DATA
%% But run >> datainput_run  (default sample name is user_datainput)
%% (Note you can save this e.g., scans_2016_1015a to keep all the
%% various good scans oabout a particular sample there
%% then run >> datainput_run('scans_2016_1015a') to run a specific file

%----------------------------------------------------------------- 
DOCU0 = 'n130704a m-plane';  %% <<< change rarely


FORCE.FLAG=1;   % 0 X is the first column
	FORCE.X='H';    % there is possiblity of choosing to plot in point with FORCE.X='specpoint'
FORCE.FLAGdet=1; %% 0 
	% 0 is (default det  as det/(sec.mon)) 
	% 1, 2, or 3 will use detector in FORCE.det
	%		May use more than one detector, see BELOW
	%	 1(all corrections) 2(det/mon) 3(det raw)
	%FORCE.det=char('p_small','p_med');
	FORCE.det=char('p_med','p_small');
	FORCE.det=char('p_med','p_lar');

DOCUscan = 'medipix on the detector arm';  %% <<< change as needed
specfilename = ['2017_0810_1']; 	SCNstr = '[27]'; %MYLEGEND = char(' 25C',' 450C');
specfilename = ['2017_0810_1']; 	SCNstr = '[42 67]'; %MYLEGEND = char('pregrowth 600C','postgrowth 625C');
specfilename = ['2017_0811_1']; 	SCNstr = '[2]'; %MYLEGEND = [];%char('TY','TZ');


FORCE.FLAG=0;   % 0 X is the first column
	FORCE.X='TY';    % there is possiblity of choosing to plot in point with FORCE.X='specpoint'
FORCE.FLAGdet=1; %% 0 
	% 0 is (default det  as det/(sec.mon)) 
	% 1, 2, or 3 will use detector in FORCE.det
	%		May use more than one detector, see BELOW
	%	 1(all corrections) 2(det/mon) 3(det raw)
	%FORCE.det=char('p_small','p_med');
	FORCE.det=char('p_med','p_small');
	FORCE.det=char('p_small');
DOCU0= 'n1708920(GaNKiban-60321B1)c-plane'; 
specfilename	= ['2017_0823_1'];SCNstr = '[30 31]';DOCUscan = ['1000C TY scan'];SINGLE=1;CLIM = log10([.1 32]); %% slit size 8(h)x10(v)

%----------------------------------------------------------------------




%% If you want a different set of line legends, then
%% put them into variable MYLEGEND 
%% MYLEGEND = char('450C','550C')

%clear MYLEGEND
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Working CT 2016-10  ****BELOW****
%%
%% if multiple detectors, all will use same corrections
%% ONLY one scan, the following
%% Following will automatically change legend to the detectors
%%   >> recolorlines 
%%%  will make colors better if you did not like the first choice

if 0   % not using right now
	if length(FORCE.det(:,1))>1;
		MYLEGEND = pfilename(FORCE.det);
	else
		MYLEGEND=[];
	%	clear MYLEGEND
	end
end
%
