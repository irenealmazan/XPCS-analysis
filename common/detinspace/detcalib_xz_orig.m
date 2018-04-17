function det_s = detcalib_xz(det_s)
% takes the detetor calibration structure and adds more information onto it
% that is necessary for putting images onto detector patches in the graphics
%
% in directions for reciprocal space QX, QY, QZ with respect to diffractometer at 00000
%	Note - with respect to the UB (determined from lattice and OM)
%	QX is parallel with the H, QY is in same plane as defined by H and K
%	and QZ is perpendicular to that plane.
%
% The detcalib parameter files are set up to be 'easy' for
% a user to input intuitively understood parameters that are
% connected to the diffractometer and detector in front of them
%	 but that can be translated here to QX QY QZ that
%	can map the det patch (or later image onto that patch) properly
%	
% rowdir and  coldir can be +x, -x, +z -z. 
% (They will never be +y or -y 
%	but could conceivably be mixture of xz if detector has independent rotation 
%	separate from usual spectrometer angles

% Keep notation with 'raw' image as [ROWS,COLS] = size(imageraw)  (or in plotting [Y,X]=size)
%	but do not confuse this Y and X with what is meant by 'X' and 'Z' used below. 

% Figure out detector patch orientation on diffractomer (at 0,0,0,0)
	x=[1 0 0];
	z=[0 0 1];

	% +x,-x,+z,-z will evaluate as [1 0 0] or [-1 0 0] or [0 0 1] or [0 0 -1]
	COLDIR = eval(det_s.coldir);
	ROWDIR = eval(det_s.rowdir);

	% following will give [xdeg2pix 0 ydeg2pix] with sign so we can pick out x, z
	xzdeg2pix	= [det_s.coldeg2pix.*COLDIR + det_s.rowdeg2pix.*ROWDIR];
	xzsign 		= sign(xzdeg2pix);   % used to figure out if need to make N neg

	zang2pix	=	abs(xzdeg2pix(3));
	xang2pix	=	abs(xzdeg2pix(1));


	NROW = det_s.SIZE(1);
	NCOL = det_s.SIZE(2);
	% if on raw image, rows end up related to X on spectrometer, and col to Z on spectrometer
	%	according to precsription outlined in detector calibration files
	if abs(COLDIR)==z;  % condition need to figure out
		TRANSPOSE_flag 	= [1];
		Nzcentered	= 	xzsign(3).*([1:NCOL]-det_s.colCEN);
		zname 		= 	det_s.colname;
		Nxcentered	=	xzsign(1).*([1:NROW]-det_s.rowCEN);
		xname		=	det_s.rowname;
		danglez		=	Nzcentered.*zang2pix;
		danglex		=	Nxcentered.*xang2pix;

	else
		TRANSPOSE_flag = [0];
		Nzcentered	= 	xzsign(3).*([1:NROW]-det_s.rowcen);
		zname		=	det_s.rowname;
		Nxcentered	=	xzsign(1).*([1:NCOL]-det_s.colcen);
		xname		=	det_s.colname;
		danglez		=	Nzcentered.*zang2pix;
		danglex		=	Nxcentered.*xang2pix;

	end

	% additional information
	det_s.transpose_flag 	= TRANSPOSE_flag;
	det_s.Nzcentered 	= Nzcentered;
	det_s.Nxcentered 	= Nxcentered;
	det_s.zang2pix		= zang2pix;
	det_s.xang2pix		= xang2pix;
	det_s.zname		= zname;
	det_s.xname		= xname;
	det_s.docu		= strvcat(det_s.docu,'***',[date, 'x z related to detpatch graphics']);
	det_s.danglez		= danglez;
	det_s.danglex		= danglex;
	


end

