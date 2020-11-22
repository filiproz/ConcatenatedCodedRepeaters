function [CsSigChannelQ, CsSigc1Q, CsSigc2Q] = CsForAnalogInfoQuadQ(cVecRealtime124Q,cVecRealtime356Q,cVecRealtime7Q,n)
%This function constructs matrix of used GKP rescaling coefficients c's to put into sigma for analog info
%matrix for each qubit for the [[7,1,3]] code for the q-quadrature. Note that the c's in sigma are shifted with
%respect to c's used in GKP correction because in sigma we care
%about the noise channel and so about the c used at the previous
%correction. This is because the rescaling coefficient used at the previous
%GKP correction determines the residual displacement error after that
%correction.

%Inputs:

%cVecRealtimeQ -            Vector of rescaling coefficients for the
%                           [[7,1,3]] code. We have a separate vector for
%                           qubits (1,2,4), (3,5,6) and 7.
%n -                        number of GKP channels and GKP corrections before a higher level correction

%Outputs:

%CsSigChannelQ -            rescaling coefficients for residual displacements for the likelihood
%                           estimation at the GKPs that correct the communication channel
%                           noise. These are rescaling coeffs for the noise
%                           distribution and so they correspond to the rescaling
%                           coefficients implemented implemented at the previous GKP correction.
%CsSigc1Q -                 rescaling coefficients for residual displacements for the likelihood
%                           estimation at the GKPs that correct the noise
%                           when the channel included the back-action from
%                           multiqubit correction and from GKP correction
%                           in the p-quadrature.
%                           Since some qubits are
%                           measured different number of times than others,
%                           for a round in which a given qubit is not
%                           measured the value is set to 0. This matches
%                           the measured analog syndrome of 0 for these
%                           rounds. 
%                           These are rescaling coeffs for the noise
%                           distribution
%                           and so they correspond to the rescaling
%                           coefficients implemented implemented at the previous GKP correction.
%CsSigc2Q -                 rescaling coefficients for residual displacements for the likelihood
%                           estimation at the GKPs that correct the noise
%                           when the channel included only the back-action from GKP correction in the p-quadrature. 
%                           Since some qubits are
%                           measured different number of times than others,
%                           for a round in which a given qubit is not
%                           measured the value is set to 0. This matches
%                           the measured analog syndrome of 0 for these
%                           rounds. 
%                           These are rescaling coeffs for the noise
%                           distribution
%                           and so they correspond to the rescaling
%                           coefficients implemented implemented at the previous GKP correction.


%These matrices pick the qubits and rounds that were involved in the given
%c1 (channel with back-action from both GKP and multi-qubit stabiliser measurements) 
%and c2 (no back-action from multi-qubit correction, only from GKP
%correction) corrections

RoundsGKPCorrMultiQubitRep = load('RoundsGKPCorrMultiQubitRep.mat'); 

RoundsC1Corr=RoundsGKPCorrMultiQubitRep.RoundsC1Corr;
RoundsC2Corr=RoundsGKPCorrMultiQubitRep.RoundsC2Corr;

%Firstly the channel part, we evaluate it on all qubits   
CsSigChannelQ = zeros(7,n);
for i = [1,2,4]
    CsSigChannelQ(i,1) = cVecRealtime124Q(end);
    for j=2:n
        CsSigChannelQ(i,j) = cVecRealtime124Q(j-1);
    end
end
for i = [3,5,6]
    CsSigChannelQ(i,1) = cVecRealtime356Q(end);
    for j=2:n
        CsSigChannelQ(i,j) = cVecRealtime356Q(j-1);
    end
end
CsSigChannelQ(7,1) = cVecRealtime7Q(end);
for j=2:n
    CsSigChannelQ(7,j) = cVecRealtime7Q(j-1);
end


CsSigc1Q = zeros(7,6);
CsSigc2Q = zeros(7,7);

%Now the remaining part for qubits 1,2,4
for i = [1,2,4]
    w=0;
    w= w+1;
    %After the channel we have a single c2 correction on all the qubits
    CsSigc2Q(i,1) = cVecRealtime124Q(n+w-1);
    %Now we have c1 corrections, we have two intermediate corrections
    %between the 3 stabilisers, refreshing, second round
    %and the final correction on all the qubits.
    for j = 1:6
        if RoundsC1Corr(i,j) == 1
            w= w+1;
            CsSigc1Q(i,j) = cVecRealtime124Q(n+w-1);
        end
    end
    %Now we have the extra c2 correction on all qubits followed by the
    % the two c2 corrections between the stabilisers, refreshing and the
    % second round
    for j = 1:6
        if RoundsC2Corr(i,j) == 1
            w= w+1;
            CsSigc2Q(i,j+1) = cVecRealtime124Q(n+w-1);
        end
    end
end

%Now the same for qubits 3,5,6
for i = [3,5,6]
    w=0;
    w= w+1;
    CsSigc2Q(i,1) = cVecRealtime356Q(n+w-1);
    for j = 1:6
        if RoundsC1Corr(i,j) == 1
            w= w+1;
            CsSigc1Q(i,j) = cVecRealtime356Q(n+w-1);
        end
    end
    for j = 1:6
        if RoundsC2Corr(i,j) == 1
            w= w+1;
            CsSigc2Q(i,j+1) = cVecRealtime356Q(n+w-1);
        end
    end
end

%Now the same for qubit 7
w=0;
w= w+1;
CsSigc2Q(7,1) = cVecRealtime7Q(n+w-1);
for j = 1:6
    if RoundsC1Corr(7,j) == 1
        w= w+1;
        CsSigc1Q(7,j) = cVecRealtime7Q(n+w-1);
    end
end 
for j = 1:6
    if RoundsC2Corr(7,j) == 1
        w= w+1;
        CsSigc2Q(7,j+1) = cVecRealtime7Q(n+w-1);
    end
end