% Test JointErrorLikelihood

z_matrix_empty = zeros(7,2);

z_matrix_1 =   [0, 0, 0, 0, sqrt(pi)/3, 0, 0;
                0, 0, 0, sqrt(pi)/3, 0, 0, 0]';
            
z_matrix_2 =   [0, 0, 0, 0, sqrt(pi)/2, 0, 0;
                0, 0, 0, 0, 0, 0, 0;]';
             
error_vector_1 = [0, 0, 0, 1, 1, 0, 0];
error_vector_2 = [1, 0, 0, 0, 0, 0, 0];              
error_vector_3 = [0, 0, 0, 0, 1, 0, 0];
           

sig_empty = zeros(7,2);
sigCh = 0.3 * ones(7,2);
sigc1 = 0.2 *ones(7,2);
sigc2 = 0.15 *ones(7,2);


z_matrixCh_Cross = [0, 0, 0, 0, sqrt(pi)/2 - 0.05, 0, 0;
                    0, 0, 0, 0, 0, 0, 0]';
                
z_matrixc1_Cross = [0, 0, 0, 0, sqrt(pi)/2 - 0.05, 0, 0;
                    0, 0, 0, 0, 0, 0, 0]';

z_matrixc2_Cross = [0, 0, 0, sqrt(pi)/2 - 0.05, 0, 0, 0;
                    0, 0, 0, 0, 0, 0, 0]';
                


%% Test 1: channel
a = JointErrorLikelihood(error_vector_1, z_matrix_1,sigCh,z_matrix_empty,sig_empty,z_matrix_empty,sig_empty);
b = JointErrorLikelihood(error_vector_2, z_matrix_1,sigCh,z_matrix_empty,sig_empty,z_matrix_empty,sig_empty);
assert(a > b)

c = JointErrorLikelihood(error_vector_3, z_matrix_2,sigCh,z_matrix_empty,sig_empty,z_matrix_empty,sig_empty);
assert(round(c,5) == -1)

%% Test 2: c1
a = JointErrorLikelihood(error_vector_1, z_matrix_empty,sig_empty,z_matrix_1,sigc1,z_matrix_empty,sig_empty);
b = JointErrorLikelihood(error_vector_2, z_matrix_empty,sig_empty,z_matrix_1,sigc1,z_matrix_empty,sig_empty);
assert(a > b)

c = JointErrorLikelihood(error_vector_3, z_matrix_empty,sig_empty,z_matrix_2,sigc1,z_matrix_empty,sig_empty);
assert(round(c,5) == -1)

%% Test 3: c2
a = JointErrorLikelihood(error_vector_1, z_matrix_empty,sig_empty,z_matrix_empty,sig_empty,z_matrix_1,sigc2);
b = JointErrorLikelihood(error_vector_2, z_matrix_empty,sig_empty,z_matrix_empty,sig_empty,z_matrix_1,sigc2);
assert(a > b)

c = JointErrorLikelihood(error_vector_3, z_matrix_empty,sig_empty,z_matrix_empty,sig_empty,z_matrix_2,sigc2);
assert(round(c,5) == -1)

%% Test 4: cross case between channel, c1, c2
a = JointErrorLikelihood(error_vector_1, z_matrixCh_Cross,sigCh,z_matrixc1_Cross,sigc1,z_matrixc2_Cross,sigc2);
b = JointErrorLikelihood(error_vector_2, z_matrixCh_Cross,sigCh,z_matrixc1_Cross,sigc1,z_matrixc2_Cross,sigc2);
assert(a > b)


