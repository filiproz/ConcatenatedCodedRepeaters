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
%               second to the correspodning maximum infidelity and third to
%               the relative error on the infidelity


DataMaxInfid = zeros(size(Data,1),3);

%Error threshold from the simulation
rel_err_thr = 0.1;

for i = 1:size(Data,1)
    Zerr = Data(i,3);
    Xerr = Data(i,4);
    %Probability of Pauli X and Z flips
    qX = Xerr * (1-Zerr);
    qZ = Zerr * (1-Xerr);
    
    %Coefficients from the error on qX and qZ:
    u = 1 + (Zerr/(1-Zerr))^2;
    v = 1 + (Xerr/(1-Xerr))^2;
    
    %Relative error on the infidelity:
    err_infid = rel_err_thr * sqrt(u * qX^2 + v * qZ^2)/(qX + qZ);
    %Maximum infidelity is the probability of X or Z flip but not Y flip
    DataMaxInfid(i,:) = [Data(i,1), qX + qZ, err_infid];
end