function [ Srt_PrdLnk ] = sort_column3( Uniq_PrdLnk )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Sorting PrdLnk_mat ascendingly
Srt_PrdLnk=zeros(length(Uniq_PrdLnk),3);

[B1,I1]=sort(Uniq_PrdLnk(:,3),'descend');

for i=1:length(I1)
        Srt_PrdLnk(i,:)=Uniq_PrdLnk(I1(i),:);
end

end

