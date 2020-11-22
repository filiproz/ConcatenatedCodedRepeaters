function pdeltas = Code7QubitQuadP(pdeltas, sigChannel, sigGKP, n, tableSingleErr, tableDoubleErr, AncillashiftsMultiCorr,cVecRealtime124P,cVecRealtime356P,cVecRealtime7P, CsSigChannelP, CsSigc1P, CsSigc2P) 
%This function evolves the p-quadrature for the 7-qubit Steane code on the
%second level using the method of repeating the measurement of all stabilisers in 2 rounds
%with extra GKP corrections before the second level syndrome measurements 
%to reduce the residual noise on the data qubits before the multi-qubit
%correction.
%The function runs one elementary link between two multi-qubit repeaters

%Inputs:

%pdeltas -                  input p-quadrature displacements at the
%                           beginning before the link 
%sigChannel -               standard deviation caused by the Gaussian displacement
%                           channel coming from amplification followed by transmission
%                           through a pure loss channel
%sigGKP -                   standard deviation of an ancilla GKP
%n -                        number of GKP channels and GKP corrections before a higher level correction
%tableSingleErr -           error look up table for the Steane code for single
%                           errors
%tableDoubleErr -           error look up table for the Steane code for two-qubit
%                           errors
%AncillashiftsMultiCorr -   random numbers for ancilla errors
%cVecRealtimeP -            vectors of rescaling coefficients for the GKP
%                           corrections. We have a separate vector for
%                           qubits (1,2,4), (3,5,6) and 7.
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
%                           Since some qubits are
%                           measured different number of times than others,
%                           for a round in which a given qubit is not
%                           measured the value is set to 0. This matches
%                           the measured analog syndrome of 0 for these
%                           rounds. 
%                           These are rescaling coeffs for the noise
%                           and so they correspond to the rescaling
%                           coefficients for the round before
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
%                           and so they correspond to the rescaling
%                           coefficients for the round before

%Outputs:

%pdeltas -                  the values of p-quadrature at the end of the
%                           cycle


w = 1; %Counter of random numbers
x = ones(7,1); %Counter of rescaling coeffs c


%Firstly the correction in q after all the multiqubit-p measurements
pdeltas = SingleQuadratureGKPCorr(0, [1,2,3,4,5,6,7], pdeltas, AncillashiftsMultiCorr(w:w+6), 7, 0);
w = w + 7;

%Now the extra GKP in p
c = [cVecRealtime124P(x(1)),cVecRealtime124P(x(2)),cVecRealtime356P(x(3)),cVecRealtime124P(x(4)),cVecRealtime356P(x(5)),cVecRealtime356P(x(6)),cVecRealtime7P(x(7))]';
[pdeltas,pZc2ExtraGKP1] = SingleQuadratureGKPCorr(1, [1,2,3,4,5,6,7], pdeltas, AncillashiftsMultiCorr(w:w+6), 7, c);   
w = w + 7;
x = x + ones(7,1);

%Now the two rounds of measuring the Z stabilisers
[pdeltas, pZc1FirstTime, w, x] = Code7QubitQuadPMeasureZStabs(pdeltas, AncillashiftsMultiCorr, w, x, cVecRealtime124P,cVecRealtime356P,cVecRealtime7P);
[pdeltas, pZc1SecondTime, w, x] = Code7QubitQuadPMeasureZStabs(pdeltas, AncillashiftsMultiCorr, w, x, cVecRealtime124P,cVecRealtime356P,cVecRealtime7P); 

%Now the channel with single GKP stations:
[pZmatrixCh, pdeltas, x] = ChannelWithGKPCorr7QubitCode(1, pdeltas, sigChannel, sigGKP, n, cVecRealtime124P,cVecRealtime356P,cVecRealtime7P,x);

%Now the extra GKP corrections in both q and p to remove cChannel from
%p.
pdeltas = SingleQuadratureGKPCorr(0, [1,2,3,4,5,6,7], pdeltas, AncillashiftsMultiCorr(w:w+6), 7, 0);   
w = w + 7;

c = [cVecRealtime124P(x(1)),cVecRealtime124P(x(2)),cVecRealtime356P(x(3)),cVecRealtime124P(x(4)),cVecRealtime356P(x(5)),cVecRealtime356P(x(6)),cVecRealtime7P(x(7))]';
[pdeltas,pZc2ExtraGKP2] = SingleQuadratureGKPCorr(1, [1,2,3,4,5,6,7], pdeltas, AncillashiftsMultiCorr(w:w+6), 7, c);
w = w + 7;
x = x + ones(7,1);

%Now we want to correct these Z-errors in the p-quadrature using
%multiqubit correction:    

%First round
[pdeltas, pZc2FirstTime, measuredIIIXXXX1, measuredIXXIIXX1, measuredXIXIXIX1, cIIIXXXX1, cIXXIIXX1, cXIXIXIX1, w, x] = Code7QubitQuadPMeasureXStabs(pdeltas, AncillashiftsMultiCorr, w, x, cVecRealtime124P,cVecRealtime356P,cVecRealtime7P); 

%Now we apply intermediate GKP(q) correction to refresh the qubits which induces error in p:
pdeltas = SingleQuadratureGKPCorr(0, [1,2,3,4,5,6,7], pdeltas, AncillashiftsMultiCorr(w:w+6), 7, 0);   
w = w + 7;

