
% 
%
% 
% Insert BELOW your code 
 
% INSERT YOUR CODE HERE!
function [U,S] = myPCA(Xmu)
    C = cov(Xmu);
    [U,S]=eig(C, 'vector'); 
    [lamdasort,ind]=sort(S,'descend');
    U = U(:, ind);    
end
