function Xout = p_dig(Xin,DIG)
% Xout = p_dig(Xin,DIG)
%		Default DIG = 4 such as such as 0.010123333 to 0.0101
% change number of digits in order to make a easier to read num2str(Xout)
	if nargin<2;DIG = 4;end
	
	Xout = round(Xin .* 10^DIG)./10^DIG;
	
end
