function [ repeat_flg ] = Is_Rep_Triangle( cur_triangle, result )
%   Operation: Finding the cur_triangle in result matrix
%   Inputs:
    % cur_triangle : found triangle sorted node #
    % result       : target search matrix

    repeat_flg=0;

    % Sorting nodes of predicted edges ascendingly
    for i=1:length(result)
        result(i,1:3)=sort(result(i,1:3));
    end
    result_temp = zeros(length(result),3);
    [~,I]=sort(result(:,1));
    for i=1:length(I)
        result_temp(i,:)=result(I(i),:);
    end
    result=result_temp;
    
    % Now start searching cur_triangle in result matrix
    for i=1:length(result)
        if(cur_triangle(1,1) == result(i,1))
            for(j=i:length(result))
                if(cur_triangle(1,1) == result(j,1) && cur_triangle(1,2) == result(j,2))
                    for(k=j:length(result))
                        if(cur_triangle(1,1) == result(k,1) && cur_triangle(1,2) == result(k,2) && cur_triangle(1,3) == result(k,3))    
                            repeat_flg=1;
                            break;
                        end
                    end
                end
            end
        end
    end
    
end

