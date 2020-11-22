function [CsSigChannelP, CsSigc1P, CsSigc2P] = CsForAnalogInfo4QubitCodeQuadP(cVecRealtimeP,n)
%This function constructs matrix of used c's to put into sigma for analog info
%matrix for each qubit for the 4-qubit code for the p-quadrature. Note that the c's in sigma are shifted with
%respect to c's used in GKP correction because in sigma we care
%about the noise and so about the c used at the previous
%correction.

%Inputs:

%cVecRealtimeP -    Vector of rescaling coefficients for the 4-qubit code
%n -                number of GKP channels and GKP corrections before a higher level correction

%Outputs:

%CsSigChannelP -            rescaling coefficients for residual displacements for the likelihood
%                           estimation at the GKPs that correct the communication channel
%                           noise. These are rescaling coeffs for the noise
%                           and so they correspond to the rescaling
%                           coefficients for the round before
%CsSigc1P -                 rescaling coefficients for residual displacements for the likelihood
%                           estimation at the GKPs that correct the noise
%                           when the channel included the back-action from
%                           multiqubit correction and from GKP correction
%                           in the q-quadrature.
%                           These are rescaling coeffs for the noise
%                           and so they correspond to the rescaling
%                           coefficients for the round before
%CsSigc2P -                 rescaling coefficients for residual displacements for the likelihood
%                           estimation at the GKPs that correct the noise
%                           when the channel included only the back-action from GKP correction in the q-quadrature. 
%                           These are rescaling coeffs for the noise
%                           and so they correspond to the rescaling
%                           coefficients for the round before


%The name marks the type of correction at that station to determine
%number of sigGKP's that need to be included in the prob distribution
%for analog info. The assigned c's however come fro mthe previous
%correction round.
CsSigc1P = zeros(4,1);
CsSigChannelP = zeros(4,n);
CsSigc2P = zeros(4,2);

w=0;
%Firstly we have the c1 for back-action from q and multiqubit q, where the
%residual c from the last round was the end c
CsSigc1P(:,1) = cVecRealtimeP(end);

%Now we have the channel
for j=1:n
    w = w+1;
    CsSigChannelP(:,j) = cVecRealtimeP(w);
end
%Now we have the c2 correction, first the extra one and then between the two XXXX measurements
w = w+1;
CsSigc2P(:,1) = cVecRealtimeP(w);
w = w+1;
CsSigc2P(:,2) = cVecRealtimeP(w);