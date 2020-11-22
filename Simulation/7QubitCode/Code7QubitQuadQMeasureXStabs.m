function [qdeltas,qZc1, w, x] = Code7QubitQuadQMeasureXStabs(qdeltas, AncillashiftsMultiCorr, w, x, cVecRealtime124Q,cVecRealtime356Q,cVecRealtime7Q) 
%This function evolves the q-quadrature with the 7-qubit Steane code on the
%second level through a round of the X stabiliser measurements (opposite
%stabilisers to the quadrature, so no info extracted, only added noise)

%Inputs:

%qdeltas -                  input p-quadrature displacements at the
%                           beginning before the round 
%AncillashiftsMultiCorr -   random numbers for ancilla errors
%w -                        counter of the random numbers before the round
%x -                        vector of dim = 7 that counts the rescaling
%                           coeffs before the round
%cVecRealtimeQ -            vectors of rescaling coefficients for the GKP
%                           corrections. We have a separate vector for
%                           qubits (1,2,4), (3,5,6) and 7.

%Outputs:

%qdeltas -                  the values of p-quadrature at the end of the
%                           round
%qZc1 -                     The analog syndromes for the c1 corrections in
%                           between
%w -                        counter of the random numbers after the round
%x -                        vector of dim = 7 that counts the rescaling
%                           coeffs after the round


qZc1 = zeros(7,3);
%Now we want to correct the Z-errors in p quadrature using multiqubit
%correction inducing errors in q.

%Make the IIIXXXX measurement twice

%Induce error in q quadrature from the sum gate
qAncilla =  AncillashiftsMultiCorr(w);
w = w + 1;
qdeltas(4:7) = qdeltas(4:7) - qAncilla * ones(4,1);

%Intermediate GKP between stabilisers

%Apply an intermediate GKP correction in q on these qubits which we
%will use for another p stabiliser to get rid of the q errors from the
%sum gate
c = [cVecRealtime356Q(x(5)),cVecRealtime356Q(x(6)),cVecRealtime7Q(x(7))]';
[qdeltas, qZc1(:,1)] = SingleQuadratureGKPCorr(1, [5,6,7], qdeltas, AncillashiftsMultiCorr(w:w+2), 7, c);
w = w + 3;
x(5:7) = x(5:7) + ones(3,1);

%Apply an intermediate GKP correction in p on these qubits which we
%will use for another p stabiliser

qdeltas = SingleQuadratureGKPCorr(0, [5,6,7], qdeltas, AncillashiftsMultiCorr(w:w+2), 7, 0);
w = w + 3;

%Make the IXXIIXX measurement twice

%Induce error in q quadrature from the sum gate
qAncilla =  AncillashiftsMultiCorr(w);
w = w + 1;
qdeltas([2:3,6:7]) = qdeltas([2:3,6:7]) - qAncilla * ones(4,1);

%Intermediate GKP between stabilisers

%Apply an intermediate GKP correction in q on these qubits which we
%will use for the last p stabiliser to get rid of the q errors from the
%sum gate
c = [cVecRealtime356Q(x(3)),cVecRealtime7Q(x(7))]';
[qdeltas, qZc1(:,2)] = SingleQuadratureGKPCorr(1, [3,7], qdeltas, AncillashiftsMultiCorr(w:w+1), 7, c);
w = w + 2;
x([3,7]) = x([3,7]) + ones(2,1);
%Apply an intermediate GKP correction in p on these qubits which we
%will use for the final p stabiliser

qdeltas = SingleQuadratureGKPCorr(0, [3,7], qdeltas, AncillashiftsMultiCorr(w:w+1), 7, 0);
w = w + 2;   

%Make the XIXIXIX measurement twice

%Induce error in q quadrature from the sum gate
qAncilla =  AncillashiftsMultiCorr(w);
w = w + 1;
qdeltas([1,3,5,7]) = qdeltas([1,3,5,7]) - qAncilla * ones(4,1);    

%Now apply q-correction to all the qubits:
c = [cVecRealtime124Q(x(1)),cVecRealtime124Q(x(2)),cVecRealtime356Q(x(3)),cVecRealtime124Q(x(4)),cVecRealtime356Q(x(5)),cVecRealtime356Q(x(6)),cVecRealtime7Q(x(7))]';
[qdeltas, qZc1(:,3)] = SingleQuadratureGKPCorr(1, [1,2,3,4,5,6,7], qdeltas, AncillashiftsMultiCorr(w:w+6), 7, c);
x = x + ones(7,1);
w = w + 7; 