function DeltasOut = ChannelWithGKPCorr(quad, DeltasIn, sigChannel, sigGKP, n)
%This function applies the channel noise followed by GKP error correction n
%times in the specified quadrature.

%Input:

%quad -         which quadrature
    % 0 - q
    % 1 - p
%DeltasIn -     deltas in the chosen quadrature to which we will apply noise and GKP correction
%sigChannel -   standard deviation of the channel noise
%sigGKP -       standard deviation of the ancilla GKPs
%n -            number of times we do the channel + GKP correction
%
%Output:
%
%DeltasOut -    deltas in the chosen quadrature after the n channel + GKP
%               corrections


%Assign the optimal rescaling coefficents
if sigGKP ==0
    c= 1;
else
    c = (-sigGKP^2 - sigChannel^2 + sqrt((sigGKP^2 + sigChannel^2) * (5*sigGKP^2 + sigChannel^2)))/(2*sigGKP^2);
end

%Generate random number for the noise
shiftsChannel = normrnd(0,sigChannel,1,n);
shiftsAncilla = normrnd(0,sigGKP,1,2*n);

deltas_temp = DeltasIn;

if quad == 0
    %Now we will apply and GKP correct the errors with SD sigma n times:
    for k = 1:n
        %Channel in q:
        deltas_temp = deltas_temp + shiftsChannel(:,k);
        %Measure the q stabiliser
        z = ReminderMod(deltas_temp + shiftsAncilla(:,k),sqrt(pi));
        %Correct the q-error using the given optimal c
        deltas_temp = deltas_temp - c*z;
        %Induce error in q from the sum-gate for measuring p stabiliser:
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
        z = ReminderMod(deltas_temp + shiftsAncilla(:,k),sqrt(pi));
        %Correct the p-errors using the given optimal c's
        deltas_temp = deltas_temp - c*z;
    end
end

DeltasOut = deltas_temp;



   