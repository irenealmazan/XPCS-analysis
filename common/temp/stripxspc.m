function STRIPPEDSTR = stripxspc(NUMSTRING)
% STRIPPEDSTR = stripxblnk %strips excess SPACES in NUMBER STRINGS, leaving only one in each

if NUMSTRING>15
NUMBERS = eval(['[',NUMSTRING,']']);
STRIPPEDSTR = ['[',num2str(NUMBERS,' %d'),']'];
end
% this at least
