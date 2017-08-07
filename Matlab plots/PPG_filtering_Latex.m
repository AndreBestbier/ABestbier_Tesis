clc
clear

data = csvread('ppgText2.txt');

time = data(:,3);
rawIR = data(:,4);
n = length(time);
w = zeros(n,1);
acIR = zeros(n,1);
a = 0.7;

%% AC extraction
for i=2:n
    w(i) = rawIR(i) + a*w(i-1);
    acIR(i) = w(i)-w(i-1);    
end

%% Unfiltered FFT
Y1 = schefft(acIR, 50);
Y1(1) = [];
n1 = length(Y1);
power1 = abs(Y1(1:floor(n1/2)));
freq1 = (1:n1/2)/60;

%% Low-pass filter
[b, a] = butter(3, 3/(50/2), 'low');
filterIR = filter(b, a, acIR);

%% Filtered FFT
Y2 = schefft(filterIR, 50);
Y2(1) = [];
n2 = length(Y2);
power2 = abs(Y2(1:floor(n2/2)));
freq2 = (1:n2/2)/60;

%% Plots
figure('units','normalized','outerposition',[0.25 0.25 0.55 0.7])
subplot(2,1,1)
plot(time(50:n), rawIR(50:n), 'k');
title('Raw PPG with DC offset and drift: x_n');
ylabel('ADC value'); xlabel('Time (ms)');

subplot(2,1,2)
plot(time(50:n), acIR(50:n), 'k');
title('Extracted AC component');
ylabel('AC value'); xlabel('Time (ms)');

figure('units','normalized','outerposition',[0.25 0.25 0.55 0.7])

subplot(2,1,1)
plot(time(50:n), acIR(50:n), 'k');
title('Extracted AC component');
ylabel('AC value'); xlabel('Time (ms)');
axis([70000 126000 -80 80]);

subplot(2,1,2)
plot(time(50:n), filterIR(50:n), 'k');
title('Filtered AC component: y_n');
ylabel('Filtered value'); xlabel('Time (ms)');
axis([70000 126000 -80 80]);

figure('units','normalized','outerposition',[0.25 0.25 0.55 0.7])
plot(time(50:n), filterIR(50:n), 'k');
title('Filtered AC component of PPG');
ylabel('Filtered value'); xlabel('Time (ms)'); grid;
axis([76790 81400 -35 35]);