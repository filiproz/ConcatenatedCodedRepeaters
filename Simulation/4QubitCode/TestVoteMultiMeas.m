% Test VoteMultiMeasTest

measured1 = [sqrt(pi)/4, -(5/6) * sqrt(pi)];
cMat1 = [0.6, 0.6, 0.6, 0.6; 0.6, 0.6, 0.6, 0.6];

measured2 = [sqrt(pi)/4 + 0.1, -(3/4) * sqrt(pi) - 0.1];
cMat2 = [0.3, 0.3, 0.3, 0.3; 1, 1, 1, 1];

sigGKP = 0.1;

zNoIntermediateError = zeros(7,1);
zIntermediateError = (sqrt(pi)/2 - 0.05) * ones(7,1);
CsSigc2 = ones(7,2);

%% Test 1: the same c's
% Here we show that if the channels are the same for both measurements then
% the parity is the one that is further away from the boundary
assert(VoteMultiMeas(measured1, sigGKP, cMat1, zNoIntermediateError, CsSigc2) == 1)

%% Test 2: different c's for the two measurements
% Here we show that even if the first value is further away from 0 than the
% second is from 1, the most probable parity can still be 0 if the channel
% for the first value has little noise and the second channel is very noisy.
assert(VoteMultiMeas(measured2, sigGKP, cMat2, zNoIntermediateError, CsSigc2) == 0)

%% Test 3: Intermediate error
%With an intermediate error we take the value from the second measurement
assert(VoteMultiMeas(measured2, sigGKP, cMat2, zIntermediateError, CsSigc2) == 1)