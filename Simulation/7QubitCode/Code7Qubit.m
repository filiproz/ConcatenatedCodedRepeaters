function [psucc,Zerr,Xerr] = Code7Qubit(noise, value, sigGKP, n, N)
%This function calculates the performance a GKP code concatenated with the 
%7-qubit Steane code over a chain of 100 multiqubit repeaters

%Inputs:

%noise -    define type of noise considered;
%       0 -     random displacement with gaussian distribution
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

%Define the look-up table for single  errors. The table is the same for Z
%and X errors
%Rows are 3 X stabilisers and columns are single Z errors (parity check matrix) or vice versa.

tableSingleErr =    [ 0, 0, 0, 1, 1, 1, 1;
                      0, 1, 1, 0, 0, 1, 1;
                      1, 0, 1, 0, 1, 0, 1]';

%Table with double errors

tableDoubleErr =  zeros(7,3,7);
for i = 1:7
   for j = 1:7
        tableDoubleErr(i,:,j) = mod(tableSingleErr(i,:) + tableSingleErr(j,:), 2);
   end
end

%Count successes
M = 0;
%Count logical X errors after correction
Xerr=0;
%Count logical Z errors after correction
Zerr=0;

%Count out of code space events:
OutOf7QbitCodeSpaceZ = 0;
OutOf7QbitCodeSpaceX = 0;


%Calculate the optimal rescaling coefficients:
if sigGKP == 0
    cVecRealtime124Q = ones(n+5,1);
    cVecRealtime124P = ones(n+5,1);
    cVecRealtime356Q = ones(n+9,1);
    cVecRealtime356P = ones(n+9,1);
    cVecRealtime7Q = ones(n+13,1);
    cVecRealtime7P = ones(n+13,1);
else    
    [cVecRealtime124Q,cVecRealtime356Q,cVecRealtime7Q] = OptimalCs7QubitCode(0,sigChannel,sigGKP,n);
    [cVecRealtime124P,cVecRealtime356P,cVecRealtime7P] = OptimalCs7QubitCode(1,sigChannel,sigGKP,n);
end

%Calculate the residual errors for the ananlog information distribution
[CsSigChannelQ, CsSigc1Q, CsSigc2Q] = CsForAnalogInfoQuadQ(cVecRealtime124Q,cVecRealtime356Q,cVecRealtime7Q,n);
[CsSigChannelP, CsSigc1P, CsSigc2P] = CsForAnalogInfoQuadP(cVecRealtime124P,cVecRealtime356P,cVecRealtime7P,n);

%Give explicit names to the last rescaling coeffs
cVecRealtime124Qend = cVecRealtime124Q(end);
cVecRealtime356Qend = cVecRealtime356Q(end);
cVecRealtime7Qend = cVecRealtime7Q(end);
cVecRealtime124Pend = cVecRealtime124P(end);
cVecRealtime356Pend = cVecRealtime356P(end);
cVecRealtime7Pend = cVecRealtime7P(end);

%Simulation

parfor j = 1:N
    
    %Initial starting errors
    
    %Random numbers for the starting values
    AncillashiftsMultiCorrStart = normrnd(0,sigGKP,14,1);
    
    %In p-quadrature start after the multiqubit correction of Z errors
    %from X stabilisers where each qubit has some residual error from the
    %last GKP(p) correction
    pdeltas = zeros(7,1);
    pdeltas([1,2,4]) = sqrt(cVecRealtime124Pend)*AncillashiftsMultiCorrStart(1:3);
    pdeltas([3,5,6]) = sqrt(cVecRealtime356Pend)*AncillashiftsMultiCorrStart(4:6);
    pdeltas(7) = sqrt(cVecRealtime7Pend)*AncillashiftsMultiCorrStart(7);
    
    %In q-quadrature start after the multiqubit correction of X errors
    %from Z stabilisers where each qubit has some residual error from the
    %last GKP(q) correction
    qdeltas = zeros(7,1);
    qdeltas([1,2,4]) = sqrt(cVecRealtime124Qend)*AncillashiftsMultiCorrStart(8:10);
    qdeltas([3,5,6]) = sqrt(cVecRealtime356Qend)*AncillashiftsMultiCorrStart(11:13);
    qdeltas(7) = sqrt(cVecRealtime7Qend)*AncillashiftsMultiCorrStart(14);
    
    %Simulation of a chain with 100 multiqubit repeaters
    
    for i = 1:NElemLinks
        %Define ancilla errrors for each elementary link between
        %neighbouring multiqubit repeaters
        AncillashiftsMultiCorr = normrnd(0,sigGKP,244,1);
        AncillashiftsMultiCorrP = AncillashiftsMultiCorr(1 : length(AncillashiftsMultiCorr)/2);
        AncillashiftsMultiCorrQ = AncillashiftsMultiCorr(length(AncillashiftsMultiCorr)/2 + 1 : end);
        
        %Simulate the chain
        pdeltas = Code7QubitQuadP(pdeltas, sigChannel, sigGKP, n, tableSingleErr, tableDoubleErr, AncillashiftsMultiCorrP, cVecRealtime124P,cVecRealtime356P,cVecRealtime7P, CsSigChannelP, CsSigc1P, CsSigc2P);
        qdeltas = Code7QubitQuadQ(qdeltas, sigChannel, sigGKP, n, tableSingleErr, tableDoubleErr, AncillashiftsMultiCorrQ, cVecRealtime124Q,cVecRealtime356Q,cVecRealtime7Q, CsSigChannelQ, CsSigc1Q, CsSigc2Q);

    end
    
    %Virtual correction at the end to read of logical errors
    [Zerrors,OutOf7QbitCodeSpaceYesNoZ] = VirtualGKPandMultiqubit7QubitCode(pdeltas, tableSingleErr);
    [Xerrors,OutOf7QbitCodeSpaceYesNoX] = VirtualGKPandMultiqubit7QubitCode(qdeltas, tableSingleErr);
    
    %Count the out-of-code-space events
    OutOf7QbitCodeSpaceZ = OutOf7QbitCodeSpaceZ + OutOf7QbitCodeSpaceYesNoZ;
    OutOf7QbitCodeSpaceX = OutOf7QbitCodeSpaceX + OutOf7QbitCodeSpaceYesNoX;
     
    %We have a success if after the whole procedure therer are no errors.
    %For success we assign m=1, for failure m=0.
    if Xerrors == zeros(7,1) &  Zerrors == zeros(7,1)
        m=1;
    else
        m=0;
    end
    
    %Count successes
    M = M + m;

    %Count the errors
    if any(Zerrors)
        Zerr = Zerr + 1;
    end
    if any(Xerrors)
        Xerr = Xerr + 1;
    end
       
        
end
%Print out-of-subspace probability
OutOf7QbitCodeSpaceZ = OutOf7QbitCodeSpaceZ/N
OutOf7QbitCodeSpaceX = OutOf7QbitCodeSpaceX/N

%Output probability of success as well as logical X and Z error probabilities
psucc = M/N;
Zerr = Zerr/N;
Xerr = Xerr/N;