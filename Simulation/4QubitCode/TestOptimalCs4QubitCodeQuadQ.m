%Test OptimalCs4QubitCodeQuadQ 

sigChannel = 0.3;
sigGKP = 0.1;
cstart = 1;
n = 15;
[cVecRealtime,MinVar] = OptimalCs4QubitCodeQuadQ(sigChannel,sigGKP,cstart,n);

%% Test1: MinVar

assert(MinVar < 0.1^2)

%% Test2: CsQubits
assert(all(cVecRealtime(1:n) > 0.85 & cVecRealtime(1:n) < 1))
assert(cVecRealtime(n+1) > 0.6 & cVecRealtime(n+1) < 0.7)
assert(all(cVecRealtime(n+2:n+3) > 0.7 & cVecRealtime(n+2:n+3) < 0.8))