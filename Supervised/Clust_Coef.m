function [ clust ] = Clust_Coef( edge_list, CN, adj )
%Clust_Coef Summary of this function goes here
%   Detailed explanation goes here
clust=zeros(length(edge_list),1);

G=graph(adj);

%% Degree calculation
deg1=degree(G,edge_list(:,1));
deg2=degree(G,edge_list(:,2));
min_deg12=zeros(length(deg1),1);
for i=1:length(deg1)
    min_deg12(i,1)=min(deg1(i,1)-1,deg2(i,1)-1);
end

clust = CN(:,1)./min_deg12(:,1);

clust(isinf(clust))=0;
clust(isnan(clust))=0;
% disp(['Elapsed time for clust. coef. calculation:',num2str(toc)])

end

