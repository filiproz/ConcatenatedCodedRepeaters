# ConcatenatedCodedRepeaters

This is the code used to generate the data for the article arXiv:2011.15076

## Content
The code consists of two parts:

1. *Mathematica* notebook `AnalyticalGKPRepChain.nb` that implements the analytical model of the GKP repeater chain.
2.  *Matlab* simulation of the GKP repeater chain and the concatenated-coded architectures based on the [[4,1,2]] code and the [[7,1,3]] code.

## *Mathematica* code

The *Mathematica* notebook finds the largest distance for which secret-key rate per mode stays above 0.01 when optimising over all the repeater placement configurations for the GKP repeater chain. The optimisation is done for multiple specified values of GKP squeezing and photon coupling efficiency. The search for the achievable distance is implemented through 10 iterations of the binary search method over distances in the range of [0,10000] km.

## *Matlab* code

The *Matlab* code is divided into two folders:

1. `Simulation` containing the code that generates the data.
2.  `DataAnalysis` containing tools to analyse the generated data in terms of maximising secret-key rate per mode and minimising the cost function.

Each of the two folders contains separate tools for the GKP repeater chain, the concatenated-coded architecture based on the [[4,1,2]] code and the concatenated-coded architecture based on the [[7,1,3]] code. Additionally, there is a separate piece of code in the folder `InfiniteSqueezing` which runs a faster and simplified simulation for the case when ideal error correction is considered.

### Simulation

The main piece of code are the functions `GKPRepeaterChain.m`, `Code4Qubit.m` and `Code7Qubit.m` for the 3 respective architectures in the 3 respective folders. They run a simulation in which they track the errors in the two quadratures over the chain of 100 elementary links and then extract the logical error probabilities. Here by elementary link we refer to a link between consecutive GKP repeaters for the GKP repeater chain and to a link between consecutive multi-qubit repeaters for the concatenated-coded schemes. The input to these functions include the amount of noise or loss in the communication channel, the amount of GKP squeezing, the number of channels followed by GKP corrections before the multi-qubit correction for the concatenated-coded schemes (that is the number of all repeaters until and including the multi-qubit repeater) and the number of simulation runs. The output of the function provides the probability of success, that is the probability of no logical error as well as the probability of a logical X and logical Z flips for the chain of 100 such elementary links. Note that these are independent probabilities of X and Z flips, that is in the resulting Pauli channel the probability of the logical X would be the probability that there was an X flip but no Z flip etc.

The simulation is run through the script `SimulationRunVaryStations.m` which considers specific loss channel due to optical fibre with given attenuation length as well as given photon coupling efficiency. The script considers multiple different repeater placement configurations with different number of type-A and type-B repeaters per 10 km. The scripts also makes sure that the simulation runs until a desired accuracy level is obtained. The output corresponds to an array with logical X and Z flip probabilities over a chain of 100 elementary links for all the considered repeater placement configurations. Note that depending on the repeater configuration, such 100 links corresponds to different distance. Therefore additionally the output also includes an array with the probability of any logical error (occuring in at least one elementary link) for a fixed distance of 1000 km for all the repeater configurations.

Additionally the folder `InfiniteSqueezing` also includes the functions `GKPRepeaterChain.m`, `Code4Qubit.m` and `Code7Qubit.m` which run a simulation over a single elementary link for the case when perfect error correction is considered (using infinitely squeezed ancillas). These functions allow for simulation of this specific case much more efficiently. They can be run using the script `SimulationRunFig2` which generates data for FIG. 2 in the paper. That is, this script considers a scenario when a single elementary link is considered, with just a single channel followed by a single error correcting station. The script runs the simulation for different values of the photon loss probability of the channel. 


### DataAnalysis

In this folder we have two sets of tools that operate on the generated data:

1. The function `AchievableDistance.m` used to maximise the secret-key rate per mode over all the simulated repeater placement configurations for all the distances such that it outputs the largest distance for which this key rate per mode stays above 0.01.
2. Tools to minimise the cost function and find the repeater placement configuration and the secret-key rate per mode which minimise this cost function. This tool is only used for the concatenated-coded schemes. All the plots with the corresponding data can be generated by running the scripts `PlotsSecKeyResourcesCostfunctionVsDistance4QubitCode.m` and `PlotsSecKeyResourcesCostfunctionVsDistance7QubitCode.m` on the generated data for the respective architectures. After running these scripts on both the [[4,1,2]] code data and the [[7,1,3]] code data, one can also run the script `PlotsCostfunctionVsDistance.m` on all these data to obtain a single plot of cost function versus distance for all the architectures based on the two outer codes.

Additionally, in the folder `InfiniteSqueezing` we also provide a script that generates the plot of logical error probability versus photon loss probability as shown in FIG. 2 in the paper. This script operates on the data generated using the script `SimulationRunFig2` from the folder `InfiniteSqueezing` from the `Simulation` part of the code.

We already provide the generated simulation data for some values of the GKP squeezing and photon coupling efficiency in the folder `data` where the parameter values are specified in the name of the data file. In the folder `InfiniteSqueezing` we also include the generated data presented in FIG. 2.

The *Matlab* scripts generating the plots make use of the following function:

Adam Danz (2020). supersizeme (https://www.mathworks.com/matlabcentral/fileexchange/67644-supersizeme), MATLAB Central File Exchange. Retrieved November 19, 2020.
 