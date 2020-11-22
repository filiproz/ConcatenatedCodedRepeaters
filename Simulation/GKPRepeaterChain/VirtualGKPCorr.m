function Errors = VirtualGKPCorr(deltas)
%This function performs the ideal GKP and Steane code corrections 
%without analog information to bring the state to the nearest logical state
%of both codes. We use it at the end of the the chain of 100 multiqubit repeaters.

%Input:

%deltas -                   vector of dim = 7 with quadrature values
%tableSingleErr -           error look up table for Steane code for single-qubit errors

%Output:

%MultiqubitErrors -         vector of dim=7 with discrete 7 qubit errors.
%OutOf7QbitCodeSpaceYesNo - this variable tells us whether after ideal GKP
%                           correction the state is in the code space of
%                           the Steane code or not (0 for in the code space, 1 for not).


Errors = 0;

%Now apply a "virtual" perfect GKP correction to bring the state back to logical
ns = round((deltas - ReminderMod(deltas, sqrt(pi)))/sqrt(pi));
    
if mod(ns,2) == 1
    Errors = 1;
end