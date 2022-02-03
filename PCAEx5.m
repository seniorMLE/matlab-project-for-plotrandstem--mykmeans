%
%
%  Assignment 3 | 
%  
%
% 
% Insert BELOW your code 

% INSERT YOUR CODE HERE!
clc;
clear;
X =importdata('pcadata.mat');
figure(1);
scatter(X(:,1),X(:,2));
title('Datapoints and their 2 principal components');
xlim([0 7]);
ylim([2 8]);
hold on;

[Xmu, mu] = subtractMean(X);
[U,S] = myPCA(Xmu);

X1 = U(:,1) + mu';
Y1 = U(:,2) + mu';
%plot(X1,Y1);
plot([3.9893 X1(1,1)],[5.0028 X1(2,1)],'r',[3.9893 Y1(1,1)],[5.0028 Y1(2,1)],'g');
Z = projectData(Xmu, U, 1);
disp(Z(1:3,:));
Xrec = recoverData(Z, U, 1, mu);
disp(Xrec);

figure(2);
scatter(X(:,1),X(:,2));
title('Datapoints and their reconstruction');
xlim([0 7]);
ylim([2 8]);
hold on;

scatter(Xrec(:,1),Xrec(:,2),'p');
xlim([0 7]);
ylim([2 8]);


X =importdata('pcafaces.mat');
figure(3);
subplot(1,2,1);
displayData(X(1:100,:));
title('original faces');
[Xmu, mu] = subtractMean(X);
[U,S] = myPCA(Xmu);
Z = projectData(Xmu, U, 200);
x_rec = recoverData(Z,U,200,mu);
subplot(1,2,2);
displayData(x_rec(1:100,:));
title('Recovered faces');








