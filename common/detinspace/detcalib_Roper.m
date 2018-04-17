function [det_s,DetRotOper,angleR] = detcalib_Roper(det_s,TOL)
% det_s = detcalib_xztanR(det_s)
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

Hcal = det_s.Hcal(:,2:end) - ones(HNm,1)*det_s.pixXYCEN;
Vcal = det_s.Vcal(:,2:end) - ones(VNm,1)*det_s.pixXYCEN;
Halpha = (det_s.HVbeam(1) - det_s.Hcal(:,1));
Valpha = (det_s.HVbeam(2) - det_s.Vcal(:,1));
cosdm = calc_cosdm(det_s);
LENGTHXY = calc_lengthXY(Hcal,Vcal,det_s);

% 
[angleR,DetRotOper,Otype]= calc_R(Halpha, Valpha, Hcal, Vcal,cosdm);



D2PH = abs([( LENGTHXY(:,1).*cosdm(:,1) ) ./ tand(Halpha)]) ;
D2PV = abs([ ( LENGTHXY(:,2).*cosdm(:,2) ) ./ tand(Valpha)]); 

% up to now, have carried through all the measurements, 
% now is time to weight them for final answer
% Mainly, the longer the 'throw' from zero the better the measurement is
% I will weight the measurements linearly based on the 'throw'

D2PH = sum( D2PH .* LENGTHXY(:,1)./sum(LENGTHXY(:,1)) );
D2PH = sum( D2PV .* LENGTHXY(:,2)./sum(LENGTHXY(:,2)) );

% OK made it cruder - need to eventually carry through the above 
% work better - the idea was to be able to incoroporate
% tan and cos terms related with various correction ter4ms
% because of translation/rotation arms, and because
% detector is FLAT and not curved, 

%Pix 2 deg hard wired columns X Vert (del)	rows Y Hor (nu)
D2PH = abs(diff(det_s.Hcal(:,1)) ./ diff(det_s.Hcal(:,3)));
D2PV = abs(diff(det_s.Vcal(:,1)) ./ diff(det_s.Vcal(:,2)));
% This is the operator to change Xpixels,Ypixel pairs to angles
% note - positive negative taken care of by the operator
[angleR,Oper,Otype] = calc_R(Halpha, Valpha, Hcal,Vcal,cosdm);



det_s.rot.oper = [D2PH 0 ; 0 D2PV] * (DetRotOper');
%% that is 
%  HORangle  =   oper   *  pixX
%  VERangle                pixY


det_s.rot.angle = angleR;
%det_s.rot.oper = DetRotOper;
det_s.rot.Otype = Otype;


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [angleR,Oper,Otype] = calc_R(Halpha, Valpha, Hcal,Vcal,cosdm)
% using convention for X Y as X, Y pixel (from image J)
% and for x' y' for the detector, Horizontal and Vertical)

[HX,HY] = get_components(Hcal);
[VX,VY] = get_components(Vcal);


th_testR1 = atan2d(+sign(Valpha).*VX,+sign(Valpha).*VY);
th_testR2 = atan2d(-sign(Halpha).*HY,+sign(Halpha).*HX);
th_testMR1 = atan2d(+sign(Valpha).*VX,-sign(Valpha).*VY);
th_testMR2 = atan2d(+sign(Halpha).*HY,+sign(Halpha).*HX);

% Is it a plain relative rotation, or do we need to rotate and reflect 
% to relate detector H vs V and the pixel X vs Y
% If it is case A the first equality will hold below
% If it is case B the second equality will hold
% if A does not apply, the different will be about 180 degrees)
% hence I'm just comparing rounded off integer values as quickest method
% as always - i work in mode of 'passive' rotation - rotate the axes to calculate components in new reference frame. 
% and Positive Angle is CCW about + axis).

% I haven't decided how to carry through weighting to choose best value 
% of angle, 


	if 	([( round(th_testR1) == round(th_testR2)  ) | ...
			( abs(round(th_testR1-th_testR2))==360 ) ])
			
		angleR = th_testR1(1);
		Oper = [	 cosd(angleR) sind(angleR)
					-sind(angleR) cosd(angleR) ];
		Otype = 'R';
		Osign = +1;

	elseif	([( round(th_testMR1) == round(th_testMR2) ) | ...
			( abs(round(th_testMR1-th_testMR2))==360 ) ])
			
		angleR = th_testR1(1);
		Oper =  [1 0 ; 0 -1] * ...
					[	 cosd(angleR) sind(angleR)
						-sind(angleR) cosd(angleR) ];
		Otype = 'MR';
		Osign = -1;

	else  angleR=1;Oper=1;Otype='Not valid';
		disp('Someone probably entered incorrect pixels in the calibration file- perhaps reversing X Y in pixels or you did not accurately determine pixel positions at various angles for the calibration at direct beam or ignored a minus sign for an angle.')
		disp(['In comparisons below, each row was a different measurement'])
		disp(['If angle to pixel only requires a  rotation, all angles will be equal (including sign).']);
		disp(num2str([th_testR1 th_testR2]));
		disp(['If angle to pixel requires a rotation and a flip, all of these angles will be equal.']);
		disp(num2str([th_testMR1 th_testMR2]));
		disp('Note - situtations like +90 and -90 are NOT the same, they are 180 degrees apart.  (only allowed differences are 360o)');
	end


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [XCOMP,YCOMP] = get_components(XYcomp)
	% assumes column X and Y in XYcomp
	XCOMP = XYcomp(:,1);
	YCOMP = XYcomp(:,2);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cosdm = calc_cosdm(DetCalib)
% choose if cosdm scale is required

	if strcmp(DetCalib.HRotType,'Rot')
		cosdm(:,1) = ones(size(DetCalib.Hcal(:,1)));
	else %translation rotation motor
		cosdm(:,1) = cosd(DetCalib.Hcal(:,1));
	end
	
	if strcmp(DetCalib.VRotType,'Rot')
		cosdm(:,2) = ones(size(DetCalib.Vcal(:,1)));
	else %translation rotation motor
		cosdm(:,2) = cosd(DetCalib.Vcal(:,1));
		
	end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  [NORMXY] = calc_lengthXY(Hcal,Vcal,DetCalib);
% While we have placeholder for relative scale and if
% pixels arranged non square or even non orthogonal, 
%  that would be in DetCalib.pixXYSCALE = [Xscale Yscale anglebetween]
% (just need relative scale so simplest to set one equal to 1
	NORMV =  sqrt(sum((Vcal').^2))';
	NORMH =  sqrt(sum((Hcal').^2))';
	NORMXY = [NORMH NORMV];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [scaleX,scaleY] = calc_scalingXY(DetCalib)

scaleX = 1;
scaleY = 1;
% place holder for scaling the XY and makign 
% orthonormalized versions for calculations
%  orthogonalized version to run


end


