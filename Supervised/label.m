function [ label ] = label( edge_list,adj )
%LABEL Summary of this function goes here
%   Detailed explanation goes here

tic
disp('Labeling...');

Gr=graph(adj);
label= zeros(length(edge_list),1);

for i=1:size(Gr.Edges,1)

    % All indexes in "edge_list" that equals to source node in i-th node in Gr.Edges list
    ind_first_column = find(edge_list(:,1) == Gr.Edges{i,1}(1,1));

    % Match may occur in the sencond column of edge_list
    ind_second_column= find(edge_list(:,2) == Gr.Edges{i,1}(1,1));

    % Find the index in "edge_list" that the second element is matched with
    % i-th destination node in Gr.Edges list
    i_ind1= edge_list(ind_first_column,2) == Gr.Edges{i,1}(1,2);
    
    if (isempty(find(i_ind1,1)))
        % The first match was occured in the second column of edge_list
        i_ind2 = edge_list(ind_second_column,1) == Gr.Edges{i,1}(1,2);
        label(ind_second_column(i_ind2),1)=Gr.Edges{i,2};
    else
        label(ind_first_column(i_ind1),1)=Gr.Edges{i,2};
    end
    
    %% Command window display-------------------
    progress=round(100*i/size(Gr.Edges,1));
    if(i>1)
        fprintf(repmat('\b', 1, 26+length(num2str(progress))));
        disp(['Calculation (% progress):',num2str(progress)]);
    else
        disp(['      Calculation (% progress):',num2str(progress)]);
    end
    %%    
    
end

disp(['Label list created:',num2str(toc)]);


end

