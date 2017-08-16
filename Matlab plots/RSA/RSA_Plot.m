clc
clear

load EM.mat
load Nexus.mat

figure('units','normalized','outerposition',[0.25 0.25 0.55 0.7]);
plot(EM(:,1), EM(:,2), '-o', 'MarkerSize', 2, 'MarkerFaceColor', 'b'); hold on;
plot(Nexus(:,1), Nexus(:,2)-20);
axis([60000 115000 410 1030]);
legend('Ear-Monitor beat period','Chest expantion');
xlabel('Time (ms)'); ylabel('Ear-Monitor beat period and scaled Nexus chest expantion');
title('Plots of heart beat periods and chest expansion'); grid; hold off;

