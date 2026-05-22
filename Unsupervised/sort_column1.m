function [ output ] = sort_column1( input )
%SORT_COLUMN1 Summary of this function goes here
%   Detailed explanation goes here

[~,I]=sort(input(:,1), 'descend');
output = zeros(length(input),3);

for i=1:length(I)
    output(i,:)=input(I(i),:);
end

end

