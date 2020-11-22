function [SecretKeyMinCostfunc,SecretKeyMinCostfuncOnlyMultiQubit] = SecretKeyForOptimisedCostFunctionOverStations(Data7QubitCode,MinNMultiQubit,MinNall,MinNOnlyMultiQubit)
%This function calculates secret-key rate per optical mode for a given
%repeater configuration. The calculation is done both for the hybrid
%architecture as well as one with only type-A repeaters.

%Inputs:

%Data7QubitCode -                       simulation data
%MinNMultiQubit -                       vector with optimal number of type-A, stations 
%                                       for each distance, hybrid scheme
%MinNall -                              vector with optimal number of, all stations for
%                                       each distance, hybrid scheme
%MinNOnlyMultiQubit -                   vector with optimal number of type-A, stations 
%                                       for each distance, scheme with only type-A
%                                       stations

%Outputs:

%SecretKeyMinCostfunc -                 vector with secret key that minimises the cost
%                                       function for each distance, hybrid scheme
%SecretKeyMinCostfuncOnlyMultiQubit -   vector with secret key that minimises the cost
%                                       function for each distance, scheme
%                                       with only type-A stations


Lmax = 10000;
Lfix = 10;
SecretKeyMinCostfunc = zeros(Lmax/Lfix,1);
SecretKeyMinCostfuncOnlyMultiQubit = zeros(Lmax/Lfix,1);

for i = 1:Lmax/Lfix
    Ltot = i * Lfix;
    NMultiQubit = MinNMultiQubit(i);
    Nall = MinNall(i);
    NOnlyMultiQubit = MinNOnlyMultiQubit(i);
    Zerr = Data7QubitCode(NMultiQubit, Nall, 2);
    Xerr = Data7QubitCode(NMultiQubit, Nall, 3);
    ZerrOnlyMultiQubit = Data7QubitCode(NOnlyMultiQubit, NOnlyMultiQubit, 2);
    XerrOnlyMultiQubit = Data7QubitCode(NOnlyMultiQubit, NOnlyMultiQubit, 3);
    
    SecretKeyMinCostfunc(i) = SecretKey6State(NMultiQubit, Ltot, Zerr, Xerr);
    SecretKeyMinCostfuncOnlyMultiQubit(i) = SecretKey6State(NOnlyMultiQubit, Ltot, ZerrOnlyMultiQubit, XerrOnlyMultiQubit);
end