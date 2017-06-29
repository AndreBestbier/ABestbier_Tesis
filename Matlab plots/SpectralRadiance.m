%Spectral radiance
clc

h = 6.626070040e-34;    %Planck's constant
c = 299792458;          %Speed of light
kb = 1.38064852e-23;    %Boltzmann constant
lambda = (1:0.01:100).*(10^-6);  %Wave length
T1 = 308.15;                %Temperature
T2 = 310.15;                %Temperature
T3 = 312.15;                %Temperature

for i=1:length(lambda)
B1(i) = ((2*h*c^2)/(lambda(i)^5))*(1/(exp((h*c)/(lambda(i)*kb*T1))-1));
end

for i=1:length(lambda)
B2(i) = ((2*h*c^2)/(lambda(i)^5))*(1/(exp((h*c)/(lambda(i)*kb*T2))-1));
end

for i=1:length(lambda)
B3(i) = ((2*h*c^2)/(lambda(i)^5))*(1/(exp((h*c)/(lambda(i)*kb*T3))-1));
end










plot(lambda*1000000, B1/1000000); grid; hold on;
plot(lambda*1000000, B2/1000000);
plot(lambda*1000000, B3/1000000);
title('Planck''s Law at T = 37 deg C');
xlabel('Wavelength (\mum)');
ylabel('Spectral Radiance (kW·sr^{-1}·m^{-2}·nm^{-1})');
legend('35 deg C','37 deg C','39 deg C');
axis([0 100 0 14]); hold off;



