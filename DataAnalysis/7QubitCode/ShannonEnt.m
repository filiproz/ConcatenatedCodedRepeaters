function out = ShannonEnt(T)
%This function computes the Shannon entropy

%Inputs:
%T      - input row vector with discrete probability distribution

%Outputs:
%out    - shannon entropy value

H = 0;
for x = T
    if x~=0
        H = H - x*log2(x);
    end
end
out = H;