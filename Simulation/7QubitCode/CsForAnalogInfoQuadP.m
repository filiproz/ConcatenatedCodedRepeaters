function [CsSigChannelP, CsSigc1P, CsSigc2P] = CsForAnalogInfoQuadP(cVecRealtime124P,cVecRealtime356P,cVecRealtime7P,n)
%This function constructs matrix of used GKP rescaling coefficients c's to put into sigma for analog info
%matrix for each qubit for the [[7,1,3]] code for the p-quadrature. Note that the c's in sigma are shifted with
%respect to c's used in GKP correction because in sigma we care
%about the noise channel and so about the c used at the previous
%correction. This is because the rescaling coefficient used at the previous
%GKP correction determines the residual displacement error after that
%correction.

%Inputs:

%cVecRealtimeP -            Vector of rescaling coefficients for the
%                           [[7,1,3]] code. We have a separate vector for
%                           qubits (1,2,4), (3,5,6) and 7.
%n -                        number of GKP channels and GKP corrections before a higher level correction

%Outputs:

%CsSigChannelP -            rescaling coefficients for residual displacements for the likelihood
%                           estimation at the GKPs that correct the communication channel
%                           noise. These are rescaling coeffs for the noise
%                           distribution
%                           and so they correspond to the rescaling
%                           coefficients implemented at the previous GKP correction.
%CsSigc1P -                 rescaling coefficients for residual displacements for the likelihood
%                           estimation at the GKPs that correct the noise
%                           when the channel included the back-action from
%                           multiqubit correction and from GKP correction
%                           in the q-quadrature.
%                           Since some qubits are
%                           measured different number of times than others,
%                           for a round in which a given qubit is not
%                           measured the value is set to 0. This matches
%                           the measured analog syndrome of 0 for these
%                           rounds. 
%                           These are rescaling coeffs for the noise
%                           distribution
%                           and so they correspond to the rescaling
%                           coefficients implemented at the previous GKP correction.
%CsSigc2P -                 rescaling coefficients for residual displacements for the likelihood
%                           estimation at the GKPs that correct the noise
%                           when the channel included only the back-action from GKP correction in the q-quadrature. 
%                           Since some qubits are
%                           measured different number of times than others,
%                           for a round in which a given qubit is not
%                           measured the value is set to 0. This matches
%                           the measured analog syndrome of 0 for these
%                           rounds. 
%                           These are rescaling coeffs for the noise
%                           distribution
%                           and so they correspond to the rescaling
%                           coefficients implemented at the previous GKP correction.


%These matrices pick the qubits and rounds that were involved in the given
%c1 (channel with back-action from both GKP and multi-qubit stabiliser measurements)
%and c2 (no back-action from multi-qubit correction, only from GKP
%correction) corrections.
RoundsGKPCorrMultiQubitRep = load('RoundsGKPCorrMultiQubitRep.mat');

RoundsC1Corr=RoundsGKPCorrMultiQubitRep.RoundsC1Corr;
RoundsC2Corr=RoundsGKPCorrMultiQubitRep.RoundsC2Corr;

%The name marks the type of correction at that station to determine
%number of sigGKP's that need to be included in the prob distribution
%for analog info. The assigned c's however come from the previous
%correction round.
CsSigc1P = zeros(7,6);
CsSigChannelP = zeros(7,n);
CsSigc2P = zeros(7,7);

%Firstly for qubits 1,2,4
for i = [1,2,4]
    w=0;
    %Firstly we have the extra c2 correction on all qubits, where the
    %residual c from the last round was the end c
    CsSigc2P(i,1) = cVecRealtime124P(end);
    %Now we have c1 corrections, we have two intermediate corrections
    %between the 3 stabilisers, refreshing, second round
    %and the final correction on all the qubits.
    for j = 1:6
        if RoundsC1Corr(i,j) == 1
            w = w+1;
            CsSigc1P(i,j) = cVecRealtime124P(w);
        end
    end
    %Now we have the channel
    for j=1:n
        w = w+1;
        CsSigChannelP(i,j) = cVecRealtime124P(w);
    end
    %Now we have the extra c2 correction on all qubits followed by the
    % the two c2 corrections between the stabilisers, refreshing and
    % second round
    for j = 1:6
        if RoundsC2Corr(i,j) == 1
            w = w+1;
            CsSigc2P(i,j+1) = cVecRealtime124P(w);
        end
    end
end

%Now the same for qubits 3,5,6
for i = [3,5,6]
    w=0;
    CsSigc2P(i,1) = cVecRealtime356P(end);
    for j = 1:6
        if RoundsC1Corr(i,j) == 1
            w = w+1;
            CsSigc1P(i,j) = cVecRealtime356P(w);
        end
    end
    for j=1:n
        w = w+1;
        CsSigChannelP(i,j) = cVecRealtime356P(w);
    end
    for j = 1:6
        if RoundsC2Corr(i,j) == 1
            w = w+1;
            CsSigc2P(i,j+1) = cVecRealtime356P(w);
        end
    end
end

%Now the same for qubit 7
w=0;
CsSigc2P(7,1) = cVecRealtime7P(end);
for j = 1:6
    if RoundsC1Corr(7,j) == 1
        w = w+1;
        CsSigc1P(7,j) = cVecRealtime7P(w);
    end
end
for j=1:n
    w = w+1;
    CsSigChannelP(7,j) = cVecRealtime7P(w);
end
for j = 1:6
    if RoundsC2Corr(7,j) == 1
        w = w+1;
        CsSigc2P(7,j+1) = cVecRealtime7P(w);
    end
end