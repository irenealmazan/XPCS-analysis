function [COLORS] = linecolors(N)
%linecolors(N) makes a set of colors, goes black, r, g, b, dark yellow, then darker color, then random if necessary
% useful when trying to plot a lot of lines and what mostly to distinguish.
% Avoids yellow as too light
%   
STDCOLOR = [0 0 0;1 0 0;0 1 0;0 0 1;1 0 1; 0 1 1; 0.8 0.8 0];
    STDCOLOR = [STDCOLOR ; 0.7.*STDCOLOR];
    LL = round(N-length(STDCOLOR(:,1)))+1;
    %this gives about 14, then starts random
    COLORS = [STDCOLOR;rand(LL,3)];


end

