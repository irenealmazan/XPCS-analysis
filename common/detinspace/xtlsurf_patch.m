function HSxtlsurf = xtlsurf_patch_(NRML,UB)
% HSxtlsurf = xtlsurf_patch(NRML,UB,spectrometer_hphi_function))
% if NRML is 2 element vector, assume it is sigma tau from surface for spectrometer at 0,0,0,0,0,
% if NRML is 3 element vector, assume it is given as HKL of the crystal surface face
% 		e.g., [0 0 1]  if the c-faces is terminating face. (Note the hkl of 

if nargin<1;NRML = [0 -90];end
if nargin<2;UB.U=1;end
if isempty(UB);UB.UBinv=1;end

	% setting up range - finer grid will do nicer reflections
	urange	=[-4:.1: 4];vrange=urange;
	[u,v]	=meshgrid(urange,vrange);
	[N1,N2]	=size(u);
	uv 		= [u(:) v(:)];

if length(NRML)==2;
	Sigma=NRML(1);Tau = NRML(2);
	% need to double check whether all geometries define angles as such
	%tau = -(90-thetamax), sigma = sigma (must be positive)
	%			if subtract or add 180deg to tau, then sigma must be negative.
	% in XYZ coordinates (spectrometer) 
	%  n0 is normal to surface, ntau is the axis about which sigma rotates, nsigma is projection of n0 on surface
	%n0_XYZ 		= [cosd(Tau).*sind(Sigma); 	-sind(Tau).*sind(Sigma); 	cosd(Sigma)];
	%ntau_XYZ		= [-sind(Tau); 				-cosd(Tau);				0];
	%nsigma_XYZ  	= [cosd(Tau).*cosd(Sigma);	-sind(Tau).*cosd(Sigma);	-sind(Sigma)];
	%n_lattice 	= UB.UBinv*n_XYZ;   % this is respect to lattice and in lattice units
	ntau_XYZ		= [-sind(Tau);			-cosd(Tau);				0];
	nsigma_XYZ  		= [cosd(Tau).*cosd(Sigma);	-sind(Tau).*cosd(Sigma);	-sind(Sigma)];
	
	% makes columns of  X, Y, Z positions of surface points
	S_XYZ = ([u(:) v(:)] * [ntau_XYZ';nsigma_XYZ'])';
	
	% rotate to orient with respect to the lattice points;
	% These are expressed in terms of the orthonormal coordinate system (not a*,b*,c*)
	S_lattice = inv(UB.U)*S_XYZ;
	Xxtl_lattice = reshape(S_lattice(1,:),N1,N2);
	Yxtl_lattice= reshape(S_lattice(2,:),N1,N2);
	Zxtl_lattice =  reshape(S_lattice(3,:),N1,N2);
	
elseif length(NRML==3);
	% then given the surface plane or the hkl of these planes
	n_lattice = UB.B*NRML(:);
	%n_arbitrary  need good n_arbitrary (to work if normal is 100 or 010 or 001) to make a crossproduct
	n_arbitrary = n_lattice([2 3 1])   % reorder to get a vector that is not parallel to use in cross products to get surfaces
	n_surfy	= cross(n_lattice,n_arbitrary); 
	n_surfx	= cross(n_surfy,n_lattice); 
    	% makes columns of  X, Y, Z positions of surface points
	S_XYZ = ([u(:) v(:)] * [n_surfx';n_surfy'])';
	
	% rotate to orient with respect to the lattice points;
	% These are expressed in terms of the orthonormal coordinate system (not a*,b*,c*)
	S_lattice = inv(UB.U)*S_XYZ;
	Xxtl_lattice = reshape(S_lattice(1,:),N1,N2);
	Yxtl_lattice= reshape(S_lattice(2,:),N1,N2);
	Zxtl_lattice =  reshape(S_lattice(3,:),N1,N2);


end
	xtalsurf_prop = xtlproperties;
	
	HSxtlsurf.H = surface(Xxtl_lattice,Yxtl_lattice,Zxtl_lattice,xtlproperties);
end


function [props] = xtlproperties
% for patch that is just on the detector, which will be shiny like metal, 
	props.AmbientStrength = 0.3;
	props.DiffuseStrength = 0.3;
	props.SpecularStrength = 1;
	props.SpecularExponent = 25;
	props.SpecularColorReflectance = 0.8;

	props.FaceColor= 'texture';  %'flat'
	props.EdgeColor = 'none';%'interp';
	props.FaceLighting = 'phong';
	%props.Cdata = DETECTOR;

	props.FaceAlpha = 0.3;% 'texture';%'texture'; %'texture' if using 
	%props.EdgeAlpha = 'flat';%'flat';%
	props.Alphadatamapping = 'none';% to make all ones be 
	%props.Alphadata = ones(size(DETECTOR)).*.8;

end




