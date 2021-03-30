function out = SecretKey6State(NMultiQbit, Ltot, Zerr, Xerr)
%This function calculates secret-key rate per optical mode for the
%architecture based on the [[7,1,3]]-code. The QKD protocol considered is
%the six-state protocol supplemented with Advantage Distillation of 
%Watanabe, et al. PRA 76.3 (2007): 032312.

%Inputs:

%NMultiQubit -      number of type-A repeaters per Lfix km
%Ltot -             distance over which we want to calculate the key
%Zerr, Xerr -       probability of Z-flip and X-flip over a chain of 100 
%                   elementary links where each elementary link is a link 
%                   between the neighbouring type-A repeaters.

%Outputs

%out -              secret key per optical mode

%Define Lfix
Lfix = 10;
%Define the number of elementary links we have simulated
NElemLinks = 100;


% The maximum flip probability is 0.5, as if the flip probabilities were larger, we would
% just flip all the corresponding bits.

if Zerr > 0.5
    Zerr = 0.5;
end

if Xerr > 0.5
    Xerr = 0.5;
end

%Establish the effective flip probability over distance Ltot
QerrZ = (1 - (1 - 2 * Zerr)^(NMultiQbit * Ltot / (NElemLinks*Lfix)) )/2;
QerrX = (1 - (1 - 2 * Xerr)^(NMultiQbit * Ltot / (NElemLinks*Lfix)) )/2;

%Extract independent probabilities X, Y, Z
qZ = QerrZ * (1 - QerrX);
qX = QerrX * (1 - QerrZ);
qY = QerrZ * QerrX;


%QBER
%Flip in each basis generates errors in the other 2 bases

eX = min(qZ + qY, 0.5) ;
eZ = min(qX + qY, 0.5) ;
eY = min(qZ + qX, 0.5) ;



%AD Watanabe with key in Y basis

lambda00 = 1-(eX + eY + eZ)/2;
lambda01 = (eX + eZ - eY)/2;
lambda10 = (-eX + eY + eZ)/2;
lambda11 = (eX - eZ + eY)/2;

Lambdas = [lambda00, lambda01, lambda10, lambda11];

PX0 = (lambda00 +lambda01)^2 + (lambda10 + lambda11)^2;
PX1 = 2 * (lambda00 +lambda01) * (lambda10 + lambda11);

lambda00prime = (lambda00^2 + lambda01^2)/PX0;
lambda10prime = (2*lambda00 * lambda01)/PX0;
lambda01prime = (lambda10^2 + lambda11^2)/PX0;
lambda11prime = (2 * lambda10 * lambda11)/PX0;

Lambdasprime = [lambda00prime, lambda01prime, lambda10prime, lambda11prime];

out1 = 1 - ShannonEnt(Lambdas) + (PX1/2) * BinEnt((lambda00*lambda10 + lambda01 * lambda11)/((lambda00 + lambda01)*(lambda10 + lambda11)));
out2 = (PX0/2) * (1 - ShannonEnt(Lambdasprime));

%The total secret key per mode is normalised by 4, the number of optical modes
%encoding a logical qubit.
out = max([out1,out2,0])/7;
