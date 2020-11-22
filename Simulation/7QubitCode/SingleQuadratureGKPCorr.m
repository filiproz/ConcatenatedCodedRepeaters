function [DeltasOut,stabilisersOutcomes] = SingleQuadratureGKPCorr(quad, qubits, DeltasIn, AncillaErrors, code, c)
%This function applies a single GKP correction in one quadrature
%quad -                 whether the quadrature that we are evolving is the one in which we
%                       correct errors
%                       0 - no, so our correction will only add errors
%                       1 - yes, we are correcting errors
%qubits -               row vector with numbers indicating which qubits are involved in
%                       in this correction
%DeltasIn -             The quadrature values on all qubits before the correction
%AncillaErrors-         Random numbers for errors on the ancillas used during
%                       correction
%code -                 The number of physical qubits in the code
%c -                    Vector of rescaling coefficients during correction. Vector
%                       must have the same dimension as qubits.
%Output:

%DeltasOut -            quadrature values after correction
%stabilisersOutcomes -  vector of dimension code with the analog stabiliser
%                       outcomes. If quad = 0, it is a zero vector. For qubits that were not
%                       involved, the value is set to 0.

stabilisersOutcomes = zeros(code,1);
if quad == 0
    %We are correcting errors in the other quadrature so in this one we are
    %inducing errors
    DeltasIn(qubits) = DeltasIn(qubits) - AncillaErrors;
elseif quad == 1
    %We are correcting errors in this quadrature
    %Measure the stabilisers
    stabilisersOutcomes(qubits) = ReminderMod(DeltasIn(qubits) + AncillaErrors,sqrt(pi));
    %Correct the errors
    DeltasIn(qubits) = DeltasIn(qubits) - c.*stabilisersOutcomes(qubits);   
end

DeltasOut = DeltasIn;