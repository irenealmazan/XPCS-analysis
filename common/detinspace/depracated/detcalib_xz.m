function det_s = detcalib_xz(det_s)
% det_s = detcalib_xz(det_s)
% Takes detector calibration structure (set up per detector/run)
% and adds fields/data related to xyz lab/diffractometer making it
% possible to create patches for visualizations.

% QX, QY, QZ with respect to diffractometer at 00000
%	With respect to the UB (determined from lattice and OM)
%	QX is parallel with the H, QY is in same plane as defined by H and K
%	and QZ is perpendicular to that plane.
%
% The detcalib parameter files are set up to be created relatively
% straightforwardly with some recipes for finding the parameters.
% These are not in the detcalib files because it would make them too
% complicated and are useful mostly just for mapping the det patch 
%	
% rowdir and  coldir can be +x, -x, +z -z  and they are ONLY related
% to the spectrometer geometry 
% (They will never be +y or -y 
% But could conceivably be mixture of xz if detector has independent rotation 
% separate from usual spectrometer angles

% Keep notation with 'raw' image as [ROWS,COLS] = size(imageraw)  
%		(or in plotting [Y,X]=size)
% but do not confuse imageing pixel Y and X with what is meant by 'x' and 'z' used below. 

% Figure out detector patch orientation on diffractomer (at 0,0,0,0)
	x=[1 0 0];
	z=[0 0 1];

	% Given the geometry angle associated with the col or row on image,
	% What axis does this angle rotate about +z, +x, -z, -x?
	% In detcalib structure, user has entered this as '+z' or '-x' etc
	COLDIR = eval(det_s.coldir);
	ROWDIR = eval(det_s.rowdir);

	% Figure out detector indexing with repsect to xyz spectrometer 
	xzsign	= sign([det_s.col_sgnD2P.*COLDIR + det_s.col_sgnD2P.*ROWDIR]);

	NROW = det_s.SIZE(1);
	NCOL = det_s.SIZE(2);
	
	% Row(Y on matrix) is 'z' on spectrometer -don't need to transpose patches
	% Col(X on matrix) is 'z' on spectrometer -need to transpose  
	if abs(COLDIR)==z;  
		xname		=	det_s.rowname;
		zname 		= 	det_s.colname;
		TRANSPOSE_flag 	= [1];
		Nzcentered	= 	xzsign(3).*([1:NCOL]-det_s.colCEN);
		Nxcentered	=	xzsign(1).*([1:NROW]-det_s.rowCEN);

	else
		xname		=	det_s.colname;
		zname		=	det_s.rowname;
		TRANSPOSE_flag = [0];
		Nzcentered	= 	xzsign(3).*([1:NROW]-det_s.rowcen);
		Nxcentered	=	xzsign(1).*([1:NCOL]-det_s.colcen);

	end

	% additional information
	det_s.transpose_flag 	= TRANSPOSE_flag;
	det_s.Nzcentered 	= Nzcentered;
	det_s.Nxcentered 	= Nxcentered;
	det_s.zname		= zname;
	det_s.xname		= xname;
	det_s.docu		= strvcat(det_s.docu,'***',[date, 'x z related to detpatch graphics']);
	

end

%%%%%%%%%%%%  HELPER FUNCTIONS %%%%%%%%%%%%%

%% If using a circle, one could be careful about the detector being flat
%% this is a very small effect we ignore for noe, however, if the motor is a rotation/translation
%% this is a big effect. 

