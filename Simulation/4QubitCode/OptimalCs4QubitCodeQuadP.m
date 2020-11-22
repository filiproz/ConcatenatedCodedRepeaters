function [cVecRealtime,MinVar] = OptimalCs4QubitCodeQuadP(sigChannel,sigGKP,cstart,n)
%This function solves for the optimal real time Cs for the p-quadrature for the
%4Qbit Code
%sigChannel -   standard deviation of the communication channel between
%               repeaters
%sigGKP -       standard deviation of the ancilla errors
%cstart -       the optimal rescaling coefficient at the end of the previous round,
%               so it quantifies the residual displacement at the beginning of the simulation
%                as sqrt(cstart) * sigGKP,
%n -            number of GKP corrections before a multiqubit correction
%
% Output:
%
%cVecRealtime - A vector of optimal rescaling coefficients,
%MinVar -       Minimised variance after the last the GKP correction

%For the p-quadrature we have the following corrections for which we want to determine c:
%1. Back-action from GKP-q and from multiqubit in q
%2. Back-action from fibre channel and GKP-q n times
%3. Back-action from the extra GKP-q
%4. Back-action from GKP-q between the repeated XXXX(p)

%First we build the covariance matrix

A = ones(n+3,n+3);

%c1 part
A(1,1) = cstart*sigGKP^2 + sigGKP^2 + 2*sigGKP^2;
for j = 2 : size(A,1)
    A(1,j) = cstart*sigGKP^2 + 2*sigGKP^2;
    A(j,1) = cstart*sigGKP^2 + 2*sigGKP^2;
end

%channel part
for i=2:n+1
    A(i,i) = A(i-1,i-1) + (sigGKP^2 + sigChannel^2) ;
    for j = i+1 : size(A,1)
        A(i,j) = A(i-1,j) + (sigGKP^2 + sigChannel^2) ;
        A(j,i) = A(j,i-1) + (sigGKP^2 + sigChannel^2) ;
    end
end
%c2 part
A(n+2,n+2) = A(n+1,n+1) + sigGKP^2;
A(n+2,n+3) = A(n+1,n+3) + sigGKP^2;
A(n+3,n+2) = A(n+3,n+1) + sigGKP^2;
A(n+3,n+3) = A(n+2,n+2) + sigGKP^2;

%Now the b Vector:
b = ones(size(A,1),1);
for i = 1:size(A,1)
    b(i,1) = A(i,i) - sigGKP^2;
end

%Now a
a = b(size(A,1),1);
b = -2*b;

%Now we can solve for optimal c's in the postpone scenario
cPostVec = 2*vpa(A)\(-b);
%We can also find the final minimized variance at the end
MinVar = a - (1/4) * transpose(b)*inv(A)*b;

%Now we find the Real Time values of c:
cVecRealtime = CVecRealTimeConvert(cPostVec);

