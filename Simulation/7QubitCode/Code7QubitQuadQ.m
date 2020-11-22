function qdeltas = Code7QubitQuadQ(qdeltas, sigChannel, sigGKP, n, tableSingleErr, tableDoubleErr, AncillashiftsMultiCorr, cVecRealtime124Q,cVecRealtime356Q,cVecRealtime7Q, CsSigChannelQ, CsSigc1Q, CsSigc2Q) 
%This function evolves the q-quadrature for the 7-qubit Steane code on the
%second level using the method of repeating the measurement of all stabilisers in 2 rounds
%with extra GKP corrections before the second level syndrome measurements 
%to reduce the residual noise on the data qubits before the multi-qubit
%correction.
%The function runs one elementary link between two multi-qubit repeaters

%Inputs:

%qdeltas -                  input q-quadrature displacements at the
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
%cVecRealtimeQ -            vectors of rescaling coefficients for the GKP
%                           corrections. We have a separate vector for
%                           qubits (1,2,4), (3,5,6) and 7.
%CsSigChannelQ -            rescaling coefficients for residual displacements for the likelihood
%                           estimation at the GKPs that correct the communication channel
%                           noise. These are rescaling coeffs for the noise
%                           and so they correspond to the rescaling
%                           coefficients for the round before
%CsSigc1Q -                 rescaling coefficients for residual displacements for the likelihood
%                           estimation at the GKPs that correct the noise
%                           when the channel included the back-action from
%                           multiqubit correction and from GKP correction
%                           in the p-quadrature. Since some qubits are
%                           measured differnet number of times than others,
%                           for a round in which a given qubit is not
%                           measured the value is set to 0. This matches
%                           the measured analog syndrome of 0 for these
%                           rounds. These are rescaling coeffs for the noise
%                           and so they correspond to the rescaling
%                           coefficients for the round before
%CsSigc2Q -                 rescaling coefficients for residual displacements for the likelihood
%                           estimation at the GKPs that correct the noise
%                           when the channel included only the back-action from GKP correction in the p-quadrature. 
%                           Since some qubits are
%                           measured different number of times than others,
%                           for a round in which a given qubit is not
%                           measured the value is set to 0. This matches
%                           the measured analog syndrome of 0 for these
%                           rounds. These are rescaling coeffs for the noise
%                           and so they correspond to the rescaling
%                           coefficients for the round before

%Outputs:

%qdeltas -                  the values of q-qaudrature at the end of the
%                           cycle
%             

w = 1; %Counter of random numbers
x = ones(7,1); %Counter of rescaling coeffs c

%First we have the end GKP(p) correction which induces error in q:
qdeltas = SingleQuadratureGKPCorr(0, [1,2,3,4,5,6,7], qdeltas, AncillashiftsMultiCorr(w:w+6), 7, 0);   
w = w + 7;

%Now the channel with single GKP stations:
[qZmatrixCh, qdeltas, x] = ChannelWithGKPCorr7QubitCode(0, qdeltas, sigChannel, sigGKP, n, cVecRealtime124Q,cVecRealtime356Q,cVecRealtime7Q,x);

%Now the extra GKP corrections in both q and p to remove cChannel from
%p.
c = [cVecRealtime124Q(x(1)),cVecRealtime124Q(x(2)),cVecRealtime356Q(x(3)),cVecRealtime124Q(x(4)),cVecRealtime356Q(x(5)),cVecRealtime356Q(x(6)),cVecRealtime7Q(x(7))]';
[qdeltas,qZc2ExtraGKP1] = SingleQuadratureGKPCorr(1, [1,2,3,4,5,6,7], qdeltas, AncillashiftsMultiCorr(w:w+6), 7, c);   
w = w + 7;
x = x + ones(7,1);

qdeltas = SingleQuadratureGKPCorr(0, [1,2,3,4,5,6,7], qdeltas, AncillashiftsMultiCorr(w:w+6), 7, 0);
w = w + 7;

