%Test Correct MultiQubitParity

parityVector = [1,1,0];

%% Test1: No intermediate error 
QubitWithErrorVector = [0,0,0];
perrorGKPCorrMaxVector = [0,0,0];
parityVectorCorrected = CorrectMultiQubitParity(parityVector, QubitWithErrorVector, perrorGKPCorrMaxVector);
assert(all(parityVectorCorrected == parityVector))

%% Test2: Intermediate error on qubit 7 after first X1
QubitWithErrorVector = [7,0,0];
perrorGKPCorrMaxVector = [0.2,0,0];
parityVectorCorrected = CorrectMultiQubitParity(parityVector, QubitWithErrorVector, perrorGKPCorrMaxVector);
assert(all(parityVectorCorrected == parityVector))

%% Test3: Intermediate error on qubit 7 after second X2
QubitWithErrorVector = [0,0,7];
perrorGKPCorrMaxVector = [0,0,0.2];
parityVectorCorrected = CorrectMultiQubitParity(parityVector, QubitWithErrorVector, perrorGKPCorrMaxVector);
assert(all(parityVectorCorrected == [0,0,0]))

%% Test4: Intermediate error on qubit 5 after second X1
QubitWithErrorVector = [0,0,5];
perrorGKPCorrMaxVector = [0,0,0.2];
parityVectorCorrected = CorrectMultiQubitParity(parityVector, QubitWithErrorVector, perrorGKPCorrMaxVector);
assert(all(parityVectorCorrected == [0,1,0]))

%% Test5: Intermediate error on qubit 7 after first X3
QubitWithErrorVector = [7,7,7];
perrorGKPCorrMaxVector = [0.3,0.4,0.2];
parityVectorCorrected = CorrectMultiQubitParity(parityVector, QubitWithErrorVector, perrorGKPCorrMaxVector);
assert(all(parityVectorCorrected == [1,1,0]))
