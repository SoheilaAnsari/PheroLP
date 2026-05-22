function Score = CN(testID,Net)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


num_test = size(testID,1);
Score = zeros(num_test,1);
I = unique(testID(:,1));
Num = length(I);
for i = 1:Num
    list = testID((testID(:,1)==I(i)),2); %index of links connecting node i
    list2 = find((testID(:,1)==I(i)));
    if(~isempty(list))
        tmp = repmat(Net(I(i),:),length(list),1);
        IDX = logical(tmp) & logical(Net(list,:));
        Score(list2,:) = sum(IDX,2);
    end
    % Command window display-------------------
%     progress=round(100*i/Num);
%     if(i>1)
%         fprintf(repmat('\b', 1, 29+length(num2str(progress))));
%         disp(['CN calculation (% progress):',num2str(progress)]);
%     else
%         disp(['      CN calculation (% progress):',num2str(progress)]);
%     end
    % -----------------------------------------
end


end