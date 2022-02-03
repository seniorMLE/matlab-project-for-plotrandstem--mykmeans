function Random_Forest = Stochastic_Bosque(Data,Labels,varargin)

%Data - sample dataset
%Labels - label from file ->medv
okargs =   {'minparent' 'minleaf' 'nvartosample' 'ntrees' 'nsamtosample' 'method' 'oobe' 'weights'}; %set optimal
defaults = {2 1 round(sqrt(size(Data,2))) 50 numel(Labels) 'c' 'n' []};
[eid,emsg,minparent,minleaf,m,nTrees,n,method,oobe,W] = getargs(okargs,defaults,varargin{:}); % init value

for i = 1 : nTrees     

     TDindx = unique(TDindx); %unique TDindx
    
    Random_ForestT = createRandomforest(Data(TDindx,:),Labels(TDindx), ...
        'minparent',minparent,'minleaf',minleaf,'method',method,'nvartosample',m,'weights',W); %create random forest
    
    Random_ForestT.method = method; %performs classification using random forests. 

    Random_ForestT.oobe = 1;
    if strcmpi(oobe,'y')        
        NTD = setdiff(1:numel(Labels),TDindx);
        tree_output = eval_cartree(Data(NTD,:),Random_ForestT)';
        
        switch lower(method)        
            case {'c','g'}                
                Random_ForestT.oobe = numel(find(tree_output-Labels(NTD)==0))/numel(NTD);
            case 'r'
                Random_ForestT.oobe = sum((tree_output-Label(NTD)).^2);
        end        
    end
    
    Random_Forest(i) = Random_ForestT;
end