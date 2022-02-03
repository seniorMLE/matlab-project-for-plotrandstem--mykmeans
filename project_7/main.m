

    dataset = readmatrix('ncidata.txt');
    dataset = dataset';
    dist_fcn = @(x1,x2) sqrt( (x1(1)-x2(1)).^2+(x1(2)-x2(2)).^2+(x1(3)-x2(3)).^2 ) .* abs(x1(4)-x2(4));
    D = pdist(dataset, dist_fcn);
    Dm = squareform(D);    
    tree = linkage(Dm,'complete');
    result = dendrogram(tree);
    
    
    