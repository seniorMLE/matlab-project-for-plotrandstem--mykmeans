function Random_Forest = Stochastic_Bosque(Data,Labels, tree_num, varargin )

    okargs =   {'crim' 'zn' 'indus' 'chas' 'nox' 'rm' 'age' 'dis' 'rad' 'tax' 'ptratio' 'black' 'lstat'};
    defaults = {2 1 round(sqrt(size(Data,2))) tree_num numel(Labels) 'c' 'n' []};
    
    [eid,emsg,minparent,minleaf,m,nTrees,n,method,oobe,W] = getargs(okargs,defaults,varargin{:});
    for i = 1 : nTrees     
        TDindx = round(numel(Labels)*rand(n,1)+.5);

        Random_ForestT = cartree(Data(TDindx,:),Labels(TDindx), ...
            'minparent',minparent,'minleaf',minleaf,'method',method,'nvartosample',m,'weights',W);

        Random_ForestT.method = method;
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