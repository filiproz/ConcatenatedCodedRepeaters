%Test GKPRepeaterChain

%% Test 1: No error case
psucc = GKPRepeaterChain(1, 0, 10000);
assert(psucc==1)

%% Test 2: infinitely large error
%If the channel adds infinite amount of noise we get the depolarising
%channel
psucc = GKPRepeaterChain(0, 99999999, 100000);
assert(round(psucc,2)==0.25)