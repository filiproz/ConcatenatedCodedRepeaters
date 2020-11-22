%Test VirtualCorr4QubitCodeQuadQ

                  
%% Test 1: correct single qubit error on first and third qubit
qdeltas = (sqrt(pi)/2 + 0.1) * [1;0.1;1;0.1];
[Xerrors,OutOf4QbitCodeSpaceYesNoX] = VirtualCorr4QubitCodeQuadQ(qdeltas);
assert(all(Xerrors == zeros(4,1)))
assert(OutOf4QbitCodeSpaceYesNoX == 1)

%% Test 2: single qubit error on second or fourth qubit leads to logical error
qdeltas = (sqrt(pi)/2 + 0.1) * [0.1;1;0.1;0.1];
[Xerrors,OutOf4QbitCodeSpaceYesNoX] = VirtualCorr4QubitCodeQuadQ(qdeltas);
assert(all(Xerrors == [1;1;0;0]))
assert(OutOf4QbitCodeSpaceYesNoX == 1)

qdeltas = (sqrt(pi)/2 + 0.1) * [0.1;0.1;0.1;1];
[Xerrors,OutOf4QbitCodeSpaceYesNoX] = VirtualCorr4QubitCodeQuadQ(qdeltas);
assert(all(Xerrors == [0;0;1;1]))
assert(OutOf4QbitCodeSpaceYesNoX == 1)

%% Test 3: 2-qubit error on certain qubits are logicals and stay
qdeltas = (sqrt(pi)/2 + 0.1) * [1;1;0.1;0.1];
[Xerrors,OutOf4QbitCodeSpaceYesNoX] = VirtualCorr4QubitCodeQuadQ(qdeltas);
assert(all(Xerrors == [1;1;0;0]))
assert(OutOf4QbitCodeSpaceYesNoX == 0)

qdeltas = (sqrt(pi)/2 + 0.1) * [0.1;0.1;1;1];
[Xerrors,OutOf4QbitCodeSpaceYesNoX] = VirtualCorr4QubitCodeQuadQ(qdeltas);
assert(all(Xerrors == [0;0;1;1]))
assert(OutOf4QbitCodeSpaceYesNoX == 0)
%% Test 4: stabiliser errors are erased
qdeltas = (sqrt(pi)/2 + 0.1) * [1;1;1;1];
[Xerrors,OutOf4QbitCodeSpaceYesNoX] = VirtualCorr4QubitCodeQuadQ(qdeltas);
assert(all(Xerrors == zeros(4,1)))
assert(OutOf4QbitCodeSpaceYesNoX == 0)