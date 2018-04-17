function  [HLs] = makexline(Y,HA);
% To draw a 'horizontal' line(s) across plot at position(s) Y; 
% 	[HLs]= makeyline(Y)    (uses currently active plot axes) 
% 	[HLs]= makeyline(Y,HA) (HA (handle) of axes to draw lines)
%
%	OUTPUT 
%		HLs  ;  handle(s) of the line(s)
%	INPUT
%		Y is vector of Y positions , 
%		HA is handle of axes; defaults "HA=gca";  (currently active axes/figure)
%
%  complementary - makexline, makeyline

if nargin<2; HA = gca;end

XLIM = get(gca,'xlim');

for ii=1:length(Y);
	HL = line([0 0]+Y(ii),[XLIM]);
	HL.LineWidth = 2;

end


