
%close all;
%clear all;
filename='/Volumes/SRS/Data/2017/Cycle_3/huber/SPEC/2017_1207_1';    %Identify the file that contains the data (update this identifier)
%filename='/Users/eastman/Documents/Jeffs_Documents/PECOH/MATLAB/Oct_2016/2016_1008_2';
scan=77;  

%Identify where the images are (update this identifier)
Imagepath = '/Volumes/SRS/Data/2017/Cycle_3/huber/AREA/2017_1216_1/2017_1216_1_0';
%Imagepath = '/Users/eastman/Documents/Jeffs_Documents/PECOH/MATLAB/Oct_2016/2016_1009_1_area/2016_1009_1_0';

% read in the spec scan
  [scans, outpts, scantype, scandate, ncols, collabels]= readspecscan(filename,scan);
  Time(:,1)= scans(:,1);
  epoch(:,1)= scans(:,2);
  hubmon(:,1)=scans(:,6);
  Filters(:,1)=scans(:,9);
  Correct(:,1)=scans(:,10);  
  p_total(:,1)=scans(:,15);  
  p_med(:,1)=scans(:,16);
  p_large(:,1)=scans(:,17);
  p_image(:,1)=scans(:,18);
 % pxcen(:,1)=scans(:,19);  
 % pycen(:,1)=scans(:,21);
  DCV1(:,1)=scans(:,30);
  DCV2(:,1)=scans(:,34);
  p_point(:,1)=scans(:,39);

  

Im_num=length(scans(:,1));


for ii=0:Im_num-1;
%for ii=0:10;
 Imdex_num=ii;
 Imdex=num2str(Imdex_num);
 if length(Imdex)==1
 Imagenum=strcat('pil_0000',Imdex,'.tif'); 
 elseif length(Imdex)==2
 Imagenum=strcat('pil_000',Imdex,'.tif');   
 elseif length(Imdex)==3; 
 Imagenum=strcat('pil_00',Imdex,'.tif');     
 elseif length(Imdex)==4;  
 Imagenum=strcat('pil_0',Imdex,'.tif');
 end

for jj=1:length(scan)
if length(num2str(scan(jj)))==1
Scannum=num2str(scan(jj));
ScanLoc=strcat(Imagepath,'00', Scannum,'/');

else if length(num2str(scan(jj)))==2
Scannum=num2str(scan(jj));
ScanLoc=strcat(Imagepath,'0', Scannum,'/');
    else
Scannum=num2str(scan(jj));
ScanLoc=strcat(Imagepath, Scannum,'/');    
    end
    end
    
Im_num=length(scans(:,1));

     ImLoc = strcat(ScanLoc,Imagenum);

     [imtemp] = imread(ImLoc);
     
 
      Image = imtemp;
         
end

im_double = double(imtemp);

images.(['n' num2str(ii+1)])=im_double;


        if DCV1(ii+1)<300.
            shutter(ii+1)=0;
        else
            shutter(ii+1)=1;
        end
 




end


for hh = 1:Im_num
    goodimages.(['n' num2str(hh)]) = images.(['n' num2str(hh)])';
end

%for yy = 1:Im_num
%for pp = 1:195
%sum_in_del(yy,pp)=sum(goodimages.(['n' num2str(yy)])(150:165,pp));
%end
%end

% plot the data

%hold on
figure
[ax,h1,h2]=plotyy(Time,p_med,Time,shutter);
xlabel('Time (sec)');
ylabel(ax(1),'p\_point Intensity');
ylabel(ax(2),'Shutter Status','Color','[.8 .3 .2]');
set(ax(1),'fontsize',24);
set(ax(2),'fontsize',24);
%set(ax(1),'xlim',[0,433]);
%set(ax(2),'xlim',[0,433]);
set(ax(2),'ylim',[-.1,1.1]);
ax(2).YTick = [0 1];




%figure;
%mesh(im_double);
%view([0,90]);
%CLIM =[100 40000];
%set(gca, 'Clim', CLIM);
%xlabel('del pixel #','FontSize',20,'Color','b');
%ylabel('nu pixel #','FontSize',20,'Color','b');






