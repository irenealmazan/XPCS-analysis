function [SPECpath,IMAGEpath,COMMONpath,HOMEpath] = pathdisplay    
% [SPECpath,IMAGEpath,COMMONpath,HOMEpath] = pathdisplay 
% 
% Used to pass current paths as needed. Edit this 
% for temporary access to other paths, otherwise, it uses stpath to set up

stpaths;		% get DATApath, AREApath
% If need to change defaults for a one time pass, then add them here
%%%%%%%%%%%%%%%%%%%5
%DATAroot = '/data/dataxray/2013/2013_march_nitridedata';    
%DATAroot = '/data/dataxray/2013/2013_july_nitridedata';  
%DATAroot = '/DATA/DATA/2013/2013_07_datanitride'; 
%DATAroot = '/DATA/DATA/2016/2016_02_mocvd_nitride'; 
%DATAroot = '/DATA/DATA/2016/2016_07_mocvd_nitride'; 
%DATAroot = '/dataone/dataoneshare/data/2016/2016_03_sput_composite'; 
%%%%%%%%%%%%%%%%%%%%

HERE = pwd;

 % here is how they are named within programs
 % we try to not clobber stpath settings                
SPECpath	= DATApath;
COMMONpath	= [HERE,filesep,'common'];                                          
HOMEpath	= HERE;
IMAGEpath	= AREApath;
