function [HSsphere] = ewaldsphere(Energy)
%[HSsphere] = ewaldsphere(params)
%   draws an ewald sphere
% Center of sphere at [0 -1 0]*kscale  hf is pointing along + y
%need params center or vector from center to originalong
%[Xewald0, Yewald0, Zewald0] = sphere(20);  %makes sphere, radius 1 at origin)
%R0 radius
%CEN = [X0 Y0 Z0];
%Xewald = R0.*Xewald0 + X0; 
%Yewald = R0.*Yewald0 + Y0;
%Zewald = R0.*Zewald0 + Z0;
%quiver3(x,y,z,u,v,w,0) 
%plots vectors with components (u,v,w) aXewald = Xewald+X0;t the points (x,y,z). The matrices x,y,z,u,v,w must all be the same size and contain the corresponding position and vector components. 
% using 0 in 7th is 'scale' and 0 means do not scale to not overlap
% (otherwise, it doesn't actually draw the right distance, just draws all
% equivalently scalled so as not to overlapp
if nargin<1;Energy = 28300;end;
N=100;

% make sphere and place it
[x,y,z] = sphere(N);
kSCALE = 2.* pi .*Energy/fhc;
x=(x+0).*kSCALE;
y=(y-1).*kSCALE;
z=(z+0).*kSCALE;
sphereCEN = [0 -1 0]'.*kSCALE;
% kin = sphereCEN to 000, kout is 000 to DETinv*kin (rotated)
clf;
axis square 
propewald = ewaldsphereproperties(ones(size(z)));

%Hkin		=	make3line([sphereCEN;0 0 0]);

%HL = line(0,0,0);
%set(HL,'marker','.','markersize',20,'color','r');
HL = make3sphere([0;0;0],.03,[1 0 0],.9);

kin = (([0 -1 0]'.*kSCALE));
HLkin	=	make3line([kin [0;0;0]]);

HSsphere.H = surface(x,y,z,propewald);
HSsphere.x0 = x;
HSsphere.y0 = y;
HSsphere.z0 = z;
HSsphere.propewald  = propewald;
HSsphere.sphereCEN0 = sphereCEN;
HSsphere.HLkin = HLkin;

%L1	=	light('position',[1    1  0].*kSCALE);
%L2	=	light('position',[1   .2   -0.8].*kSCALE,'color',[0.6 0.2 0.2]);

axis equal
axis([-1 1 -1 1 -1 1].*ceil(kSCALE));
set(gca,'clim',[0 2]);
xlabel('q_x'),ylabel('q_y'),zlabel('q_z')


end

function [props]=ewaldsphereproperties(CDATA)
	%for metallic somewhat transparent ball of CDATA colors that is lit up
	props.AmbientStrength = 0.3;
	props.DiffuseStrength = 0.3;
	props.SpecularStrength = 1;
	props.SpecularExponent = 25;
	props.SpecularColorReflectance = 0.8;
	
	props.FaceColor= 'texture';  %'flat'
	props.EdgeColor = 'none';%'interp';
	props.FaceLighting = 'phong';
	props.Cdata = ones(size(CDATA)).*0.5;
	
	props.FaceAlpha = 0.05; %  'texture';
	props.EdgeAlpha = 0.05;%'none';%'flat' need alphadata same size as zdata
	%props.Alphadatamapping = 'none';% default is 'scaled'
	%props.Alphadata = ones(size(DETECTOR)).*.8;
end


function testing
if 0
cparam = [3.186 3.186 5.178 90 90 120];

h1 = [1 1 0];
a1 = [15.8076 42.55 0 0 ];
h2 = [-1 2 0];
a2 = [15.8076 103.155 0 0];
h3 = [1 1 2];
a3 = [15.8838 45.4134 1.18977 8.465];
h4 = [1 1 4];
a4 = [15.9402 54.0976 1.19303 18.3698];

sigma = 0.19328;tau = -146.15;
HKLnorm =[ -0.00205 0.0013029 1];
end
end

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
