%This programme generates data for FIG. 2 in the paper.
%That is, it considers a single link with varying loss gamma and GKP and
%multi-qubit correction at the end of the link. 
%Correction is implemented using infinitely squeezed ancillas so gamma is 
% the only source of noise (alternatively, one can also think that perfect 
%photon coupling efficiency is considered). The data corresponds to
%logical error probability (any type of Pauli error) vs gamma.

%Graining of the gamma loss interval into m data points
m = 100; 
%%Relative error threshold:
rel_err_thr = 0.1;

Gamma_4Q= zeros(m,2);
Gamma_7Q= zeros(m,2);
Gamma_7QNoAnalogInfo= zeros(m,2);
Gamma_GKPRepChain= zeros(m,2);
gammaRange = 0.08 : 0.12/m : 0.2;

for idx = 1:numel(gammaRange)
    gamma = gammaRange(idx);
    N=10;
    error_est = 1 - Code4Qubit(1, gamma,1, N);
    st_err = sqrt( (error_est * (1 - error_est))/N );
    %
    rel_err = st_err/error_est;
    while rel_err > rel_err_thr || error_est==0
        N = 10*N;
        error_est2 = 1 - Code4Qubit(1, gamma,1, 0.9*N);
        error_est = 0.1 * error_est + 0.9 * error_est2;
        %
        st_err = sqrt( (error_est * (1 - error_est))/N );
        %
        rel_err = st_err/error_est;
        %
    end
    Gamma_4Q(idx,:) = [gamma,error_est]
end

for idx = 1:numel(gammaRange)
    gamma = gammaRange(idx);
    N=10;
    error_est = 1 - Code7Qubit(1, gamma,1, N);
    st_err = sqrt( (error_est * (1 - error_est))/N );
    %
    rel_err = st_err/error_est;
    while rel_err > rel_err_thr || error_est==0
        N = 10*N;
        error_est2 = 1 - Code7Qubit(1, gamma,1, 0.9*N);
        error_est = 0.1 * error_est + 0.9 * error_est2;
        %
        st_err = sqrt( (error_est * (1 - error_est))/N );
        %
        rel_err = st_err/error_est;
        %
    end
    Gamma_7Q(idx,:) = [gamma,error_est]
end

for idx = 1:numel(gammaRange)
    gamma = gammaRange(idx);
    N=10;
    error_est = 1 - Code7QubitNoAnalogInfo(1, gamma,1, N);
    st_err = sqrt( (error_est * (1 - error_est))/N );
    %
    rel_err = st_err/error_est;
    while rel_err > rel_err_thr  || error_est==0
        N = 10*N;
        error_est2 = 1 - Code7QubitNoAnalogInfo(1, gamma,1, 0.9*N);
        error_est = 0.1 * error_est + 0.9 * error_est2;
        %
        st_err = sqrt( (error_est * (1 - error_est))/N );
        %
        rel_err = st_err/error_est;
        %
    end
    Gamma_7Q_NoAnalogInfo(idx,:) = [gamma,error_est]
end

for idx = 1:numel(gammaRange)
    gamma = gammaRange(idx);
    N=10;
    error_est = 1 - GKPRepeaterChain(1, gamma, N);
    st_err = sqrt( (error_est * (1 - error_est))/N );
    %
    rel_err = st_err/error_est;
    while rel_err > rel_err_thr  || error_est==0
        N = 10*N;
        error_est2 = 1 - GKPRepeaterChain(1, gamma, 0.9*N);
        error_est = 0.1 * error_est + 0.9 * error_est2;
        %
        st_err = sqrt( (error_est * (1 - error_est))/N );
        %
        rel_err = st_err/error_est;
        %
    end
    Gamma_GKPRepChain(idx,:) = [gamma,error_est]
end

save('DataFig2.mat', 'Gamma_4Q', 'Gamma_7Q', 'Gamma_7Q_NoAnalogInfo','Gamma_GKPRepChain')