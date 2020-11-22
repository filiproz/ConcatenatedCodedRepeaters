function out = VoteMultiMeas(measured, sigGKP, cMat, z, CsSigc2)
%This function determines the parity from a repeated twice second level 
%stabiliser measurement.
% measured -    a row vector of two measured syndrome values (continuous
%               numbers in [-sqrt(pi), sqrt(pi)))
% sigGKP -      the amount of noise on the GKP ancilla
% cMat -        the residual c's on the qubits that are measured,
%               the two rows correspond to the two measurement rounds, the
%               columns to the residual c's on different qubits
% z -           syndrome outcomes from the GKP corrections between the 2
%               rounds of measuring the XXXX stabiliser.
% CsSigc2P -    matrix with residual GKP rescaling coeffs before the c2 GKP
%               corrections

% Output:
%
% out -         The most probable parity consistent with measured
% 
%The noise comes from data qubits, each with standard deviation sqrt(c)*sigGKP
%and the ancilla qubit with standard deviation sigGKP

%Determine stabiliser values for each outcome
parity = zeros(2,1);
for i = 1:2
    if abs(measured(i))< sqrt(pi)/2
        parity(i) = 0;
    else
        parity(i) = 1;
    end
end
    
if all(parity == parity(1))
    out = parity(1);
else
    %We calculate the values mod sqrt(pi) onto the interval [-sqrt(pi)/2,
    %sqrt(pi)/2), since in this way we don't look at the actual parity
    %value but only on the error shifts.
    measuredModRootPi = ReminderMod(measured', sqrt(pi));
    %Now we establish the error likelihood
    sigMultiQubit1 = sqrt((sum(cMat(1,:))+1))*sigGKP;
    sigMultiQubit2 = sqrt((sum(cMat(2,:))+1))*sigGKP;
    perror = ErrorLikelihood(measuredModRootPi, [sigMultiQubit1; sigMultiQubit2]);
    
    %Now calculate the error likelihood on the intermediate GKP correction 
    sigc2 = sqrt(2 + CsSigc2(:,2)) * sigGKP;
    perrorGKPCorr = 1-prod(1-ErrorLikelihood(z, sigc2),"all");
    
    %Assign the parity according to the obtained analog info
    if max([perrorGKPCorr,perror(1), perror(2)]) == perrorGKPCorr
        %If there was high probability of an intermediate error we assign
        %the second value
        out = parity(2);
    else
        if perror(1) < perror(2)
            out = parity(1);
        else
            out = parity(2);
        end
    end
end

