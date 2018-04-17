function [X,Y,Z,newsphereCEN,HSdeti] = r_det_patch(HSdet,angles,UB,spectrometername,ADDflag)
%  [X,Y,Z,newsphereCEN] = r_det_patch(HSdet,angles,UB,spectrometername,ADDflag)
%   rotates the zero detector patch according to detector rotations and
%   sample rotations to place it with respect to lattice.
%  HSdet is output of  det_patch, and includes the HSdet.x0, .y0, .z0
% [X,Y,Z] are the new X,Y,Z to be used in slice or in plotting of the new
% % NO NOT CHANGE HSdet.x0, .y0, .z0 since these are at 0,0,0,0,0
%% and needed for each new rotation calculation
%HSdet.x0 = Xdet;
%HSdet.y0 = Ydet;
%HSdet.z0 = Zdet;
%HSdet.sphereCEN0 = sphereCEN;   % at zeroed detector
%HSdet.PropDet = propdet;
%HSdet.DetCalib = DetCalib;
%HSdet.Energy = Energy;
%   figure handles (they are rotated and redrawn,
%HSdet.H = surface(Xdet,Ydet,Zdet,propdet);
%HSdet.HLkout = HLkout;  handle of the k_out line
%HSdet.HLkin	= HLkin; handle of the k_in line
% 2016_02 CT detector RotTrans added and using detector angle names as varioables
% put add and rotate in same function 
% ADDflag = 0; default) rotate the existing patch
% ADDflag = 1; add a patch at the rotated position

if nargin<4;ADDflag=0;end
if nargin<3;UB.U=1;end
if isempty(UB);UB.U=1;end
if nargin<4; spectrometername = 'sevchex';end

	sphereCEN = HSdet.sphereCEN0;
	kSCALE = 2*pi.*HSdet.Energy./fhc;
	kout = (([0 1 0]'.*kSCALE));

	[N1,N2] = size(HSdet.x0);
	
% unpack some things
DetCalib = HS.DetCalib;

% transform to XYZ, 
% Note- because unitary;  DETinv  = DET' and Uinv is U';
% Caution, BUT  B is not unitary UB is also not unitary 
% (would require other methods to invert if we needed B or UB, but we do not need them here)

% different rotation operators for different diffractometers
% this command makes calc_ROTOPER act as pointer to correct function
	calc_ROTOPER = str2func(['calc_ROTOPER_',spectrometername]);
	[DET,SAMP] = calc_ROTOPER(angles);

	DETinv = DET';
	Uinv = UB.U';

% If necessary to shrink or expand patch due to R changes (distance from COR)
%%%  (needed in zaxis because of way detector rotates)
% make detector (spectrometer : z' , x')  
%  arc = r*angle, projection in z', x'
	% if need to rescale because on zaxis, but need to keep referenced to at 0,0,0,0;
	Xdet 	= HSdet.x0(:)' - sphereCEN(1);
	Ydet 	= HSdet.y0(:)' - sphereCEN(2);
	Zdet 	= HSdet.z0(:)' - sphereCEN(3);


	% For RotTranslation as angle increases, ang2pix gets smaller
	% if Row(Y on matrix) is 'z' on spectrometer normal
	% Col(X on matrix) is 'z' on spectrometer will transpose
	% Scninfo.geoangles_i and scninfo.geoangles_label
	if strcmp(DetCalib.rowRotType,'RotTrans');
		if DetCalib.rowdir(2)=='x';
				Xdet	= Xdet .* ...
					cosd(angles(chan2col(Scninfo.geoangles_label,DetCalib.rowname,'quiet')));
		else
				Zdet	= Zdet .* ...
					cosd(angles(chan2col(Scninfo.geoangles_label,DetCalib.rowname,'quiet')));
	end
	if strcmp(DetCalib.colRotType,'RotTrans');
		if DetCalib.coldir(2)=='x';
				Xdet	= Xdet .* ...
					cosd(angles(chan2col(Scninfo.geoangles_label,DetCalib.colname,'quiet')));
		else
				Zdet	= Zdet .* ...
					cosd(angles(chan2col(Scninfo.geoangles_label,DetCalib.colname,'quiet')));
		end
	end 
	
		Ydet = sqrt(kSCALE.^2 - Xdet.^2 - Zdet.^2);


% Rotate patch and kout in reciprocal space from its 0,0,0,0,...  position to its position after detector motions completed
% Results as expressed in 'lab' coordinates. It rotates about Ewald sphere center so make that 'zero' 
	XYZ 	= DETinv * [Xdet;  Ydet;  Zdet];
	kout 	= DETinv * kout;

% However, in visualization, Keep lattice as reference (unmoved) 
% Thus rotate patch and kout due to sample rotations and put in lattice axes
	newsphereCEN		= Uinv*SAMP*sphereCEN;
	XYZ			= Uinv*SAMP*( XYZ);
	kout			= Uinv*SAMP*kout;

% complete the 'paperwork' to return from column vectors of points back to 
%	a matrix forms used in surface plots
% and put center of Ewald sphere back in position
	X	= reshape(XYZ(1,:),N1,N2)  + newsphereCEN(1);
	Y	= reshape(XYZ(2,:),N1,N2)  + newsphereCEN(2);
	Z	= reshape(XYZ(3,:),N1,N2)  + newsphereCEN(3);

% if there is figure with this patch, go ahead and rotate the patch position and kin and kout lines to reflect new position
HSdeti.propdet = HSdet.propdet;
HSdeti.H = surface(X,Y,Z,HSdeti.propdet);
% if there is figure with this patch, rotate the patch position as
% requested, the below would move the existing patch
%if ishandle(HSdet.H)
%	set(HSdet.H,'xdata',X,'ydata',Y,'zdata',Z);
%	set(HSdet.HLkout.H,'xdata',[0 kout(1) ]+newsphereCEN(1),'ydata',[0 kout(2)]+newsphereCEN(2),'zdata',[0 kout(3)]+newsphereCEN(3));
%end
if ADDflag~=0;
	if ishandle(HSdet.H)
		set(HSdet.H,'xdata',X,'ydata',Y,'zdata',Z);
		set(HSdet.HLkout.H,...
			'xdata',[0 kout(1) ]+newsphereCEN(1),...
				'ydata',[0 kout(2)]+newsphereCEN(2),...
					'zdata',[0 kout(3)]+newsphereCEN(3));
		set(HSdet.HLkin.H,'xdata',[newsphereCEN(1) 0],'ydata',[newsphereCEN(2) 0],'zdata',[newsphereCEN(3) 0]);
	end
else 
%	HSdeti = HSdet;
	HSdeti.propdet = HSdet.propdet;
	HSdeti.H = surface(X,Y,Z,HSdeti.propdet);
end

