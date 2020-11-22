function parityVector = CorrectMultiQubitParity(parityVector, QubitWithErrorVector, perrorGKPCorrMaxVector)
%This function corrects the parity vector of the multiqubit correction to
%account for possible errors in the intermediate GKP corrections in such a
%way that those intermediate errors are also reflected by the stabiliser
%values.

%Inputs:

% parityVector -            vector of raw parity values
% QubitWithErrorVector -    vector of most likely qubits with intermediate
%                           errors for each of the 3 measured stabilisers.
% perrorGKPCorrMaxVector -  vector of error probabilities on those qubits
%                           corresponding to QubitWithErrorVector for the 3
%                           stabilisers

% Output:

%parityVector -            vector of updated parity values

[perrorGKPCorrMaxVectorMax,ind] = max(perrorGKPCorrMaxVector);

if perrorGKPCorrMaxVectorMax > 0
    QubitWithError = QubitWithErrorVector(ind);
    if QubitWithError == 3
        if QubitWithErrorVector(2) == 0
            parityVector(2) = mod(parityVector(2) + 1,2);
        end
    end
    if QubitWithError == 5 || QubitWithError == 6
        if QubitWithErrorVector(1) == 0
            parityVector(1) = mod(parityVector(1) + 1,2);
        end
    end
    if QubitWithError == 7
        if QubitWithErrorVector(1) == 0 && QubitWithErrorVector(2) == 0
            parityVector(1) = mod(parityVector(1) + 1,2);
            parityVector(2) = mod(parityVector(2) + 1,2);
        elseif QubitWithErrorVector(1) == 0 && QubitWithErrorVector(2) ~= 0
            parityVector(1) = mod(parityVector(1) + 1,2);
        end
    end
end