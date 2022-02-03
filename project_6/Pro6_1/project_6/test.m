
data_matrix = readmatrix('Boston.csv');
icol = size(data_matrix,2)
Data = data_matrix(:,1:icol-1); % predictors matrix
Labels = data_matrix(:,end); % last column is 2 for benign, 4 for malignant

BaggedEnsemble = generic_random_forests(data_predictor, label, 500, 'classification');