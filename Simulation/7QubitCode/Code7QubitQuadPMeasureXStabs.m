function [pdeltas, pZc2, measuredIIIXXXX, measuredIXXIIXX, measuredXIXIXIX, cIIIXXXX, cIXXIIXX, cXIXIXIX, w, x] = Code7QubitQuadPMeasureXStabs(pdeltas, AncillashiftsMultiCorr, w, x, cVecRealtime124P,cVecRealtime356P,cVecRealtime7P) 
%This function evolves the p-quadrature with the 7-qubit Steane code on the
%second level through a round of the X stabiliser measurements

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
%pZc2 -                     The analog syndromes for the c2 corrections in
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



pZc2 = zeros(7,2);

%Correct Z errors from X stabilisers which measure p quadrature:

%Make the IIIXXXX measurement
%The c's used in the GKP correction before this multi-qubit measurement
cIIIXXXX = [cVecRealtime124P(x(4)-1), cVecRealtime356P(x(5)-1),cVecRealtime356P(x(6)-1),cVecRealtime7P(x(7)-1)];
%Measure the ancilla:
pAncilla =  AncillashiftsMultiCorr(w);
w = w + 1;
measuredIIIXXXX = ReminderMod(sum(pdeltas(4:7)) + pAncilla, 2*sqrt(pi));


%Intermediate GKP between stabilisers

%Apply an intermediate GKP correction in q on these qubits which we
%will use for another p stabiliser to get rid of the q errors from the
%sum gate

pdeltas = SingleQuadratureGKPCorr(0, [5,6,7], pdeltas, AncillashiftsMultiCorr(w:w+2), 7, 0);
w = w + 3;

%Apply an intermediate GKP correction in p on these qubits which we
%will use for another p stabiliser
c = [cVecRealtime356P(x(5)),cVecRealtime356P(x(6)),cVecRealtime7P(x(7))]';
[pdeltas,pZc2(:,1)] = SingleQuadratureGKPCorr(1, [5,6,7], pdeltas, AncillashiftsMultiCorr(w:w+2), 7, c);
w = w + 3;
x(5:7) = x(5:7) + ones(3,1);


%Make the IXXIIXX measurement
%The c's used in the GKP correction before this multi-qubit measurement
cIXXIIXX = [cVecRealtime124P(x(2)-1), cVecRealtime356P(x(3)-1), cVecRealtime356P(x(6)-1),cVecRealtime7P(x(7)-1)];
%Measure the ancilla:
pAncilla =  AncillashiftsMultiCorr(w);
w = w + 1;
measuredIXXIIXX = ReminderMod(sum(pdeltas([2:3,6:7])) + pAncilla, 2*sqrt(pi));

%Intermediate GKP between stabilisers

%Apply an intermediate GKP correction in q on these qubits which we
%will use for the last p stabiliser to get rid of the q errors from the
%sum gate
pdeltas = SingleQuadratureGKPCorr(0, [3,7], pdeltas, AncillashiftsMultiCorr(w:w+1), 7, 0);
w = w + 2;
%Apply an intermediate GKP correction in p on these qubits which we
%will use for the final p stabiliser
c = [cVecRealtime356P(x(3)),cVecRealtime7P(x(7))]';
[pdeltas,pZc2(:,2)] = SingleQuadratureGKPCorr(1, [3,7], pdeltas, AncillashiftsMultiCorr(w:w+1), 7, c);
w = w + 2;
x([3,7]) = x([3,7]) + ones(2,1);

%Make the XIXIXIX measurement
%The c's used in the GKP correction before this multi-qubit measurement
cXIXIXIX = [cVecRealtime124P(x(1)-1), cVecRealtime356P(x(3)-1),cVecRealtime356P(x(5)-1),cVecRealtime7P(x(7)-1)];
%Measure the ancilla:
pAncilla =  AncillashiftsMultiCorr(w);
w = w + 1;
measuredXIXIXIX = ReminderMod(sum(pdeltas([1,3,5,7])) + pAncilla, 2*sqrt(pi));