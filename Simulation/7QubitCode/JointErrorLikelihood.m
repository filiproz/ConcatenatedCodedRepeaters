function joint_prob = JointErrorLikelihood(error_vector, z_matrixCh,sigCh,z_matrixc1,sigc1,z_matrixc2,sigc2)
%This function takes a vector defining location of errors, the
%corresponding z-values (analog syndromes) measured during the GKP correction as well as
%the corresponding sigma of the random displacement distribution for GKP to calculate the
%probability of the error events given by the error_vector (The error_vector
%is obtained by the syndrome measurement of the qubit code, and the errors
%arise from errors in the GKP correction).
%Here we are considering a scenario where there were multiple rounds of
%GKP correction before the multi-qubit correction. We calculate the probability
%that on the given qubit(s) there was an odd number of errors and even on the others.
%Each row of z_matrix corresponds to a different qubit and each column
%to a different GKP round.
%We distinguish separately the values for the communication channel, and
%two types of channels inside multi-qubit repeaters. One where there was a
%back-action from a multi-qubit correction (c1) and one where there wasn't
%(c2).
%We calculate the log of the probability as the resulting addition keeps
%more accurate track than multiplication

%Input:

%error_vector -     Row vector specifying qubits with errors by 1s, other
%                   entries 0
%z_matrix -         Matrix with measured analog syndromes, rows correspond
%                   to qubits, columns to GKP correction rounds, we
%                   distinguish the communication channel, c1 (channel with back-action
%                   from both GKP and multi-qubit stabiliser measurements) 
%                   and c2 (no back-action from multi-qubit correction, 
%                   only from GKP correction) cases.
%sig -              Matrix with Standard Deviations for the corresponding error channels
%                   for which the syndrome was z_matrix
%
%Output:
%
%joint_prob -       Log of the probability that given all the analog syndromes, the
%                   errors are given by error_vector 

joint_prob_temp = 0;
nqubit = length(error_vector);
for qubit_index = 1:nqubit
     if(error_vector(qubit_index) == 1)
         % we use the formula (1 - (1-2p1)(1-2p2)...)/2 for the probability
         % of odd number of errors (an error). We take log2 and log2(1/2) = -1
        joint_prob_temp = joint_prob_temp - 1 +  log2(1 - prod(1 - 2 * ErrorLikelihood(z_matrixCh(qubit_index,:), sigCh(qubit_index,:)) ) ... 
        * prod(1 - 2 * ErrorLikelihood(z_matrixc1(qubit_index,:), sigc1(qubit_index,:)) ) * prod(1 - 2 * ErrorLikelihood(z_matrixc2(qubit_index,:), sigc2(qubit_index,:)) ) );
     else
        % we use the formula (1 + (1-2p1)(1-2p2)...)/2 for the probability
        % of even number of errors (no error). We take log2 and log2(1/2) = -1
        joint_prob_temp = joint_prob_temp - 1 +  log2(1 + prod(1 - 2 * ErrorLikelihood(z_matrixCh(qubit_index,:), sigCh(qubit_index,:)) ) ... 
        * prod(1 - 2 * ErrorLikelihood(z_matrixc1(qubit_index,:), sigc1(qubit_index,:)) ) * prod(1 - 2 * ErrorLikelihood(z_matrixc2(qubit_index,:), sigc2(qubit_index,:)) ) );
    
    end

end

joint_prob = joint_prob_temp;