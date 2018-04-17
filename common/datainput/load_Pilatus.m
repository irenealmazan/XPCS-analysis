 function [data,DateTime,ImageInfo] = loadPilatus(imname,EXT)
% [data,imtime,DateTime,ImageInfo] = load_Pilatus(imname,EXT)   
%	output
%		data (2D or 3D array): 
%				may be 3D if multiple imnames 
%				
%		imtime (scalar or vector): timestamp (in seconds) of when image acquired
%				may be vector if multiple imnames
%		thresh (structure of arrays): raw 3D arrays with Ilow and Ihigh raw
%			thresh.low and thresh.high
%		
%	input
%		imname (string or matrix string) filename (needs paths)
%		EXT (default is '.tif'
%		
%			
%		
%		
% This script loads multiple image files (assumed tifs, single image per tif
%	such as what comes out of pilatus
% imname: name of a file, if you leave blank, then loads all tif files within the directory.
%
%
% Timestamp (in seconds) 
% 		h5read(imname,'/entry/instrument/NDAttributes/NDArrayTimeStamp')
%

if nargin<2;EXT='.tif';end

%
%% Load data
if nargin==1;
    fileinfo=dir('*.tif');% This creates information of folders.
    for n=1:length(fileinfo)
        imname=fileinfo(n).name;
        temp=h5read(imname,'/entry/data/data');
        imtime(n) = imtimetemp;
    end
elseif nargin==2
	for n=1:length(imname(:,1))
		imnameii = deblank(imname(n,:));
        imtime(n) = imtimetemp;
    end
end


% Rows = Y, Cols = X, 
data=double(data);

disp(['The dataset is loaded.']);
disp(['The size is ' num2str(size(data,2)) ' X(cols) ' num2str(size(data,1)) ' Y(rows) '])
end
