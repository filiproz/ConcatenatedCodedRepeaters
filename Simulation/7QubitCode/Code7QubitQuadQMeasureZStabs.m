function [qdeltas, qZc2, measuredIIIZZZZ, measuredIZZIIZZ, measuredZIZIZIZ, cIIIZZZZ, cIZZIIZZ, cZIZIZIZ, w, x] = Code7QubitQuadQMeasureZStabs(qdeltas, AncillashiftsMultiCorr, w, x, cVecRealtime124Q,cVecRealtime356Q,cVecRealtime7Q) 
%This function evolves the p-quadrature with the 7-qubit Steane code on the
%second level through a round of the X stabiliser measurements

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
%
%Outputs:

%qdeltas -                  the values of p-quadrature at the end of the
%                           round
%qZc2 -                     The analog syndromes for the c2 corrections in
%                           between
%measured -                 the analog continuous values of the 3 X stabiliser
%                           measurement outcomes
%c -                        the extracted rescaling coefficients that were
%                           used directly before the multi-qubit syndrome
%                           measurements and hence will be used in majority
%                           voting to establish the final discrete
%                           multi-qubit syndromes
%w -                        counter of the random numbers after the round
%x -                        vector of dim = 7 that counts the rescaling
%                           coeffs after the round


qZc2 = zeros(7,2);
%Correct X errors from Z stabilisers which measure q quadrature

%Make the IIIZZZZ measurement
%The c's used in the GKP correction before this multi-qubit measurement
cIIIZZZZ = [cVecRealtime124Q(x(4)-1), cVecRealtime356Q(x(5)-1),cVecRealtime356Q(x(6)-1),cVecRealtime7Q(x(7)-1)];
%Measure the ancilla:
qAncilla =  AncillashiftsMultiCorr(w);
w = w + 1;
measuredIIIZZZZ = ReminderMod(sum(qdeltas(4:7)) + qAncilla, 2*sqrt(pi));

%Intermediate GKP between stabilisers

%Apply an intermediate GKP correction in p on these qubits which we
%will use for another q stabiliser to get rid of the p errors from the
%sum gate

qdeltas = SingleQuadratureGKPCorr(0, [5,6,7], qdeltas, AncillashiftsMultiCorr(w:w+2), 7, 0);
w = w + 3;


%Apply an intermediate GKP correction in q on these qubits which we
%will use for another q stabiliser
c = [cVecRealtime356Q(x(5)),cVecRealtime356Q(x(6)),cVecRealtime7Q(x(7))]';
[qdeltas,qZc2(:,1)] = SingleQuadratureGKPCorr(1, [5,6,7], qdeltas, AncillashiftsMultiCorr(w:w+2), 7, c);
w = w + 3;
x(5:7) = x(5:7) + ones(3,1);

%Make the IZZIIZZ measurement
%The c's used in the GKP correction before this multi-qubit measurement
cIZZIIZZ = [cVecRealtime124Q(x(2)-1), cVecRealtime356Q(x(3)-1), cVecRealtime356Q(x(6)-1),cVecRealtime7Q(x(7)-1)];
%Measure the ancilla:
qAncilla =  AncillashiftsMultiCorr(w);
w = w + 1;
measuredIZZIIZZ = ReminderMod(sum(qdeltas([2:3,6:7])) + qAncilla, 2*sqrt(pi));

%Intermediate GKP between stabilisers

%Apply an intermediate GKP correction in p on these qubits which we
%will use for the last q stabiliser to get rid of the p errors from the
%sum gate

qdeltas = SingleQuadratureGKPCorr(0, [3,7], qdeltas, AncillashiftsMultiCorr(w:w+1), 7, 0);
w = w + 2;

%Apply an intermediate GKP correction in q on these qubits which we
%will use for the final q stabiliser
c = [cVecRealtime356Q(x(3)),cVecRealtime7Q(x(7))]';
[qdeltas,qZc2(:,2)] = SingleQuadratureGKPCorr(1, [3,7], qdeltas, AncillashiftsMultiCorr(w:w+1), 7, c);
w = w + 2;
x([3,7]) = x([3,7]) + ones(2,1);

%Make the ZIZIZIZ measurement
%The c's used in the GKP correction before this multi-qubit measurement
cZIZIZIZ = [cVecRealtime124Q(x(1)-1), cVecRealtime356Q(x(3)-1),cVecRealtime356Q(x(5)-1),cVecRealtime7Q(x(7)-1)];
%Measure the ancilla:
qAncilla =  AncillashiftsMultiCorr(w);
w = w + 1;
measuredZIZIZIZ = ReminderMod(sum(qdeltas([1,3,5,7])) + qAncilla, 2*sqrt(pi));