% test SyndrometoErrors
tableSingleErr = [ 0, 0, 0, 1, 1, 1, 1;
                      0, 1, 1, 0, 0, 1, 1;
                      1, 0, 1, 0, 1, 0, 1]';

% Table with double errors

tableDoubleErr =  zeros(7,3,7);
for i = 1:7
   for j = 1:7
        tableDoubleErr(i,:,j) = mod(tableSingleErr(i,:) + tableSingleErr(j,:), 2);
   end
end

nqubit = 7;

syndrome_vec1 = [0,0,1];


%% Test1: full error matrix
error = SyndromeToErrors(syndrome_vec1, tableSingleErr, tableDoubleErr, nqubit);
errorMatrix = zeros(4,7);
A = eye(7);
errorMatrix(1,:) = A(1,:);
errorMatrix(2,:) = [0,1,1,0,0,0,0];
errorMatrix(3,:) = [0,0,0,1,1,0,0];
errorMatrix(4,:) = [0,0,0,0,0,1,1];
assert(all(error == errorMatrix, 'all'))