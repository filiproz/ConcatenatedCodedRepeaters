function [psucc,Zerr,Xerr] = GKPRepeaterChain(noise, value, N)
%This function calculates the probability that the GKP code corrects
%random shifts in phase space with SD sigma when infinitely squeezed 
%ancillas are used. The success probability is over a link between two 
%neighbouring GKP repeaters.


%Inputs:

%noise -    define type of noise considered;
%       0 -     random displacement with Gaussian distribution
%       1 -     amplification followed by pure loss
%value -    strength of noise, either standard deviation of Gaussian
%           displacement or loss probability gamma for the pure loss channel
%N -        number of simulation runs

%Outputs:

%psucc -    probability that there was no logical error
%Zerr -     probability of a logical phase flip
%Xerr -     probability of a logical bit flip

% Either define SD sigma directly or through the loss parameter gamma
%for the pure loss channel.
if noise == 0
    sig = value;
elseif noise == 1
    sig = sqrt(value);
end

%Store successes
M = 0;
%Count logical X errors after correction
Xerr=0;
%Count logical Z errors after correction
Zerr=0;

for i = 1:N
    %Define the vector of X and Z errors:
    Xerrors = 0;
    Zerrors = 0;

    %Define the q and p random shifts with SD sigma:
    qshifts = normrnd(0,sig,1,1);
    pshifts = normrnd(0,sig,1,1);
        
    %Find the measured value z in the interval from -sqrt(pi)/2 to +sqrt(pi)/2:
    qZ = ReminderMod(qshifts,sqrt(pi));
    pZ = ReminderMod(pshifts,sqrt(pi));
    
    %Find the multiplicative factor n that determines whether there was an
    %error
    qn = round((qshifts - qZ)/sqrt(pi));
    pn = round((pshifts - pZ)/sqrt(pi));
    
    %Determine X errors after GKP correction:
    if mod(qn,2) == 1
        Xerrors = 1;
    end
    
    %Determine Z errors after GKP correction:
    if mod(pn,2) == 1
        Zerrors = 1;
    end
    
    %We have a success if after the whole procedure there are no errors.
    %For success we assign m=1, for failure m=0.
    if Xerrors == 0 && Zerrors == 0
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

%Output probability of success as well as logical X and Z error probabilities
psucc = M/N;
Zerr = Zerr/N;
Xerr = Xerr/N;