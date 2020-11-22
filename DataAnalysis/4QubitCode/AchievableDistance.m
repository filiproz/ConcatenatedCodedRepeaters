function [MaxDistanceMin, MaxDistance, MaxDistanceMax] = AchievableDistance(Data4QubitCode, RelError)
%This function calculates the maximum distance for which the secret key
%>0.01. We also calculate this distance assuming +/- relative error on the
%X/Z- flip probability.

%Inputs:

%Data4QubitCode             -   simulation data;
%RelError                   -   relative error of the simulation data for
%                               calculating upper and lower bound on the
%                               achievable distance

%Outputs:

%MaxDistanceMin -     Achievable distance, lower bound
%MaxDistance -        Achievable distance,
%MaxDistanceMax -     Achievable distance, upper bound

Lmax = 10000;
Lfix = 10;
X = zeros(1, Lmax/Lfix);


AllStationsRange = 40;
MultiQubitStationsRange = 40;


%Distance lower bound
SecretKeyArray = zeros(Lmax/Lfix,  MultiQubitStationsRange, AllStationsRange);

for i = 1:Lmax/Lfix
    Ltot = i * Lfix;
    X(i) = Ltot;
    for NMultiQubit = 1:MultiQubitStationsRange
        for Nall = NMultiQubit:NMultiQubit:AllStationsRange
            Zerr = (1+RelError)*Data4QubitCode(NMultiQubit, Nall,2);
            Xerr = (1+RelError)*Data4QubitCode(NMultiQubit, Nall,3);
            SecretKeyArray(i,NMultiQubit,Nall) = SecretKey6State(NMultiQubit, Ltot, Zerr, Xerr);
        end 
    end   
end

%Maximise key for each Ltot
KeyMaxLow = max(SecretKeyArray, [], [2,3]);

%Distance upper bound

SecretKeyArray = zeros(Lmax/Lfix,  MultiQubitStationsRange, AllStationsRange);

for i = 1:Lmax/Lfix
    Ltot = i * Lfix;
    X(i) = Ltot;
    for NMultiQubit = 1:MultiQubitStationsRange
        for Nall = NMultiQubit:NMultiQubit:AllStationsRange
            Zerr = (1-RelError)*Data4QubitCode(NMultiQubit, Nall,2);
            Xerr = (1-RelError)*Data4QubitCode(NMultiQubit, Nall,3);
            SecretKeyArray(i,NMultiQubit,Nall) = SecretKey6State(NMultiQubit, Ltot, Zerr, Xerr);
        end 
    end   
end

%Maximise key for each Ltot
KeyMaxUpp = max(SecretKeyArray, [], [2,3]);

%Expected value

SecretKeyArray = zeros(Lmax/Lfix,  MultiQubitStationsRange, AllStationsRange);

for i = 1:Lmax/Lfix
    Ltot = i * Lfix;
    X(i) = Ltot;
    for NMultiQubit = 1:MultiQubitStationsRange
        for Nall = NMultiQubit:NMultiQubit:AllStationsRange
            Zerr = Data4QubitCode(NMultiQubit, Nall,2);
            Xerr = Data4QubitCode(NMultiQubit, Nall,3);
            SecretKeyArray(i,NMultiQubit,Nall) = SecretKey6State(NMultiQubit, Ltot, Zerr, Xerr);
        end 
    end   
end

%Maximise key for each Ltot
KeyMax = max(SecretKeyArray, [], [2,3]);


DistUpp=find(KeyMaxUpp>0.01, 1, 'last');
Dist=find(KeyMax>0.01, 1, 'last');
DistLow=find(KeyMaxLow>0.01, 1, 'last');

MaxDistanceMin = Lfix * DistLow;
MaxDistance = Lfix * Dist;
MaxDistanceMax = Lfix * DistUpp;