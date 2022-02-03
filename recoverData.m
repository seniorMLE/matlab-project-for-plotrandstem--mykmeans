function X_rec = recoverData(Z, U, K, mu)
	X_rec = Z * U(:,1:K)' + repmat(mu, size(Z, 1), 1);
 
end
