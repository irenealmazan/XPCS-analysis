function  [HLs] = makeyline(X,COLOR,HA);
% To draw a 'vertical' line(s) across plot at position(s) X;  
% 	[HLs]= makeyline(X)    (uses current active plot axes) 
% 	[HLs]= makeyline(X,COLOR) (COLOR of line)  (default is white)  CT 2017-1005
% 	[HLs]= makeyline(X,COLOR,HA) (HA (handle) of axes to draw lines)
%
%	OUTPUT 
%		HLs  ;  handle(s) of the line(s)
%	INPUT
%		X is vector of positions , 
%		HA is handle of axes; defaults "HA=gca";  (currently active axes/figure)
%		COLOR is color of line (in RGB [1 0 0] is red) or 'r')  
%				default is white 'w' ([1 1 1])
%
%  complementary - makexline, makeyline

if nargin<3; HA = gca;end
if nargin<2; COLOR = 'w';end

YLIM = get(gca,'ylim');

for ii=1:length(X);
	HLs = line([0 0 0]+X(ii),[YLIM(1) (diff(YLIM).*1e-2)+YLIM(1) YLIM(2)]);
	HLs.LineWidth = 1;
	HLs.Color=COLOR;

end


