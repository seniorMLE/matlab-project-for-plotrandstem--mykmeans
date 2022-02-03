
% 
% 
% 
% Insert BELOW your code 

% INSERT YOUR CODE HERE!
function [Xmu mu] = subtractMean(X)
mu = mean(X);
Xmu = (X - mu);
end