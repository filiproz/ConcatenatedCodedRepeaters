function [psucc,Zerr,Xerr] = Code7Qubit(noise, value, n, N)
%This function calculates the probability that the [[7,1,3]] code,
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
%Zerr -     probability of a logical phase flip
%Xerr -     probability of a logical bit flip

% Either define SD sigma directly or through the loss parameter gamma
%for the pure loss channel.
if noise == 0
    sig = value;
elseif noise == 1
    sig = sqrt(value);
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

%Simulation

parfor j = 1:N
    %Define the vector of X and Z errors:
    Xerrors = zeros(7,1);
    Zerrors = zeros(7,1);
    
    [qZmatrix, pZmatrix, Xflips, Zflips] = ChannelWithGKPCorr(7,sig,n);
    
    Xerrors = mod(Xerrors + Xflips,2);
    Zerrors = mod(Zerrors + Zflips,2);
    
   %Now we check Z errors. In the simulation we proceed only if there were Z errors after GKP. If there were no Z errors then
   %nothing happens.
   
   if any(Zerrors)
        
        %Measuring X stabilisers to check for Z errors

        %Make the IIIXXXX measurement
        parityIIIXXXX = mod(Zerrors(4) + Zerrors(5) + Zerrors(6) + Zerrors(7), 2);
        
        %Make the IXXIIXX measurement
        parityIXXIIXX = mod(Zerrors(2) + Zerrors(3) + Zerrors(6) + Zerrors(7), 2);
        
        %Make the XIXIXIX measurement
        parityXIXIXIX = mod(Zerrors(1) + Zerrors(3) + Zerrors(5) + Zerrors(7), 2);
        
        parityVectorZerr = [parityIIIXXXX, parityIXXIIXX, parityXIXIXIX];
        
        %If we got a logical error we will not detect it, so we only proceed if the parity check signals an error: 
        if any(parityVectorZerr)
            
            error_matrix_z = SyndromeToErrors(parityVectorZerr, tableSingleErr, tableDoubleErr, 7);
            
            matrix_size = size(error_matrix_z);
            num_errs = matrix_size(1);

            
            ErrProb = zeros(1,num_errs);
            
            for k = 1:num_errs
                ErrProb(1,k) = JointErrorLikelihood(error_matrix_z(k,:), pZmatrix, sig);
            end
                        
            %Calculate the most possible error index
            [~,indmax] = max(ErrProb); 
            
            %Correct those errors
            Zerrors = mod(Zerrors + transpose(error_matrix_z(indmax,:)), 2);
        
        end
   end

   % Certain 4Qubit errors are not errors as they are exactly stabilisers:
   if isequal(Zerrors, [0; 0; 0; 1; 1; 1; 1]) || isequal(Zerrors, [0; 1; 1; 0; 0; 1; 1])...
      || isequal(Zerrors, [1; 0; 1; 0; 1; 0; 1]) || isequal(Zerrors, [0; 1; 1; 1; 1; 0; 0])...
      || isequal(Zerrors, [1; 0; 1; 1; 0; 1; 0]) || isequal(Zerrors, [1; 1; 0; 0; 1; 1; 0])...
      || isequal(Zerrors, [1; 1; 0; 1; 0; 0; 1])
  
        Zerrors = zeros(7,1);
   end
   
   
   %Now we check for X errors. In the simulation we proceed only if there were X errors after GKP. If there were no X errors then
   %nothing happens.
   
   if any(Xerrors)
       
        %Measuring Z stabilisers to check for X errors

        %Make the IIIXXXX measurement
        parityIIIZZZZ = mod(Xerrors(4) + Xerrors(5) + Xerrors(6) + Xerrors(7), 2);

        %Make the IXXIIXX measurement
        parityIZZIIZZ = mod(Xerrors(2) + Xerrors(3) + Xerrors(6) + Xerrors(7), 2);

        %Make the XIXIXIX measurement
        parityZIZIZIZ = mod(Xerrors(1) + Xerrors(3) + Xerrors(5) + Xerrors(7), 2);

        parityVectorXerr = [parityIIIZZZZ, parityIZZIIZZ, parityZIZIZIZ];
        
        %If we got a logical error we will not detect it, so we only proceed if the parity check signals an error: 
        if any(parityVectorXerr)
                        
            error_matrix_x = SyndromeToErrors(parityVectorXerr, tableSingleErr, tableDoubleErr, 7);
                        
            matrix_size = size(error_matrix_x);
            num_errs = matrix_size(1);
            
            ErrProb = zeros(1,num_errs);
            
            for k = 1:num_errs
                ErrProb(1,k) = JointErrorLikelihood(error_matrix_x(k,:), qZmatrix, sig);
            end
            
            %Calculate the most possible error index
            [~,indmax] = max(ErrProb); 
                     
            %Correct those errors
            Xerrors = mod(Xerrors + transpose(error_matrix_x(indmax,:)), 2);
 
        end
   end
   
   % Certain 4Qubit errors are not errors as they are exactly stabilisers:
   if isequal(Xerrors, [0; 0; 0; 1; 1; 1; 1]) || isequal(Xerrors, [0; 1; 1; 0; 0; 1; 1])...
      || isequal(Xerrors, [1; 0; 1; 0; 1; 0; 1]) || isequal(Xerrors, [0; 1; 1; 1; 1; 0; 0])...
      || isequal(Xerrors, [1; 0; 1; 1; 0; 1; 0]) || isequal(Xerrors, [1; 1; 0; 0; 1; 1; 0])...
      || isequal(Xerrors, [1; 1; 0; 1; 0; 0; 1])
  
        Xerrors = zeros(7,1);
   end

   %We have a success if after the whole procedure therer are no errors.
   %For success we assign m=1, for failure m=0.
   if Xerrors == zeros(7,1) &  Zerrors == zeros(7,1)
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