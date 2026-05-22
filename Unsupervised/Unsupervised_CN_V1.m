%% Dataset selection
%  'Dolphins', 'USAir', 'Karate', 'Football', 'Jazz', 'polblogs',
%  'powergrid','NS','celegans', 'Yeast'
clc; clear all;
%% Parameter settings
L_top=20;
num_of_run=10;
dataset='Karate';
%%
adj=adj_gen(dataset);
G=graph(adj);
existing_edges=G.Edges{:,:};

%% Choosing 10% of existing edges as test
sum_AUC=0;
% sum_X=0;
% sum_Y=0;
eval_par=zeros(num_of_run,7);
sum_eval_par=zeros(1, 7);

for(j=1:num_of_run)
disp(['progress ',num2str((100*j/num_of_run)), ' pecent'])
    
p = 0.9;      % proportion of rows to select for training
N = size(existing_edges,1);  % total number of rows 
tf = false(N,1);    % create logical index vector
tf(1:round(p*N)) = true ;    
tf = tf(randperm(N));   % randomise order
dataTraining = existing_edges(tf,:); 
dataTesting = existing_edges(~tf,:);

% New adj is needed to correctly calculate the feature
New_G = graph(dataTraining(:,1),dataTraining(:,2),dataTraining(:,3),length(adj));
adj_train=adjacency(New_G);

% Listing Unexisting edges
adj_prime=~adj_train;
temp_zero=diag(true(1,length(adj_prime)),0);
adj_prime(temp_zero)=0; % Setting diagonal elements to zero
G_prime=graph(adj_prime);
unexisting_edges=G_prime.Edges{:,:}; % Unexisting edges in train graph

% Creating the edge list for test
edges_train = unexisting_edges;

%% Feature calc

%tic

CN_feature= cat(2,CN(edges_train(:,1:2),adj_train),edges_train(:,1:2));

%disp(['Elapsed time for CN calculation is ',num2str(toc),' sec'])
%disp('-----------------------------------------')

% sorting based on the feature score

CN_sorted=sort_column1(CN_feature);
true_label=zeros(length(CN_sorted),1);
CN_sorted=cat(2,CN_sorted,true_label);
for i=1:length(CN_sorted)
    if(findedge(G,CN_sorted(i,2),CN_sorted(i,3))>0)
        CN_sorted(i,4)=1;
    end
end

% Eval parameters calculation
% EVAL = [accuracy sensitivity specificity precision recall f_measure gmean];
% EVAL = Evaluate(ACTUAL,PREDICTED)
predicted_topL=cat(1,ones(L_top,1), zeros(size(CN_sorted,1)-L_top,1));
eval_par(j,:)=Evaluate(CN_sorted(:,4),predicted_topL);
sum_eval_par = sum_eval_par + Evaluate(CN_sorted(:,4),predicted_topL); 

% Actual labels: CN_sorted(:,4), scores=CN_sorted(:,1)
[X,Y,T,AUC] = perfcurve(CN_sorted(:,4), CN_sorted(:,1),'1');

sum_AUC = AUC + sum_AUC;
% sum_X   = X + sum_X;
% sum_Y   = Y + sum_Y;

end
disp('Avg_eval_par = [accuracy sensitivity specificity precision recall f_measure gmean]')
Avg_eval_par=sum_eval_par./num_of_run
AUC_final=sum_AUC/num_of_run
% X_final=sum_X/num_of_run;
% Y_final=sum_Y/num_of_run;
% plot(X,Y)
