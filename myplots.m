
%  
%
% 
% Insert BELOW your code 

% INSERT YOUR CODE HERE!
function result = myplots(function_string, color, marker)

function_name = function_string(1,:);
color_data = color(1,:);
marker_data = marker(1,:);

length_1 = length(function_name);
length_2 = length(color_data);
length_3 = length(marker_data);
    if length_1 == 4
        if length_2 == 4
            if length_2 == 4            
                for index = 1:length_1 

                    subplot(2, 2, index);
                    x = -2*pi:0.3:2*pi;
                    fun_name = function_name(1,index);
                    fun_name = string(fun_name);
                    assignin('base','fun_name',fun_name);
                    y = eval(fun_name+'(x)');
                    p = [color_data(1,index) marker_data(1,index)];                
                    plot(x,y,p);
                    title(fun_name+'(x)');
                end
            else
                warndlg('Input array must set 4','Warning');   
            end
        else
            warndlg('Input array must set 4','Warning');   
        end
    else
        warndlg('Input array must set 4','Warning');       
    end
                
            %disp(string(function_string));
end
