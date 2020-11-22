function [cVecRealtime124,MinVar124,cVecRealtime356,MinVar356,cVecRealtime7,MinVar7] = OptimalCs7QubitCodeQuadQ(sigChannel,sigGKP,cstart124,cstart356,cstart7,n)
%This function solves for the optimal real-time GKP rescaling coefficients c's for the q-quadrature for the
%7Qubit Code

%Input:

%sigChannel -   standard deviation of the communication channel between
%               repeaters
%sigGKP -       standard deviation of the ancilla errors
%cstart -       the optimal rescaling coefficient at the end of the previous round,
%               so it quantifies the residual displacement at the beginning of the simulation
%               as sqrt(cstart) * sigGKP, there are separate values for qubits 1,2,4; 3,5,6;
%               and 7 respectively 
%n -            number of GKP corrections before a multiqubit correction
%
%Output:
%
%cVecRealtime - A vector of optimal real time rescaling coefficients, there are separate values for qubits 1,2,4; 3,5,6;
%               and 7 respectively
%MinVar -       Minimised variance after the last GKP correction, there are separate values for qubits 1,2,4; 3,5,6;
%               and 7 respectively

%For the q-quadrature we have the following corrections for which we want to determine c:
%1. Back-action from GKP-p and fibre channel n times
%2. Back action from GKP-p for the extra GKP
%3. Back-action from GKP-p and from multiqubit in p x6 for qubit 7, x4 for
%qubits 3,5,6 x2 for qubits 1,2,4
%4. Back action from GKP-p for the extra GKP
%5. Back-action from GKP-p x5 for qubit 7, x3 for
%qubits 3,5,6, x1 for qubits 1,2,4

%For qubits, 1,2,4

%First we build the covariance matrix

A = ones(n+5,n+5);

%channel part
for i=1:n
    A(i,i) = cstart124*sigGKP^2 + sigGKP^2 + i * (sigGKP^2 + sigChannel^2) ;
    for j = i+1 : size(A,1)
        A(i,j) = cstart124*sigGKP^2 + i * (sigGKP^2 + sigChannel^2) ;
        A(j,i) = cstart124*sigGKP^2 + i * (sigGKP^2 + sigChannel^2) ;
    end
end

%Extra GKP
A(n+1,n+1) = A(n,n) + sigGKP^2 ;
    for j = n+2 : size(A,1)
        A(n+1,j) = A(n,j) + sigGKP^2;
        A(j,n+1) = A(j,n) + sigGKP^2;
    end

%c1 part (channel with back-action from both GKP and multi-qubit stabiliser measurements)
for i = n+2:n+3
    A(i,i) = A(i-1,i-1) + 2 * sigGKP^2 ;
    for j = i+1 : size(A,1)
        A(i,j) = A(i-1,j) + 2 * sigGKP^2 ;
        A(j,i) = A(j,i-1) + 2 * sigGKP^2 ;
    end
end
%c2 part (no back-action from multi-qubit correction, only from GKP
%correction)
A(n+4,n+4) = A(n+3,n+3) + sigGKP^2;
A(n+5,n+4) = A(n+5,n+3) + sigGKP^2;
A(n+4,n+5) = A(n+3,n+5) + sigGKP^2;
A(n+5,n+5) = A(n+4,n+4) + sigGKP^2;

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
MinVar124 = a - (1/4) * transpose(b)*inv(A)*b;

%Now we find the Real Time values of c:
cVecRealtime124 = CVecRealTimeConvert(cPostVec);

%For qubits, 3,5,6

%First we build the covariance matrix

A = ones(n+9,n+9);

%channel part
for i=1:n
    A(i,i) = cstart356*sigGKP^2 + sigGKP^2 + i * (sigGKP^2 + sigChannel^2) ;
    for j = i+1 : size(A,1)
        A(i,j) = cstart356*sigGKP^2 + i * (sigGKP^2 + sigChannel^2) ;
        A(j,i) = cstart356*sigGKP^2 + i * (sigGKP^2 + sigChannel^2) ;
    end
end

%Extra GKP
A(n+1,n+1) = A(n,n) + sigGKP^2 ;
    for j = n+2 : size(A,1)
        A(n+1,j) = A(n,j) + sigGKP^2;
        A(j,n+1) = A(j,n) + sigGKP^2;
    end

%The c1 part
for i = n+2:n+5
    A(i,i) = A(i-1,i-1) + 2 * sigGKP^2 ;
    for j = i+1 : size(A,1)
        A(i,j) = A(i-1,j) + 2 * sigGKP^2 ;
        A(j,i) = A(j,i-1) + 2 * sigGKP^2 ;
    end
end


%The c2 part
for i = n+6 : n+8
    A(i,i) = A(i-1,i-1) + sigGKP^2 ;
    for j = i+1 : size(A,1)
        A(i,j) = A(i-1,j) + sigGKP^2 ;
        A(j,i) = A(j,i-1) + sigGKP^2 ;
    end
end
A(n+9,n+9) = A(n+8,n+8) + sigGKP^2 ;

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
MinVar356 = a - (1/4) * transpose(b)*inv(A)*b;

%Now we find the Real Time values of c:
cVecRealtime356 = CVecRealTimeConvert(cPostVec);




%For qubit 7

%First we build the covariance matrix

A = ones(n+13,n+13);

%channel part
for i=1:n
    A(i,i) = cstart7*sigGKP^2 + sigGKP^2 + i * (sigGKP^2 + sigChannel^2) ;
    for j = i+1 : size(A,1)
        A(i,j) = cstart7*sigGKP^2 + i * (sigGKP^2 + sigChannel^2) ;
        A(j,i) = cstart7*sigGKP^2 + i * (sigGKP^2 + sigChannel^2) ;
    end
end

%Extra GKP
A(n+1,n+1) = A(n,n) + sigGKP^2 ;
    for j = n+2 : size(A,1)
        A(n+1,j) = A(n,j) + sigGKP^2;
        A(j,n+1) = A(j,n) + sigGKP^2;
    end

%The c1 part
for i = n+2:n+7
    A(i,i) = A(i-1,i-1) + 2 * sigGKP^2 ;
    for j = i+1 : size(A,1)
        A(i,j) = A(i-1,j) + 2 * sigGKP^2 ;
        A(j,i) = A(j,i-1) + 2 * sigGKP^2 ;
    end
end


%The c2 part
for i = n+8 : n+12
    A(i,i) = A(i-1,i-1) + sigGKP^2 ;
    for j = i+1 : size(A,1)
        A(i,j) = A(i-1,j) + sigGKP^2 ;
        A(j,i) = A(j,i-1) + sigGKP^2 ;
    end
end
A(n+13,n+13) = A(n+12,n+12) + sigGKP^2 ;

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
MinVar7 = a - (1/4) * transpose(b)*inv(A)*b;

%Now we find the Real Time values of c:
cVecRealtime7 = CVecRealTimeConvert(cPostVec);

end

