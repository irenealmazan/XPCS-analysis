function [PRESET] = plotstuff(HA,PAPERPOSITION);
% function to set the papersize, and the fontsizes
% etc for the current plot
% call by
%	plotstuff(HA)
%	where HA is the handle for the current axes
%	HA = gca;
% This one has a SQUEEZE parameter that was set
% up to allow a three line title but turned back to [1 1 1 1]
% Rather old fashioned graphics handling but will work with GBS's old versions 
% Note - we are pulling ourselves slowly to graphics past matlab2015
% it is possible some things in here till not work in GBS's old verion

if nargin<1;HA=gca;end
if nargin<2;PAPERPOSITION = [2 2 3.75  3.5];end

FONTSIZE = 8;
FONTNAME = 'Times-Roman'; %'Inconsolata'; %'Times';
LINEWIDTH = 0.8;
MARKERSIZE = 10;
COLORORDER = ['b';'g';'r';'c';'k';'m'];

% need to do modulo here, but needed quicklyfor last plot of evening
COLORORDER = [COLORORDER;COLORORDER;COLORORDER];


%this is sort of set by hand to get everything fitting
% by changing the size of the axes in the plot
% works for the 3 line title 
%SQUEEZE = [1 1 0.93 0.88];
%SQUEEZE = [1 1 1 1];
SQUEEZE = [1 1 0.95 0.9];

% children, like title, xlabel, etc of axes
% this will be applied if this function called after plot made
CFONTSIZE = 8;

HF = get(HA,'parent');
	set(HF,'paperposition',PAPERPOSITION);

set(HA,'box','on');
set(HA,'fontsize',FONTSIZE,'fontname',FONTNAME);
AA = get(HA,'position');
set(HA,'position',AA.*SQUEEZE);

% COMMENT this section out (or at least the line stuff)
% if you do not want the line sizes etc to be changed

HL = get(HA,'children');
HT = get(HA,'title'); set(HT,'fontname',FONTNAME,'fontsize',CFONTSIZE);
HX = get(HA,'xlabel');set(HX,'fontname',FONTNAME,'fontsize',CFONTSIZE);
HY = get(HA,'ylabel');set(HY,'fontname',FONTNAME,'fontsize',CFONTSIZE);

HL = [HL;HT;HX;HY];

	for ii = 1:length(HL);

		TYPE = get(HL(ii),'type');

		if strcmp(TYPE,'line');
			set(HL(ii),'linewidth',LINEWIDTH);
			set(HL(ii),'color',COLORORDER(ii));

		elseif strcmp(TYPE,'text');
			set(HL(ii),'fontname',FONTNAME,'fontsize',CFONTSIZE);

		end

	end

