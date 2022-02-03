

% 
%
%  
% Insert BELOW your code 

% INSERT YOUR CODE HERE!
function z = projectData(Xmu, U, K)
    %K = 1;
    v = U(:,1:K);    
    z = Xmu*v;
