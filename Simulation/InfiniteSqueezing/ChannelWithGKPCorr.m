function [qZmatrix, pZmatrix, Xflips, Zflips] = ChannelWithGKPCorr(NQubit,sig,n)
%This function applies the channel noise followed by GKP error correction n
%times when the GKP correction is implemented using infinitely squeezed
%ancillas

%Input:

%NQubit -               number of physical qubits in the higher level encoding
%sig -                  standard deviation of the channel noise
%n -                    number of times we do the channel + GKP correction
%
%Output:
%
%qZmatrix, pZmatrix -   matrix with analog syndrome information, rows corrspond to
%                       qubits, n columns to n times
%Xflips, Zflips -       logical GKP flip errors after the chain of n
%                       channels and GKP corrections


%Store analog information qZs and pZs and the errors after the whole chain of n GKP stations:
qZmatrix = zeros(NQubit, n);
pZmatrix = zeros(NQubit, n);

Xflips = zeros(NQubit,1);
Zflips = zeros(NQubit,1);

%Define the vectors of q and p random shifts with SD sigma:
qshifts = normrnd(0,sig,NQubit,n);
pshifts = normrnd(0,sig,NQubit,n);


%Now we will apply and GKP correct the errors with SD sigma n times:
for k = 1:n

    %Find the measured value z in the interval from -sqrt(pi)/2 to +sqrt(pi)/2:
    qZmatrix(:,k) = ReminderMod(qshifts(:,k),sqrt(pi));
    pZmatrix(:,k) = ReminderMod(pshifts(:,k),sqrt(pi));

    %Find the multiplicative factor n that determines whether there was an
    %error
    qns = round((qshifts(:,k) - qZmatrix(:,k))/sqrt(pi));
    pns = round((pshifts(:,k) - pZmatrix(:,k))/sqrt(pi));

    %Determine X errors after GKP correction:
    for i = 1:NQubit
        if mod(qns(i),2) == 1
            Xflips(i) = mod(Xflips(i) + 1, 2);
        end
    end

    %Determine Z errors after GKP correction:    
    for i = 1:NQubit
        if mod(pns(i),2) == 1
            Zflips(i) = mod(Zflips(i) + 1, 2);
        end
    end
end