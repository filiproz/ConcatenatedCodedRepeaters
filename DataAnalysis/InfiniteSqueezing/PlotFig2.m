%This script plots the data "DataFig2", that is, it plots the logical error
%probability versus photon loss gamma.

figure
plot(Gamma_GKPRepChain(:,1),Gamma_GKPRepChain(:,2),Gamma_4Q(:,1), Gamma_4Q(:,2), Gamma_7Q(:,1), Gamma_7Q(:,2), Gamma_7Q_NoAnalogInfo(:,1), Gamma_7Q_NoAnalogInfo(:,2),'LineWidth', 7)
set(gca, 'YScale', 'log')
grid on
ax = gca;
ax.GridAlpha = 1;
supersizeme(+3.5)
title('Logical error probability vs loss \gamma')
xlabel('\gamma')
ylabel('Logical error probability')
legend('only GKP', '[[4,1,2]]', '[[7,1,3]]','[[7,1,3]], no analog info', 'Location', 'southeast')