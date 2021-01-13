%This script plots the data "DataFig2", that is, it plots the maximum infidelity versus photon loss gamma.

%Graining of the gamma loss interval into m data points
m = 100; 
gammaRange = 0.08 : 0.12/m : 0.2;

%The maximum infidelity for the [[4,1,2]] encoding against amplitude
%damping channel
Code4QubitAD = arrayfun(@(x) 5*x^2,gammaRange);

%Maximum infidelity for our codes:
MaxInfidGKPRepChain = MaxInfid(Gamma_GKPRepChain);
MaxInfidCode4Qubit = MaxInfid(Gamma_4Q);
MaxInfidCode7Qubit = MaxInfid(Gamma_7Q);
MaxInfidCode7QubitNoAnalogInfo = MaxInfid(Gamma_7QNoAnalogInfo);


figure
hold all
plot(gammaRange, Code4QubitAD,'LineWidth', 7,'color','[0.4660    0.6740    0.1880]', 'LineStyle', ':')
plot(MaxInfidGKPRepChain(:,1),MaxInfidGKPRepChain(:,2),'LineWidth', 7,'color','black', 'LineStyle', ':')
plot(MaxInfidCode7QubitNoAnalogInfo(:,1), MaxInfidCode7QubitNoAnalogInfo(:,2),'LineWidth', 7,'color','[0.4940, 0.1840, 0.5560]')
plot(MaxInfidCode4Qubit(:,1), MaxInfidCode4Qubit(:,2),'LineWidth', 7, 'color','[0.8500, 0.3250, 0.0980]')
plot(MaxInfidCode7Qubit(:,1), MaxInfidCode7Qubit(:,2),'LineWidth', 7, 'color','[0, 0.4470, 0.741]')
set(gca, 'YScale', 'log')
grid on
ax = gca;
ax.GridAlpha = 1;
supersizeme(+3.5)
title('Infidelity vs photon loss probability \gamma')
xlabel('\gamma')
ylabel('Infidelity')
legend('only [[4,1,2]]', 'only GKP', '[[7,1,3]] with GKP, no analog info', '[[4,1,2]] with GKP', '[[7,1,3]] with GKP', 'Location', 'southeast')