
%
%  Assignment 3 | 
% 
% 
% 
% Insert BELOW your code 

% INSERT YOUR CODE HERE!
function result = plotrandstem(file_name, index)

FID = fopen(file_name,'r');
formatSpec = '%s %f';
sizeA = [4 Inf];
data = fscanf(FID,formatSpec,sizeA);
fclose(FID);
select_data = data';
column_number = length(select_data);
if index > column_number 
    warndlg('Index must set 1~100 ','Warning');    
else    
    p=randi([1,100],1,index);
    x = select_data(p, 2);
    y = select_data(p, 4);
    stem(x,y);
    title(string(index)+'random data points');
    xlabel('x axis');
    ylabel('y axis');
    %stringData = string(data{:});
end    
end

