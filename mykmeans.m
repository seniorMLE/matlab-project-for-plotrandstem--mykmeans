
% 
%
% 
% Insert BELOW your code 
 
% INSERT YOUR CODE HERE!
function [C, V] = mykmeans(Data, n)

K = n;
max_iterations = n;
rand_centroid_idx = randi([1,3000],1,n);
centroids = Data(rand_centroid_idx,:);

cluster_assigned = zeros(length(Data),1);

cluster_sum = zeros(K,2);
cluster_samples = zeros(K,1);
assignin('base','centr',cluster_samples);  


for iter = 1:max_iterations    
    for num_sample = 1:length(Data)        
        temp = Data(num_sample,:) - centroids;
        euc_dist = vecnorm(temp,2,2);                
        closest_cluster = find(euc_dist == min(euc_dist));        
        cluster_assigned(num_sample) = closest_cluster;        
        
        cluster_sum(closest_cluster,:) = cluster_sum(closest_cluster,:) ...
            + Data(num_sample,:);
        
        cluster_samples(closest_cluster) = cluster_samples(closest_cluster)+1;        
    end    
    centroids =  cluster_sum ./ cluster_samples;    
    cluster_sum = zeros(K,2);
    cluster_samples = zeros(K,1);
end

 
figure(2)
for i=1:K    
    pts = Data(cluster_assigned==i,:);
    plot(pts(:,1),pts(:,2),'.','color',rand(1,3),'MarkerSize',12); hold on;
end 
plot(centroids(:,1),centroids(:,2),'rd','MarkerSize',12);
title 'K-means clustering';
end
