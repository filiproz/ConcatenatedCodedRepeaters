%Test CsForAnalogInfoQuadQ

sigChannel = 0.3;
sigGKP = 0.1;
cstart124 = 1;
cstart356 = 1;
cstart7 = 1;
n = 15;
[cVecRealtime124Q,MinVar124,cVecRealtime356Q,MinVar356,cVecRealtime7Q,MinVar7] = OptimalCs7QubitCodeQuadQ(sigChannel,sigGKP,cstart124,cstart356,cstart7,n);
[CsSigChannelQ, CsSigc1Q, CsSigc2Q] = CsForAnalogInfoQuadQ(cVecRealtime124Q,cVecRealtime356Q,cVecRealtime7Q,n);

%% Test1: CsSigChannelQ

assert(all(CsSigChannelQ(:,1)> 0.6 & CsSigChannelQ(:,1) < 0.7))
assert(all(CsSigChannelQ(:,2:n)> 0.85 & CsSigChannelQ(:,2:n) < 1,'all'))

%% Test2: CsSigc1Q124
assert(all(CsSigc1Q([1,2,4],3) > 0.6 & CsSigc1Q([1,2,4],3) < 0.7))
assert(all(CsSigc1Q([1,2,4],6) > 0.7 & CsSigc1Q([1,2,4],6) < 0.8))
assert(all(CsSigc1Q([1,2,4],[1,2,4,5]) == 0,'all'))

%% Test3: CsSigc1Q356
assert(all(CsSigc1Q([3,5,6],[3,6]) > 0.7 & CsSigc1Q([3,5,6],[3,6]) < 0.8,'all'))
assert(CsSigc1Q(3,2) > 0.6 & CsSigc1Q(3,2) < 0.7)
assert(CsSigc1Q(3,5) > 0.7 & CsSigc1Q(3,5) < 0.8)
assert(all(CsSigc1Q(3,[1,4]) ==0))
assert(all(CsSigc1Q([5,6],1) > 0.6 & CsSigc1Q([5,6],1) < 0.7))
assert(all(CsSigc1Q([5,6],4) > 0.7 & CsSigc1Q([5,6],4) < 0.8))
assert(all(CsSigc1Q([5,6],[2,5]) ==0,'all'))

%% Test4: CsSigc1Q7
assert(CsSigc1Q(7,1) > 0.6 & CsSigc1Q(7,1) < 0.7)
assert(all(CsSigc1Q(7,2:6) > 0.7 & CsSigc1Q(7,2:6) < 0.8))

%% Test5: CsSigc2Q124
assert(all(CsSigc2Q([1,2,4],1) > 0.85 & CsSigc2Q([1,2,4],1) < 1))
assert(all(CsSigc2Q([1,2,4],2) > 0.7 & CsSigc2Q([1,2,4],2) < 0.8))
assert(all(CsSigc2Q([1,2,4],5) > 0.6 & CsSigc2Q([1,2,4],5) < 0.7))
assert(all(CsSigc2Q([1,2,4],[3,4,6,7]) == 0,'all'))

%% Test6: CsSigc2Q356
assert(all(CsSigc2Q([3,5,6],1) > 0.85 & CsSigc2Q([3,5,6],1) < 1))
assert(all(CsSigc2Q([3,5,6],2) > 0.7 & CsSigc2Q([3,5,6],2) < 0.8))
assert(all(CsSigc2Q([3,5,6],5) > 0.6 & CsSigc2Q([3,5,6],5) < 0.7))
assert(all(CsSigc2Q(3,[4,7]) > 0.6 & CsSigc2Q(3,[4,7]) < 0.7))
assert(all(CsSigc2Q(3,[3,6]) == 0))
assert(all(CsSigc2Q([5,6],[3,6]) > 0.6 & CsSigc2Q([5,6],[3,6]) < 0.7,'all'))
assert(all(CsSigc2Q([5,6],[4,7]) == 0,'all'))

%% Test7: CsSigc2Q7
assert(CsSigc2Q(7,1) > 0.85 & CsSigc2Q(7,1) < 1)
assert(CsSigc2Q(7,2) > 0.7 & CsSigc2Q(7,2) < 0.8)
assert(all(CsSigc2Q(7,3:7) > 0.6 & CsSigc2Q(7,3:7) < 0.7))