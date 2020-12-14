% Test JointErrorLikelihood

z_matrix_empty = zeros(7,2);

z_matrix_1 =   [0, 0, 0, 0, sqrt(pi)/3, 0, 0;
                0, 0, 0, sqrt(pi)/3, 0, 0, 0]';
            
z_matrix_2 =   [0, 0, 0, 0, sqrt(pi)/2, 0, 0;
                0, 0, 0, 0, 0, 0, 0;]';
             
error_vector_1 = [0, 0, 0, 1, 1, 0, 0];
error_vector_2 = [1, 0, 0, 0, 0, 0, 0];              
error_vector_3 = [0, 0, 0, 0, 1, 0, 0];
           

sig_empty = 0;
sigCh = 0.3;

%% Test 1: channel
a = JointErrorLikelihood(error_vector_1, z_matrix_1,sigCh);
b = JointErrorLikelihood(error_vector_2, z_matrix_1,sigCh);
assert(a > b)

c = JointErrorLikelihood(error_vector_3, z_matrix_2,sigCh);
assert(round(c,5) == -1)