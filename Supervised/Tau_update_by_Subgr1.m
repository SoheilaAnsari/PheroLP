function [ tau ] = Tau_update_by_Subgr1( triangle,tau, adj_mat, i, nSubgrB )
%LP Summary of this function goes here
%   Detailed explanation goes here

 % Check all nodes connection with triangle nodes

score = 0;
flag1=0; flag2=0; flag3=0;
        
 if (triangle (1,1) ~= i && triangle (1,2) ~= i && triangle (1,3) ~= i)
    % ignoring triangle nodes
    lnk_cnt=0;
    if (adj_mat(triangle(1,1),i) == 1)
      lnk_cnt = lnk_cnt+1;
      flag1 = 1;
    end
    if (adj_mat(triangle(1,2),i) == 1)
        lnk_cnt=lnk_cnt+1;
        flag2=1;
    end
    if (adj_mat(triangle(1,3),i) == 1)
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

            tau(triangle(1,1), i) = tau(triangle(1,1), i) + 0.5*flag1*round(score/3) + 0.5*round(score/3);
            tau(triangle(1,2), i) = tau(triangle(1,2), i) + 0.5*flag2*round(score/3) + 0.5*round(score/3);
            tau(triangle(1,3), i) = tau(triangle(1,3), i) + 0.5*flag3*round(score/3) + 0.5*round(score/3);
            % Tau matrix should be symmetric
            tau(i, triangle(1,1)) = tau(i, triangle(1,1)) + 0.5*flag1*round(score/3) + 0.5*round(score/3);
            tau(i, triangle(1,2)) = tau(i, triangle(1,2)) + 0.5*flag2*round(score/3) + 0.5*round(score/3);
            tau(i, triangle(1,3)) = tau(i, triangle(1,3)) + 0.5*flag3*round(score/3) + 0.5*round(score/3);

    %% Subgraph a        
     elseif (lnk_cnt == 1)
        % Score is the sum of edge phermones of the triangle
        score = tau(triangle(1,1),triangle(1,2))+...
                tau(triangle(1,2),triangle(1,3))+...
                tau(triangle(1,3),triangle(1,1));
            
            tau(triangle(1,1), i) = tau(triangle(1,1), i) + 0.5*flag1*round(score/3) + 0.5*round(score/3);
            tau(triangle(1,2), i) = tau(triangle(1,2), i) + 0.5*flag2*round(score/3) + 0.5*round(score/3);
            tau(triangle(1,3), i) = tau(triangle(1,3), i) + 0.5*flag3*round(score/3) + 0.5*round(score/3);
            % Tau matrix should be symmetric
            tau(i, triangle(1,1)) = tau(i, triangle(1,1)) + 0.5*flag1*round(score/3) + 0.5*round(score/3);
            tau(i, triangle(1,2)) = tau(i, triangle(1,2)) + 0.5*flag2*round(score/3) + 0.5*round(score/3);
            tau(i, triangle(1,3)) = tau(i, triangle(1,3)) + 0.5*flag3*round(score/3) + 0.5*round(score/3);

    end
 end
 
end

