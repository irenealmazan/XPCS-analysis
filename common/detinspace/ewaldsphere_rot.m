function [X,Y,Z,newsphereCEN] = ewaldsphere_rot(HSsphere,angles,UB,spectrometer_name)
%[HSsphere] = ewaldsphere_rot(params)
% Rotates and moves the ewald sphere
%   
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

if nargin<2;angles = [15.8838 45.4134 1.18977 8.465];end  %1 1 2 in GaN c-plane template
if nargin<3;UB.U=1;end
if isempty(UB);UB.U=1;end;
if nargin<4; spectrometer_name = 'zaxis_mocvd';end

calc_ROTOPER = str2func(['calc_ROTOPER_',spectrometer_name]);

sphereCEN = HSsphere.sphereCEN0;

% be careful - which is 'z' is gam and 'x' in spectrometer is del
[N1,N2] = size(HSsphere.x0);
%transform to XYZ, because unitary DETinv  = DET';
[DET,SAMP] = calc_ROTOPER(angles);
%newsphereCEN = SAMP*HSsphere.sphereCEN0;
DETinv = DET';
Uinv = inv(UB.U);

% Rotate  due to detector rotations
% due to detector positions from ZEROd orientation of spectrometer
% actually, rotating sphere does not move it anywhere
XYZ = DETinv*[HSsphere.x0(:)'-sphereCEN(1);  
                HSsphere.y0(:)'-sphereCEN(2);  
                HSsphere.z0(:)'-sphereCEN(3)];

% Keep lattice fixed and rotate due to sample rotations and lattice
% This keep lattice as reference xyz (unmoved) in the visualization	
	newsphereCEN	= Uinv*SAMP*sphereCEN;
	XYZ		= Uinv*SAMP*( XYZ);


% return from column vectors of points to matrix used in surface plots
X = reshape(XYZ(1,:),N1,N2)  + newsphereCEN(1);
Y = reshape(XYZ(2,:),N1,N2)  + newsphereCEN(2);
Z = reshape(XYZ(3,:),N1,N2)  + newsphereCEN(3);

if 0
XYZ = DETinv*[HSsphere.x0(:)';  HSsphere.y0(:)';  HSsphere.z0(:)'];

% Keep lattice fixed and rotate due to sample rotations
% This keep lattice as reference (unmoved) in the visualization	
	newsphereCEN	= Uinv*SAMP*sphereCEN;
	XYZ		= Uinv*SAMP*( XYZ);

% return from column vectors of points to matrix used in surface plots
X = reshape(XYZ(1,:),N1,N2) ;
Y = reshape(XYZ(2,:),N1,N2) ;
Z = reshape(XYZ(3,:),N1,N2) ;
end

%Hkin		=	make3line([newsphereCEN';0 0 0]);
if ishandle(HSsphere.H)
	set(HSsphere.H,'xdata',X,'ydata',Y,'zdata',Z);
	set(HSsphere.HLkin.H,'xdata',[newsphereCEN(1) 0],'ydata',[newsphereCEN(2) 0],'zdata',[newsphereCEN(3) 0]);
	
end

