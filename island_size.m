%figure;
%mesh(goodimages.n110);
%view([0,90]);
%CLIM =[10 500];
%set(gca, 'Clim', CLIM);

gauss_line=fittype('.398*a1/c1*exp(-((x-b1)^2)/2/c1/c1)+d1')
ftype=fittype(gauss_line); % change this if another function is desired instead

%Choose the parameter bounds, and starting points for the peak:
opts=fitoptions(gauss_line); % change this if another function is used

opts.Lower=[0.0 0.0 0.0 0.0]; % in alphabetical order [a1 b1 c1 d e]
opts.Upper=[1E10 1000 1000 1E10]; % ditto
opts.StartPoint=[1600 125 2 150]; % ditto, these are the initial guesses


for i=110:140
    for j = 20:230
INT(i,j)=goodimages.n70(j,i);
L(i,j)=i;
    end
end
%end


for j=20:230
gfit=fit([L(110:140,j)],[INT(110:140,j)],ftype,opts)
ci=confint(gfit,.95); % Change .95 value if other that 95% confidence intervals desired

Intens(j)=gfit.a1;
CEN(j)=gfit.b1;
FWHM(j)=gfit.c1;
bkgd(j)=gfit.d1;

end

%figure;
%semilogy(L(110:140,1),INT(110:140,1),'bo','MarkerSize',9);
%hold on;
%semilogy(L(110:140,1),gfit(L(110:140,1)),'r-')
%xlabel('L (rlu)','FontSize',20);
%ylabel('Intensity (arb.)','FontSize',20);

%figure; 
plot(20:230,Intens(20:230));
 xlabel('del (pixel #)','FontSize',20);
 ylabel('Intensity (arb.)','FontSize',20);

