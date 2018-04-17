function DATEANDTIMESTRING = dateandtime
%function DATEANDTIMESTRING = dateandtime
% function that outputs date and time in string
% Note that it outputs string with [ ] on both sides so
% that you don't need to add blanks when embedding it in
% another character string vector

D = fix(clock)';
plottime = ...
[' [',datestr(now,1),'  ',datestr(now,15),'] '];
DATEANDTIMESTRING = [plottime];
