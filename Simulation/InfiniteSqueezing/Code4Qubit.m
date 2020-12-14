function psucc = Code4Qubit(noise, value, n, N)
%This function calculates the probability that the [[4,1,2]] code,
%concatenated with GKP code, corrects random shifts in phase space with
%SD sigma when infinitely squeezed ancillas are used. The success
%probability is over a link between two neighbouring multi-qubit repeaters.

%Inputs:

%noise -    define type of noise considered;
%       0 -     random displacement with Gaussian distribution
%       1 -     amplification followed by pure loss
%value -    strength of noise, either standard deviation of Gaussian
%           displacement or loss probability gamma for the pure loss channel
%n -        number of GKP channels and GKP corrections before a higher level correction
%N -        number of simulation runs

%Outputs:

%psucc -    probability that there was no logical error


% Either define SD sigma directly or through the loss parameter gamma
%for the pure loss channel.
if noise == 0
    sig = value;
elseif noise == 1
    sig = sqrt(value);
end

%Count successes
M = 0;

parfor j = 1:N
    %Define the vector of X and Z errors:
    Xerrors = zeros(4,1);
    Zerrors = zeros(4,1);
       
    [qZmatrix, pZmatrix, Xflips, Zflips] = ChannelWithGKPCorr(4,sig,n);
        
    Xerrors = mod(Xerrors + Xflips,2);
    Zerrors = mod(Zerrors + Zflips,2);

    if any(Xerrors)      
        
        %Calculate error prob for each qZ:
        qZmatrixErrProb = arrayfun(@(x) ErrorLikelihood(x, sig), qZmatrix);
        
        %Make the Z1Z2 measurement to check for X1X2 errors:
        parityZ1Z2 = mod( Xerrors(1) + Xerrors(2), 2);
        %Correct the error on the qubit with largest error probability from
        %analog info.
        if parityZ1Z2 == 1
            %Assume single qubit error on qubit 1 or 2. We calculate the
            %log of the probability that there was no logical error
            %in this elementary chain for each qubit wchich is equivalent
            %to the probability that there was an even number of errors which
            %is given by:
            %(1 + (1-2p1)(1-2p2)...)/2
            %Then we take the qubit for which this value is the smallest.
            %This is equivalent to finding the qubit for which
            %(1-2p1)(1-2p2)... is the smallest. We calculate the log2 of this
            %expression.
            [~,minSuccQubit_I] = min(sum(log2(ones(2,n) - 2*qZmatrixErrProb(1:2,:)),2));
            Xerrors(minSuccQubit_I) = mod(Xerrors(minSuccQubit_I) + 1,2);
        end

        %Make the Z3Z4 measurement to check for X3X4 errors:
        parityZ3Z4 = mod( Xerrors(3) + Xerrors(4), 2);
        %Correct the error on the qubit with larger |z| (closer to the
        %boundary)
         if parityZ3Z4 == 1
            %Assume single qubit error on qubit 3 or 4. We calculate the
            %log of the probability that there was no logical error
            %in this elementary chain for each qubit wchich is equivalent
            %to the probability that there was an even number of errors which
            %is given by:
            %(1 + (1-2p1)(1-2p2)...)/2
            %Then we take the qubit for which this value is the smallest.
            %This is equivalent to finding the qubit for which
            %(1-2p1)(1-2p2)... is the smallest. We calculate the log2 of this
            %expression.
            [~,minSuccQubit_I] = min(sum(log2(ones(2,n) - 2*qZmatrixErrProb(3:4,:)),2));
            Xerrors(2+minSuccQubit_I) = mod(Xerrors(2+minSuccQubit_I) + 1,2);
         end
        
    end
    
    if any(Zerrors)
  
        %Calculate error prob for each pZ:
        pZmatrixErrProb = arrayfun(@(x) ErrorLikelihood(x, sig), pZmatrix);

        %Make the X1X2X3X4 measurement to check for Z1Z2Z3Z4 errors:
        parityX1X2X3X4 = mod( sum(Zerrors), 2);
        %Correct the error on the qubit with largest error probability from
        %analog info.
        if parityX1X2X3X4 == 1
            %Assume single qubit error on qubit 1 or 2 or 3 or 4. We calculate the
            %log of the probability that there was no logical error
            %in this elementary chain for each qubit wchich is equivalent
            %to the probability that there was an even number of errors which
            %is given by:
            %(1 + (1-2p1)(1-2p2)...)/2
            %Then we take the qubit for which this value is the smallest.
            %This is equivalent to finding the qubit for which
            %(1-2p1)(1-2p2)... is the smallest. We calculate the log2 of this
            %expression.
            [~,minSuccQubit_I] = min(sum(log2(ones(4,n) - 2*pZmatrixErrProb),2));
            Zerrors(minSuccQubit_I) = mod(Zerrors(minSuccQubit_I) + 1,2);
        end
        
    end

    %Now apply the fact that the state is invariant under stabiliser errors:
    if Xerrors == ones(4,1)
        Xerrors = zeros(4,1);
    end

    if mod(Zerrors(1) + Zerrors(2),2) == 0
        Zerrors(1) = 0;
        Zerrors(2) = 0;
    end 

    if mod(Zerrors(3) + Zerrors(4),2) == 0
        Zerrors(3) = 0;
        Zerrors(4) = 0;
    end 
    
    %We have a success if after the whole procedure there are no errors.
    %For success we assign m=1, for failure m=0.
    if Xerrors == zeros(4,1) &  Zerrors == zeros(4,1)
        M = M+1;
    end
    
        
end

psucc = M/N;