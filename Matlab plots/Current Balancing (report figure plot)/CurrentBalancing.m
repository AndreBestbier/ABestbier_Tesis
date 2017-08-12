data = csvread('CB_Data.txt');
rawIR = data(:,1);
rawRED = data(:,2);
time = (1:length(rawIR)).*0.02;

figure('units','normalized','outerposition',[0.25 0.25 0.55 0.7])
plot(time, rawIR, time, rawRED); grid;
xlabel('Time (seconds)'); ylabel('MAX30100 PPG output'); title('Current Balancing');
legend('Infrared PPG', 'Red PPG');
axis([0 12 26000 44000]);