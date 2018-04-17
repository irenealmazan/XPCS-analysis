function [HSdet] = det_patch_im(HSdet,image)
% HSdet = detectorpatch_im(HSdet,image)
% places image as the detector patch

% should eventually take out size checking to calling program so that
% this program does not have extraneous 'if' statements to slow it down
% Note - detector e.g. pilatus image size is col x rows which is gam vs del   
% so when reading detector image - the tif has X(gamma) and Y(delta)
% 
% but in the detector patch, we are oriented to the spectrometer axes
% where x is Nu and z is Delta (at 0,0,0,0) and the calculation of the
% patch surface is done as is y(x,z)  (then rotated wherever needed)
DetCalib = HSdet.DetCalib;

%Image = 
% respect to pixels
% note that NY is related to Nu (rows) and NX is related to Delta (columns)
%		this is w.r.t. the rows/columns of the matrix
% However,
%		w.r.t. the image, X is X (columns) and Y is Y (rows) but size of
%		image will be output as (Y,X)
% unless detector rotated 90 degrees from our standard
[NYi NXi] = size(image);

	if any([NYi NXi]~=DetCalib.SIZE);
		D1= 'image size is not consistent with detector information';
		D2 = ['images size is [',int2str([NYi NXi]),'], detector calibration information is [',int2str(DetCalib.SIZE),' ]'  ];
		ERRORm = strvcat(D1, D2);
		disp(ERRORm)
		return
	end

% Now - it actually may need to be rotated if for purposes of placing on the detector patch
	if DetCalib.transpose_flag==1;
	%%% think harder here, need to figure out automatic way 
	%%% to decide when transpose (mirror) and when rotate
		image = image';
	end
	
HSdet.PropDet=imageprops(image);
	
% if there is figure with this patch, show new image on patch
if ishandle(HSdet.H)
	set(HSdet.H,HSdet.propdet)
end

	
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function props = imageprops(image);
 %decorate edges
 %edgedecorate = zeros(size(image));
 %edgedecorate([1:3 (end-3):1:end],:) = ones(size( edgedecorate([1:3 (end-3):1:end],:)     ) ).*1e7;
 %edgedecorate(:, [1 end]) = ones(size(edgedecorate(:,[1 end]) )).*1e7;
 
	props.Cdata = image; 
	props.EdgeColor = 'none';
	props.FaceColor = 'interp';
	% the following maps transparency with the cdata allowing more intense
	% things to be more opaque, and less intense to be transparent.
	props.Alphadata = ones(size(image));%image;%(image-min(min(image)))./[max(max(image))-min(min(image))];%ones(size(image));
	props.Alphadatamapping = 'scaled';%'scaled';%'scaled';
	props.FaceAlpha = 'interp';%'interp';     % texture (when different size than zdata, or interp, or a number
	props.EdgeAlpha = 'interp';
	%ideally, Alim would be equal to Clim
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	DisplayName
%	CData
%	Clim
%	CDataMapping: [ direct | {scaled} ]
%	EdgeColor: [ none | flat | interp ] -or- {a ColorSpec}.
%    FaceColor: [ none | {flat} | interp | texturemap ] -or- a ColorSpec.
%
%	AlphaData
%	Alim
%	AlphaDataMapping: [ none | direct | {scaled} ]
%	EdgeAlpha: [ flat | interp ] -or- {an Alpha}.
%	FaceAlpha: [ flat | interp | texturemap ] -or- {an Alpha}.
%
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

