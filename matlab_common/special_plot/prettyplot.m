function [PRESET] = plotstuff(HA,PAPERPOSITION,SQUEEZEflag);
% function to set the papersize, and the fontsizes
% different from plotstuff_forrun in that it doesn't change color of lines (commented out
% etc for the current plot
% call by
%	plotstuff(HA)
%	where HA is the handle for the current axes
%	HA = gca;
% This one has a SQUEEZE parameter that was set
% up to allow a three line title 
%% duplicative of plotstuff_forrun in another directory common should put togeher
if nargin<3;SQUEEZEflag=1;end
if nargin<2;PAPERPOSITION = [2 2 3.75 3.5];end

%PAPERPOSITION = [2 2 4.5 3.8];
%PAPERPOSITION = [2 2 4.5 3.5];
%PAPERPOSITION = [2 2 3.75 3.5];
FONTSIZE = 8;
%FONTNAME = 'times';
FONTNAME = 'Times-Roman';
LINEWIDTH = 1;
MARKERSIZE = 6;

%this is sort of set by hand to get everything fitting
% by changing the size of the axes in the plot
% works for the 3 line title 
%SQUEEZE = [1 1 0.93 0.88];
%SQUEEZE = [1 1 0.95 0.9];
SQUEEZE = [1 1 1 1];

if SQUEEZEflag ~=1;
SQUEEZE = [1 1 1 1];
end

% children, like title, xlabel, etc of axes
% this will be applied if this function called after plot made
CFONTSIZE = 8;
TFONTSIZE = 6;

HF = get(HA,'parent');
	set(HF,'paperposition',PAPERPOSITION);

set(HA,'box','on');
set(HA,'fontsize',CFONTSIZE,'fontname',FONTNAME);
AA = get(HA,'position');
set(HA,'position',AA.*SQUEEZE);

% COMMENT this section out (or at least the line stuff)
% if you do not want the line sizes etc to be changed

HL = get(HA,'children');
HT = get(HA,'title');
HX = get(HA,'xlabel');
HY = get(HA,'ylabel');

HHL = [HL;HX;HY];

	for ii = 1:length(HHL);

		TYPE = get(HHL(ii),'type');

		if strcmp(TYPE,'line');
			set(HHL(ii),'linewidth',LINEWIDTH);
			makecolor(HL(ii));    %% commented out to not change color of lines
		elseif strcmp(TYPE,'text');
			set(HHL(ii),'fontname',FONTNAME,'fontsize',CFONTSIZE);

		end

	end
% treat title differntly as having issues
		set(HT,'fontname',FONTNAME,'fontsize',TFONTSIZE,'fontweight','bold');
end

%%%%%%%%%%  HELPER FUNCTIONS %%%%%%%%%%%%%
function [COLORS] = makecolor(HL)

COLORS = [1 1 1];
while mean(COLORS)>0.9;  % keep doing it until it is not too light colored)
COLORS = rand(1,3);
end
set(HL,'color',COLORS);

end

