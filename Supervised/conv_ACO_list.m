function [ ACO_list ] = conv_ACO_list( tau_mat, order_list )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
disp('-----------------------------------------')
% Make Table for ACO_Feature to Concatenate to NLC & CN
tic
% Graph_tau=graph(tau_mat);
% tau_edges=Graph_tau.Edges{:,:}; 

ACO_list = zeros(length(order_list),1); 
for x=1:1:length(order_list)
    ACO_list(x,1)= tau_mat(order_list(x,1),order_list(x,2));
end
disp(['ACO order change',num2str(toc)])
end

