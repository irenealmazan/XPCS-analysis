function [X,Y,Z,newsphereCEN,HSdeti] = det_patch_rot_add(HSdet,angles,UB,spectrometer_hphi_function)
%  [X,Y,Z,newsphereCEN,HSdeti] = det_patch_rot_add(HSdet,angles,UB,spectrometer_hphi_functiom)
%   adds a new detector patch according to detector rotations and
%   *adds* a new patch at sample rotations to place it with respect to lattice.
%       note    det_patch_rot will rotate the existing patch at (HSdet)
%               det_patch_rot_add will rotate but place new patch     
%  HSdet is output of  det_patch, and includes the HSdet.x0, .y0, .z0
% [X,Y,Z] are the new X,Y,Z to be used in slice or in plotting of the new
% % NO NOT CHANGE HSdet.x0, .y0, .z0 since these are at 0,0,0,0,0
%% and needed for each new rotation calculation
%HSdetector.x0 = Xdet;
%HSdetector.y0 = Ydet;
%HSdetector.z0 = Zdet;
%HSdetector.sphereCEN0 = sphereCEN;   % at zeroed detector
%HSdetector.H = surface(Xdet,Ydet,Zdet,propdet);
%HSdetector.propdet = propdet;
%HSdetector.detcalib = detcalib;
%HSdetector.Energy = Energy;
%HSdetector.HLkout = HLkout;

%if nargin<2;angles = [15.8838 45.4134 1.18977 8.465];end  %1 1 2 in GaN
if nargin<3;UB.U=1;end
if isempty(UB);UB.U=1;end
if nargin<4; spectrometer_hphi_function = 'zaxis_mocvd';end

% different rotation operators for different diffractometers
% this command makes calc_ROTOPER act as pointer to correct function
calc_ROTOPER = str2func(['calc_ROTOPER_',spectrometer_hphi_function]);

sphereCEN = HSdet.sphereCEN0;
kSCALE = 2*pi.*HSdet.Energy./fhc;
kout = (([0 1 0]'.*kSCALE));

[N1,N2] = size(HSdet.x0);
%transform to XYZ, 
% Note- because unitary DETinv  = DET' and Uinv is U';
% Caution, if needed to invert - B is not unitary, neither is UB  (UB.B, UB.UB)

[DET,SAMP,OPER] = calc_ROTOPER(angles);
DETinv = DET';
%kout = (DETinv *([0 1 0]'.*kSCALE))';
% need to rotate about center of ewald sphere, and to use DET* or DETinv*
% need columns of [x1;y1;z1 ....]

% Rotate  due to detector rotations
% due to detector positions from ZEROd orientation of spectrometer
XYZ = DETinv*[HSdet.x0(:)'-sphereCEN(1);  
                HSdet.y0(:)'-sphereCEN(2);  
                HSdet.z0(:)'-sphereCEN(3)];
kout = DETinv*kout;

% Keep lattice fixed and rotate due to sample rotations
% This keep lattice as reference (unmoved) in a visualization
	Uinv = inv(UB.U);
	newsphereCEN	= Uinv*SAMP*sphereCEN;
	XYZ					= Uinv*SAMP*( XYZ);
	kout					= Uinv*SAMP*kout;

	% return from column vectors of points to matrix used in surface plots
	X = reshape(XYZ(1,:),N1,N2)  + newsphereCEN(1);
	Y = reshape(XYZ(2,:),N1,N2) + newsphereCEN(2);
	Z =  reshape(XYZ(3,:),N1,N2) + newsphereCEN(3);

HSdeti.propdet = HSdet.propdet;
HSdeti.H = surface(X,Y,Z,HSdeti.propdet);
% if there is figure with this patch, rotate the patch position as
% requested, the below would move the existing patch
%if ishandle(HSdet.H)
%	set(HSdet.H,'xdata',X,'ydata',Y,'zdata',Z);
%	set(HSdet.HLkout.H,'xdata',[0 kout(1) ]+newsphereCEN(1),'ydata',[0 kout(2)]+newsphereCEN(2),'zdata',[0 kout(3)]+newsphereCEN(3));
%end

end


%	AlphaData
%	AlphaDataMapping: [ none | direct | {scaled} ]
%	EdgeAlpha: [ flat | interp ] -or- {an Alpha}.
%	FaceAlpha: [ flat | interp | texturemap ] -or- {an Alpha}.
%	CData
%	CDataMapping: [ direct | {scaled} ]
%	EdgeColor: [ none | flat | interp ] -or- {a ColorSpec}.
%   FaceColor: [ none | {flat} | interp | texturemap ] -or- a ColorSpec.
%	DisplayName
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
