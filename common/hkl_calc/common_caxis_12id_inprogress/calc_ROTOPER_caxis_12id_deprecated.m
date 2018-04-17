function [DET,SAMP,OPER] = calc_ROTOPER_caxis_12id(angles)
%[DET,SAMP] = calc_ROTOPER_caxis_12id([Nu Chi Eta Delta Phi(ignored) Mu(ignored)])
% C. Thompson 2012 05-10
% Output is the DET and SAMP matrix calculated with Angles (only one set per calculation) 
%	[Nu Chi Eta Delta]   % as output in prpeak in zaxis
% Calculates the rotation matrices for the DETECTOR and SAMPLE
% USING MATRIX MULTIPLICATION
%     (r)' = DET * r  or (r)' = SAMP * r
% gives r in coordinates of the rotated system.
%
% SAMP and DET are rotation matrices and 
% are unitary ( U^(-1) = U(transpose)
% calculated -  right handed x,y,z, before any rotations system  
% y (pointing downstream = kin), 
% z (pointing vertically), 
% x (pointing inboard)
% after all detector rotations, in new system r'(kout) = (0 1 0)
% For the zaxis mocvd,  
% DET = DELTA(CCW about +x)*NU(CW about +z);
% SAMP = CHI(CW about +z)*ETA(CCW about +x);

% Might be able to code this so that it does more than one set of angles at a time, 
% then output in a sparse block diagonal matrix 


% calculated using x,y,z and + rotations  as indicated above
Nu = angles(1);    % + CW about +z or its equivalent after rotate
Chi = angles(2);  % + CW about +z  or its equivalent after rotate
Eta = angles(3); % + CCW about +x immovable- always only about original x
Delta = angles(4); % + CCW about +x: or its equivalent after rotate

% The following are the full calculated
DET = [	cos(Nu)				-sind(Nu)				0
		cosd(Delta).*sind(Nu)	cosd(Delta).*cosd(Nu)	sind(Delta)
		-sind(Delta).*sind(Nu)	-sind(Delta).*cosd(Nu)	cosd(Delta)];

SAMP = [cosd(Chi)		-sind(Chi).*cosd(Eta)	-sind(Chi).*sind(Eta)
		sind(Chi)		cosd(Chi).*cosd(Eta)	cosd(Chi).*sind(Eta)
		0			-sind(Eta)			cosd(Eta)];

% use [minus value of angle] to turn an operator as written for CCW rotation to be defined for CW rotation
% (this is for having separate operators which can sometimes be useful for numerical checks)
	OPER.Nu 		= zoper(-Nu);
	OPER.Chi 	= zoper(-Chi);
	OPER.Eta 	= xoper(Eta);
	OPER.Delta	= xoper(Delta);
end

% FOLLOWING ARE GENERALIZED FOR CCW ROTATION ABOUT AXIS +x, +y, +z
% FOR CW rotation, input the 'negative' of the angle
function XOPER = xoper(CCWangle)
XOPER = [1		0							0
		0		cosd(CCWangle)		sind(CCWangle)
		0		-sind(CCWangle)		cosd(CCWangle)];
end
function YOPER = yoper(CCWangle)
YOPER = [cosd(CCWangle)		0		-sind(CCWangle)	
		0					1					0
		sind(CCWangle)		0					cosd(CCWangle)];
end
function ZOPER = zoper(CCWangle)
ZOPER = [cosd(CCWangle)		sind(CCWangle)		0
		-sind(CCWangle)		cosd(CCWangle)		0
		0					0					1];
end

