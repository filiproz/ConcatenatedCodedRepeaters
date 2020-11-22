function [MaxDistanceMin, MaxDistance, MaxDistanceMax] = AchievableDistance(DataGKPRepeaterChain, RelError)
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


%Distance lower bound
SecretKeyArray = zeros(Lmax/Lfix, AllStationsRange);

for i = 1:Lmax/Lfix
    Ltot = i * Lfix;
    X(i) = Ltot;
    for Nall = 1:AllStationsRange
        Zerr = (1+RelError)*DataGKPRepeaterChain(Nall,2);
        Xerr = (1+RelError)*DataGKPRepeaterChain(Nall,3);
        SecretKeyArray(i,Nall) = SecretKey6State(Nall, Ltot, Zerr, Xerr);
    end  
end

%Maximise key for each Ltot
KeyMaxLow = max(SecretKeyArray, [], 2);

%Distance upper bound

SecretKeyArray = zeros(Lmax/Lfix, AllStationsRange);

for i = 1:Lmax/Lfix
    Ltot = i * Lfix;
    X(i) = Ltot;
    for Nall = 1:AllStationsRange
        Zerr = (1-RelError)*DataGKPRepeaterChain(Nall,2);
        Xerr = (1-RelError)*DataGKPRepeaterChain(Nall,3);
        SecretKeyArray(i,Nall) = SecretKey6State(Nall, Ltot, Zerr, Xerr);
    end  
end

%Maximise key for each Ltot
KeyMaxUpp = max(SecretKeyArray, [], 2);

%Expected value

SecretKeyArray = zeros(Lmax/Lfix, AllStationsRange);

for i = 1:Lmax/Lfix
    Ltot = i * Lfix;
    X(i) = Ltot;
    for Nall = 1:AllStationsRange
        Zerr = DataGKPRepeaterChain(Nall,2);
        Xerr = DataGKPRepeaterChain(Nall,3);
        SecretKeyArray(i,Nall) = SecretKey6State(Nall, Ltot, Zerr, Xerr);
    end  
end

%Maximise key for each Ltot
KeyMax = max(SecretKeyArray, [], 2);


DistUpp=find(KeyMaxUpp>0.01, 1, 'last');
Dist=find(KeyMax>0.01, 1, 'last');
DistLow=find(KeyMaxLow>0.01, 1, 'last');

MaxDistanceMin = Lfix * DistLow;
MaxDistance = Lfix * Dist;
MaxDistanceMax = Lfix * DistUpp;