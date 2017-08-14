clc
clear

data = csvread('ppgText3.txt');

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

%% SSF window size followed by calling the SSF function
w = 10;             
for i=1:n
    if i>w
        window = filterIR((i-1):-1:(i-w));
        SSF(i) = SSF_function(window);
    else
        SSF(i) = 0;
    end    
end

%% Beat Detection Ear
prev_beatMillis = time(1);
beatDelay = 500;
beatPeriodSum = 0;
beatPeriodMillis = zeros(10,1);
beatPeriodAverage = 0;
threshold = ones(n,1).*10;
stdev = zeros(n,1);
numOfPeaks_Ear = 0;

%Beat betection function Ear
for i=2:n-1 %Start at the 2nd
    tempBeatPeriod = time(i)-prev_beatMillis;
    if numOfPeaks_Ear>=3
        thres_Window = EarPeaks(numOfPeaks_Ear-1:numOfPeaks_Ear, 2);
        peakmean = mean(thres_Window);
        threshold(i) = peakmean/2.2;
    end
    
    if tempBeatPeriod > 2*beatPeriodAverage
        %fprintf('Reset threshold at %d\n', EarPPG_X(i));
        %threshold(i) = 10;
    end

    if SSF(i) > threshold(i) && tempBeatPeriod > beatDelay && SSF(i-1)<=SSF(i) && SSF(i)>SSF(i+1)
        beatPeriodSum = beatPeriodSum - beatPeriodMillis(10);
        numOfPeaks_Ear = numOfPeaks_Ear+1;
        
        for j=10:-1:2
            beatPeriodMillis(j) = beatPeriodMillis(j-1); 
        end
        
        if tempBeatPeriod>1500
            beatPeriodMillis(1) = 1500;
        elseif tempBeatPeriod<500
            beatPeriodMillis(1) = 500;
        else
            beatPeriodMillis(1) = tempBeatPeriod;
        end
        
        prev_beatMillis = time(i);
        
        beatPeriodSum = beatPeriodSum + beatPeriodMillis(1);
        beatPeriodAverage = beatPeriodSum/10;
        beatDelay = 0.7*beatPeriodAverage;
        EarPeaks(numOfPeaks_Ear,1) = time(i);
        EarPeaks(numOfPeaks_Ear,2) = SSF(i);
        %EarPeakMillis(numOfPeaks_Ear) = EarMillis(i);
        
        if numOfPeaks_Ear>1
            EarPeriod(numOfPeaks_Ear-1,1) = beatPeriodMillis(1);
        end
    end
end

for i=1:length(EarPeaks)-1
    EarPeriod(i) = EarPeaks(i+1,1) - EarPeaks(i,1);
end




%% Plots

%Raw -> AC
figure('units','normalized','outerposition',[0.25 0.25 0.55 0.7])
subplot(2,1,1)
plot(time(50:n), rawIR(50:n), 'k');
title('Raw PPG with DC offset and drift: x_n');
ylabel('ADC value'); xlabel('Time (ms)');
axis([70000 112500 -40200 -39200]);

subplot(2,1,2)
plot(time(50:n), acIR(50:n), 'k');
title('Extracted AC component');
ylabel('AC value'); xlabel('Time (ms)');
axis([70000 112500 -80 80]);


%AC -> Filtered
figure('units','normalized','outerposition',[0.25 0.25 0.55 0.7])
subplot(2,1,1)
plot(time(50:n), acIR(50:n), 'k');
title('Extracted AC component');
ylabel('AC value'); xlabel('Time (ms)');
axis([70000 112500 -80 80]);

subplot(2,1,2)
plot(time(50:n), filterIR(50:n), 'k');
title('Filtered AC component: y_n');
ylabel('Filtered value'); xlabel('Time (ms)');
axis([70000 112500 -80 80]);


%Characteristics
figure('units','normalized','outerposition',[0.25 0.25 0.55 0.7])
plot(time(50:n), filterIR(50:n), 'k');
title('Filtered AC component of PPG');
ylabel('Filtered value'); xlabel('Time (ms)'); grid;
axis([76790 81400 -35 35]);


%Filtered -> SSF
figure('units','normalized','outerposition',[0.25 0.25 0.55 0.7])
subplot(2,1,1)
plot(time(50:n), filterIR(50:n), 'k');
title('Filtered AC component: y_n');
ylabel('Filtered value'); xlabel('Time (ms)');
axis([70000 112500 -50 60]);

subplot(2,1,2)
plot(time(50:n), SSF(50:n), 'k');
title('SSF');
ylabel('SSF value'); xlabel('Time (ms)');
axis([70000 112500 -5 80]);


%Beats
figure('units','normalized','outerposition',[0.25 0.25 0.55 0.7])
plot(time(50:n), SSF(50:n), 'k'); hold on;
plot(EarPeaks(:,1), EarPeaks(:,2), 'o', 'Color',[1 0 0], 'MarkerSize', 3, 'MarkerFaceColor', [1 0 0]);
plot(time(50:n), threshold(50:n), 'k');
title('Beat Detection');
ylabel('SSF value'); xlabel('Time (ms)');
legend('Filtered AC PPG', 'Detected beats');
axis([70000 112500 -5 80]); hold off;