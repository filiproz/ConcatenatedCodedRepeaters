%Test CsForAnalogInfoQuadP

sigChannel = 0.3;
sigGKP = 0.1;
cstart124 = 1;
cstart356 = 1;
cstart7 = 1;
n = 15;
[cVecRealtime124P,MinVar124,cVecRealtime356P,MinVar356,cVecRealtime7P,MinVar7] = OptimalCs7QubitCodeQuadP(sigChannel,sigGKP,cstart124,cstart356,cstart7,n);
[CsSigChannelP, CsSigc1P, CsSigc2P] = CsForAnalogInfoQuadP(cVecRealtime124P,cVecRealtime356P,cVecRealtime7P,n);

%% Test1: CsSigChannelP

assert(all(CsSigChannelP(:,1)> 0.7 & CsSigChannelP(:,1) < 0.8))
assert(all(CsSigChannelP(:,2:n)> 0.85 & CsSigChannelP(:,2:n) < 1,'all'))

%% Test2: CsSigc1P124
assert(all(CsSigc1P([1,2,4],3) > 0.6 & CsSigc1P([1,2,4],3) < 0.7))
assert(all(CsSigc1P([1,2,4],6) > 0.7 & CsSigc1P([1,2,4],6) < 0.8))
assert(all(CsSigc1P([1,2,4],[1,2,4,5]) == 0,'all'))

%% Test3: CsSigc1P356
assert(all(CsSigc1P([3,5,6],[3,6]) > 0.7 & CsSigc1P([3,5,6],[3,6]) < 0.8,'all'))
assert(CsSigc1P(3,2) > 0.6 & CsSigc1P(3,2) < 0.7)
assert(CsSigc1P(3,5) > 0.7 & CsSigc1P(3,5) < 0.8)
assert(all(CsSigc1P(3,[1,4]) ==0))
assert(all(CsSigc1P([5,6],1) > 0.6 & CsSigc1P([5,6],1) < 0.7))
assert(all(CsSigc1P([5,6],4) > 0.7 & CsSigc1P([5,6],4) < 0.8))
assert(all(CsSigc1P([5,6],[2,5]) ==0,'all'))

%% Test4: CsSigc1P7
assert(CsSigc1P(7,1) > 0.6 & CsSigc1P(7,1) < 0.7)
assert(all(CsSigc1P(7,2:6) > 0.7 & CsSigc1P(7,2:6) < 0.8))

%% Test5: CsSigc2P124
assert(all(CsSigc2P([1,2,4],1) > 0.6 & CsSigc2P([1,2,4],1) < 0.7))
assert(all(CsSigc2P([1,2,4],2) > 0.85 & CsSigc2P([1,2,4],2) < 1))
assert(all(CsSigc2P([1,2,4],5) > 0.6 & CsSigc2P([1,2,4],5) < 0.7))
assert(all(CsSigc2P([1,2,4],[3,4,6,7]) == 0,'all'))

%% Test6: CsSigc2P356
assert(all(CsSigc2P([3,5,6],1) > 0.6 & CsSigc2P([3,5,6],1) < 0.7))
assert(all(CsSigc2P([3,5,6],2) > 0.85 & CsSigc2P([3,5,6],2) < 1))
assert(all(CsSigc2P([3,5,6],5) > 0.6 & CsSigc2P([3,5,6],5) < 0.7))
assert(all(CsSigc2P(3,[4,7]) > 0.6 & CsSigc2P(3,[4,7]) < 0.7))
assert(all(CsSigc2P(3,[3,6]) == 0))
assert(all(CsSigc2P([5,6],[3,6]) > 0.6 & CsSigc2P([5,6],[3,6]) < 0.7,'all'))
assert(all(CsSigc2P([5,6],[4,7]) == 0,'all'))

%% Test7: CsSigc2P7
assert(CsSigc2P(7,1) > 0.6 & CsSigc2P(7,1) < 0.7)
assert(CsSigc2P(7,2) > 0.85 & CsSigc2P(7,2) < 1)
assert(all(CsSigc2P(7,3:7) > 0.6 & CsSigc2P(7,3:7) < 0.7))