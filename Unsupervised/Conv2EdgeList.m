function [ NLC_list] = Conv2EdgeList( edge_list, NLC_matrice )
%CONV2EDGELIST Summary of this function goes here
%   Detailed explanation goes here

tic
disp('Converting to edge list...');

temp_zero=diag(true(1,length(NLC_matrice)),0);
NLC_matrice(temp_zero)=0;
clear temp_zero;

G_NLC=graph(NLC_matrice);
NLC_list=zeros(length(edge_list),1);

% G_NLC.Edges{i,2} represents for NLC feature

for i=1:size(G_NLC.Edges,1)

    % All indexes in "edge_list" that equals to source node in i-th NLC edge(non-zero NLC feature)
    ind_first_column = find(edge_list(:,1) == G_NLC.Edges{i,1}(1,1));

    % Match may occur in the sencond column of edge_list
    ind_second_column= find(edge_list(:,2) == G_NLC.Edges{i,1}(1,1));

    % Find the index in "edge_list" that the second element is matched with
    % i-th destination node in NLC edge (non-zero NLC feature)
    i_ind1= edge_list(ind_first_column,2) == G_NLC.Edges{i,1}(1,2);
    
    if ( isempty(find(i_ind1,1)))
        % The first match was occured in the second column of edge_list
        i_ind2 = edge_list(ind_second_column,1) == G_NLC.Edges{i,1}(1,2);
        NLC_list(ind_second_column(i_ind2),1)=G_NLC.Edges{i,2};
    else
        NLC_list(ind_first_column(i_ind1),1)=G_NLC.Edges{i,2};
    end
    
    %% Command window display-------------------
    progress=round(100*i/size(G_NLC.Edges,1));
    if(i>1)
        fprintf(repmat('\b', 1, 26+length(num2str(progress))));
        disp(['Calculation (% progress):',num2str(progress)]);
    else
        disp(['      Calculation (% progress):',num2str(progress)]);
    end
    %%    
    
end

disp(['NLC_edge_list created:',num2str(toc)]);

end

