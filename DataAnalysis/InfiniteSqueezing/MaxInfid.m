function DataMaxInfid = MaxInfid(Data)
%This function calculates the maximum infidelity from the data generated
%for Fig2. That is, it is the maximum infidelity after the transmission
%over a single link with perfect decoding at the end.

%Inputs:

%Data -         Input data with first column corresponding to gamma parameter,
%               second to any logical flip probability, third to Z flip
%               probability and fourth to X flip probability

%Outputs

%DatMaxInfid -  Output data with first column corresponding to gamma parameter,
%               and second to the correspodning maximum infidelity


DataMaxInfid = zeros(size(Data,1),2);

for i = 1:size(Data,1)
    Zerr = Data(i,3);
    Xerr = Data(i,4);
    %Maximum infidelity is the probability of X or Z flip but not both
    %together (Y flip)
    DataMaxInfid(i,:) = [Data(i,1), Zerr * (1-Xerr) + Xerr * (1-Zerr)];
end