


dataset = readmatrix('Boston.csv');
len_dataset = length(dataset);
p=randi([1,len_dataset],1,100);
B = dataset(p,:);
