function qdeltas = Code4QubitQuadQ(qdeltas, sigChannel, sigGKP, n, AncillashiftsMultiCorr,cVecRealtimeQ, CsSigChannelQ, CsSigc1Q, CsSigc2Q) 

w = 1;
x = 1;


%Now we have an end GKP(p) correction which induces error in q:
qdeltas = SingleQuadratureGKPCorr(0, [1,2,3,4], qdeltas, AncillashiftsMultiCorr(w:w+3), 4, 0);   
w = w + 4;

%Now we have the channel with single GKP stations    
[qZmatrixCh, qdeltas, xOut] = ChannelWithGKPCorr4QubitCode(0, qdeltas, sigChannel, sigGKP, n, cVecRealtimeQ, x);
x = xOut;

%Additional GKP to replace Cchannel with c2:

c = cVecRealtimeQ(x)*ones(4,1);
[qdeltas, qZc2] = SingleQuadratureGKPCorr(1, [1,2,3,4], qdeltas, AncillashiftsMultiCorr(w:w+3), 4, c);   
w = w + 4;
x = x + 1;

qdeltas = SingleQuadratureGKPCorr(0, [1,2,3,4], qdeltas, AncillashiftsMultiCorr(w:w+3), 4, 0);   
w = w + 4;



%Now we want to correct the Z-errors in p quadrature using multiqubit
%correction inducing errors in q:

%We measure the XXXX stabiliser for Z-errors twice
%First time:
%Induce error in q quadrature from the sum gate
qAncilla =  AncillashiftsMultiCorr(w);
w = w + 1;
qdeltas = qdeltas - qAncilla * ones(4,1);

%Apply an intermediate GKP correction in q on all the qubits to get rid
%of the errors from the sum gate
c = cVecRealtimeQ(x)*ones(4,1);
[qdeltas, qZ1c1] = SingleQuadratureGKPCorr(1, [1,2,3,4], qdeltas, AncillashiftsMultiCorr(w:w+3), 4, c);
w = w + 4;
x = x + 1;
%Apply an intermediate GKP correction in p on all the qubits which we
%will use for the second round of stabiliser measurement

qdeltas = SingleQuadratureGKPCorr(0, [1,2,3,4], qdeltas, AncillashiftsMultiCorr(w:w+3), 4, 0);
w = w + 4;

%Second time:
%Induce error in q quadrature from the sum gate
qAncilla =  AncillashiftsMultiCorr(w);
w = w + 1;
qdeltas = qdeltas - qAncilla * ones(4,1);

%Apply an intermediate GKP correction in q on all qubits as they all got noise from the sum gates for XXXX measurement:
c = cVecRealtimeQ(x)*ones(4,1);
[qdeltas, qZ2c1] = SingleQuadratureGKPCorr(1, [1,2,3,4], qdeltas, AncillashiftsMultiCorr(w:w+3), 4, c);   
w = w + 4;
x = x + 1;

%Now we want to correct these X-errors in the q-quadrature using
%multiqubit correction

%Correct X errors from Z stabilisers which measure q quadrature

%Make the Z1Z2 measurement to check for X1X2 errors:
%Measured value mod sqrt(pi)
qAncilla =  AncillashiftsMultiCorr(w);
w = w + 1;
measuredZZII = ReminderMod(qdeltas(1) + qdeltas(2) + qAncilla,2*sqrt(pi));

%Make the Z3Z4 measurement to check for X3X4 errors:
%Measured value mod sqrt(pi)
qAncilla =  AncillashiftsMultiCorr(w);
w = w + 1;
measuredIIZZ = ReminderMod(qdeltas(3) + qdeltas(4) + qAncilla,2*sqrt(pi));

%Calculate array of error probabilities for each qubit at each GKP
%station

%Distributions for analog info:

%Residual error, transmission channel, back action from GKP, ancilla
%error
sigCh = sqrt(sigChannel^2 + (2 + CsSigChannelQ)*sigGKP^2);
%Residual error, back action from GKP and multi-qubit, ancilla error
sigc1 = sqrt(3 + CsSigc1Q) * sigGKP;
%Residual error, back action from GKP, ancilla error
sigc2 = sqrt(2 + CsSigc2Q) * sigGKP;

qZmatrixErrProbCh = zeros(4,n);
qZmatrixErrProbc1 = zeros(4,2);
qZmatrixErrProbc2 = zeros(4,1);
qZc1 = [qZ1c1,qZ2c1];

for i = 1:4
    qZmatrixErrProbCh(i,:) = ErrorLikelihood(qZmatrixCh(i,:), sigCh(i,:));
    qZmatrixErrProbc1(i,:) = ErrorLikelihood(qZc1(i,:), sigc1(i,:) );
    qZmatrixErrProbc2(i,:) = ErrorLikelihood(qZc2(i,:), sigc2(i,:) );
end

%Check and correct errors from the ZZII and IIZZ stabilisers

%Check the stabiliser value:
if abs(measuredZZII)< sqrt(pi)/2
    parityZZII = 0;
else
    parityZZII = 1;
end


%Correct the error on the qubit with largest error probability from
%analog info.
if parityZZII == 1
    %Assume single qubit error on qubit 1 or 2. We calculate the
    %log of the probability that there was no logical error
    %in this elementary chain for each qubit wchich is equivalent
    %to the probability that there was an even number of errors which
    %is given by:
    %(1 + (1-2p1)(1-2p2)...)/2
    %Then we take the qubit for which this value is the smallest.
    %This is equivalent to finding the qubit for which
    %(1-2p1)(1-2p2)... is the smallest. We calculate the log2 of this
    %expression.
    [~,minSuccQubit_I] = min(sum(log2(ones(2,n) - 2*qZmatrixErrProbCh(1:2,:)),2) + sum(log2(ones(2,2) - 2*qZmatrixErrProbc1(1:2,:)),2) + log2(ones(2,1) - 2*qZmatrixErrProbc2(1:2,:)));
    qdeltas(minSuccQubit_I) = qdeltas(minSuccQubit_I) - sqrt(pi);
end


%Check the stabiliser value:
if abs(measuredIIZZ)< sqrt(pi)/2
    parityIIZZ = 0;
else
    parityIIZZ = 1;
end
%Correct the error on the qubit with larger |z| (closer to the
%boundary)
if parityIIZZ == 1
    %Assume single qubit error on qubit 3 or 4. We calculate the
    %log of the probability that there was no logical error
    %in this elementary chain for each qubit wchich is equivalent
    %to the probability that there was an even number of errors which
    %is given by:
    %(1 + (1-2p1)(1-2p2)...)/2
    %Then we take the qubit for which this value is the smallest.
    %This is equivalent to finding the qubit for which
    %(1-2p1)(1-2p2)... is the smallest. We calculate the log2 of this
    %expression.
    [~,minSuccQubit_I] = min(sum(log2(ones(2,n) - 2*qZmatrixErrProbCh(3:4,:)),2) + sum(log2(ones(2,2) - 2*qZmatrixErrProbc1(3:4,:)),2) + log2(ones(2,1) - 2*qZmatrixErrProbc2(3:4,:)));
    qdeltas(2+minSuccQubit_I) = qdeltas(2+minSuccQubit_I) - sqrt(pi);
end