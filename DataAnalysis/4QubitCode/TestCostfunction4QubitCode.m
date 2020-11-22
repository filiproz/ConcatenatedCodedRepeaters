% Test Costfunction4QubitCode

NMultiQubit = 10;
Nall = 10;
Ltot = 1000;
CostMultiQubit = 68;
Lfix = 10;
%Size of the code:
n = 4;
%% Test
x = Costfunction4QubitCode(Nall, NMultiQubit, Ltot, 0, 0)
assert(x==(NMultiQubit/Lfix + 1/Ltot)*CostMultiQubit*n)