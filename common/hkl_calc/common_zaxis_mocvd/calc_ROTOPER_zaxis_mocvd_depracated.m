function [DET,SAMP,OPER] = calc_ROTOPER_zaxis_axis(angles)
%[DET,SAMP] = calc_ROTOPER_zaxis_mocvd([Delta Theta Mu Gamma])
% Angles (only one set per calculation)
%	[Delta Theta Mu Gamma]   % as output in prpeak in zaxis
% Calculates the rotation matrices for the DETECTOR and SAMPLE
% USING MATRIX MULTIPLICATION
%     (r)' = DET * r  or (r)' = SAMP * r
% gives r in coordinates of the rotated system.
% to find r in coordinates of the unrotated system)
%	(r) = DET' * r' or (r) = SAMP' * r'
% SAMP and DET are rotation matrices and 
% are unitary ( U^(-1) = U(transpose)
% calculated -  right handed x,y,z, before any rotations system  
% y (pointing downstream = kin), 
% z (pointing vertically), 
% x (pointing inboard)
% after all detector rotations, in new system r'(kout) = (0 1 0)
% For the zaxis mocvd,  
% DET = GAMMA*DELTA*MU;
% SAMP = THETA*MU
% for another spectrometer, it would be different.

% Might be able to code this so that it does more than one set of angles at a time, 
% then output in a sparse block diagonal matrix 

% my operators - calculated ala Goldstein to rotate axis  
%	apply to ABCD to r to find r expressed in r' coordinates

% calculated using x,y,z and + rotations  as indicated above
Delta = angles(1);    % + CW about z or its equivalent after rotate
Theta = angles(2);  % + CW about z  or its equivalent after rotate
Mu = angles(3); % + CCW about x immovable- always only about original x
Gamma = angles(4); % + CCW about x: or its equivalent after rotate

DET = [cosd(Delta)			-sind(Delta).*cosd(Mu)		-sind(Delta).*sind(Mu)
	cosd(Gamma).*sind(Delta)	cosd(Gamma).*cosd(Delta).*cosd(Mu)-sind(Gamma).*sind(Mu)		cosd(Gamma).*cosd(Delta).*sind(Mu)+sind(Gamma).*cosd(Mu)
	-sind(Gamma).*sind(Delta)	-sind(Gamma).*cosd(Delta).*cosd(Mu)-cosd(Gamma).*sind(Mu)	-sind(Gamma).*cosd(Delta).*sind(Mu)+cosd(Gamma).*cosd(Mu)];

SAMP = [ cosd(Theta)	-sind(Theta).*cosd(Mu)	-sind(Theta).*sind(Mu)
		sind(Theta)	cosd(Theta).*cosd(Mu)	cosd(Theta).*sind(Mu)
		0				-sind(Mu)				cosd(Mu) ];

% use minus to turn operator written for CCW rotation to be valid for CW rotation
	OPER.Theta 	= zoper(-Theta);
	OPER.Mu 	= xoper(Mu);
	OPER.Gamma 	= xoper(Gamma);
	OPER.Delta	= zoper(-Delta);
end

function XOPER = xoper(CCWangle)
XOPER = [1		0							0
		0		cosd(CCWangle)		sind(CCWangle)
		0		-sind(CCWangle)		cosd(CCWangle)];
end
function ZOPER = zoper(CCWangle)
ZOPER = [cosd(CCWangle)		sind(CCWangle)		0
		-sind(CCWangle)		cosd(CCWangle)		0
		0					0					1];
end

% using this for h_phi for mocvd Zaxis, this is as seen in Lohmeier and Vlieg 1993
% but corrected for a typo they have in the last factor of 1st row
% they have +cos(mu) instead of -cos(mu) (their alpha is our mu)
% their later calculation do not propagate this error, thankfully
% zaxis code at 12id in spec is also correct
% h_phi = [
%	cosd(theta).*sind(delta).*cosd(gam) - sind(theta).*(cosd(delta).*cosd(gam) - cosd(mu))
%	sind(theta).*sind(delta).*cosd(gam) + cosd(theta).*(cosd(delta).*cosd(gam) - cosd(mu))
%					sind(gam) + sind(mu)];

%from zaxis (spec code) is correct, althugh ordered differently). 
%h_phi_speczaxis = [
%	sind(theta) .* (cosd(mu) - cosd(gam).* cosd(delta)) + (cosd(gam).*sind(delta).*cosd(theta))
%-1.*cosd(theta).* (cosd(mu) - cosd(gam).* cosd(delta)) + (cosd(gam).*sind(delta).*sind(theta))
%	sind(gam) + sind(mu)]; 	

