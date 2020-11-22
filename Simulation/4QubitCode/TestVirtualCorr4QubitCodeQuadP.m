%Test VirtualCorr4QubitCodeQuadP

                  
%% Test 1: correct single qubit error on first qubit
pdeltas = (sqrt(pi)/2 + 0.1) * [1;0.1;0.1;0.1];
[Zerrors,OutOf4QbitCodeSpaceYesNoZ] = VirtualCorr4QubitCodeQuadP(pdeltas);
assert(all(Zerrors == zeros(4,1)))
assert(OutOf4QbitCodeSpaceYesNoZ == 1)

%% Test 2: single qubit error on second qubit leads to stabiliser Z1Z2
pdeltas = (sqrt(pi)/2 + 0.1) * [0.1;1;0.1;0.1];
[Zerrors,OutOf4QbitCodeSpaceYesNoZ] = VirtualCorr4QubitCodeQuadP(pdeltas);
assert(all(Zerrors == zeros(4,1)))
assert(OutOf4QbitCodeSpaceYesNoZ == 1)

%% Test 3: do not correct single qubit error on third qubit
pdeltas = (sqrt(pi)/2 + 0.1) * [0.1;0.1;1;0.1];
[Zerrors,OutOf4QbitCodeSpaceYesNoZ] = VirtualCorr4QubitCodeQuadP(pdeltas);
assert(all(Zerrors == [1;0;1;0]))
assert(OutOf4QbitCodeSpaceYesNoZ == 1)
%% Test 4: 2-qubit error on certain qubits are logicals and stay
pdeltas = (sqrt(pi)/2 + 0.1) * [0.1;1;1;0.1];
[Zerrors,OutOf4QbitCodeSpaceYesNoZ] = VirtualCorr4QubitCodeQuadP(pdeltas);
assert(all(Zerrors == [0;1;1;0]))
assert(OutOf4QbitCodeSpaceYesNoZ == 0)

pdeltas = (sqrt(pi)/2 + 0.1) * [1;0.1;1;0.1];
[Zerrors,OutOf4QbitCodeSpaceYesNoZ] = VirtualCorr4QubitCodeQuadP(pdeltas);
assert(all(Zerrors == [1;0;1;0]))
assert(OutOf4QbitCodeSpaceYesNoZ == 0)
%% Test 5: stabiliser errors are erased
pdeltas = (sqrt(pi)/2 + 0.1) * [1;1;0;0];
[Zerrors,OutOf4QbitCodeSpaceYesNoZ] = VirtualCorr4QubitCodeQuadP(pdeltas);
assert(all(Zerrors == zeros(4,1)))
assert(OutOf4QbitCodeSpaceYesNoZ == 0)

pdeltas = (sqrt(pi)/2 + 0.1) * [0;0;1;1];
[Zerrors,OutOf4QbitCodeSpaceYesNoZ] = VirtualCorr4QubitCodeQuadP(pdeltas);
assert(all(Zerrors == zeros(4,1)))
assert(OutOf4QbitCodeSpaceYesNoZ == 0)