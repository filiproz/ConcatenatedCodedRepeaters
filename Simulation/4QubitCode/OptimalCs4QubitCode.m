function cVecRealtime = OptimalCs4QubitCode(quad,sigChannel,sigGKP,n)
%This function interates OptimalCsQquad4QbitCode to find the optimal c's
%and the optimal cstart. The MinVar at the end should be equal to the
%cstart * sigGKP^2 at the beginning
% quad - which quandrature:
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
%cVecRealtime - Vector of real time rescaling coeffs c, after optimising
%               over cstart through iteration

%Start with an initial cstart = 1
MinVar = sigGKP^2;
RelErr = 1;

while RelErr > 0.0005

    cstart = MinVar/sigGKP^2;
    
    if quad == 0
        [cVecRealtime,MinVar] = OptimalCs4QubitCodeQuadQ(round(sigChannel,2),round(sigGKP,2), round(cstart,1), n);
    elseif quad == 1
        [cVecRealtime,MinVar] = OptimalCs4QubitCodeQuadP(round(sigChannel,2),round(sigGKP,2), round(cstart,1), n);
    end
    
    RelErr = (cstart*sigGKP^2 - MinVar)/MinVar;
    
end


