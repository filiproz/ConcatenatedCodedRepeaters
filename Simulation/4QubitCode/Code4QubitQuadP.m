function pdeltas = Code4QubitQuadP(pdeltas, sigChannel, sigGKP, n, AncillashiftsMultiCorr,cVecRealtimeP, CsSigChannelP, CsSigc1P, CsSigc2P) 

w = 1;
x = 1;

%Now we have intermediate GKP(q) correction which induces error in p:
pdeltas = SingleQuadratureGKPCorr(0, [1,2,3,4], pdeltas, AncillashiftsMultiCorr(w:w+3), 4, 0);   
w = w + 4;


%Now we want to correct the X-errors in q quadrature using multiqubit
%correction inducing errors in p.

%Make the Z1Z2 measurement to check for X1X2 errors:
%Induce error in p quadrature from the sum gate
pAncilla =  AncillashiftsMultiCorr(w);
w = w+1;
pdeltas(1:2) = pdeltas(1:2) - pAncilla * ones(2,1);
%Make the Z3Z4 measurement to check for X3X4 errors:
%Induce error in p quadrature from the sum gate
pAncilla =  AncillashiftsMultiCorr(w);
w = w+1;
pdeltas(3:4) = pdeltas(3:4) - pAncilla * ones(2,1);


%Now we have an end GKP(p) correction:
c = cVecRealtimeP(x)*ones(4,1);
[pdeltas, pZc1] = SingleQuadratureGKPCorr(1, [1,2,3,4], pdeltas, AncillashiftsMultiCorr(w:w+3), 4, c);   
w = w + 4;
x = x + 1;

%Now we have the channel with single GKP stations    
[pZmatrixCh, pdeltas, xOut] = ChannelWithGKPCorr4QubitCode(1, pdeltas, sigChannel, sigGKP, n, cVecRealtimeP, x);
x = xOut;

%Additional GKP to replace Cchannel with c2:

pdeltas = SingleQuadratureGKPCorr(0, [1,2,3,4], pdeltas, AncillashiftsMultiCorr(w:w+3), 4, 0);   
w = w + 4;

c = cVecRealtimeP(x)*ones(4,1);
[pdeltas, pZ1c2] = SingleQuadratureGKPCorr(1, [1,2,3,4], pdeltas, AncillashiftsMultiCorr(w:w+3), 4, c);   
w = w + 4;
x = x + 1;

%Now we want to correct these Z-errors in the p-quadrature using
%multiqubit correction:    

%Correct Z errors from X stabilisers which measure p quadrature

%Make the X1X2X3X4 measurement to check for Z1Z2Z3Z4 errors, do it
%twice.

%First time
pAncilla =  AncillashiftsMultiCorr(w);
w = w+1;
measuredXXXX1 = ReminderMod(sum(pdeltas) + pAncilla, 2*sqrt(pi));

%Apply an intermediate GKP correction in q on all the qubits to get rid
%of the errors from the sum gate

pdeltas = SingleQuadratureGKPCorr(0, [1,2,3,4], pdeltas, AncillashiftsMultiCorr(w:w+3), 4, 0);
w = w + 4;
%Apply an intermediate GKP correction in p on all the qubits which we
%will use for the second round of stabiliser measurement
c = cVecRealtimeP(x)*ones(4,1);
[pdeltas, pZ2c2] = SingleQuadratureGKPCorr(1, [1,2,3,4], pdeltas, AncillashiftsMultiCorr(w:w+3), 4, c);
w = w + 4;
x = x + 1;

%Second time
pAncilla =  AncillashiftsMultiCorr(w);
w = w+1;
measuredXXXX2 = ReminderMod(sum(pdeltas) + pAncilla, 2*sqrt(pi));

%Do majority voting using analog information
%2 rows correspond to the 2 tiems we measure the syndrome.
%4 columns correspond to 4 c factors for residual displacements on the
%4 participating qubits
%The c we had on the first measurement was the c of the additional GKP
%correction used to replace cChannel with c2. That c had an index
%xOut, since the Channel function incremented the index after its last
%correction.  
cFirstTime = cVecRealtimeP(xOut)*ones(1,4);
%The second time it was just the variable that is now called c
cSecondTime = c';
cMat = [cFirstTime; cSecondTime];
measuredXXXX = [measuredXXXX1,measuredXXXX2];
parityXXXX = VoteMultiMeas(measuredXXXX, sigGKP, cMat, pZ2c2, CsSigc2P);

if parityXXXX == 1

    %Calculate array of error probabilities for each qubit at each GKP
    %station
    
    %Distributions for analog info:
    %Residual error, transmission channel, back action from GKP, ancilla
    %error
    sigCh = sqrt(sigChannel^2 + (2 + CsSigChannelP)*sigGKP^2);
    %Residual error, back action from GKP and multi-qubit, ancilla error
    sigc1 = sqrt(3 + CsSigc1P) * sigGKP;
    %Residual error, back action from GKP, ancilla error
    sigc2 = sqrt(2 + CsSigc2P) * sigGKP;

    pZmatrixErrProbCh = zeros(4,n);
    pZmatrixErrProbc1 = zeros(4,1);
    pZmatrixErrProbc2 = zeros(4,2);
    pZc2 = [pZ1c2,pZ2c2];

    for i = 1:4
        pZmatrixErrProbCh(i,:) = ErrorLikelihood(pZmatrixCh(i,:), sigCh(i,:));
        pZmatrixErrProbc1(i,:) = ErrorLikelihood(pZc1(i,:), sigc1(i,:) );
        pZmatrixErrProbc2(i,:) = ErrorLikelihood(pZc2(i,:), sigc2(i,:) );
    end

    %Assume single qubit error on qubit 1 or 2 or 3 or 4. We calculate the
    %log of the probability that there was no logical error
    %in this elementary chain for each qubit wchich is equivalent
    %to the probability that there was an even number of errors which
    %is given by:
    %(1 + (1-2p1)(1-2p2)...)/2
    %Then we take the qubit for which this value is the smallest.
    %This is equivalent to finding the qubit for which
    %(1-2p1)(1-2p2)... is the smallest. We calculate the log2 of this
    %expression.
    [~,minSuccQubit_I] = min(sum(log2(ones(4,n) - 2*pZmatrixErrProbCh),2) + log2(ones(4,1) - 2*pZmatrixErrProbc1) + sum(log2(ones(4,2) - 2*pZmatrixErrProbc2),2));
    %Flip the Z value of that qubit by applying sqrt(pi) shift in p
    %quadrature

    pdeltas(minSuccQubit_I) = pdeltas(minSuccQubit_I) - sqrt(pi);
end