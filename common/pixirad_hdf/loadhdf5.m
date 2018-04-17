function [ data,thresh ] = loadhdf5(imname)
% Wonsuk Cha, SRS, MSD, ANL
% Dec. 18, 2015
% This script loads multiple three-dimensional hdf5 type files.
% imname: name of a file, if you leave blank, then this load all hdf5 files in the directory.
%% Load data
if nargin~=1
    fileinfo=dir('*.h5');% This creates information of folders.
    for n=1:length(fileinfo)
        imname=fileinfo(n).name;
        temp=h5read(imname,'/entry/data/data');
        thresh.low(:,:,n)=temp(:,:,1);
        thresh.high(:,:,n)=temp(:,:,2);
    end
elseif nargin==1
        temp=h5read(imname,'/entry/data/data');
        thresh.low=temp(:,:,1);
        thresh.high=temp(:,:,2);
end

thresh.low=double(thresh.low);
thresh.high=double(thresh.high);

thresh.low=fliplr(thresh.low);
thresh.high=fliplr(thresh.high);

data=thresh.low-thresh.high;
data=double(data);

disp('The dataset is loaded.');
disp(['The size is ' num2str(size(data,2)) ' X ' num2str(size(data,1)) ' X ' num2str(size(data,3)) '.'])
end