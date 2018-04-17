function namematrix = makenamematrix(cell_pathsnfiles,orfiles)
% namematrix = makenamematrix(cell_pathsnfiles) or  matenamematrix(dirpath,files)
%
%  OUTPUT - namematrix (matrix of directorys and files)
%
%  INPUT 
%		one argument is a  cell input
%		pathsnfiles  is an Nx2 Cell structure with each cell a string or string matrix
%		The directory portion path  of each row is expected to be ONE directory per cell
%		The file portion can have multiple files.
%			{dirpathA} {fileA1;fileA2 }
%			{dirpathB} {fileB1}
%			{dirpathC} {fileC1;fileC2;fileC3}
%	OR
%		two arguments (2 string matrices)
%		dirpath = dirpathA (if more than one path, Nrows must equal Nfiles
%		files 	= [fileA1;fileA2;fileB1]
%
%
% 	Function does not do error checking if there are empty cells
%	If files names are different lengths, make sure spaces are at ends of files.

% Put in nargin stuff here to choose
if nargin<1;
		help makenamematrix;return
end
if nargin<2 & ~iscell(cell_pathsnfiles);
		help makenamematrix;return
end

namematrix = [];

if iscell(cell_pathsnfiles);

		[dum,LENGTH] = size(cell_pathsnfiles);
		for ii = 1:LENGTH
			namematrixii = [...
				 char(ones(length(cell_pathsnfiles{ii,2}(:,1)),1)  *  [cell_pathsnfiles{ii,1},filesep] )  , cell_pathsnfiles{ii,2}  ];
			namematrix = strvcat(namematrix,namematrixii);   % in case of different lengths  - puts blanks at ends
		end

else		% input is in simple path and files string matrices
		dirpath = cell_pathsnfiles;
		filenames = orfiles;


		if length(dirpath(:,1))==1 
			namematrix =  [char(ones(length(filenames(:,1)),1)*[dirpath, filesep]), filenames];
		elseif length(dirpath(:,1))==length(filenames(:,1))   % easy one
			SEPmatrix = char(ones(length(filenames(:,1)),1)*[filesep]);
			namematrix = [dirpath,SEPmatrix,filenames];
		else disp('error')
		end
end

end  % of main function

%% HELPER FUNCTIONS HERE %%%%%
