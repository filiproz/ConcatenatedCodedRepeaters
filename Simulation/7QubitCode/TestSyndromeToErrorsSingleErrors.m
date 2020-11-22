% Test SyndrometoErrorsSingleErrors
single_error_table = [ 0, 0, 0, 1, 1, 1, 1;
                      0, 1, 1, 0, 0, 1, 1;
                      1, 0, 1, 0, 1, 0, 1]';
nqubit = 7;
syndrome_vec1 = [0,0,1];
syndrome_vec2 = [0,1,0];
syndrome_vec3 = [0,1,1];
syndrome_vec4 = [1,0,0];
syndrome_vec5 = [1,0,1];
syndrome_vec6 = [1,1,0];
syndrome_vec7 = [1,1,1];

errorMatrix = eye(7);

%% Test1: all single errors
error = SyndromeToErrorsSingleErrors(syndrome_vec1, single_error_table, nqubit);
assert(all(error == errorMatrix(1,:)))

error = SyndromeToErrorsSingleErrors(syndrome_vec2, single_error_table, nqubit);
assert(all(error == errorMatrix(2,:)))

error = SyndromeToErrorsSingleErrors(syndrome_vec3, single_error_table, nqubit);
assert(all(error == errorMatrix(3,:)))

error = SyndromeToErrorsSingleErrors(syndrome_vec4, single_error_table, nqubit);
assert(all(error == errorMatrix(4,:)))

error = SyndromeToErrorsSingleErrors(syndrome_vec5, single_error_table, nqubit);
assert(all(error == errorMatrix(5,:)))

error = SyndromeToErrorsSingleErrors(syndrome_vec6, single_error_table, nqubit);
assert(all(error == errorMatrix(6,:)))

error = SyndromeToErrorsSingleErrors(syndrome_vec7, single_error_table, nqubit);
assert(all(error == errorMatrix(7,:)))