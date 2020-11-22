function out = ReminderMod(vec,modval)
%This function calculates the reminder mod modval in the interval [-modval/2,
%modval/2) of all the entries in a vector vec
% vec -     input vector with entries on which we want to calculate the
%           reminder
% modval -  The value modulo which we wish to divide such that the result
%           is in the interval [-modval/2, modval/2)
%
%Output
%
%out -      Output vector with reminder values


N = length(vec);

out = mod(vec + (modval/2)*ones(N,1),modval) - (modval/2)*ones(N,1);