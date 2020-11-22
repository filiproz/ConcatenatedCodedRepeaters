%Test SingleQuadratureGKPCorr(quad, qubits, DeltasIn, AncillaErrors, code, c)

code = 7;
c = 1;
qubits = [1,2,3,4,5,6,7];

%% Test1: Correcting quadrature
AncillaErrors = [0;0;0;0;0;0;0];
DeltasIn = sqrt(pi)/4 * ones(7,1);
[DeltasOut,stabilisersOutcomes] = SingleQuadratureGKPCorr(1, qubits, DeltasIn, AncillaErrors, code, c);
assert(all(round(DeltasOut,10) == zeros(7,1)))

DeltasIn = sqrt(pi)/2 + 0.001 * ones(7,1);
[DeltasOut,stabilisersOutcomes] = SingleQuadratureGKPCorr(1, qubits, DeltasIn, AncillaErrors, code, c);
assert(all(round(DeltasOut,10) == round(sqrt(pi) * ones(7,1),10)))

%% Test2: Back-action quadrature
AncillaErrors = sqrt(pi)/5 * ones(7,1);
DeltasIn = zeros(7,1);
[DeltasOut,stabilisersOutcomes] = SingleQuadratureGKPCorr(0, qubits, DeltasIn, AncillaErrors, code, 0.75);
assert(all(round(DeltasOut,10) == round(-sqrt(pi)/5 * ones(7,1),10)))