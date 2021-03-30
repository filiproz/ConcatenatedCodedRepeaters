%This script plots secret-key rate per optical mode, optimal repeater configuration and the
%minimised normalised cost function for the data
%"Data4QubitCode"


[CostfunctionMin4QubitCode,CostfunctionMinOnlyMultiQubit4QubitCode,MinNMultiQubit,MinNall,MinNOnlyMultiQubit] = CostFunctionMinimiseOverStationsVsDistance(Data4QubitCode);
[SecretKeyMinCostfunc,SecretKeyMinCostfuncOnlyMultiQubit] = SecretKeyForOptimisedCostFunctionOverStations(Data4QubitCode,MinNMultiQubit,MinNall,MinNOnlyMultiQubit);

Lmax = 10000;
Lfix = 10;
X = zeros(1, Lmax/Lfix);
for i = 1:Lmax/Lfix
    Ltot = i * Lfix;
    X(i) = Ltot;
end

%Secret key
PLOB = -log2(1-exp(-X/22));
figure
plot(X,SecretKeyMinCostfunc,'LineWidth', 7)
hold all
plot(X,SecretKeyMinCostfuncOnlyMultiQubit,'LineWidth', 7,'LineStyle',':')
plot(X,PLOB,'LineWidth', 7,'LineStyle','--')
yline(0.25,'LineWidth', 4,'LineStyle',':');
ylim([0. 0.3])
grid on
ax = gca;
ax.GridAlpha = 1;
set(gca, 'XScale', 'log')
supersizeme(+3.5)


title('Secret-key rate r'' vs distance, [[4,1,2]] code')
xlabel('Distance (km)')
ylabel('Secret-key rate r'' (bits per mode)')

legend('Hybrid','Only type-A repeaters', 'PLOB bound', 'Saturation secret key','Location', 'northeast')


%Resources - both stations

figure
plot(X,MinNMultiQubit,'color',[0.4660    0.6740    0.1880],'LineWidth', 7)
hold all
plot(X,MinNall - MinNMultiQubit,'color',[0    0.4470    0.7410],'LineWidth', 7)
plot(X,MinNOnlyMultiQubit,'color',[0.8500    0.3250    0.0980],'LineWidth', 7, 'LineStyle',':')
ylim([0 40])
grid on
ax = gca;
ax.GridAlpha = 1;
set(gca, 'XScale', 'log')
supersizeme(+3.5)

title('No. of repeaters per 10 km vs distance, [[4,1,2]] code')
xlabel('Distance (km)')
ylabel('No of repeaters per 10 km')

legend('Type-A repeaters, hybrid', 'Type-B repeaters, hybrid', 'Only type-A repeaters', 'Location', 'northwest')

%Resources - cost function

figure
hold all
plot(X,CostfunctionMin4QubitCode,'LineWidth', 7)
plot(X,CostfunctionMinOnlyMultiQubit4QubitCode,'LineWidth', 7, 'LineStyle',':')
grid on
ax = gca;
ax.GridAlpha = 1;
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
supersizeme(+3.5)


title('Normalised cost function C'' vs distance, [[4,1,2]] code')
xlabel('Distance (km)')
ylabel('Normalised cost function C''')

legend('Hybrid', 'Only type-A repeaters','Location', 'northwest')