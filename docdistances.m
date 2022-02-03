
% 
% 
% 
% Insert BELOW your code 

% INSERT YOUR CODE HERE!
function result = docdistances()

    readFcn = @extractFileText;
    bag = bagOfWords;
    fds = fileDatastore('Cinderella.txt','ReadFcn',readFcn);
    str = read(fds);
    document = tokenizedDocument(str);
    bag = addDocument(bag,document);

    fds = fileDatastore('PrincessPea.txt','ReadFcn',readFcn);
    str = read(fds);
    document = tokenizedDocument(str);
    bag = addDocument(bag,document);

    fds = fileDatastore('RedRidingHood.txt','ReadFcn',readFcn);
    str = read(fds);
    document = tokenizedDocument(str);
    bag = addDocument(bag,document);
    
    fds = fileDatastore('CAFA1.txt','ReadFcn',readFcn);
    str = read(fds);
    document = tokenizedDocument(str);
    bag = addDocument(bag,document);
    
    fds = fileDatastore('CAFA2.txt','ReadFcn',readFcn);
    str = read(fds);
    document = tokenizedDocument(str);
    bag = addDocument(bag,document);
    
    fds = fileDatastore('CAFA3.txt','ReadFcn',readFcn);
    str = read(fds);
    document = tokenizedDocument(str);
    bag = addDocument(bag,document);    
    M = tfidf(bag);
    M=M';    
    tfidf_value = full(M(:,1:6));    
    cosine_distance = [];
    assignin('base','bagg',tfidf_value );
    k = length(tfidf_value);    
    A = 0;
    A2 = 0;
    B2 = 0;
    for i = 1:6
        for j = 1:6
            for kk = 1:k
                A = A + tfidf_value(kk,i)*tfidf_value(kk,j);            
                A2 = A2 + tfidf_value(kk,i)^2;
                B2 = B2 + tfidf_value(kk,j)^2;                            
            end           
            cosine_distance(i, j) = A/(sqrt(A2)*sqrt(B2));
            A = 0;
            A2 = 0;
            B2 = 0;
        end
    end
    
    clims = [0 1];
    colormap(1-gray);
    imagesc(cosine_distance,clims)
    colorbar
    title('Cosine Distance');
    xticks([1:6]);
    xticklabels({'RRH','PPea','Cinde','CAFA1','CAFA2','CAFA3'});
    yticks([1:6]);
    yticklabels({'RRH','PPea','Cinde','CAFA1','CAFA2','CAFA3'});
       
end




%assignin('base','m',M);


