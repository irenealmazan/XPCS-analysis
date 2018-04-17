function [HL,COLORORDER] = showrois(ROIS,HF,LW,COLORORDER)
% [HL,COLORORDER]= showrois(ROIS,HF,LW,COLORSROIS)  HF figure, LW linewidth, COLOR roi lines
% CT 2017-08 made more colors so can have more consistent set (currently 10

if nargin<2;
	HF=gcf;LW=2;writeROIflag=1;COLORORDER=[];
elseif nargin<3
	LW=2;writeROIflag=0;COLORORDER=[];
elseif nargin<4
	writeROIflag=0;COLORORDER=[];
else
	writeROIflag=0;
	end

ndxrois = [1:length(ROIS(:,1))];
magenta = [1 0 1];
cyan = [0 1 1];
yellow = [1 1 0]; % don't use yellow usually
red = [1 0 0];
blue = [0 0 1];
green = [0 1 0];
gray = [.4 .4 .4];

if isempty(COLORORDER);
[COLORORDER,NColors] = makecolororder;
COLORORDER = [COLORORDER;rand(length(ndxrois)-NColors,3)];  % if still more ROISs than defined colors
end

figure(HF);

	Xl = ROIS(:,1);
	Xh = ROIS(:,2);
	Yl = ROIS(:,3);
	Yh = ROIS(:,4);

	HL = line(([Xl Xh Xh Xl Xl]'),([Yl Yl Yh Yh Yl]'));
	
for ii=ndxrois;

	set(HL(ii),'LineWidth',LW,'Color',COLORORDER(ii,:),'LineStyle','--');
	% If using R2015 or later, can use following instead
	% HL(ii).LineWidth=1;
	% HL(ii).Color = 'r';
end

if writeROIflag;
STRING = strvcat('ROIs shown are the following',...
' ROIindex : minX maxX  minY maxY  ',...
' ',...
['ROInum : MYROIS = [...'],...
int2str([ndxrois' ROIS]),'  ];');

disp(STRING)
end

end
%%%%% Helper Function
function [COLORORDER,NColor] = makecolororder
magenta = [1 0 1];
cyan = [0 1 1];
yellow = [1 1 0]; % don't use yellow usually
red = [1 0 0];
blue = [0 0 1];  % often the images are blue background 
green = [0 1 0];
gray = [.6 .6 .6];
maroon = [0.5 0 0];
olive = [0.7 0.7 0];
teal = [0 0.5 0.5];
navy = [0 0 0.5];
purple = [0.5 0 0.5];
orange = [.8 .35 0];

COLORORDER = [magenta;cyan;green;red;purple;teal;navy;orange;gray;olive;blue];
NColor = length(COLORORDER(:,1));
end
