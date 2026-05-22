function [ Prd_edge ] = LP( triangle, tau, i, nSubgrB )
%LP Summary of this function goes here
%   Detailed explanation goes here

 % Check all nodes connection with triangle nodes

Prd_edge = zeros(1,3); % node #, node #, score
score = 0;
flag1=0; flag2=0; flag3=0;
        
 if (triangle (1,1) ~= i && triangle (1,2) ~= i && triangle (1,3) ~= i)
    % ignoring triangle nodes
    lnk_cnt=0;
    if (tau(triangle(1,1),i) >= 1)
      lnk_cnt = lnk_cnt+1;
      flag1 = 1;
    end
    if (tau(triangle(1,2),i) >= 1)
        lnk_cnt=lnk_cnt+1;
        flag2=1;
    end
    if (tau(triangle(1,3),i) >= 1)
        lnk_cnt=lnk_cnt+1;
        flag3=1;
    end
    if (lnk_cnt == 3)
        return;
    %% Subgraph b
    elseif (lnk_cnt == 2)
        
        % Score is the sum of edge phermones of the triangle
        score = nSubgrB+tau(triangle(1,1),triangle(1,2))+...
                tau(triangle(1,2),triangle(1,3))+...
                tau(triangle(1,3),triangle(1,1));
        if (flag1 ~= 1)
            Prd_edge = [triangle(1,1), i, score];
        elseif (flag2 ~= 1)
            Prd_edge = [triangle(1,2), i, score];
        elseif (flag3 ~= 1)
            Prd_edge = [triangle(1,3), i, score];
        end
    %% Subgraph a        
     elseif (lnk_cnt == 1)
        % Score is the sum of edge phermones of the triangle
        score = tau(triangle(1,1),triangle(1,2))+...
                tau(triangle(1,2),triangle(1,3))+...
                tau(triangle(1,3),triangle(1,1));
        if (flag1 ~= 1)
            Prd_edge = [triangle(1,1), i, score];
        elseif (flag2 ~= 1)
            Prd_edge = [triangle(1,2), i, score];
        elseif (flag3 ~= 1)
            Prd_edge = [triangle(1,3), i, score];
        end
    end
 end
 
end

