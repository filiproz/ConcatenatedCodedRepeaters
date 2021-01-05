% Test MaxInfid

m = 100; 
gammaRange = 0.08 : 0.12/m : 0.2;

%The first data set has no errors
Data = zeros(101,4);
Data(:,1) = gammaRange';
%The second data set has 50% flip probabilities
Data2 = 0.5*ones(101,4);
Data2(:,1) = gammaRange';

DataMaxInfid = MaxInfid(Data);
DataMaxInfid2 = MaxInfid(Data2);

%% Test1: No error case
assert(all(DataMaxInfid(:,1) == gammaRange'))
assert(all(DataMaxInfid(:,2) == zeros(101,1)))

%% Test2: Maximum depolarisation
assert(all(DataMaxInfid2(:,1) == gammaRange'))
assert(all(DataMaxInfid2(:,2) == 0.5*ones(101,1)))