%Spectral radiance
clc

h = 6.626070040e-34;    %Planck's constant
c = 299792458;          %Speed of light
kb = 1.38064852e-23;    %Boltzmann constant
lambda = (1:0.01:100).*(10^-6);  %Wave length
T1 = 310.15;                %Temperature
T2 = 273.15;                %Temperature
T3 = 373.15;                %Temperature

for i=1:length(lambda)
B1(i) = ((2*h*c^2)/(lambda(i)^5))*(1/(exp((h*c)/(lambda(i)*kb*T1))-1));
end



plot(lambda*1000000, B1/1000000, 'k'); grid;
title('Planck''s Law at T = 37 deg C');
xlabel('Wavelength (\mum)');
ylabel('Spectral Radiance (kW·sr^{-1}·m^{-2}·nm^{-1})');
axis([0 100 0 14]);



