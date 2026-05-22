function [ Triangles ] = sort_column1( fin_res )
%SORT_COLUMN1 Summary of this function goes here
%   Detailed explanation goes here

[~,I]=sort(fin_res(:,1));
Triangles = zeros(length(fin_res),3);

for i=1:length(I)
    Triangles(i,:)=fin_res(I(i),:);
end

end

