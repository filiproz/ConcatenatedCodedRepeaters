%Test VoteMultiMeas

measured = [sqrt(pi)/4, 3*sqrt(pi)/4 + 0.05];
sigGKP = 0.1;
cMatEqual =         [0.8, 0.7, 0.6, 0.9; 0.6, 0.9, 0.7, 0.8];
cMat1stlessNoise =  [0.6, 0.7, 0.6, 0.6; 0.6, 0.9, 0.7, 0.8];
zNoIntermediateError = zeros(7,5);
RoundsGKPCorrMultiQubitRep = load('RoundsGKPCorrMultiQubitRep.mat');
RoundsC2Corr=RoundsGKPCorrMultiQubitRep.RoundsC2Corr;
zIntermediateError = (sqrt(pi)/2 - 0.05) * RoundsC2Corr(:,2:6);
CsSigc2P = ones(7,7);
StabVec = [4,5,6,7];
stabNo = 1;

%% Test1: Equal
[out,QubitWithError,perrorGKPCorrMax] = VoteMultiMeas(measured, sigGKP, cMatEqual, zNoIntermediateError, StabVec, CsSigc2P, stabNo);
assert(out==1)
assert(QubitWithError ==0)
assert(perrorGKPCorrMax ==0 )

%% Test2: 1stlessNoise
[out,QubitWithError,perrorGKPCorrMax] = VoteMultiMeas(measured, sigGKP, cMat1stlessNoise, zNoIntermediateError, StabVec, CsSigc2P, stabNo);
assert(out==0)
assert(QubitWithError ==0)
assert(perrorGKPCorrMax ==0 )

%% Test3: 1stlessNoise and error on 7th qubit
[out,QubitWithError,perrorGKPCorrMax] = VoteMultiMeas(measured, sigGKP, cMat1stlessNoise, zIntermediateError, StabVec, CsSigc2P, stabNo);
assert(out==1)
assert(QubitWithError ==7)
assert(perrorGKPCorrMax > 0 )