function call_generic_random_forests()


data_matrix = readmatrix('Boston.csv');
icol = size(data_matrix,2)
data_predictor = data_matrix(:,1:icol-1); % predictors matrix
label = data_matrix(:,end); % last column is 2 for benign, 4 for malignant

BaggedEnsemble = generic_random_forests(data_predictor, label, 500, 'classification');
predict(BaggedEnsemble, [1000025,5,1,1,1,2,1,3,1,1]);

% Model says that x6 (single epithelial cell size) is most important
% predictor