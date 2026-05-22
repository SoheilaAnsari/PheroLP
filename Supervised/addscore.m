function [ Uniq_PrdLnk ] = addscore( PrdLnk_mat )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

Uniq_PrdLnk = zeros(length(PrdLnk_mat),3);
m=1;
for i=1:length(PrdLnk_mat)
    score_lnk = PrdLnk_mat (i,3);
    repeat_flag=0;
    for j=i+1:length(PrdLnk_mat)
        if(PrdLnk_mat(i,1) == PrdLnk_mat(j,1) && ...
           PrdLnk_mat(i,2) == PrdLnk_mat(j,2))
           PrdLnk_mat (j,3) = score_lnk + PrdLnk_mat (j,3);
            repeat_flag=1;
            break;
        end
    end
    if (repeat_flag == 0)
        Uniq_PrdLnk(m,:) = [PrdLnk_mat(i,1),PrdLnk_mat(i,2),score_lnk];
        m=m+1;
    end
end
Uniq_PrdLnk(m:end,:)=[];

end

