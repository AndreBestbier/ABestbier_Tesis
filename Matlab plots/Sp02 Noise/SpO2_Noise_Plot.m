clear
clc

load EarPeaksMillis_X.mat
load irAC_filt.mat
load ppgMillis.mat
load redAC_filt.mat
load Sats_meanAbs_beats2.mat
load SureSign.mat
load SureSign_X.mat

figure('units','normalized','outerposition',[0 0 1 1]);
subplot(2,1,1)
plot(SureSign_X, SureSign); hold on;
plot(EarPeaksMillis_X, Sats_meanAbs_beats2);
axis([0 40000 95 101]);

subplot(2,1,2)
plot(ppgMillis, redAC_filt); hold on;
plot(ppgMillis, irAC_filt);
legend('IR AC','Red AC');
axis([0 40000 -120 130]);
grid; hold off;