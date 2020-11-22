function [Xerrors, OutOf4QbitCodeSpaceYesNoX] = VirtualCorr4QubitCodeQuadQ(qdeltas)
%This function performs the ideal GKP and [[4,1,2]] code corrections 
%without analog information to bring the state to the nearest logical state
%of both codes in q-quadrature. We use it at the end of the the chain of 100 multiqubit repeaters.

%Input:

%qdeltas -                   vector of dim = 4 with q-quadrature values

%Outputs

%MultiqubitErrorsX -         vector of dim=4 with discrete 4 qubit errors in q-quadrature.
%OutOf4QbitCodeSpaceXYesNo - this variable tells us whether after ideal GKP
%                            correction the state is in the code space of
%                            the Steane code or not (0 for in the code space, 1 for not).


Xerrors = zeros(4,1);
OutOf4QbitCodeSpaceYesNoX = 0;

%Now apply a "virtual" perfect GKP correction to bring the state back
%to logical space
qns = round((qdeltas - ReminderMod(qdeltas, sqrt(pi)))/sqrt(pi));
       
for i = 1:4
    if mod(qns(i),2) == 1
        Xerrors(i) = 1;
    end
end

%Now apply perfect multiqubit to bring the state to the higher level
%logical:

if any(Xerrors)      
        
    %Make the Z1Z2 measurement to check for X1X2 errors:
    parityZ1Z2 = mod( Xerrors(1) + Xerrors(2), 2);
    if parityZ1Z2 == 1
        Xerrors(1) = mod(Xerrors(1) + 1,2);
    end

    %Make the Z3Z4 measurement to check for X3X4 errors:
    parityZ3Z4 = mod( Xerrors(3) + Xerrors(4), 2);
     if parityZ3Z4 == 1
        Xerrors(3) = mod(Xerrors(3) + 1,2);
     end

    if parityZ1Z2 == 1 || parityZ3Z4 == 1
        OutOf4QbitCodeSpaceYesNoX = OutOf4QbitCodeSpaceYesNoX + 1;
    end
    
end

%Now apply the fact that the state is invariant under stabiliser errors:
if Xerrors == ones(4,1)
    Xerrors = zeros(4,1);
end