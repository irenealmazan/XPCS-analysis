function [ImageNew,MarkImage]	= apply_badpixreplace(ImageMatrix,badpixtxt,plotflag)
%[ImageNew,MarkImage]	= apply_badpixreplace(ImageMatrix,badpix_filename)
% Used bad pix file ([Xbad Ybad Xrep Yrep] epics indexing of image matrix) 
%  to replace bad pixels with others in the image matrix 
%		Pix in badpix (epic/imageJ) enumerated as [X,Y]
%		Matlab enumerates as  [Y+1,X+1]
%
%			Matlab uses matrix indexing, so [Y=ROW, X=COLUMN]
%			And pixel [0,0] imageJ is matrix entry [1,1] in matlab
% 
%	OUTPUT
%		ImageNew  takes ImageMatrix and uses a simple pixel replacement
%		MarkImage can be used to indicate where bad pixelsm
%			MarkImage(:,:,1) 1(bad pix) 0(good pix)
%			MarkImage(:,:,2) 1(pix used for replacement) 0(other)
%			MarkImage(:,:,3) zeros; RGB indexing >> image(MarkImage)
%			>> image(MarkImage) make figure on black ground showing
%				Red  pixel - are listed as BAD in pixel file
%				Green pixel  - are used for replacement to a bad pixel
%				Yellow pixel - are listed as BAD and used as a replacement
%				(that is, something has been typed in wrong in pixel file)
%	INPUT
%		ImageMatrix (can be 3 dimensional for a sequence of images)
%		badpix_filename  (string) e.g., 'badpix.txt' from EPICS
%			each row is 4 numbers, [Xbad Ybad Xrep Yrep] 
%			e.g., [5  10  5  11] use pixel one column over as replacement
%		plotflag (optional) if 1, will automatically show image(MarkImage)
%		
if nargin<3;plotflag=0;end

[NYrow,NXcol,NZ] = size(ImageMatrix);

MarkImage = zeros(NYrow,NXcol,3);

BADPIXTXT = load(badpixtxt);
[NUMbad,DUM]=size(BADPIXTXT);

% matrix (matlab) indexing starts at 1, 
% ROI and imageJ used for badpix file start at 0
BADPIX = BADPIXTXT(:,[1 2])+1;
REPPIX = BADPIXTXT(:,[3 4])+1;

% Turns out that to index, cannot do A(Brow,Ccol) with Brow and Ccol vectors
%	it makes all combinations between the two
%	so turn the indices, [Brows,Ccol] into the linear index used in (A(:))
N1 = sub2ind([NYrow NXcol 3],BADPIX(:,2),BADPIX(:,1),ones(NUMbad,1));
N2 = sub2ind([NYrow NXcol 3],REPPIX(:,2),REPPIX(:,1),ones(NUMbad,1).*2);

% can use a RGB indexed
MarkImage(N1) = ones(NUMbad,1);
MarkImage(N2) = ones(NUMbad,1);
MarkImage(:,:,3) = zeros(NYrow,NXcol);

Nwrong = find([MarkImage(:,:,1)+MarkImage(:,:,2)]==2);
if ~isempty(Nwrong);
	disp(['There are ',int2str(length(Nwrong)),' pixels that are listed both as BAD'])
	disp('and as good REPLACEMENT for another. That cannot be right')
	disp('Check and fix logic in the the bad pixel file')
end

ImageNew = ImageMatrix;

for ii=1:NZ;
	Imageii = ImageMatrix(:,:,ii);
	Imageii(N1) = Imageii([N2 - (NYrow.*NXcol)]);
	ImageNew(:,:,ii) = Imageii;
end


if plotflag==1;
 figure;  N=gcf;
 H = image([1:NXcol],[1:NYrow],MarkImage);   
 % can plot each one separately, but together can be  RGB also
xlabel('X Pixels Columns');
ylabel('Y Pixels Rows');
title(strvcat(	['Badpix file used [',pfilename(badpixtxt),']'],...
				'[RED  listed BAD pixel]',...
				'[GREEN listed to replace some bad pixel]',...
				'[YELLOW Hey - BAD and marked as good to replace another]') )
%setprops(H,NYrow,NXcol);
end

end	


