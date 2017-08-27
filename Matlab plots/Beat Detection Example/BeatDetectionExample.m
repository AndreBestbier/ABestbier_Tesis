load EarPPG_X.mat
load EarPPG.mat
load SSF.mat
load threshold.mat
load EarPeaks.mat

figure('units','normalized','outerposition',[0.25 0.25 0.6 0.62])
plot(EarPPG_X, EarPPG); grid; hold on;
plot(EarPPG_X, SSF);
plot(EarPPG_X, threshold, 'Color',[190/255 190/255 190/255]);
plot(EarPeaks(:,1), EarPeaks(:,2), 'o', 'Color',[1 0 0], 'MarkerSize', 3, 'MarkerFaceColor', [1 0 0]);
axis([46600 62450 -20 43]);
title('SSF and Filtered AC PPG vs. Time');
legend('Ear-Monitor Filtered AC PPG', 'Ear-Monitor SSF', 'Threshold', 'Beats detected');
ylabel('Ear-Monitor PPG and SSF values'); xlabel('Time (MS)'); hold off;