%Now we apply intermediate GKP(p) correction to refresh the qubits before the second round:
c = [cVecRealtime124P(x(1)),cVecRealtime124P(x(2)),cVecRealtime356P(x(3)),cVecRealtime124P(x(4)),cVecRealtime356P(x(5)),cVecRealtime356P(x(6)),cVecRealtime7P(x(7))]';
[pdeltas,pZc2Intermediate] = SingleQuadratureGKPCorr(1, [1,2,3,4,5,6,7], pdeltas, AncillashiftsMultiCorr(w:w+6), 7, c);
w = w + 7;
x = x + ones(7,1);

%Second round
[pdeltas, pZc2SecondTime, measuredIIIXXXX2, measuredIXXIIXX2, measuredXIXIXIX2, cIIIXXXX2, cIXXIIXX2, cXIXIXIX2, w, x] = Code7QubitQuadPMeasureXStabs(pdeltas, AncillashiftsMultiCorr, w, x, cVecRealtime124P,cVecRealtime356P,cVecRealtime7P); 

%Do majority voting using analog information
%2 rows correspond to the 2 times we measure the syndrome.
%4 columns correspond to 4 c factors for residual displacements on the
%4 participating qubits
%For each syndrome if the two rounds of syndrome measurement are different
%we consider 3 error posibilites, either an error measurement in one of the
%two rounds or an error during the intermediate GKP correction. We look for
%the most likely scenario.


pZmatrixc2Between = [pZc2FirstTime,pZc2Intermediate,pZc2SecondTime];
%IIIXXXX
cVec = [cIIIXXXX1; cIIIXXXX2];
measuredIIIXXXX = [measuredIIIXXXX1,measuredIIIXXXX2];
[parityIIIXXXX, QubitWithErrorIIIXXXX, perrorGKPCorrMaxIIIXXXX] = VoteMultiMeas(measuredIIIXXXX, sigGKP,cVec, pZmatrixc2Between, [4,5,6,7], CsSigc2P, 1);

%IXXIIXX
cVec = [cIXXIIXX1; cIXXIIXX2];
measuredIXXIIXX = [measuredIXXIIXX1,measuredIXXIIXX2];
[parityIXXIIXX, QubitWithErrorIXXIIXX, perrorGKPCorrMaxIXXIIXX] = VoteMultiMeas(measuredIXXIIXX, sigGKP, cVec, pZmatrixc2Between, [2,3,6,7], CsSigc2P, 2);

%XIXIXIX
cVec = [cXIXIXIX1; cXIXIXIX2];
measuredXIXIXIX = [measuredXIXIXIX1,measuredXIXIXIX2];
[parityXIXIXIX, QubitWithErrorXIXIXIX, perrorGKPCorrMaxXIXIXIX] = VoteMultiMeas(measuredXIXIXIX, sigGKP, cVec, pZmatrixc2Between, [1,3,5,7], CsSigc2P, 3);

parityVectorZerr = [parityIIIXXXX, parityIXXIIXX, parityXIXIXIX];
QubitWithErrorVector = [QubitWithErrorIIIXXXX, QubitWithErrorIXXIIXX, QubitWithErrorXIXIXIX];
perrorGKPCorrMaxVector = [perrorGKPCorrMaxIIIXXXX, perrorGKPCorrMaxIXXIIXX, perrorGKPCorrMaxXIXIXIX];

%If we think there was an intermediate GKP error we look for the most
%likely error location and adjust the stabilisers accordingly to include
%the effect of that error.
parityVectorZerr = CorrectMultiQubitParity(parityVectorZerr, QubitWithErrorVector, perrorGKPCorrMaxVector);

%If we got a logical error we will not detect it, so we only proceed if the parity check signals an error: 
if any(parityVectorZerr)
    
    %Establish possible errors consistent with the parity vector
    error_matrix_z = SyndromeToErrors(parityVectorZerr, tableSingleErr, tableDoubleErr, 7);

    matrix_size = size(error_matrix_z);
    num_errs = matrix_size(1);

    %Establish the error distributions for analog info
    ErrProb = zeros(1,num_errs);
    pZmatrixc1 = [pZc1FirstTime,pZc1SecondTime];
    pZmatrixc2 = [pZc2ExtraGKP1, pZc2ExtraGKP2, pZc2FirstTime,pZc2Intermediate,pZc2SecondTime];
    %Residual error, transmission channel, back action from GKP, ancilla
    %error
    sigCh = sqrt(sigChannel^2 + (2 + CsSigChannelP)*sigGKP^2);
    %Residual error, back action from GKP and multi-qubit, ancilla error
    sigc1 = sqrt(3 + CsSigc1P) * sigGKP;
    %Residual error, back action from GKP, ancilla error
    sigc2 = sqrt(2 + CsSigc2P) * sigGKP;
    
    %Calculate the error probability for each error configuration
    for k = 1:num_errs
        ErrProb(1,k) = JointErrorLikelihood(error_matrix_z(k,:), pZmatrixCh, sigCh, pZmatrixc1, sigc1, pZmatrixc2, sigc2);
    end

    %Calculate the most probable error index
    [~,indmax] = max(ErrProb); 

    %Correct those errors
    pdeltas = pdeltas - sqrt(pi) * transpose(error_matrix_z(indmax,:));
end