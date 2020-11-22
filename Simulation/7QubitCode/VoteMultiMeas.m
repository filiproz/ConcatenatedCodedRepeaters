function [out,QubitWithError,perrorGKPCorrMax] = VoteMultiMeas(measured, sigGKP, cMat, z, StabVec, CsSigc2, stabNo)
%This function determines the parity from a repeated twice second level 
%stabiliser measurement.
% measured -        a row vector of two measured syndrome values (continuous
%                   numbers in [-sqrt(pi), sqrt(pi)))
% sigGKP -          the amount of noise on the GKP ancilla
% cMat -            the residual c's on the qubits that are measured,
%                   the two rows correspond to the two measurement rounds, the
%                   columns to the residual c's on different qubits
%z -                GKP syndrome measurements from the GKP corrections in the
%                   corrected quadrature that have been performed between the
%                   multiqubit stabiliser measurements
%StabVec -          vector listing the data qubits that participate in the
%                   measurements of the given stabiliser
%CsSigc2 -          matrix descrbing the residual rescaling coeffs in the channel
%                   before all the c2 corrections
%stabNo -           The number of the stabiliser measured. We have 3
%                   stabilisers for the [[7,1,3]] code indexed 1,2 and 3. 

% Output:
%
%out -              The most probable parity consistent with measured.
%QubitWithError -   States the data qubit with intermediate errror. If there was 
%                   no intermediate error, the value is zero.
%perrorGKPCorrMax - Error likelihood of the error on the qubit
%                   QubitWithError. It is the error probability on that
%                   qubit between the 2 rounds of measuring the stabiliser
%                   stabNo establised using analog info. Absolute probability, not
%                   divided/conditioned by the error on any relevant qubit
%                   between the 2 rounds of this stabiliser measurement.
% 
%The noise comes from data qubits, each with standard deviation sqrt(c)*sigGKP
%and the ancilla qubit with standard deviation sigGKP

%Determine stabiliser values for each outcome
QubitWithError = 0;
perrorGKPCorrMax = 0;
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
    %For measured, we calculate the values mod sqrt(pi) onto the interval [-sqrt(pi)/2,
    %sqrt(pi)/2), since in this way we don't look at the actual parity
    %value but only on the error shifts.
    measuredModRootPi = ReminderMod(measured', sqrt(pi));
    %Now we establish the error likelihood
    sigMultiQubit1 = sqrt((sum(cMat(1,:))+1))*sigGKP;
    sigMultiQubit2 = sqrt((sum(cMat(2,:))+1))*sigGKP;
    perror = ErrorLikelihood(measuredModRootPi, [sigMultiQubit1; sigMultiQubit2]);
    
    %Now calculate the error likelihood on the intermediate GKP correction 
    sigc2 = sqrt(2 + CsSigc2(:,3:end)) * sigGKP; 
    perrorGKPCorr = 1-prod(1-ErrorLikelihood(z(StabVec,stabNo:stabNo + 2), sigc2(StabVec, stabNo:stabNo + 2)),"all");
    
    %Assign the parity according to the obtained analog info
    if max([perrorGKPCorr,perror(1), perror(2)]) == perrorGKPCorr
        %If there was high probability of an intermediate error we assign
        %the second value
        out = parity(2);
        % We also calculate the probability of intermediate error for each
        % of the considered qubits and choose the qubit with largest error
        % probability and also save the corresponding error likelihood.
        perrorGKPCorrVec = 1-prod(1-ErrorLikelihood(z(StabVec,stabNo:stabNo + 2), sigc2(StabVec,stabNo:stabNo + 2)),2);
        [perrorGKPCorrMax,indMax] = max(perrorGKPCorrVec);
        QubitWithError = StabVec(indMax);
    else
        if perror(1) < perror(2)
            out = parity(1);
        else
            out = parity(2);
        end
    end
end

