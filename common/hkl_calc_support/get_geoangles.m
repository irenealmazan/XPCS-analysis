function ANGLES = get_geoangles(outdata,collabels,ScnInfo)
% ANGLES = get_geoangles(outdata,collabels,scninfo)
%		extracts the geometry angles from scan and also header
%		
%	OUTPUT (matrix)
%		ANGLES (Npts x NAngles) matrix  (one row per point in scan)
%			will get any spectometer geometry angles in scan, 
%			Geometry angles are those related to calculating hkl, etc)
%				a 4 circle might be TwoTheta, Theta, Chi, Phi
%			Column order will be determined by how their labels are denoted
%	INPUT  (will requires output from readspecscan and readspecscan_XXX_helper type program)
%		outdata (matrix) full data from the scan in spec file
%		collabels (string row) labels line from the scan in spec file
%		ScnInfo (structure) as output from readspecscan helper files 
%			ScnInfo.geoangles_i  (spectrometer positions from header of scan
%			ScnInfo.geoangles_label (the names of the angles)
%
% Typically for detector or hkl calculations, need all the geo angles

% finds which columns (NDX) in scan have motors that are geo motors
% and which ones are matching in of the geo labels (NDXgeo)

[NPTS,COLUMNS]	= size(outdata);
[geoNUM]	 	= length(ScnInfo.geoangles_i(:,1));

% without regard to angles that may be changed in the scan
ANGLES  = ones(NPTS,1) * ScnInfo.geoangles_i(:)';

% finds which columns (NDX) in scan have motors that are geo motors
% and, of those geo motors we expect, which ones they were (NDXgeo)
[NDX,NDXgeo] 	= chan2col(collabels,ScnInfo.geoangles_label,'quiet');

if ~isempty(NDX)
	geoangles_in_scan = outdata(:,NDX);
	% replace the columns of those that were changing in scan
	%	NDXgeo gives those columns
	ANGLES(:,NDXgeo) = geoangles_in_scan;
end




