function trimmedZ = trimZ(Z, num_clusters)
    n = size(Z,1) + 1;
	trimmedZ = zeros(num_clusters-1,2); % don't worry about "distance" column
				      % if need be, append appropriate distances from Z
	starting_node = 1 + n - num_clusters;
	starting_node_idx = starting_node + n;
	cur_leaf_idx = 0;
	cur_newZ_idx = 0;
	for i=starting_node:(n-1)
		cur_newZ_idx = cur_newZ_idx + 1;
		if(Z(i,1) < starting_node_idx)
			cur_leaf_idx = cur_leaf_idx + 1;
			trimmedZ(cur_newZ_idx,1) = cur_leaf_idx;
		else
			trimmedZ(cur_newZ_idx,1) = Z(i,1) + 2*(num_clusters - n); % cur_inode_idx;
		end
		if(Z(i,2) < starting_node_idx)
			cur_leaf_idx = cur_leaf_idx + 1;
			trimmedZ(cur_newZ_idx,2) = cur_leaf_idx;
		else
			trimmedZ(cur_newZ_idx,2) = Z(i,2) + 2*(num_clusters - n); % cur_inode_idx;
		end
    end
end

    %trimmedZ(:,3) = Z(starting_node:(n-1),3); % add third column for compatability with dendrogram, etc.