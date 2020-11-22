function [cVecRealtime124,cVecRealtime356,cVecRealtime7] = OptimalCs7QubitCode(quad,sigChannel,sigGKP,n)
%This function interates OptimalCsQquad7QbitCode to find the optimal c's
%and the optimal cstart. The MinVar at the end should be equal to the
%cstart * sigGKP^2 at the beginning

%Input:

% quad - which quadrature:
%   0 - q
%   1 - p
%sigChannel -   standard deviation of the communication channel between the
%               repeaters
%sigGKP -       standard deviation of the ancilla GKPs
%n -            number of times GKP correction is performed before a
%               multiqubit correction (n-1 GKP repeaters followed by a multiqubit repeater)
%
%Output:
%
%cVecRealtime - Vector of real-time rescaling coeffs c, after optimising
%               over cstart through iteration

%Start with an initial cstart = 1
MinVar124 = sigGKP^2;
MinVar356 = sigGKP^2;
MinVar7 = sigGKP^2;

RelErr124 = 1;
RelErr356 = 1;
RelErr7 = 1;

% We repeat the procedure until the relative error between
% cstart124*sigGKP^2 and MinVar124 is small.
while RelErr124 > 0.0005 | RelErr356 > 0.0005 | RelErr7 > 0.0005
    
    cstart124 = MinVar124/sigGKP^2;
    cstart356 = MinVar356/sigGKP^2;
    cstart7 = MinVar7/sigGKP^2;

    if quad == 0
        [cVecRealtime124,MinVar124,cVecRealtime356,MinVar356,cVecRealtime7,MinVar7] = OptimalCs7QubitCodeQuadQ(round(sigChannel,2),round(sigGKP,2),round(cstart124,1),round(cstart356,1),round(cstart7,1),n);
    elseif quad == 1
        [cVecRealtime124,MinVar124,cVecRealtime356,MinVar356,cVecRealtime7,MinVar7] = OptimalCs7QubitCodeQuadP(round(sigChannel,2),round(sigGKP,2),round(cstart124,1),round(cstart356,1),round(cstart7,1),n);
    end
    
    RelErr124 = (cstart124*sigGKP^2 - MinVar124)/MinVar124;
    RelErr356 = (cstart356*sigGKP^2 - MinVar356)/MinVar356;
    RelErr7 = (cstart7*sigGKP^2 - MinVar7)/MinVar7;
    
end


