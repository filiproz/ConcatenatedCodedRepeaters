% Test Costfunction4QubitCode

NMultiQubit = 10;
Nall = 10;
Ltot = 1000;
CostMultiQubit = 311;
Lfix = 10;
%Size of the code:
n = 7;
%% Test
x = round(Costfunction7QubitCode(Nall, NMultiQubit, Ltot, 0, 0),10)
assert(x==round((NMultiQubit/Lfix + 1/Ltot)*CostMultiQubit*n,10))