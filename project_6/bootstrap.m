

function result = randomForest(B,h)

    dataset = readmatrix('Boston.csv');
    len_dataset = length(dataset);
    p=randi([1,len_dataset],1,B);
    Bootstrap_sample = dataset(p,:);
    Data = Bootstrap_sample ;
    tree_num = B;

    result = Stochastic_Bosque(Data,Labels,varargin, tree_num);

end