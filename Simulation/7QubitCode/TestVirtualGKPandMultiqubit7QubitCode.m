%Test VirtualGKPandMultiqubit7QubitCode

tableSingleErr =    [ 0, 0, 0, 1, 1, 1, 1;
                      0, 1, 1, 0, 0, 1, 1;
                      1, 0, 1, 0, 1, 0, 1]';
                  
%% Test 1:correct single qubit errors
deltas = (sqrt(pi)/2 + 0.1) * [0.1;0.1;0.1;1;0.1;0.1;0.1];
[MultiqubitErrors,OutOf7QbitCodeSpaceYesNo] = VirtualGKPandMultiqubit7QubitCode(deltas, tableSingleErr);
assert(all(MultiqubitErrors == zeros(7,1)))
assert(OutOf7QbitCodeSpaceYesNo == 1)

%% Test 2: 2-qubit errors lead to logical
deltas = (sqrt(pi)/2 + 0.1) * [0.1;0.1;0.1;1;0.1;1;0.1];
[MultiqubitErrors,OutOf7QbitCodeSpaceYesNo] = VirtualGKPandMultiqubit7QubitCode(deltas, tableSingleErr);
assert(sum(MultiqubitErrors) == 3)
assert(OutOf7QbitCodeSpaceYesNo == 1)

%% Test 3: 3-qubit errors that are logicals stay
deltas = (sqrt(pi)/2 + 0.1) * [1;1;1;0.1;0.1;0.1;0.1];
[MultiqubitErrors,OutOf7QbitCodeSpaceYesNo] = VirtualGKPandMultiqubit7QubitCode(deltas, tableSingleErr);
assert(all(MultiqubitErrors == [1;1;1;0;0;0;0]))
assert(OutOf7QbitCodeSpaceYesNo == 0)

%% Test 4: 3-qubit errors that are not logicals are corrected
deltas = (sqrt(pi)/2 + 0.1) * [0.1;1;1;1;0.1;0.1;0.1];
[MultiqubitErrors,OutOf7QbitCodeSpaceYesNo] = VirtualGKPandMultiqubit7QubitCode(deltas, tableSingleErr);
assert(all(MultiqubitErrors == zeros(7,1)))
assert(OutOf7QbitCodeSpaceYesNo == 1)

%% Test 5: stabiliser errors are erased
deltas = (sqrt(pi)/2 + 0.1) * [0.1;0.1;0.1;1;1;1;1];
[MultiqubitErrors,OutOf7QbitCodeSpaceYesNo] = VirtualGKPandMultiqubit7QubitCode(deltas, tableSingleErr);
assert(all(MultiqubitErrors == zeros(7,1)))
assert(OutOf7QbitCodeSpaceYesNo == 0)

deltas = (sqrt(pi)/2 + 0.1) * [1;1;0.1;1;0.1;0.1;1];
[MultiqubitErrors,OutOf7QbitCodeSpaceYesNo] = VirtualGKPandMultiqubit7QubitCode(deltas, tableSingleErr);
assert(all(MultiqubitErrors == zeros(7,1)))
assert(OutOf7QbitCodeSpaceYesNo == 0)

%% Test 6: 4-qubit non-stabiliser errors lead to logicals
deltas = (sqrt(pi)/2 + 0.1) * [1;1;1;1;0.1;0.1;0.1];
[MultiqubitErrors,OutOf7QbitCodeSpaceYesNo] = VirtualGKPandMultiqubit7QubitCode(deltas, tableSingleErr);
assert(all(MultiqubitErrors == [1;1;1;0;0;0;0]))
assert(OutOf7QbitCodeSpaceYesNo == 1)

deltas = (sqrt(pi)/2 + 0.1) * [0.1;0.1;1;0.1;1;1;1];
[MultiqubitErrors,OutOf7QbitCodeSpaceYesNo] = VirtualGKPandMultiqubit7QubitCode(deltas, tableSingleErr);
assert(all(MultiqubitErrors == [0;0;1;0;1;1;0]))
assert(OutOf7QbitCodeSpaceYesNo == 1)