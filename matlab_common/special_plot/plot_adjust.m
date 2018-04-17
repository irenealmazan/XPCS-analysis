function [HL,HText] = plot_adjust(HA,colorflag,SQUEEZE);
% function to set the papersize, and the fontsizes
% [HL,HText] = plot_adjust(HA,colorflag,SQUEEZE);
%
% OUTPUT
%	HL  handles of the lines it found
%	HText handles of the text like objects it found (title, labels)
%			Prior to R2015, get(HL(1),'Color') outputs color per line 1
%			>R2015 adds  HL.Color (for all) and HL(1).Color  (for 1)
%
% INPUT
%	HA (handle of axes, default is HA=gca to use current active)
% 	colorflag = 1 (default) change colors  0: do not change line colors
% 	SQUEEZE = [1 1 1 1] (default) no change to position or size
%			squeeze axes position, SQUEEZE*position
% 
% A three line title looks best with a SQUEEZE = [1 1 0.93 0.88]

%		typically first 2 numbers should be 1 as they are x(y)start
%		the second two are x(y)width
%
% C Thompson 04-Oct-2000
% C Thompson (cthompson@niu.edu) tweaked 2015-Jan-13

PRESET =0;

if nargin<2;SQUEEZE = [1 1 1 1];end
if nargin<2;colorflag = 1;end
if nargin<1;HA = gca; end


PAPERPOSITION = [2 2 3.5 2.8];
FONTSIZE = 12;
CFONTSIZE = 12;  %children fontsize if already plotted
FONTNAME = 'Times';  % >> listfont (to see what is available on system)
LINEWIDTH = 1;
MARKERSIZE = 10;

% children, like title, xlabel, etc of axes
% this will be applied if this function called after plot made
CFONTSIZE = 12;

HF = get(HA,'parent');
	set(HF,'paperposition',PAPERPOSITION);

set(HA,'box','on');
set(HA,'fontsize',FONTSIZE,'fontname',FONTNAME);
AA = get(HA,'position');
set(HA,'position',AA.*SQUEEZE);

% COMMENT this section out (or at least the line stuff)
% if you do not want the line sizes etc to be changed

HL = get(HA,'children');
HT = get(HA,'title');
HX = get(HA,'xlabel');
HY = get(HA,'ylabel');

HText = [HT;HX;HY];

COLORORDER = flip(randcolor(length(HL)));

% When associating with the lines - the 1st line down will be lowest handle
% but bottom on legend, so it is convenience to swap order of COLORS

	for ii = 1:length(HL);

		TYPE = get(HL(ii),'type');

		if strcmp(TYPE,'line');
			set(HL(ii),'linewidth',LINEWIDTH);
			if colorflag~=0;
			set(HL(ii),'color',COLORORDER(ii,:));
			end
		end
	end
	
	for ii = 1:length(HText);
	
		TYPE = get(HText(ii),'type');
		
		if strcmp(TYPE,'text');
			set(HText(ii),'fontname',FONTNAME,'fontsize',CFONTSIZE);
		end

	end
	
%completed OK
PRESET = 1;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [COLORS] = randcolor(N)
% start with a fairly standard set that does not change
%		(avoiding bright yellow [1 1 0]) 
% then any additional, randomize but with colors that are not too light
COLORS = [...
	[0 0 1]
	[0 1 0]
	[1 0 0]
	[0 1 1]
	[0 0 0]
	[1 0 1]
	[0 .7 .3]];

if N+1 > length(COLORS(:,1));
	% rewrites the last 'white' RGB color with something else, and adds more 
	for ii= (length(COLORS(:,1))):N
		COLORS(ii,:) = rand(1,3);
		disp('t')
		while mean(COLORS(ii,:))>0.9;  % keep doing it until it is not too light colored)
		COLORS(ii,:) = rand(1,3);
		disp('x')
		end
	end
end

end
