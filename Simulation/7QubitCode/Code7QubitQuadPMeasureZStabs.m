function [pdeltas, pZc1, w, x] = Code7QubitQuadPMeasureZStabs(pdeltas, AncillashiftsMultiCorr, w, x, cVecRealtime124P,cVecRealtime356P,cVecRealtime7P) 
%This function evolves the p-quadrature with the 7-qubit Steane code on the
%second level through a round of the Z stabiliser measurements (opposite
%stabilisers to the quadrature, so no info extracted, only added noise)

%Inputs:

%pdeltas -                  input p-quadrature displacements at the
%                           beginning before the round 
%AncillashiftsMultiCorr -   random numbers for ancilla errors
%w -                        counter of the random numbers before the round
%x -                        vector of dim = 7 that counts the rescaling
%                           coeffs before the round
%cVecRealtimeP -            vectors of rescaling coefficients for the GKP
%                           corrections. We have a separate vector for
%                           qubits (1,2,4), (3,5,6) and 7.

%Outputs:

%pdeltas -                  the values of p-quadrature at the end of the
%                           round
%pZc1 -                     The analog syndromes for the c1 corrections in
%                           between
%w -                        counter of the random numbers after the round
%x -                        vector of dim = 7 that counts the rescaling
%                           coeffs after the round

pZc1 = zeros(7,3);

%Now we have intermediate GKP(q) correction which induces error in p:
pdeltas = SingleQuadratureGKPCorr(0, [1,2,3,4,5,6,7], pdeltas, AncillashiftsMultiCorr(w:w+6), 7, 0);   
w = w + 7;

%Now we want to correct the X-errors in q quadrature using multiqubit
%correction inducing errors in p. After each multiqubit syndrome
%measurement we place first GKP(p) then GKP(q) station on the qubits
%that will be used for another syndrome measurement.

%Make the IIIZZZZ measurement:

%Induce error in p quadrature from the sum gate
pAncilla =  AncillashiftsMultiCorr(w);
w = w + 1;
pdeltas(4:7) = pdeltas(4:7) - pAncilla * ones(4,1);

%Intermediate GKP between stabilisers

%Apply an intermediate GKP correction in p on these qubits which we
%will use for another q stabiliser to get rid of the p errors from the
%sum gate
c = [cVecRealtime356P(x(5)),cVecRealtime356P(x(6)),cVecRealtime7P(x(7))]';
[pdeltas,pZc1(:,1)] = SingleQuadratureGKPCorr(1, [5,6,7], pdeltas, AncillashiftsMultiCorr(w:w+2), 7, c);
w = w + 3;
x(5:7) = x(5:7) + ones(3,1);

%Apply an intermediate GKP correction in q on these qubits which we
%will use for another q stabiliser

pdeltas = SingleQuadratureGKPCorr(0, [5,6,7], pdeltas, AncillashiftsMultiCorr(w:w+2), 7, 0);
w = w + 3;

%Make the IZZIIZZ measurement
%Induce error in p quadrature from the sum gate
pAncilla =  AncillashiftsMultiCorr(w);
w = w + 1;
pdeltas([2:3,6:7]) = pdeltas([2:3,6:7]) - pAncilla * ones(4,1);

%Intermediate GKP between stabilisers

%Apply an intermediate GKP correction in p on these qubits which we
%will use for the last q stabiliser to get rid of the p errors from the
%sum gate
c = [cVecRealtime356P(x(3)),cVecRealtime7P(x(7))]';
[pdeltas,pZc1(:,2)] = SingleQuadratureGKPCorr(1, [3,7], pdeltas, AncillashiftsMultiCorr(w:w+1), 7, c);
w = w + 2;
x([3,7]) = x([3,7]) + ones(2,1);
%Apply an intermediate GKP correction in q on these qubits which we
%will use for the final q stabiliser

pdeltas = SingleQuadratureGKPCorr(0, [3,7], pdeltas, AncillashiftsMultiCorr(w:w+1), 7, 0);
w = w + 2;


%Make the ZIZIZIZ measurement

%Induce error in p quadrature from the sum gate
pAncilla =  AncillashiftsMultiCorr(w);
w = w + 1;
pdeltas([1,3,5,7]) = pdeltas([1,3,5,7]) - pAncilla * ones(4,1);

%Now apply p-correction to all the qubits:
c = [cVecRealtime124P(x(1)),cVecRealtime124P(x(2)),cVecRealtime356P(x(3)),cVecRealtime124P(x(4)),cVecRealtime356P(x(5)),cVecRealtime356P(x(6)),cVecRealtime7P(x(7))]';
[pdeltas,pZc1(:,3)] = SingleQuadratureGKPCorr(1, [1,2,3,4,5,6,7], pdeltas, AncillashiftsMultiCorr(w:w+6), 7, c);
w = w + 7;
x = x + ones(7,1);