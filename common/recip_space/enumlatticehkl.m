function [enum_hkl] = enumlatticehkl(Arg1,Arg2,Arg3)
%  enum_hkl = enum_latticehkl(Hset,Kset,Lset)   
%	(alternate)	enum_hklenumlatticehkl(hklCEN,DELhkl))
% C. Thompson rev. 2016-0110
%
%	Mainly useful to create a 3xN matrix enumerating a lot of HKL points
% 
% OUTPUT (plain) 3xN matrix of all combinations of HKL given from input
% 
% e.g    enum_hkl = enumlatticehkl([-1 0 1],[-1 2],[-1 0.4 5])
% 	enum_hkl = [
%		-1	 0	 1	-1	 0	 1	-1	 0	...
%		-1	-1	-1	 2	 2	 2	-1	-1	...
%		-1	-1	-1	-1	-1	-1	0.4	0.4	...]
%
% INPUT (plain)
%	Three argument, (arguments may be unequal lengths, and non integer)
%		Hset	vector enumerating the H values to use in permutations
%		Kset	 (as above) K
%		Lset	 (as above) L
%	Two arguments,  (enumerates all *integer* HKL plus minus DELhkl about a central hkl position
%		hklCEN	= [hcen	kcen	lcen]
%		DELhkl	= [delH	delK	delL]    or  [del]
%				(if only one value given for DELhkl, then delH=delK=delL
%   

 if nargin==2	% will force to integer hkl in this situation
 
	hklCEN = Arg1;
		if length(hklCEN~=3);
			hklCEN=[hklCEN(1) hklCEN(1) hklCEN(1)];
		end		
	DELhkl = Arg2;
		if length(DELhkl~=3);
			DELhkl=[DELhkl(1) DELhkl(1) DELhkl(1)];
		end
		
	H   = round( [-round(DELhkl(1)):round(DELhkl(1))]' +  hklCEN(1));
	K   = round( [-round(DELhkl(2)):round(DELhkl(2))]' +  hklCEN(2));
	L   = round( [-round(DELhkl(3)):round(DELhkl(3))]' +  hklCEN(3));

elseif nargin==3; % will simply make the combinations (whether inputs include integers or not)
	H=Arg1(:);K=Arg2(:);L=Arg3(:);

else 
	help enumlatticehkl

end

	sizeH	=	length(H);
	sizeK	=	length(K);	
	sizeL	=	length(L);
	
	TOTNUM = sizeH.*sizeK.*sizeL;

%	where it actually does the work is below here	
	Hcol		=	H * ones(1,sizeK.*sizeL);
	Kcol		=	K * ones(1,sizeH.*sizeL);
	Kcol		= 	reshape(Kcol,sizeK*sizeL,sizeH)';
	Lcol		=	[ L*ones(1,sizeH.*sizeK)]';

enum_hkl =[ Hcol(:)'; Kcol(:)'; Lcol(:)'];

end
