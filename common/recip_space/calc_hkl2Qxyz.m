function [hkl_xyz] = calc_hkl2Qxyz(enum_hkl,cparam)
% hkl_xyz = calc_hkl2Qxyz(hkl,cparam)
% hkl_xyz = calc_hkl2Qxyz(hkl,OM)
% C. Thompson rev. 2016-0110
%
% Converts an (hkl) lattice point to its Q components (qx qy qz) 
%		in a cartesian coordinate system suitable for plotting with plot3d. 
%		Q units will be 2pi/Angstrom (assuming lattice parameters in Ang)
%			Qx will be defined parallel to H 
%			Qz will be perpendicular to H and K 
%			Qy perpendicular to Qx and Qz (right handed)
%
% OUTPUT structure
%	hkl_xyz.q_xyz	3xN matrix, N number of points, 		
%	hkl_xyz.q_unit	3x3 matrix - columns are [Qh Qk Ql], that is, the
%					reciprocal unit cell vectors expressed in units Qx, Qy, Qz
%		the following pass the input arguments help for later use of the structure
%	hkl_xyz.unitcell [a b c alpha beta gamma]   (passes the lattice parameters)
%	hkl_xyz.hkl		the original matrix (3xN) of lattice points converted
%	hkl_xyz.docu	string that passes what was given in latdocu	
%
% INPUT (plain)
%	enum_hkl	3xN matrix - N columns each a separate hkl 
%		the function "enumlatticehkl" might be useful to populate this
%		emum_hkl = ...
%				[h1 h2 h3 ...
%				 k1 k2 k3 ...
%				 l1 l2 l3 ...]
%	cparam   	[a b c alpha beta gamma]   ANGLES are in DEGREES
%	PM	(struct) the OM structure, just needs OM.cparam piece

if isstruct(cparam);
	OM		= cparam;
	cparam	= OM.cparam;
end
if nargin<1, 
	cparam = [3.905 3.905 3.905 90 90 90];
	enum_hkl = enumlatticehkl([0:4],[0:4],[0:4]); 
end

%% other possibilities for useful defaults
%cparam = [3.905 3.905 3.905 90 90 90]; latdocu='SrTiO3';

UB = calc_UB(cparam);

hkl_xyz.cparam	 	= 	cparam;
hkl_xyz.hkl  		=   enum_hkl;

% basis set in cartesian units where qH is along X
% qZ is perpendicular to H, K, and qY is perpendicular to qH, qZ
hkl_xyz.q_unit = (UB.B * eye(3,3));
hkl_xyz.q_xyz = (UB.B * enum_hkl);

end
