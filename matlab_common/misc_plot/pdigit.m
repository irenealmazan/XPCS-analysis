function Xoutstr = pdigit(Xin,NDIG)
% Xoutstr = pdigit(Xin,NDIG)   ( pretty print digits)
% Prints number as string with set number of digits, 
% 	Default NDIG = 4
%		e.g.,  0.010123333 string output is  '0.0101'
%
	if nargin<2;NDIG = 4;end
	
	Xout = round(Xin .* 10^NDIG)./10^NDIG;
	
	Xoutstr = [num2str(Xout)];
	
end
