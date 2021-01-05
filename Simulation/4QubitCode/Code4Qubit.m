function [psucc,Zerr,Xerr] = Code4Qubit(noise, value, sigGKP, n, N)
%This function calculates the performance of the [[4,1,2]]-code based architecture
%over a chain of 100 consecutive multiqubit repeaters with GKP repeaters in between.


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
%Count out of code space events:
OutOf4QbitCodeSpaceX = 0;
OutOf4QbitCodeSpaceZ = 0;

%Calculate the optimal rescaling coefficients:
if sigGKP == 0
    cVecRealtimeQ = ones(n+3,1);
    cVecRealtimeP = ones(n+3,1);
else    
    cVecRealtimeQ = OptimalCs4QubitCode(0,sigChannel,sigGKP,n);
    cVecRealtimeP = OptimalCs4QubitCode(1,sigChannel,sigGKP,n);
end
[CsSigChannelP, CsSigc1P, CsSigc2P] = CsForAnalogInfo4QubitCodeQuadP(cVecRealtimeP,n);
[CsSigChannelQ, CsSigc1Q, CsSigc2Q] = CsForAnalogInfo4QubitCodeQuadQ(cVecRealtimeQ,n);

cVecRealtimePend = cVecRealtimeP(end);
cVecRealtimeQend = cVecRealtimeQ(end);

%Simulation
parfor j = 1:N
    Zerrors = zeros(4,1);
    Xerrors = zeros(4,1);
    %Generate random numbers for the residual displacements of all the data
    %qubits at the beginning of the repeater chain
    AncillashiftsMultiCorrStart = normrnd(0,sigGKP,8,1);
      
    %At the beginning, each qubit has some residual error from the
    %last GKP correction
    pdeltas = sqrt(cVecRealtimePend)*AncillashiftsMultiCorrStart(1:4);
    qdeltas = sqrt(cVecRealtimeQend)*AncillashiftsMultiCorrStart(5:8);
    
    %The chain of 100 links
    for i = 1:NElemLinks
        %Generate random numbers for all the GKP ancillas
        AncillashiftsMultiCorr = normrnd(0,sigGKP,56,1);
        AncillashiftsMultiCorrP = AncillashiftsMultiCorr(1 : length(AncillashiftsMultiCorr)/2);
        AncillashiftsMultiCorrQ = AncillashiftsMultiCorr(length(AncillashiftsMultiCorr)/2 + 1 : end);
        
        %Evolve both quadratures through a single link between two
        %consecutive type-A repeaters
        pdeltas = Code4QubitQuadP(pdeltas, sigChannel, sigGKP, n, AncillashiftsMultiCorrP,cVecRealtimeP, CsSigChannelP, CsSigc1P, CsSigc2P); 
        qdeltas = Code4QubitQuadQ(qdeltas, sigChannel, sigGKP, n, AncillashiftsMultiCorrQ,cVecRealtimeQ, CsSigChannelQ, CsSigc1Q, CsSigc2Q); 
    end    
    
    %Virtual correction at the end to read of logical errors
    [Zerrors,OutOf4QbitCodeSpaceYesNoZ] = VirtualCorr4QubitCodeQuadP(pdeltas);
    [Xerrors,OutOf4QbitCodeSpaceYesNoX] = VirtualCorr4QubitCodeQuadQ(qdeltas);
    
    %Count the out-of-code-space events
    OutOf4QbitCodeSpaceZ = OutOf4QbitCodeSpaceZ + OutOf4QbitCodeSpaceYesNoZ;
    OutOf4QbitCodeSpaceX = OutOf4QbitCodeSpaceX + OutOf4QbitCodeSpaceYesNoX;
 

    %We have a success if after the whole procedure there are no errors.
    %For success we assign m=1, for failure m=0.
    if Xerrors == zeros(4,1) &  Zerrors == zeros(4,1)
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
%Print out-of-subspace probability
OutOf4QbitCodeSpaceX = OutOf4QbitCodeSpaceX/N
OutOf4QbitCodeSpaceZ = OutOf4QbitCodeSpaceZ/N

%Output probability of success as well as logical X and Z error probabilities
psucc = M/N;
Zerr = Zerr/N;
Xerr = Xerr/N;