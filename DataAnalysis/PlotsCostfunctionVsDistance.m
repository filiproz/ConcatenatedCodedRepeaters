%This script plots the cost function for the two architectures based on the
%[[4,1,2]] code and the two architectures based on the [[7,1,3]] code where
%for each code we consider the hybrid architecture and the one that uses
%only type-A repeaters.
%The script takes as input the Cost function data:
%"CostfunctionMin4QubitCode", 
%"CostfunctionMinOnlyMultiQubit4QubitCode"
%"CostfunctionMin7QubitCode",
%"CostfunctionMinOnlyMultiQubit7QubitCode"


figure
hold all
plot(X,CostfunctionMin4QubitCode,'LineWidth', 7, 'color','[0.8500, 0.3250, 0.0980]')
plot(X,CostfunctionMinOnlyMultiQubit4QubitCode,'LineWidth', 7, 'color','[0, 0.4470, 0.741]')
plot(X,CostfunctionMin7QubitCode,'LineWidth', 7)
plot(X,CostfunctionMinOnlyMultiQubit7QubitCode,'LineWidth', 7)
grid on
ax = gca;
ax.GridAlpha = 1;
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
supersizeme(+3.5)


title('Normalised cost function C'' vs distance')
xlabel('Distance (km)')
ylabel('Normalised cost function')

legend('Hybrid, [[4,1,2]]', 'Only type-A repeaters, [[4,1,2]]', 'Hybrid, [[7,1,3]]', 'Only type-A repeaters, [[7,1,3]]', 'Location', 'northwest')