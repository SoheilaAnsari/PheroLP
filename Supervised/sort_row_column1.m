function [ PrdLnk_mat ] = sort_row_column1( PrdLnk )

% Sorting nodes of predicted edges ascendingly
for i=1:length(PrdLnk)
    PrdLnk(i,1:2)=sort(PrdLnk(i,1:2));
end

PrdLnk_temp = zeros(length(PrdLnk),3);

[~,I]=sort(PrdLnk(:,1));

for i=1:length(I)
   PrdLnk_temp(i,:)=PrdLnk(I(i),:);
end

PrdLnk_mat = PrdLnk_temp;

end