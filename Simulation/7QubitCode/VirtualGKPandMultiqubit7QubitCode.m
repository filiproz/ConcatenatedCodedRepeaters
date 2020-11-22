function [MultiqubitErrors,OutOf7QbitCodeSpaceYesNo] = VirtualGKPandMultiqubit7QubitCode(deltas, tableSingleErr)
%This function performs the ideal GKP and Steane code corrections 
%without analog information to bring the state to the nearest logical state
%of both codes. We use it at the end of the the chain of 100 multiqubit repeaters.

%Input:

%deltas -                   vector of dim = 7 with quadrature values
%tableSingleErr -           error look up table for Steane code for single-qubit errors

%Outputs

%MultiqubitErrors -         vector of dim=7 with discrete 7 qubit errors.
%OutOf7QbitCodeSpaceYesNo - this variable tells us whether after ideal GKP
%                           correction the state is in the code space of
%                           the Steane code or not (0 for in the code space, 1 for not).


MultiqubitErrors = zeros(7,1);
OutOf7QbitCodeSpaceYesNo = 0;

%Now apply a "virtual" perfect GKP correction to bring the state back to logical
ns = round((deltas - ReminderMod(deltas, sqrt(pi)))/sqrt(pi));
    
for i = 1:7
    if mod(ns(i),2) == 1
        MultiqubitErrors(i) = 1;
    end
end

%Now apply perfect multiqubit to bring the state to the higher level
%logical:

if any(MultiqubitErrors)


    %Measuring X/Z stabilisers to check for Z/X errors

    %Make the IIIXXXX measurement
    parityIIIPPPP = mod(sum(MultiqubitErrors(4:7)), 2);

    %Make the IXXIIXX measurement
    parityIPPIIPP = mod(sum(MultiqubitErrors([2:3,6:7])), 2);

    %Make the XIXIXIX measurement
    parityPIPIPIP = mod(sum(MultiqubitErrors([1,3,5,7])), 2);


    parityVectorMultiqubit = [parityIIIPPPP, parityIPPIIPP, parityPIPIPIP];

    %If we got a logical error we will not detect it, so we only proceed if the parity check signals an error: 
    if any(parityVectorMultiqubit)
        OutOf7QbitCodeSpaceYesNo = 1;
        error_matrix = SyndromeToErrorsSingleErrors(parityVectorMultiqubit, tableSingleErr, 7);

        %Correct those errors
        MultiqubitErrors = mod(MultiqubitErrors + transpose(error_matrix), 2);

    end
end

% Certain 4-qubit errors are not errors as they are exactly stabilisers:
if isequal(MultiqubitErrors, [0; 0; 0; 1; 1; 1; 1]) || isequal(MultiqubitErrors, [0; 1; 1; 0; 0; 1; 1])...
  || isequal(MultiqubitErrors, [1; 0; 1; 0; 1; 0; 1]) || isequal(MultiqubitErrors, [0; 1; 1; 1; 1; 0; 0])...
  || isequal(MultiqubitErrors, [1; 0; 1; 1; 0; 1; 0]) || isequal(MultiqubitErrors, [1; 1; 0; 0; 1; 1; 0])...
  || isequal(MultiqubitErrors, [1; 1; 0; 1; 0; 0; 1])

    MultiqubitErrors = zeros(7,1);
end