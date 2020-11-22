function [Zerrors, OutOf4QbitCodeSpaceYesNoZ] = VirtualCorr4QubitCodeQuadP(pdeltas)
%This function performs the ideal GKP and [[4,1,2]] code corrections 
%without analog information to bring the state to the nearest logical state
%of both codes in p-quadrature. We use it at the end of the the chain of 100 multiqubit repeaters.

%Input:

%pdeltas -                   vector of dim = 4 with p-quadrature values

%Output:

%MultiqubitErrorsZ -         vector of dim=4 with discrete 4 qubit errors in p-quadrature.
%OutOf4QbitCodeSpaceZYesNo - this variable tells us whether after ideal GKP
%                            correction the state is in the code space of
%                            the Steane code or not (0 for in the code space, 1 for not).


Zerrors = zeros(4,1);
OutOf4QbitCodeSpaceYesNoZ = 0;

%Now apply a "virtual" perfect GKP correction to bring the state back
%to logical space
pns = round((pdeltas - ReminderMod(pdeltas, sqrt(pi)))/sqrt(pi));
       
for i = 1:4
    if mod(pns(i),2) == 1
        Zerrors(i) = 1;
    end
end

%Now apply a "virtual" perfect multiqubit correction (assume it's always
%the first qubit that has an error if there is an error).

if any(Zerrors)
  
    %Make the X1X2X3X4 measurement to check for Z1Z2Z3Z4 errors:
    parityX1X2X3X4 = mod( sum(Zerrors), 2);
    if parityX1X2X3X4 == 1
        OutOf4QbitCodeSpaceYesNoZ = OutOf4QbitCodeSpaceYesNoZ + 1;
        Zerrors(1) = mod(Zerrors(1) + 1,2);
    end

end

%Now apply the fact that the state is invariant under stabiliser errors:
if mod(Zerrors(1) + Zerrors(2),2) == 0
    Zerrors(1) = 0;
    Zerrors(2) = 0;
end 

if mod(Zerrors(3) + Zerrors(4),2) == 0
    Zerrors(3) = 0;
    Zerrors(4) = 0;
end 