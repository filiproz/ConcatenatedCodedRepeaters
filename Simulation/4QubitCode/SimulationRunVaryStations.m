%This script runs the simulation for the specified photon coupling
%efficiency eta0 and amount of ancilla GKP squeezing sigGKP.
%We also specify the error threshold "b" which determines the maximum
%relative error that we can tolerate. We run the simulation for different
%repeater placement configurations such that the total number of repeaters
%per 10 km ranges from 1 to 40.
%The output of the simulation is a 40x40x3 array. The 3 values in the last
%dimension define:
%1. The probability of at least one link between consecutive multi-qubit
%repeaters to have a logical error for the total distance of 1000 km 
%(we don't use this value in our later analysis but it is useful for direct
%comparison between different repeater placement configurations)
%2. The probability of logical Z error over a chain of 100 links, where a
%single link is a link between the consecutive multi-qubit repeaters.
%3. The probability of logical X error over a chain of 100 links, where a
%single link is a link between the consecutive multi-qubit repeaters.
%Then the first dimension gives the number of type-A repeaters per 10 km and
%the second dimension the number of all repeaters per 10 km.
%Note that the Z and X logical error probabilities correspond to
%different distances for different numbers of type-A repeaters per 10 km.

%Photon coupling efficiency:
eta_0 = 0.97;
%Fibre attenuation length:
L_0 = 22;
%Distance over which we define the repeater placement configurations:
Lfix = 10;
%Ancilla noise:
sigGKP = 0.09;
%Relative error threshold:
rel_err_thr = 0.1;
%Name the file for saving the variable:
filename = sprintf('Data4QubitCode_sigGKP%d_eta%d.mat', round(100*sigGKP), round(100*eta_0));

%Define the range of repeater placements configurations which we will simulate
AllStationsRange = 40;
MultiQubitStationsRange = 40;
MultiQubitStart = 1;

Data4QubitCode = ones(40,40,3);

for NMultiQubit = MultiQubitStart:MultiQubitStationsRange
    NMultiQubit
    for Nall = NMultiQubit:NMultiQubit:AllStationsRange
        %Start with 10 samples
        N = 10;
        Nall
        %Define loss over a link between two neighbouring repeaters
        gamma = 1 - eta_0 * exp(-Lfix / (Nall * L_0));
        %Run the simulation
        [psucc,Zerr,Xerr] = Code4Qubit(1, gamma, sigGKP, Nall/NMultiQubit, N);
        %
        %Estimate the error
        st_err_Z = sqrt( (Zerr * (1 - Zerr))/N );
        st_err_X = sqrt( (Xerr * (1 - Xerr))/N );
        %
        rel_err_Z = st_err_Z/Zerr;
        rel_err_X = st_err_X/Xerr;
        %
        %Test accuracy and whether to increase N, which we do if the
        %relative error was too large or there was exactly zero logical
        %errors
        while rel_err_Z > rel_err_thr || rel_err_X > rel_err_thr || Zerr == 0 || Xerr == 0 
            %Rerun the simulation with increased N, we reuse the previous
            %runs as the 10% of the new sample.
            N = 10*N
            [succ_est2,Zerr2,Xerr2] = Code4Qubit(1, gamma, sigGKP, Nall/NMultiQubit, 0.9 * N);
            psucc = 0.1 * psucc + 0.9 * succ_est2;
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
        Zerr
        Xerr
        Data4QubitCode(NMultiQubit,Nall,:) = [1 - psucc^NMultiQubit, Zerr,Xerr];
        %save(filename, 'Data4QubitCode') 
    end
end
%save(filename, 'Data4QubitCode')