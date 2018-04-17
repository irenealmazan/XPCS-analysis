function [NameMatrix]=make_imnames_2016(filename,SCNNUM,readparms)
% [NameMatrix] = make_imnames_caxis_12id_pimage(filename,SCNNUM,readingparms)
% this will make a matrix of tif filenames from a spec scan
%
% OUTPUT (structure)
%	NameMatrix.filenames
%	NameMatrix.fullfilenamesm
%	NameMatrix.pts2num		[specpt  tifnum]	
%	NameMatrix.inputs		carries inputs (additional fields, filename,SCNNUMS,
%	NameMatrix.docu
%
% INPUT (plain)  assume 1 filename, 1 scannum, default is to read all points
%	filename	specfilename
%	SCNNUM		integer value (expectation only ONE scan)
%       (structure)
%	readingpar.scanflag =  1 default (a scan)   0 is from count
%       readingpar.imname  = 'pil_'  or similar base tif name
%                       = [] or field not exist, unique tif name based on filename
%	readingpar.SPECpath  spec file path 
%       readingpar.AREApath  area images path (top level)
%       readingpar.p_image = [] (spec point) = 'p_image' (uses the p_image number)
%
%   Assumption - tifs for each scan point N for scan dec1414_1 scan #S are  
%       if imname=[]
%
% 	{AREApath}/dec1414_1/dec1414_1_SSSS/dec1414_1_SSSS_NNNNN.tif
%
%       if imname= 'pil_' (or similar depending)
%
% 	{AREApath}/dec1414_1/dec1414_1_SSSS/pil_SSSS_NNNNN.tif
%
%   where the SSSS (scan number) and NNNNN (point number) are padded with zeros
%
%   Assumption - tifs for 'ct' or prpeak (where SCNNUM is the p_image numbers)
%
%       {AREApath}/dec1414_1/dec1414_1_NNNNN.tif
% 

		
% Note - when things are stable, they followed the above assumptions,
% When the pilatus or area detector was first installed, or upgraded
% then there would be a run or several where things would be not consistent
% 
% Note, to construct namematrix there may be blanks at end of some lines
%   (if necessary when using, can use for each line 
%           deblank(FILENAMETIF(1,:)); for examples
%


NUMdigitsSCNNUM    = 4;    % SSSS
NUMdigitsPTNUM      = 5;    % NNNNN
TIF = '.tif';

if nargin<3;
    readparms.scanflag=1;
    [SPECpath,AREApath] = pathdisplay;   % use defaults paths already set up
    readparms.SPECpath = SPECpath;
    readparms.AREApath = AREApath;
    readparms.imname = [];   % default for zaxis and sevchex
    readparms.p_image = 'p_image';  % eventually, default for sevchex will be [];
    
end


FLAG    = readparms.scanflag;   %0 is from a count or prpeak, 1 is from a scan
SPECp   = readparms.SPECpath;	
NPTS=0;
	
    if FLAG~=0
	
        [DATA,Npts,SCNTYPE,SCNDATE,ncols,collabels,fileheader,scnheader,comments] ...
            = readspecscan([SPECp,filesep,filename],SCNNUM);
                if isempty(readparms.p_image)
                    p_num = [0:Npts-1]'; 
                else
                    p_num = round(DATA(:,chan2col(collabels,readparms.p_image))); 
                end
            strSCAN     = numstring(SCNNUM,NUMdigitsSCNNUM);
            strPTNUM    = numstring(p_num,NUMdigitsPTNUM);
		
	else    % SCNNUM are really the count point numbers and it is from a count
	
		Npts = length(SCNNUM);
		%strSCAN	= 'ct';
		strSCAN		= [];
		strPTNUM = numstring(SCNNUM,NUMdigitsPTNUM);
	end

% Make the bits to string together	
        FILENAME 	= char(ones(Npts,1)*[filename]);	
	SEP		= char(ones(Npts,1)*[filesep]);
	U		= char(ones(Npts,1)*['_']);
	SCNNN		= char(ones(Npts,1)*[strSCAN]);
	TIF		= char(ones(Npts,1)*[TIF]);
	
	if FLAG~=0
	
            FILENAMETIF	= [FILENAME,U,SCNNN,U,strPTNUM,TIF];
            FULLFILENAMETIF = ...
                [FILENAME,SEP,FILENAME,U,SCNNN,SEP,FILENAME,U,SCNNN,U,strPTNUM,TIF];
            NameMatrix.pts2img	= [[0:Npts-1]'  p_num];
            NameMatrix.inputs.scnnum = SCNNUM;
		
	else   % or just a count
	
            FILENAMETIF		= [FILENAME,U,strPTNUM,TIF];
            FULLFILENAMETIF     = [FILENAME,SEP,FILENAME,U,strPTNUM,TIF];
            NameMatrix.inputs.scnnum    = SCNNUM;
		
	end
	
NameMatrix.filenames        = FILENAMETIF;
NameMatrix.fullfilenames    = FULLFILENAMETIF;
NameMatrix.inputs.filename  = filename;
NameMatrix.inputs.scnnum    = SCNNUM;
NameMatrix.inputs.readparms = readparms;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%  Helper functions %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [strNNN] = numstring(N,Ndigits)
% Converts integer N to '000N' string with digits specified Ndigits
%	example, setnumstring(12,5) outputs  character string '00012'
	N=N(:);		% ensure column vector
	ten2Ndig = eval(['1e' int2str(Ndigits)]);
	strNNN	=	int2str(N + ten2Ndig);
	strNNN	=	strNNN(:,2:end);
end 
