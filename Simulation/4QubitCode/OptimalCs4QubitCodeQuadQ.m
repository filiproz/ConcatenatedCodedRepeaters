function [cVecRealtime,MinVar] = OptimalCs4QubitCodeQuadQ(sigChannel,sigGKP,cstart,n)
%This function solves for the optimal real time Cs for the q-quadrature for the
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

%For the q-quadrature we have the following corrections for which we want to determine c:
%1. Back-action from GKP-p and fibre channel n times
%2. Back-action from  the extra GKP-p
%3. Back-action from GKP-p and from multiqubit in p x2

%First we build the covariance matrix

A = ones(n+3,n+3);

%channel part
for i=1:n
    A(i,i) = cstart*sigGKP^2 + sigGKP^2 + i * (sigGKP^2 + sigChannel^2) ;
    for j = i+1 : size(A,1)
        A(i,j) = cstart*sigGKP^2 + i * (sigGKP^2 + sigChannel^2) ;
        A(j,i) = cstart*sigGKP^2 + i * (sigGKP^2 + sigChannel^2) ;
    end
end

%The extra GKP
A(n+1,n+1) = A(n,n) + sigGKP^2  ;
    for j = n+2 : size(A,1)
        A(n+1,j) = A(n,j) + sigGKP^2;
        A(j,n+1) = A(j,n) + sigGKP^2;
    end

%c1 part
A(n+2,n+2) = A(n+1,n+1) + 2*sigGKP^2;
A(n+2,n+3) = A(n+1,n+3) + 2*sigGKP^2;
A(n+3,n+2) = A(n+3,n+1) + 2*sigGKP^2;
A(n+3,n+3) = A(n+2,n+2) + 2*sigGKP^2;

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