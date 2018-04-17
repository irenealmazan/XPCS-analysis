function det_s = detcalib_xztanR(det_s)
% det_s = detcalib_xztanR(det_s)
% Takes detector calibration structure (set up per detector/run)
% and adds fields/data related to xyz lab/diffractometer making it
% possible to create patches for visualizations.

% my xz notation has changed - more natural to ask the rotation axis (instead of direction?) in the detcalib describe the rotation axis (and then at 00000 something that rotates about +x, then at zero, going +z goes to higher angle, if soething rotations about +(-)z, then going to -(+) x goes to higher angle

%	DetCalib.docu
%	DetCalib.SIZE = [195 487];  % [Y=rows X=columns] = size(image)  
%	DetCalib.ADU2photon = [-1] %uncalb

%  'X' of raw image  (columns) 
%	DetCalib.colname 	= 'Delta';
%	DetCalib.coldir 	= '+x'; % axis for angle rotation at [0,0,...] 
%	DetCalib.colDeg2	= 2.23;
%	DetCalib.col2Pix	= 100;
%	DetCalib.col_sgnD2P 	= +1;  % change here to neg if necessary
%	DetCalib.colCEN	= round(mean(([1 3]-1)+116));

%  'Y' of raw image  (rows)
%	DetCalib.rowname 	= 'Nu';
%	DetCalib.rowdir 	= '+z';  % axis for angle rotation at [0,0,...]
%	DetCalib.rowcal		=[deg pixX pixY]  %about direct beam, deg absolute, 
%	DetCalib.rowDeg2	= 2.23;
%	DetCalib.row2Pix	= 100;
%	DetCalib.row_sgnD2P 	= +1;  % change here to neg if necessary
%	DetCalib.rowCEN	= round(mean(([1 7]-1)+100)); 

% To convert the tanR to the angle, keeping it in tanR so that
%		it is easier to use either rotation (huber) or rotation translation
%		if plain rotation, atand(tanR)+new center
%		if axis is rotation translation atand(tanR*tanTcorr) + new center

% X and Y refer to raw image
% x and z refer to orthogonalized
%
% 	x and z are used in programs that visualize the detector moving in reciprocal space

NROW = det_s.SIZE(1);
NCOL = det_s.SIZE(2);

colcenteredpix = ([0:NCOL-1]-det_s.colCEN);
rowcenteredpix = ([0:NROW-1]-det_s.rowCEN);

% tan(angle) from center (at zero) 
coltanR = calcR(det_s.col2Pix,det_s.colDeg2,colcenteredpix);
rowtanR = calcR(det_s.row2Pix,det_s.rowDeg2,rowcenteredpix);

	det_s.coltanR	= coltanR;
	det_s.rowtanR	= rowtanR;


return
% the following is related to makeing the detector patches
% Figure out detector patch orientation on diffractometer (at 0,0,0,0)
% my xz notation has changed - more natural to ask the rotation axis (instead of direction?) in the detcalib. This describes the rotation axis (and then at 00000 if an angle rotates about +x, then at zero, going +z on detector goes to higher angle, if something rotations about +(-)z, then going to -(+) x goes to higher angle,  (that is why these are defined as they are
	x=[1 0 0];
	z=[0 0 1];

	% Given diffractometer angle associated with the col or row on image,
	% Positive angle is CCW rotation of this angle is about the ? axis  +z, +x, -z, -x?
	% (e.g. zaxis (+delta is CCW about -z) (+gamma CCW about +x)
	%	sevchex (+nu CCW about -z) (+delta CCW about +x)
	%	caxis (+delta is CCW about +z) (+delta CCW about +x)
	%	The  +y axis is downstream, -y is upstream)
	COLROT = eval(det_s.colangleaxis);
	ROWROT = eval(det_s.rowangleaxis);

	% Figure out detector indexing (at zero) with respect to xyz spectrometer 
	xzsign	= sign([det_s.col_sgnD2P.*COLROT + det_s.col_sgnD2P.*ROWROT]);

	NROW = det_s.SIZE(1);
	NCOL = det_s.SIZE(2);
	
	% Row(Y on matrix) is 'z' on spectrometer -don't need to transpose patches
	% Col(X on matrix) is 'z' on spectrometer -need to transpose  
	if abs(COLROT)==x;  
		xname		=	det_s.rowname;
		zname 		= 	det_s.colname;
		TRANSPOSE_flag 	= [1];
		Nzcentered	= 	xzsign(1).*([1:NCOL]-det_s.colCEN);
		Nxcentered	=	-xzsign(3).*([1:NROW]-det_s.rowCEN);

	else
		xname		=	det_s.colname;
		zname		=	det_s.rowname;
		TRANSPOSE_flag = [0];
		Nzcentered	= 	xzsign(1).*([1:NROW]-det_s.rowCEN);
		Nxcentered	=	-xzsign(3).*([1:NCOL]-det_s.colCEN);

	end

	

	% additional information
	det_s.transpose_flag 	= TRANSPOSE_flag;
	det_s.Nzcentered 	= Nzcentered;
	det_s.Nxcentered 	= Nxcentered;
	det_s.zname		= zname;
	det_s.xname		= xname;
	det_s.docu		= strvcat(det_s.docu,'***',[date, 'x z related to detpatch graphics']);
	det_s.coltanR0	= coltanR;
	det_s.rowtanR0	= rowtanR;
	
	

end

%%%%%%%%%%%%  HELPER FUNCTIONS %%%%%%%%%%%%%

%% If using a circle, one could be careful about the detector being flat
%% this is a very small effect we ignore for noe, however, if the motor is a rotation/translation
%% this is a big effect. 
%%%%%%%%%%%%%%% HELPER FUNCTIONS %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function deg = calcDegrees(delPix,Nm,angm,angcen)
% choose which one to do
	if strcmp(DetCalib.RotType,'RotTrans')
		deg = calcRT(Nm,angm,delPix,angcen);
	else
		deg = calcR(Nm,angm,delPix);
	end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  tandegRT = calcRT(Nm,angm,delPix,angcen)
% Calculates the angles at a pixel for a spectrometer angle
% when the rotation angle is created from coupled rotation/translation
% Assumed equal aize pixels, but calculated correctly for flat detector
% Assumed 'perpendicular' to scattered beam/direct beam
%
%   angcen is angle at detector center (degrees)
%   delPix is pixels from the center
%
%	Nm and angm are the calibrations acquired when center of detector
% 		was at zero angle

% This is exact calculation
	tandegRT 	=  delPix .* cosd(angcen).*tand(angm)./(cosd(angm).*Nm);
	degRT		=  atand(tandegRT);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  tandegR = calcR(Nm,angm,delPix,angcen)
% Calculates the angles at a pixel for a spectrometer angle
% when the angle is created from a rotation (circle)
% Assumed equal aize pixels, but calculated correctly for flat detector
% Assumed 'perpendicular' to scattered beam/direct beam
%
%   delPix is pixels from the center
%
%	Nm and angm are the calibrations acquired when center of detector
% 		was at zero angle

% This is exact calculation
	tandegR 	= delPix.*tand(angm)./Nm;
	degR 		= atand(tandegR);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
