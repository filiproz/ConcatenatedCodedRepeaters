function [Zmatrix, DeltasOut, xOut] = ChannelWithGKPCorr4QubitCode(quad, DeltasIn, sigChannel,sigGKP, n,cVecRealtime,x)
%This function applies the channel noise followed by GKP error correction n
%times for the [[4,1,2]] code scheme

%quad -         which quadrature
    % 0 - q
    % 1 - p
%DeltasIn -     deltas in the chosen quadrature to which we will apply noise and GKP correction
%sigChannel -   standard deviation of the channel noise
%sigGKP -       standard deviation of the ancilla GKPs
%n -            number of times we do the channel + GKP correction
%cVecRealtime - vector of optimal rescaling factors c
%x -            counter of c's to choose the correct c's from cVecRealtime
%
%Output
%
%Zmatrix -      matrix with analog syndrome information, rows corrspond to
%               qubits, n columns to n times
%DeltasOut -    deltas in the chosen quadrature after the n channel + GKP
%               corrections
%xOut -         counter of c's at the output
%

NQbit = 4;
%Store qZs and pZs and the errors after the whole chain of n GKP stations:
Zmatrix = zeros(NQbit, n);

%Generate random number for the noise
shiftsChannel = normrnd(0,sigChannel,NQbit,n);
shiftsAncilla = normrnd(0,sigGKP,NQbit,2*n);

deltas_temp = DeltasIn;

if quad == 0
    %Now we will apply and GKP correct the errors with SD sigma n times:
    for k = 1:n
        %Channel in q:
        deltas_temp = deltas_temp + shiftsChannel(:,k);
        %Measure the q stabilisers
        Zmatrix(:,k) = ReminderMod(deltas_temp + shiftsAncilla(:,k),sqrt(pi));
        %Correct the q-errors using the given optimal c's
        c = cVecRealtime(x)*ones(NQbit,1);
        deltas_temp = deltas_temp - c.*Zmatrix(:,k);
        x = x + 1;
        %Induce error in q from the sum-gate for measuring p stabilisers:
        deltas_temp = deltas_temp - shiftsAncilla(:,n+k);
    end
elseif quad == 1
    %Now we will apply and GKP correct the errors with SD sigma n times:
    for k = 1:n
        %Channel in p:
        deltas_temp = deltas_temp + shiftsChannel(:,k);
        %Induce error in p from the sum-gate for measuring q stabilisers:
        deltas_temp = deltas_temp - shiftsAncilla(:,n+k);
        %Measure the p-stabilisers
        Zmatrix(:,k) = ReminderMod(deltas_temp + shiftsAncilla(:,k),sqrt(pi));
        %Correct the p-errors using the given optimal c's
        c = cVecRealtime(x)*ones(NQbit,1);
        deltas_temp = deltas_temp - c.*Zmatrix(:,k);
        x = x + 1;
    end
end

DeltasOut = deltas_temp;
xOut = x;



   