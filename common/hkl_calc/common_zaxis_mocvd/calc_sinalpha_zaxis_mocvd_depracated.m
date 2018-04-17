function [sinalpha,sinbeta] = calc_sinalpha_zaxis_mocvd(angles,sigmatau)
	%[]sinalpha sinbeta] = calc_sinalpha_zaxis_mocvd([Delta Theta Mu Gamma], [Sigma Tau])
	Delta = angles(:,1);Theta = angles(:,2);Mu=angles(:,3);Gamma=angles(:,4);
	Sigma = sigmatau(1);Tau=sigmatau(2);
	%Thetamax = -Tau -90 if Sigma is Positive definite, Thetamax = -Tau + 90 if Sigma Negative definite
	
	sinalpha = sind(Mu).*cosd(Sigma)  + cosd(Mu).*sind(Sigma).*sind(Tau+Theta);
	
	sinbeta =  sind(Gamma).*cosd(Sigma) - cosd(Gamma).*sind(Sigma).*sind(Theta + Tau - Delta);
end

