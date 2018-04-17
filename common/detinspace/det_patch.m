function [HSdet] = det_patch(Energy,DetCalib)
%[HSdet] = det_patch(Energy,DetectorCalib)
%   draws the patch in reciprocal space with a detector patch at the
%   0,0,0,0,0, position (using center from detectorcalib to place patch
% Center of sphere along [0 1 0] (in -Y direction)
% and detector at 90 degrees along x axis
%need params center or vector from center to origin
% need to check, center, some point has to be at origin (use as 
% Center must be R0 from the origin, since origin is on the sphere 
% (k0 is from center  of sphere to origin
%HSdet.x0 = Xdet;
%HSdet.y0 = Ydet;
%HSdet.z0 = Zdet;
%HSdet.sphereCEN0 = sphereCEN;
%HSdet.H = surface(Xdet,Ydet,Zdet,propdet);
%HSdet.PropDet = propdet;   %surface patch properties
%HSdet.DetCalib = DetCalib;
%HSdet.Energy = Energy;
%HSdet.HLkout = HLkout;


if nargin<1;Energy = 24000;end;
if nargin<2;DetCalib = default_det;end;

% THIS ASSUMES ORIENTATION OF 2D DETECTOR 
% WHEN READING THE TIF (or HDF, etc)
% THAT OUTPUT TIF has  
%  DetCalib.coldir and .rowdir gives whether orientation in detector is + or -x, + or -z
%		w.r.t spectrometer axis at 0,0,0,0 )
%	i.e., the direction of 'higher' pixel number which way does it go
%		since depending on how detector is oriented, could be weird
%		this program takes care of everything (assuming DetCalib set up OK)
%		but does not account for independent detector rotation about y axis
%			(neither zaxis or caxis do not have this motion)
% X (columns in matrix) is Delta   ('z' w.r.t spectrometer axis at 0,0,0,0 )
% Y (rows in matrix) is Nu ('x' w.r.t. spectrometer axis at 0,0,0,0)
% *******change here is detector rotated by 90 degrees
% also one more line futher down (search on 90 degrees)
% and will also have to fix 


% Figure out who is X and who is Z (at 0,0,0,0) and add onto the information
	
	DetCalib = detcalib_xz(DetCalib);

	kSCALE = 2.* pi .*Energy/fhc;
	sphereCEN = [0 -1 0]'.*kSCALE;
% kin = vector [sphereCEN to 000], kout = vector [sphereCEN to DETinv*kin] (rotated)
%%%%%% 

% make detector (spectrometer : z' , x')  
%  arc = r*angle, projection in z', x'
	Zprime = kSCALE .* sind(DetCalib.Nzcentered.*DetCalib.zang2pix);
	Xprime = kSCALE .* sind(DetCalib.Nxcentered.*DetCalib.xang2pix);

	[Xdetprime,Zdetprime] = meshgrid(Xprime,Zprime);    
	Ydetprime = sqrt(kSCALE.^2 - Xdetprime.^2 - Zdetprime.^2 );

	Xdet 	= Xdetprime + sphereCEN(1);
	Ydet 	= Ydetprime + sphereCEN(2);
	Zdet 	= Zdetprime + sphereCEN(3);
	kout 	= (([0 1 0]'.*kSCALE));
	kin 	= (([0 -1 0]'.*kSCALE));

	axis square 
	propdet = detectorproperties(ones(size(Xdet)));

% drawing the lines and origin marker
	HLkout	= make3line([[0;0;0] kout]+[sphereCEN sphereCEN]);
%	HL 	= line(0,0,0);
%		set(HL,'marker','+','markersize',8,'color','r','linewidth',2);
	HL = make3sphere([0;0;0],.03,[1 0 0],.9);
	HLkin	=	make3line([kin [0;0;0]]);

% These are reference to rotate from 0,0,0,0
	HSdetector.x0 = Xdet;   
	HSdetector.y0 = Ydet;
	HSdetector.z0 = Zdet;

	HSdetector.PropDet = propdet;
	HSdetector.sphereCEN0 = sphereCEN;
	HSdetector.DetCalib = DetCalib;
	HSdetector.Energy = Energy;
	HSdetector.HLkout = HLkout;
	HSdetector.HLkin = HLkin;

% and actually plot the surface here and get output handle 
% output handle  and the output used by det_patch_rot, etc)
	HSdetector.H = surface(Xdet,Ydet,Zdet,propdet);

end   %end of function

%%%%%% HELPER FUNCTIONS%%%%%%%%%%%%%%%%

function [props] = detectorproperties(DETECTOR)
% for patch that is just on the detector, which will be shiny like metal, 
	props.AmbientStrength = 0.3;
	props.DiffuseStrength = 0.3;
	props.SpecularStrength = 1;
	props.SpecularExponent = 25;
	props.SpecularColorReflectance = 0.5;

	props.FaceColor= 'texture';  %'flat'
	props.EdgeColor = 'none';%'interp';
	props.FaceLighting = 'phong';
	props.Cdata = DETECTOR;

	props.FaceAlpha = 0.9;% 'texture';%'texture'; %'texture' if using 
	%props.EdgeAlpha = 'flat';%'flat';%
	props.Alphadatamapping = 'none';% to make all ones be 
	%props.Alphadata = ones(size(DETECTOR)).*.8;

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function det_s = default_det

DetCalib.docu = strvcat(...
'2016-02_Pilatus file working on structure');
DetCalib.SIZE = [195 487];  % [Y=rows X=columns] = size(image) 

%  'X' of raw image  (columns) what it is when seeing without any flips etc from imageJ
DetCalib.colname 	= 'Delta';
DetCalib.rowRotType	= 'RotTrans';
DetCalib.coldir 	= '-z'; % '+z' rotation axis for angle (not which way 
DetCalib.colCEN	= round(mean(([1 1]-1)+196))+1;
DetCalib.colDeg2	= 1.7;
DetCalib.col2Pix	= 146;
DetCalib.col_sgnD2P 	= +1;  % change here to neg if necessary

%  'Y' of raw image  (rows)
DetCalib.rowname 	= 'Nu';
DetCalib.rowRotType	= 'Rot';
DetCalib.rowdir 	= '+x';    % at 0,0,0,0,0, what axis of spectrometer is direction, positive nu moves detector CCW about +x 
DetCalib.rowCEN	= round(mean(([1 1]-1)+97))+1; 
DetCalib.rowDeg2	= 1.7;
DetCalib.row2Pix	= 146;
DetCalib.row_sgnD2P 	= +1;  % change here to neg if necessary

%% ADU2photon
%%	Calibrated efficiency of 'counts' in pixel to photons; 
%%		-1 (negative number) denotes uncertain, uncalibrated
%% 		+1  (1 count in pixel is 1 photon) (note: Pilatus are not 1 to 1 efficient at high energies.
%% 		0.5 means 1 count in pixel per 2 photons
DetCalib.ADU2photon 	= -1; 

end

%#CR ROI  1: MinX=   1  SizeX= 487 MinY=   1  SizeY= 195
%%%%%%%%reminders of stuff %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	AlphaData
%	AlphaDataMapping: [ none | direct | {scaled} ]
%	CData
%	CDataMapping: [ direct | {scaled} ]
%	DisplayName
%	EdgeAlpha: [ flat | interp ] -or- {an Alpha}.
%	EdgeColor: [ none | flat | interp ] -or- {a ColorSpec}.
%	FaceAlpha: [ flat | interp | texturemap ] -or- {an Alpha}.
%    FaceColor: [ none | {flat} | interp | texturemap ] -or- a ColorSpec.
%	LineStyle: [ {-} | -- | : | -. | none ]
%	LineWidth
%	Marker: [ + | o | * | . | x | square | diamond | v | ^ | > | < | pentagram | hexagram | {none} ]
%	MarkerEdgeColor: [ none | {auto} | flat ] -or- a ColorSpec.
%	MarkerFaceColor: [ {none} | auto | flat ] -or- a ColorSpec.
%	MarkerSize
%	MeshStyle: [ {both} | row | column ]
%	XData
%	YData
%	ZData
%	FaceLighting: [ none | {flat} | gouraud | phong ]
%	EdgeLighting: [ {none} | flat | gouraud | phong ]
%	BackFaceLighting: [ unlit | lit | {reverselit} ]
%	AmbientStrength
%	DiffuseStrength
%	SpecularStrength
%	SpecularExponent
%	SpecularColorReflectance
%	VertexNormals
%	NormalMode: [ {auto} | manual ]
% 'AmbientStrength'    'DiffuseStrength   'SpecularStrength'   'SpecularExponent'   'SpecularColorReflectance'
%    'Shiny',	0.3, 	0.6, 	0.9,	20,		1.0
 %   'Dull',		0.3,	0.8,	0.0,	10,		1.0
  %  'Metal',	0.3,	0.3,	1.0,	25,		.5
  
  
 
