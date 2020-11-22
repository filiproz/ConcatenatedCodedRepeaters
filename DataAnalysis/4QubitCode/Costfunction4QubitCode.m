function out = Costfunction4QubitCode(Nall, NMultiQubit, Ltot, Zerr, Xerr)
% Normalised cost function for the [[4,1,2]]-code architecture

%Inputs:

%Nall -             number of all repeaters per Lfix km
%NMultiQubit -      number of type-A repeaters per Lfix km
%Ltot -             distance over which we want to calculate the key
%Zerr, Xerr -     probability of Z-flip and X-flip over a chain of 100 
%                   elementary links where each elementary link is a link 
%                   between the neighbouring type-A repeaters.

%Outputs

%out -              normalised cost function

%Define Lfix
Lfix = 10;
%Secret key per optical mode
secret_key = SecretKey6State(NMultiQubit, Ltot, Zerr, Xerr);

%Cost function
out =  (( 1/Lfix) * (4*(Nall-NMultiQubit) + 68*NMultiQubit) + 68/Ltot)/secret_key;