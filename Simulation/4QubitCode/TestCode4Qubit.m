%Test Code4Qubit

%% Test 1: No error case
[psucc,Zerr,Xerr] = Code4Qubit(1, 0, 0, 1, 1000);
assert(all([psucc,Zerr,Xerr]==[1,0,0]))

%% Test 2: Infinitely large error
%If the channel adds infinite amount of noise we get the depolarising
%channel
%Define tolerable error
t = 0.04;
[psucc,Zerr,Xerr] = Code4Qubit(0, 9999999, 0, 1, 1000);
assert(all([psucc,Zerr,Xerr]<[0.25 + t,0.5 + t,0.5 + t]))
assert(all([psucc,Zerr,Xerr]>[0.25 - t,0.5 - t,0.5 - t]))
[psucc,Zerr,Xerr] = Code4Qubit(0, 9999999, 0.11, 1, 1000);
assert(all([psucc,Zerr,Xerr]<[0.25 + t,0.5 + t,0.5 + t]))
assert(all([psucc,Zerr,Xerr]>[0.25 - t,0.5 - t,0.5 - t]))

%% Test 3 Channel loss of 50%
%If the channel has loss of 50% then quantum capacity needs to be zero.
%Use bound from Cerf, J. Mod. Opt. 47.2-3 (2000): 187-209.
[psucc,Zerr,Xerr] = Code4Qubit(1, 0.5, 0, 1, 1000);
pX = Xerr * (1-Zerr);
pZ = Zerr * (1-Xerr);
pY = Zerr * Xerr;
q = pX + pZ  + pY + sqrt(pX*pZ) + sqrt(pX*pY) + sqrt(pY*pZ);
assert(q>0.5)
[psucc,Zerr,Xerr] = Code4Qubit(1, 0.5, 0.11, 1, 1000);
pX = Xerr * (1-Zerr);
pZ = Zerr * (1-Xerr);
pY = Zerr * Xerr;
q = pX + pZ  + pY + sqrt(pX*pZ) + sqrt(pX*pY) + sqrt(pY*pZ);
assert(q>0.5)
