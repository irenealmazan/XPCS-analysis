% make_imnames_2016_07_test

imname = '2016_0730_4';
SCNNUM=5;

if 1
STR.scanflag=1;
STR.imname=[];
STR.SPECpath=DATApath;
STR.AREApath='TEST';
STR.p_image='p_image';
STR.ending=[];
end

if 0
STR.scanflag=1;
STR.imname=[];
STR.SPECpath=DATApath;
STR.AREApath='TEST';
STR.p_image=[];
STR.ending='.h5';
end

if 0
STR.scanflag=1;
STR.imname=[];
STR.SPECpath=DATApath;
STR.AREApath='TEST';
STR.p_image=[28 30 35];
STR.ending='.h5';
end

[TESTING,specdata] = make_imnames_2016_07(imname,SCNNUM,STR);
disp('making TESTING')
