function [ num_of_triangles ] = FindEdge( triangles, edge )
%FIND_EDGE Summary of this function goes here
%   Detailed explanation goes here
edge=sort(edge);
num_of_triangles = 0;

for j=1:length(triangles)
    if (ismember(edge, triangles(j,:)) == [1 1])
        num_of_triangles= num_of_triangles+1;
    end
end
end


%     %for k = 1 : 2
%         %output = [output, find(triangles(i,:) == edge(k))]
%          output = [output, ...
%              find( (triangles(i,1) == edge(1) && ...
%              (triangles(i,2) == edge(2) || triangles(i,3) == edge(2))) ||...
%                    triangles(i,2) == edge(1) && ...
%              (triangles(i,3) == edge(2)) )]
% 
%     %end