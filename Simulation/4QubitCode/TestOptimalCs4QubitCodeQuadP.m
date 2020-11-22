%Test OptimalCs4QubitCodeQuadP

sigChannel = 0.3;
sigGKP = 0.1;
cstart = 1;
n = 15;
[cVecRealtime,MinVar] = OptimalCs4QubitCodeQuadP(sigChannel,sigGKP,cstart,n);

%% Test1: MinVar

assert(MinVar < 0.1^2)

%% Test2: CsQubits 
assert(cVecRealtime(1) < 0.8 & cVecRealtime(1) > 0.7)
assert(all(cVecRealtime(2:n+1) > 0.85 & cVecRealtime(2:n+1) < 1))
assert(all(cVecRealtime(n+2:n+3) < 0.7 & cVecRealtime(n+2:n+3) > 0.6))