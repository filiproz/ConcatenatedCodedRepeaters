function [psucc,Zerr,Xerr] = GKPRepeaterChain(noise, value, sigGKP, N)
%This function calculates the performance of the GKP repeater chain
%over a chain of 100 consecutive GKP repeaters.


%Inputs:

%noise -    define type of noise considered;
%       0 -     random displacement with Gaussian distribution
%       1 -     amplification followed by pure loss
%value -    strength of noise, either standard deviation of Gaussian
%           displacement or loss probability gamma for the pure loss channel
%sigGKP -   standard deviation of an ancilla GKP
%n -        number of GKP channels and GKP corrections before a higher level correction
%N -        number of simulation runs

%Outputs:

%psucc -    probability that there was no logical error
%Zerr -     probability of a logical phase flip
%Xerr -     probability of a logical bit flip

%Set the number of elementary links (between the neighbouring type-A
%repeaters) that we simulate to 100
NElemLinks = 100;

% Either define SD sigma directly or through the loss parameter gamma
%for the pure loss channel.
if noise == 0
    sigChannel = value;
elseif noise == 1
    sigChannel = sqrt(value);
end

%Count successes
M = 0;
%Count logical X errors after correction
Xerr=0;
%Count logical Z errors after correction
Zerr=0;
if sigGKP ==0
    c= 1;
else
    c = (-sigGKP^2 - sigChannel^2 + sqrt((sigGKP^2 + sigChannel^2) * (5*sigGKP^2 + sigChannel^2)))/(2*sigGKP^2);
end
    %Simulation
parfor j = 1:N
    Zerrors = 0;
    Xerrors = 0;
    %Generate random numbers for the residual displacements of all the data
    %qubits at the beginning of the repeater chain
    AncillashiftsMultiCorrStart = normrnd(0,sigGKP,2,1);
      
    %At the beginning, each qubit has some residual error from the
    %last GKP correction
    pdeltas = sqrt(c)*AncillashiftsMultiCorrStart(1);
    qdeltas = sqrt(c)*AncillashiftsMultiCorrStart(2);
    
    %The chain of 100 links     
    pdeltas = ChannelWithGKPCorr(1, pdeltas, sigChannel, sigGKP, NElemLinks); 
    qdeltas = ChannelWithGKPCorr(0, qdeltas, sigChannel, sigGKP, NElemLinks);     
    
    %Virtual correction at the end to read of logical errors
    Zerrors = VirtualGKPCorr(pdeltas);
    Xerrors = VirtualGKPCorr(qdeltas);

    %We have a success if after the whole procedure therer are no errors.
    %For success we assign m=1, for failure m=0.
    if Xerrors == 0 &  Zerrors == 0
        M = M+1;
    end
               
    %Count the errors
    if any(Zerrors)
        Zerr = Zerr + 1;
    end
    if any(Xerrors)
        Xerr = Xerr + 1;
    end
    
end

psucc = M/N;
Zerr = Zerr/N;
Xerr = Xerr/N;