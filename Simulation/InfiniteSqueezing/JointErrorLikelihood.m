function joint_prob = JointErrorLikelihood(error_vector, z_matrix, sig)
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
%We calculate the log of the probability as the resulting addition keeps
%more accurate track than multiplication

%Input:

%error_vector -     Row vector specifying qubits with errors by 1s, other
%                   entries 0
%z_matrix -         Matrix with measured analog syndromes, rows correspond
%                   to qubits, columns to GKP correction rounds
%sig -              Standard deviation for the error channels
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
        joint_prob_temp = joint_prob_temp - 1 + log2(1 - prod(1 - 2 * ErrorLikelihood(z_matrix(qubit_index,:), sig) ));
     
     else
        % we use the formula (1 + (1-2p1)(1-2p2)...)/2 for the probability
        % of even number of errors (no error). We take log2 and log2(1/2) = -1
        joint_prob_temp = joint_prob_temp - 1 + log2(1 + prod(1 - 2 * ErrorLikelihood(z_matrix(qubit_index,:), sig) )); 
            
    end
end

joint_prob = joint_prob_temp;