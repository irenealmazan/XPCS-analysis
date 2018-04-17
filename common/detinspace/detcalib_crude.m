60function [det_s,DetRotOper,angleR] = detcalib_crude(det_s,TOL)
% det_s = detcalib_crude(det_s)
% just use pix2deg crude approximation
%
% CT 2016-02-16  this is very 'step by step' to check various things
% Takes detector calibration structure (set up per detector/run)
% and adds fields/data related to xyz lab/diffractometer making it
% possible to create patches for visualizations.

%% The raw fields (filled in by user - Note - because of the TransRot
%% DetCalib.pixXYSIZE		= [487 195];
%% DetCalib.pixXYCEN		= [XCEN YCEN];
%% DetCalib.pixXYSCALE		= [Xscalerelative Yscalerelative AnglebetweenXY];
%% DetCalib.ADU2photon 		= -1;   % -1 uncalibrated otherwise ADU per photon

		%%  angles (vertical) and (horizontal) 
%% DetCalib.HVbeam		= [0   -0.2];  % [Hor  Vert] (
%% DetCalib.Hname 		= 'Nu';
%% DetCalib.HRotType	= 'Rot';
			%%			[angle	Xpix	Ypix]
%% DetCalib.Hcal		= [ -0.88	196		173
%% 							+0.76	196		32];
%% DetCalib.Vname 		= 'Delta';
%% DetCalib.VRotType	= 'TransRot'; 
		%%				[at_angle	Xpix	Ypix]
%% DetCalib.Vcal		= [ -1.04	275		97
%% 							 0.80	110		97];

% for Vcal, Hcal each row a different measurement (usually on either side of beam)

% need to figure out how to deal with alpha

% there may be several measurements, since different angles formally
% particularly for the TransRot have to be kept separate.
% Typically there will just be two (plus and minus about dieect beam
if nargin<1;TOL = .1;end;  %use in future for when calibrations crappy!

HNm = length(det_s.Hcal(:,1));
VNm = length(det_s.Vcal(:,2));

% Here is where one would need to put in some sort of scaling 
% or pixel manipulation to use it, and have a matrix to transform 
% back and forth, likely.
% Then use the orthonormal axes below, andn transform back at end or 
% add another matrix related to the transflormation matrkx here

% change to a orthonormal set of Hcal and Vcal pixel cen

%%%%%%%%%%%%%
% Add some easy features - Vectors of pixels in XY with zero at zero
det_s.pixX	= [0:det_s.pixXYSIZE(1)-1]' - det_s.pixXYCEN(1);
det_s.pixY	= [0:det_s.pixXYSIZE(2)-1]' - det_s.pixXYCEN(2);


% Calculate the rotation/mirroring operator to transform Hor/Vert angles
% to X(column) Y(row) pixels. 

Halpha = (det_s.HVbeam(1) - det_s.Hcal(:,1));
Valpha = (det_s.HVbeam(2) - det_s.Vcal(:,1));
%Pix 2 deg hard wired columns X Vert (del)	rows Y Hor (nu)
D2PH = diff(det_s.Hcal(:,1)) ./ diff(det_s.Hcal(:,3));
D2PV = diff(det_s.Vcal(:,1)) ./ diff(det_s.Vcal(:,2));

% hard wired  - bigger Y pixel are bigger Hor angle (Nu)
%				bigger X pixel is small Ver angle (Nu)
% which basically means to rotate the pixels
DetRotOper = [0 1;1 0];
angleR = 90;
Otype = 'MR';

% Add CRUDE- Vectors of pixels in XY with zero at zero hardwired
det_s.Vang	= det_s.pixX .* D2PV;
det_s.Hang	= det_s.pixY .* D2PH;



% This is the operator to change Xpixels,Ypixel pairs to angles
% note - positive negative taken care of by the operator
det_s.rot.oper = [abs(D2PH) 0 ; 0 abs(D2PV)] * (DetRotOper');
%% that is 
%  HORangle  =   oper   *  pixX
%  VERangle                pixY


det_s.rot.angle = angleR;
%det_s.rot.oper = DetRotOper;
det_s.rot.Otype = Otype;


end

