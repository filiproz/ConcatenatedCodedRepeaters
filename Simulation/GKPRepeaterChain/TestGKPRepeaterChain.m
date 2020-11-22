%Test GKPRepeaterChain

%% Test 1: No error case
[psucc,Zerr,Xerr] = GKPRepeaterChain(1, 0, 0, 10000);
assert(all([psucc,Zerr,Xerr]==[1,0,0]))

%% Test 2: infinitely large error
%If the channel adds infinite amount of noise we get the depolarising
%channel
[psucc,Zerr,Xerr] = GKPRepeaterChain(0, 99999999, 0, 100000);
assert(all(round([psucc,Zerr,Xerr],2)==[0.25,0.5,0.5]))
[psucc,Zerr,Xerr] = GKPRepeaterChain(0, 99999999, 0.11, 100000);
assert(all(round([psucc,Zerr,Xerr],2)==[0.25,0.5,0.5]))

%% Test 3: Channel loss of 50%
%If the channel has loss of 50% then quantum capacity needs to be zero.
%Use bound from Cerf, J. Mod. Opt. 47.2-3 (2000): 187-209.
[psucc,Zerr,Xerr] = GKPRepeaterChain(1, 0.5, 0, 10000);
pX = Xerr * (1-Zerr);
pZ = Zerr * (1-Xerr);
pY = Zerr * Xerr;
q = pX + pZ  + pY + sqrt(pX*pZ) + sqrt(pX*pY) + sqrt(pY*pZ);
assert(q>0.5)
[psucc,Zerr,Xerr] = GKPRepeaterChain(1, 0.5, 0.11, 10000);
pX = Xerr * (1-Zerr);
pZ = Zerr * (1-Xerr);
pY = Zerr * Xerr;
q = pX + pZ  + pY + sqrt(pX*pZ) + sqrt(pX*pY) + sqrt(pY*pZ);
assert(q>0.5)