%Now the two rounds of measuring the X stabilisers
%First round
[qdeltas,qZc1FirstTime, w, x] = Code7QubitQuadQMeasureXStabs(qdeltas, AncillashiftsMultiCorr, w, x, cVecRealtime124Q,cVecRealtime356Q,cVecRealtime7Q); 

%Now we have the refreshing GKP(p) correction which induces error in q:
qdeltas = SingleQuadratureGKPCorr(0, [1,2,3,4,5,6,7], qdeltas, AncillashiftsMultiCorr(w:w+6), 7, 0);   
w = w + 7;

%Second round
[qdeltas,qZc1SecondTime, w, x] = Code7QubitQuadQMeasureXStabs(qdeltas, AncillashiftsMultiCorr, w, x, cVecRealtime124Q,cVecRealtime356Q,cVecRealtime7Q); 

%Now the extra GKP corrections in both p and q to remove c1 from
%q and replace it with c2
qdeltas = SingleQuadratureGKPCorr(0, [1,2,3,4,5,6,7], qdeltas, AncillashiftsMultiCorr(w:w+6), 7, 0);
w = w + 7;

c = [cVecRealtime124Q(x(1)),cVecRealtime124Q(x(2)),cVecRealtime356Q(x(3)),cVecRealtime124Q(x(4)),cVecRealtime356Q(x(5)),cVecRealtime356Q(x(6)),cVecRealtime7Q(x(7))]';
[qdeltas,qZc2ExtraGKP2] = SingleQuadratureGKPCorr(1, [1,2,3,4,5,6,7], qdeltas, AncillashiftsMultiCorr(w:w+6), 7, c);   
w = w + 7;
x = x + ones(7,1);

%Now we want to correct these X-errors in the q-quadrature using
%multiqubit correction:    

%First round
[qdeltas,qZc2FirstTime, measuredIIIZZZZ1, measuredIZZIIZZ1, measuredZIZIZIZ1, cIIIZZZZ1, cIZZIIZZ1, cZIZIZIZ1, w, x] = Code7QubitQuadQMeasureZStabs(qdeltas, AncillashiftsMultiCorr, w, x, cVecRealtime124Q,cVecRealtime356Q,cVecRealtime7Q); 

%Intermediate refreshing
qdeltas = SingleQuadratureGKPCorr(0, [1,2,3,4,5,6,7], qdeltas, AncillashiftsMultiCorr(w:w+6), 7, 0);   
w = w + 7;

c = [cVecRealtime124Q(x(1)),cVecRealtime124Q(x(2)),cVecRealtime356Q(x(3)),cVecRealtime124Q(x(4)),cVecRealtime356Q(x(5)),cVecRealtime356Q(x(6)),cVecRealtime7Q(x(7))]';
[qdeltas, qZc2Intermediate] = SingleQuadratureGKPCorr(1, [1,2,3,4,5,6,7], qdeltas, AncillashiftsMultiCorr(w:w+6), 7, c);
w = w + 7;
x = x + ones(7,1);

%Second round
[qdeltas,qZc2SecondTime, measuredIIIZZZZ2, measuredIZZIIZZ2, measuredZIZIZIZ2, cIIIZZZZ2, cIZZIIZZ2, cZIZIZIZ2, w, x] = Code7QubitQuadQMeasureZStabs(qdeltas, AncillashiftsMultiCorr, w, x, cVecRealtime124Q,cVecRealtime356Q,cVecRealtime7Q); 

%Do majority voting using analog information
%2 rows correspond to the 2 times we measure the syndrome.
%4 columns correspond to 4 c factors for residual displacements on the
%4 participating qubits
%For each syndrome if the two rounds of syndrome measurement are different
%we consider 3 error posibilites, either an error measurement in one of the
%two rounds or an error during the intermediate GKP correction. We look for
%the most likely scenario.

