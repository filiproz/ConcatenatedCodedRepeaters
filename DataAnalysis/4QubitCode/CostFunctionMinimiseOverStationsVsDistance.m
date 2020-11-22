function [CostfunctionMin4QubitCode,CostfunctionMinOnlyMultiQubit4QubitCode,MinNMultiQubit,MinNall,MinNOnlyMultiQubit] = CostFunctionMinimiseOverStationsVsDistance(Data4QubitCode)
%This function calculates the optimal resource configuration (for the 
%concatenated coded scheme based on the [[4,1,2]]-code), that minimises the
%cost function for each distance using the simulation data "Data4QubitCode".
%For each distance it calculates the minimum cost function value as well as
%the corresponding optimal repeater configuration. The calculation is done
%both for the hybrid architecture and the architecture based only on type-A
%repeaters.

%Inputs:

%Data4QubitCode -                           simulation data

%Outputs:

%CostfunctionMin4QubitCode -                vector with minimised cost function for
%                                           each distance for the hybrid scheme
%CostfunctionMinOnlyMultiQubit4QubitCode -  vector with minimised cost function for
%                                           each distance for the scheme that uses
%                                           only type-A stations    
%MinNMultiQubit -                           vector with optimal number of type-A
%                                           stations for each distance,
%                                           hybrid scheme
%MinNall -                                  vector with optimal number of
%                                           all stations for each distance,
%                                           hybrid scheme
%MinNOnlyMultiQubit -                       vector with optimal number of type-A
%                                           stations for each distance,
%                                           scheme with only type-A
%                                           stations

Lmax = 10000;
Lfix = 10;

AllStationsRange = 40;
MultiQubitStationsRange = 40;

CostfunctionArray = zeros(Lmax/Lfix,  MultiQubitStationsRange, AllStationsRange);
CostfunctionArrayOnlyMultiQubit = zeros(Lmax/Lfix,  MultiQubitStationsRange);

for i = 1:Lmax/Lfix
    Ltot = i * Lfix;
    for NMultiQubit = 1:MultiQubitStationsRange
        for Nall = 1:AllStationsRange
            Zerr = Data4QubitCode(NMultiQubit, Nall,2);
            Xerr = Data4QubitCode(NMultiQubit, Nall,3);
            CostfunctionArray(i,NMultiQubit,Nall) = Costfunction4QubitCode(Nall, NMultiQubit, Ltot, Zerr, Xerr);
        end
        CostfunctionArrayOnlyMultiQubit(i,NMultiQubit) = CostfunctionArray(i,NMultiQubit,NMultiQubit);
    end   
end



%Minimise cost function for each Ltot
[CostfunctionMinOverAll, MinNAllMatrix] = min(CostfunctionArray, [], 3); 
[CostfunctionMin4QubitCode, MinNMultiQubit] = min(CostfunctionMinOverAll, [], 2);
[CostfunctionMinOnlyMultiQubit4QubitCode, MinNOnlyMultiQubit] = min(CostfunctionArrayOnlyMultiQubit, [], 2);

MinNall = zeros(Lmax/Lfix, 1); 

for i = 1:Lmax/Lfix
    MinNall(i) =  MinNAllMatrix(i, MinNMultiQubit(i));
end