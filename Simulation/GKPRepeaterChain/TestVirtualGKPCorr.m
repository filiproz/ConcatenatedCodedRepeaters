% Test VirtualGKPCorr

%% Test 1: Error cases
%Shifts into the intervals [(2n+1)*sqrt(pi)/2, (2n+3)*sqrt(pi)/2] for
%even n are errors:
assert(VirtualGKPCorr(sqrt(pi)/2 + sqrt(pi)/4) == 1)
assert(VirtualGKPCorr(5*sqrt(pi)/2 + sqrt(pi)/3) == 1)

%% Test 2: No-error cases
%Shifts into the intervals [(2n+1)*sqrt(pi)/2, (2n+3)*sqrt(pi)/2] for
%odd n are no-errors:
assert(VirtualGKPCorr(-sqrt(pi)/2 + sqrt(pi)/4) == 0)
assert(VirtualGKPCorr(3*sqrt(pi)/2 + sqrt(pi)/3) == 0)