function cVecRealtime = CVecRealTimeConvert(cPostVec)
%This function converts the vector of postponed c's to a vector of real time
%Cs
%Input:
%
%cPostVec -     Vector of postponed rescaling coeffs c
%
%Output:
%
%cVecRealtime - Vector of real time rescaling coeffs c

d = length(cPostVec);

cVecRealtime = zeros(d,1);

%The last coeffs are the same for both real time and postponed scenario
cVecRealtime(d,1) = cPostVec(d);
%For the previous ones the relation is:

for i=1:d-1
    cVecRealtime(i,1) = cPostVec(i)/(1-sum(cPostVec(i+1:d)));
end