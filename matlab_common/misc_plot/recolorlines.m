function [HL,COLORS] = recolorlines(HA)
% Find lines in plot and randomize to a new set of colors trying to not be too light
% [HL,COLORS] = recolorlines(HA);  
%		if HA (handle of axes) not given, uses current active axes/plot HA=gca;
% OUTPUT  
%		HL  handle(s) of N 'line' we found associated with axes
%		COLORS  [Nx3] matrix [R G B] colors used for each line
% INPUT
%		HA (optional) if not given it will use currently active axes/plot
%				(i.e., default is HA=gca;)
%
%		note - recolorlines will not 'find' the lines associated with the legend
%			but they will automaticall recolor to match  the plot lines

if nargin<1;HA=gca;end

HL = get(HA,'children');

	for ii = 1:length(HL);

		TYPE = get(HL(ii),'type');

		if strcmp(TYPE,'line');
			COLORS(ii,:)=randcolor(HL(ii));
		end

	end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [COLORS] = randcolor(HL)

COLORS = [1 1 1];
while mean(COLORS)>0.9;  % keep doing it until it is not too light colored)
COLORS = rand(1,3);
end
set(HL,'color',COLORS);

end

