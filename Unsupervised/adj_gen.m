function [ adj_mat ] = adj_gen( dataset_name )
%ADJ_GEN  Build an undirected adjacency matrix for one of the supported
%         link-prediction datasets.
%
%   adj_mat = adj_gen('Karate')   returns the (n x n) symmetric, 0/1
%                                 adjacency matrix for the requested
%                                 dataset.
%
%   Supported dataset_name values (case-sensitive):
%       'Dolphins', 'USAir', 'Karate', 'Football', 'Jazz',
%       'polblogs', 'NS', 'celegans'
%
%   Datasets are expected to live in the repository's data/ folder
%   (relative path '../data/' from this file). The function loads ONLY
%   the dataset that was requested, so a missing file for another
%   dataset will not cause an error.
%
%   Edge lists in the .txt files use 1-based node IDs, one undirected
%   edge per row (columns 1 and 2 = endpoint IDs). The resulting
%   adjacency matrix is symmetrized.

    % Resolve the data folder relative to THIS file's location, so the
    % function works no matter what MATLAB's current directory is.
    here     = fileparts(mfilename('fullpath'));
    data_dir = fullfile(here, '..', 'data');

    switch dataset_name
        case 'Dolphins'
            edges   = load(fullfile(data_dir, 'dolphins.txt'));
            adj_mat = edges_to_adj(edges);

        case 'USAir'
            edges   = load(fullfile(data_dir, 'USAir.txt'));
            adj_mat = edges_to_adj(edges);

        case 'Karate'
            S = load(fullfile(data_dir, 'karate.mat'));   % expects karate_edges
            edges   = S.karate_edges;
            adj_mat = edges_to_adj(edges);

        case 'Football'
            S = load(fullfile(data_dir, 'FootballMatrix.mat')); % expects FootballMatrix
            adj_mat = S.FootballMatrix;

        case 'Jazz'
            edges   = load(fullfile(data_dir, 'jazz.txt'));
            adj_mat = edges_to_adj(edges);

        case 'polblogs'
            edges   = load(fullfile(data_dir, 'polblogs.txt'));
            adj_mat = edges_to_adj(edges);

        case 'NS'
            edges   = load(fullfile(data_dir, 'NS.txt'));
            adj_mat = edges_to_adj(edges);

        case 'celegans'
            edges   = load(fullfile(data_dir, 'celegans.txt'));
            adj_mat = edges_to_adj(edges);

        otherwise
            error('adj_gen:UnknownDataset', ...
                'Unknown dataset "%s". See help adj_gen for supported names.', ...
                dataset_name);
    end
end


function adj = edges_to_adj(edges)
% Build a symmetric, zero-diagonal 0/1 adjacency matrix from an edge list.
    n = max(max(edges(:,1)), max(edges(:,2)));
    adj = zeros(n);
    for ii = 1:size(edges, 1)
        adj(edges(ii,1), edges(ii,2)) = 1;
        adj(edges(ii,2), edges(ii,1)) = 1;
    end
    % Make sure there are no self-loops
    adj(1:n+1:end) = 0;
end