qZmatrixc2Between = [qZc2FirstTime,qZc2Intermediate,qZc2SecondTime];
%IIIZZZZ
cVec = [cIIIZZZZ1; cIIIZZZZ2];
measuredIIIZZZZ = [measuredIIIZZZZ1,measuredIIIZZZZ2];
[parityIIIZZZZ, QubitWithErrorIIIZZZZ, perrorGKPCorrMaxIIIZZZZ] = VoteMultiMeas(measuredIIIZZZZ, sigGKP,cVec, qZmatrixc2Between, [4,5,6,7], CsSigc2Q, 1);


%IZZIIZZ
cVec = [cIZZIIZZ1; cIZZIIZZ2];
measuredIZZIIZZ = [measuredIZZIIZZ1,measuredIZZIIZZ2];
[parityIZZIIZZ, QubitWithErrorIZZIIZZ, perrorGKPCorrMaxIZZIIZZ] = VoteMultiMeas(measuredIZZIIZZ, sigGKP, cVec, qZmatrixc2Between, [2,3,6,7], CsSigc2Q, 2);   


%ZIZIZIZ
cVec = [cZIZIZIZ1; cZIZIZIZ2];
measuredZIZIZIZ = [measuredZIZIZIZ1,measuredZIZIZIZ2];
[parityZIZIZIZ, QubitWithErrorZIZIZIZ, perrorGKPCorrMaxZIZIZIZ] = VoteMultiMeas(measuredZIZIZIZ, sigGKP, cVec, qZmatrixc2Between, [1,3,5,7], CsSigc2Q, 3);


parityVectorXerr = [parityIIIZZZZ, parityIZZIIZZ, parityZIZIZIZ];
QubitWithErrorVector = [QubitWithErrorIIIZZZZ, QubitWithErrorIZZIIZZ, QubitWithErrorZIZIZIZ];
perrorGKPCorrMaxVector = [perrorGKPCorrMaxIIIZZZZ, perrorGKPCorrMaxIZZIIZZ, perrorGKPCorrMaxZIZIZIZ];

%If we think there was an intermediate GKP error we look for the most
%likely error location and adjust the stabilisers accordingly to include
%the effect of that error.
parityVectorXerr = CorrectMultiQubitParity(parityVectorXerr, QubitWithErrorVector, perrorGKPCorrMaxVector);

%If we got a logical error we will not detect it, so we only proceed if the parity check signals an error: 
if any(parityVectorXerr)
    
    %Establish possible errors consistent with the parity vector
    error_matrix_x = SyndromeToErrors(parityVectorXerr, tableSingleErr, tableDoubleErr, 7);

    matrix_size = size(error_matrix_x);
    num_errs = matrix_size(1);

    %Establish the error distributions for analog info
    ErrProb = zeros(1,num_errs);
    qZmatrixc1 = [qZc1FirstTime, qZc1SecondTime];
    qZmatrixc2 = [qZc2ExtraGKP1, qZc2ExtraGKP2, qZc2FirstTime,qZc2Intermediate,qZc2SecondTime];
    %Residual error, transmission channel, back action from GKP, ancilla
    %error
    sigCh = sqrt(sigChannel^2 + (2 +CsSigChannelQ)*sigGKP^2);
    %Residual error, back action from GKP and multi-qubit, ancilla error
    sigc1 = sqrt(3 + CsSigc1Q) * sigGKP;
    %Residual error, back action from GKP, ancilla error
    sigc2 = sqrt(2 + CsSigc2Q) * sigGKP;

    %Calculate the error probability for each error configuration    
    for k = 1:num_errs
        ErrProb(1,k) = JointErrorLikelihood(error_matrix_x(k,:), qZmatrixCh, sigCh, qZmatrixc1, sigc1, qZmatrixc2, sigc2);
    end

    %Calculate the most probable error index
    [~,indmax] = max(ErrProb); 

    %Correct those errors
    qdeltas = qdeltas - sqrt(pi) * transpose(error_matrix_x(indmax,:));
end