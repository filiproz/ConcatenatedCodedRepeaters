%Test OptimalCsQquad7QbitCode 

sigChannel = 0.3;
sigGKP = 0.1;
cstart124 = 1;
cstart356 = 1;
cstart7 = 1;
n = 15;
[cVecRealtime124,MinVar124,cVecRealtime356,MinVar356,cVecRealtime7,MinVar7] = OptimalCs7QubitCodeQuadQ(sigChannel,sigGKP,cstart124,cstart356,cstart7,n);

%% Test1: MinVar

assert(MinVar124 < 0.1^2)
assert(MinVar356 < 0.1^2)
assert(MinVar7 < 0.1^2)

%% Test2: CsQubits 124
assert(all(cVecRealtime124(1:n) > 0.85 & cVecRealtime124(1:n) < 1))
assert(cVecRealtime124(n+1) < 0.7 & cVecRealtime124(n+1) > 0.6)
assert(all(cVecRealtime124(n+2:n+3) > 0.7 & cVecRealtime124(n+2:n+3) < 0.8))
assert(all(cVecRealtime124(n+4:n+5) < 0.65 & cVecRealtime124(n+4:n+5) > 0.6))

%% Test3: CsQubits 356
assert(all(cVecRealtime356(1:n) > 0.85 & cVecRealtime356(1:n) < 1))
assert(cVecRealtime356(n+1) < 0.7 & cVecRealtime356(n+1) > 0.6)
assert(all(cVecRealtime356(n+2:n+5) > 0.7 & cVecRealtime356(n+2:n+5) < 0.8))
assert(all(cVecRealtime356(n+6:n+9) < 0.65 & cVecRealtime356(n+6:n+9) > 0.6))

%% Test3: CsQubits 7
assert(all(cVecRealtime7(1:n) > 0.85 & cVecRealtime7(1:n) < 1))
assert(cVecRealtime7(n+1) < 0.7 & cVecRealtime7(n+1) > 0.6)
assert(all(cVecRealtime7(n+2:n+7) > 0.7 & cVecRealtime7(n+2:n+7) < 0.8))
assert(all(cVecRealtime7(n+8:n+13) < 0.65 & cVecRealtime7(n+8:n+13) > 0.6))
