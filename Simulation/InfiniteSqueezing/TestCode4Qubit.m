%Test Code4Qubit

%% Test 1: No error case
psucc = Code4Qubit(1, 0, 1, 1000);
assert(psucc==1)

%% Test 2: Infinitely large error
%If the channel adds infinite amount of noise we get the depolarising
%channel
%Define tolerable error
t = 0.04;
psucc = Code4Qubit(0, 9999999, 1, 1000);
assert(psucc<0.25 + t)
assert(psucc>0.25 - t)