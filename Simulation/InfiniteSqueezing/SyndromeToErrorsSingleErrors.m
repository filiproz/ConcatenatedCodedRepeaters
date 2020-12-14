function error_matrix = SyndromeToErrorsSingleErrors(syndrome_vec, single_error_table, nqubit)
%This function establishses all the possible single-qubit errors
%consistent with the observed syndrome_vec for the nqubit code where the
%look up table for single qubit errors is provided.
%The single_error_table is a 2-D array with columns being different
%stabilisers and rows different single qubit errors.

%Inputs:

%syndrome_vec -        row vector with measured stabiliser outcomes, each entry of
%                       of the vector must be 0 or 1.
%single_error_table -   parity check matrix, columns correspond to different stabilisers
%                       and rows to the single-qubit errors, e.g.
%                       row one gives stabiliser outcomes if the error
%                       was on the first qubit etc.
%nqubit -               Number of physical qubits in the code
%
%Output:
%
%error_matrix -         Matrix with possible errors consistent with the
%                       syndrome_vec. Each row corresponds to a different
%                       possible set of errors and a 1 in a given column
%                       indicates an error on the qubit given by the column
%                       number
        
error_matrix = [];

%We check whether our syndrome_vec corresponds to any of the rows of
    %the parity check table, if yes, then we have an error on the qubit
    %given by the row. Therefore we create a row vector with zeros and a
    %single one at the column corresponding to that error. This row vector
    %is added to the error_matrix.
for i = 1:nqubit
	if(single_error_table(i,:) == syndrome_vec)
		error_vector = zeros(1,nqubit);
		error_vector(i) = 1;
		error_matrix = cat(1,error_matrix,error_vector);
    end
end