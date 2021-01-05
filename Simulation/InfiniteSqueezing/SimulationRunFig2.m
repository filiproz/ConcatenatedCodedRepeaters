%This programme generates data for FIG. 2 in the paper.
%That is, it considers a single link with varying loss gamma and GKP and
%multi-qubit correction at the end of the link. 
%Correction is implemented using infinitely squeezed ancillas so gamma is 
% the only source of noise (alternatively, one can also think that perfect 
%photon coupling efficiency is considered). The data corresponds to
%logical error probability (any type of Pauli error) vs gamma.
%%We also specify the error threshold "b" which determines the maximum
%relative error that we can tolerate.

%Graining of the gamma loss interval into m data points
m = 100; 
%%Relative error threshold:
rel_err_thr = 0.1;

Gamma_4Q= zeros(m,4);
Gamma_7Q= zeros(m,4);
Gamma_7QNoAnalogInfo= zeros(m,4);
Gamma_GKPRepChain= zeros(m,4);
gammaRange = 0.08 : 0.12/m : 0.2;

for idx = 1:numel(gammaRange)
    gamma = gammaRange(idx);
    N=10;
    [psucc,Zerr,Xerr] = Code4Qubit(1, gamma,1, N);
    st_err_Z = sqrt( (Zerr * (1 - Zerr))/N );
    st_err_X = sqrt( (Xerr * (1 - Xerr))/N );
    %
    rel_err_Z = st_err_Z/Zerr;
    rel_err_X = st_err_X/Xerr;
    while rel_err_Z > rel_err_thr || rel_err_X > rel_err_thr || Zerr == 0 || Xerr == 0
        N = 10*N;
        [psucc2,Zerr2,Xerr2] = Code4Qubit(1, gamma,1, 0.9*N);
        psucc = 0.1 * psucc + 0.9 * psucc2;
        Zerr = 0.1 * Zerr + 0.9 * Zerr2;
        Xerr = 0.1 * Xerr + 0.9 * Xerr2;
        %
        st_err_Z = sqrt( (Zerr * (1 - Zerr))/N );
        st_err_X = sqrt( (Xerr * (1 - Xerr))/N );
        %
        rel_err_Z = st_err_Z/Zerr;
        rel_err_X = st_err_X/Xerr;
        %
    end
    Gamma_4Q(idx,:) = [gamma,1-psucc,Zerr,Xerr]
end

for idx = 1:numel(gammaRange)
    gamma = gammaRange(idx);
    N=10;
    [psucc,Zerr,Xerr] = Code7Qubit(1, gamma,1, N);
    st_err_Z = sqrt( (Zerr * (1 - Zerr))/N );
    st_err_X = sqrt( (Xerr * (1 - Xerr))/N );
    %
    rel_err_Z = st_err_Z/Zerr;
    rel_err_X = st_err_X/Xerr;
    while rel_err_Z > rel_err_thr || rel_err_X > rel_err_thr || Zerr == 0 || Xerr == 0
        N = 10*N;
        [psucc2,Zerr2,Xerr2] = Code7Qubit(1, gamma,1, 0.9*N);
        psucc = 0.1 * psucc + 0.9 * psucc2;
        Zerr = 0.1 * Zerr + 0.9 * Zerr2;
        Xerr = 0.1 * Xerr + 0.9 * Xerr2;
        %
        st_err_Z = sqrt( (Zerr * (1 - Zerr))/N );
        st_err_X = sqrt( (Xerr * (1 - Xerr))/N );
        %
        rel_err_Z = st_err_Z/Zerr;
        rel_err_X = st_err_X/Xerr;
        %
    end
    Gamma_7Q(idx,:) = [gamma,1-psucc,Zerr,Xerr]
end

for idx = 1:numel(gammaRange)
    gamma = gammaRange(idx);
    N=10;
    [psucc,Zerr,Xerr] = Code7QubitNoAnalogInfo(1, gamma,1, N);
    st_err_Z = sqrt( (Zerr * (1 - Zerr))/N );
    st_err_X = sqrt( (Xerr * (1 - Xerr))/N );
    %
    rel_err_Z = st_err_Z/Zerr;
    rel_err_X = st_err_X/Xerr;
    while rel_err_Z > rel_err_thr || rel_err_X > rel_err_thr || Zerr == 0 || Xerr == 0
        N = 10*N;
        [psucc2,Zerr2,Xerr2] = Code7QubitNoAnalogInfo(1, gamma,1, 0.9*N);
        psucc = 0.1 * psucc + 0.9 * psucc2;
        Zerr = 0.1 * Zerr + 0.9 * Zerr2;
        Xerr = 0.1 * Xerr + 0.9 * Xerr2;
        %
        st_err_Z = sqrt( (Zerr * (1 - Zerr))/N );
        st_err_X = sqrt( (Xerr * (1 - Xerr))/N );
        %
        rel_err_Z = st_err_Z/Zerr;
        rel_err_X = st_err_X/Xerr;
        %
    end
    Gamma_7QNoAnalogInfo(idx,:) = [gamma,1-psucc,Zerr,Xerr]
end

for idx = 1:numel(gammaRange)
    gamma = gammaRange(idx);
    N=10;
    [psucc,Zerr,Xerr] = GKPRepeaterChain(1, gamma, N);
    st_err_Z = sqrt( (Zerr * (1 - Zerr))/N );
    st_err_X = sqrt( (Xerr * (1 - Xerr))/N );
    %
    rel_err_Z = st_err_Z/Zerr;
    rel_err_X = st_err_X/Xerr;
    while rel_err_Z > rel_err_thr || rel_err_X > rel_err_thr || Zerr == 0 || Xerr == 0
        N = 10*N;
        [psucc2,Zerr2,Xerr2] = GKPRepeaterChain(1, gamma, 0.9*N);
        psucc = 0.1 * psucc + 0.9 * psucc2;
        Zerr = 0.1 * Zerr + 0.9 * Zerr2;
        Xerr = 0.1 * Xerr + 0.9 * Xerr2;
        %
        st_err_Z = sqrt( (Zerr * (1 - Zerr))/N );
        st_err_X = sqrt( (Xerr * (1 - Xerr))/N );
        %
        rel_err_Z = st_err_Z/Zerr;
        rel_err_X = st_err_X/Xerr;
        %
    end
    Gamma_GKPRepChain(idx,:) = [gamma,1-psucc,Zerr,Xerr]
end

save('DataFig2.mat', 'Gamma_4Q', 'Gamma_7Q', 'Gamma_7QNoAnalogInfo','Gamma_GKPRepChain')