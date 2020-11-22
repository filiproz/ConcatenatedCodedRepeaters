function [CsSigChannelQ, CsSigc1Q, CsSigc2Q] = CsForAnalogInfo4QubitCodeQuadQ(cVecRealtimeQ,n)
%This function constructs matrix of used c's to put into sigma for analog info
%matrix for each qubit for the 4-qubit code for the q-quadrature. Note that the c's in sigma are shifted with
%respect to c's used in GKP correction because in sigma we care
%about the noise and so about the c used at the previous
%correction.

%Inputs:

%cVecRealtimeQ -    Vector of rescaling coefficients for the 4-qubit code
%n -                number of GKP channels and GKP corrections before a higher level correction

%Outputs

%CsSigChannelQ -            rescaling coefficients for residual displacements for the likelihood
%                           estimation at the GKPs that correct the communication channel
%                           noise. These are rescaling coeffs for the noise
%                           and so they correspond to the rescaling
%                           coefficients for the round before
%CsSigc1Q -                 rescaling coefficients for residual displacements for the likelihood
%                           estimation at the GKPs that correct the noise
%                           when the channel included the back-action from
%                           multiqubit correction and from GKP correction
%                           in the p-quadrature.
%                           These are rescaling coeffs for the noise
%                           and so they correspond to the rescaling
%                           coefficients for the round before
%CsSigc2Q -                 rescaling coefficients for residual displacements for the likelihood
%                           estimation at the GKPs that correct the noise
%                           when the channel included only the back-action from GKP correction in the p-quadrature. 
%                           These are rescaling coeffs for the noise
%                           and so they correspond to the rescaling
%                           coefficients for the round before


%Firstly the channel part, we evaluate it on all qubits
CsSigChannelQ = zeros(4,n);
CsSigChannelQ(:,1) = cVecRealtimeQ(end);
for j=2:n
    CsSigChannelQ(:,j) = cVecRealtimeQ(j-1);
end

%After the channel we have the c2 extra GKP-correction
CsSigc2Q = zeros(4,1);
CsSigc2Q(:,1) = cVecRealtimeQ(n);

CsSigc1Q = zeros(4,2);

w=0;
%Then we have the two c1 corrections one after each time XXXX(p) is
%measured
for j = 1:2
    w= w+1;
    CsSigc1Q(:,j) = cVecRealtimeQ(n+w);
end