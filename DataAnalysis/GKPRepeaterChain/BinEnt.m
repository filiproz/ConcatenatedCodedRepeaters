function out = BinEnt(p)
%This function computes the binary entropy

%Inputs:
%p      - input probability

%Outputs:
%out    - binary entropy value

if p > 0 && p < 1
    h = -p * log2(p) - (1-p) * log2(1 - p);
else
    h = 0;
end

out = h;