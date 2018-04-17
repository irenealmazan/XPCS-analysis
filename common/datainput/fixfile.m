function PRESET = fixfile(filename)
% function PRESET = fixfile
% can be used as >> fixfile
%  it will erase all the *.ndx files and *.cndx

% if no filename is given, it will erase all the *.ndx files and *.cndx
% if filename given, it will erase its *.ndx files and
% that particular file in the data directory
% FOR EACH RUN - need to change inside this file
%       DATApath, and FINALDATE 
%


% gets the datapaths currently in use by users
[DATApath]=pathdisplay;

% get type of computer just in case running on PCwindows
% SINCE WE ARE USUALLY RUNNING EXPERIMENTS ON A UNIX COMPUTER - 
% ONLY ALLOW REMOVE *.NDX (NOT THE DATA FILE) IF ON A WINDOWS COMPUTER
if isunix
	REMOVE = 'rm ';
else
	REMOVE = 'del ';
end	


       commandstring1 = ['!',REMOVE,DATApath,filesep,'*.ndx'];
       commandstring2 = ['!',REMOVE,DATApath,filesep,'*.cndx'];

eval(commandstring1);
disp(commandstring1);

eval(commandstring2);
disp(commandstring2);
