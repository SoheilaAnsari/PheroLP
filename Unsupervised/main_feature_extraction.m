% In the name of ALLAH!

clc; clear; close all;

%% Dataset selection
%  'Dolphins', 'USAir', 'Karate', 'Football', 'Jazz', 'polblogs',
%  'powergrid','NS','celegans'
dataset='NS';

%% Phromone feature extraction + Triangle search
[tau, adj, triangles]=ACO_Feature_Extract(dataset);
disp('-----------------------------------------')
%% Removing nodes with zero degree (if existed any)
G_temp=graph(adj);
m=0;
for i=1:length(adj)
    if(degree(G_temp,i) == 0)
        G_temp=rmnode(G_temp,i);
        m=m+1;
    end
end
if(m>0)
    disp(['The nodes with zero degree are removed:',num2str(m),'nodes'])
    adj=adjacency(G_temp);
end
clear 'G_temp';
%% Cover remained unconnected nodes (zero elements of tau matrice) 
tau_prime=~tau;
temp_zero=diag(true(1,length(tau_prime)),0);
tau_prime(temp_zero)=0; % Setting diagonal elements to zero
clear 'temp_zero'
%% Considering tau feature as the weight of Graph parameter
G_temp1=graph(tau);
G_temp2=graph(tau_prime);
zero_edges_table=table(G_temp2.Edges{:,:},zeros(size(G_temp2.Edges,1),1),'VariableNames',{'EndNodes', 'Weight'});
G=cat(1, G_temp1.Edges, zero_edges_table);
clear('G_temp');
Graph=G{:,:}; %Converting table to matrice
%% CN feature calculation as another feature
tic
CN_feature=CN(Graph(:,1:2),adj);
Graph=cat(2,Graph,CN_feature);
disp(['Elapsed time for CN calculation:',num2str(toc)])
disp('-----------------------------------------')
%% Clustering coefficient calculation
tic
clust = Clust_Coef( Graph(:,1:2), CN_feature, adj);
Graph=cat(2,Graph,clust);
disp(['Clust. coef. added to the Graph table successfully:',num2str(toc)]);
clear 'clust'; clear 'CN_feature';
disp('-----------------------------------------');
%% NLC clustering coefficient calculation
tic
disp('NLC feature Calculation');
NLC_feature=NLC(adj);
NLC_edge_list=Conv2EdgeList(Graph(:,1:2), NLC_feature);
Graph = cat(2,Graph,NLC_edge_list);
clear NLC_feature; clear NLC_edge_list;
disp(['NLC feature added to the Graph table successfully:',num2str(toc)]);
disp('-----------------------------------------');
%% Labeling
label_G = label(Graph(:,1:2), adj);
Graph = cat(2,Graph,label_G);
clear label_G;

%% Dividing edge_list (Graph with feature vectors) into test and train sets
% disp('Dividing dataset to dataTraining & dataTesting sets');
% p = 0.9;                    % proportion of rows to select for training
% N = size(Graph,1);          % total number of rows 
% tf = false(N,1);            % create logical index vector
% tf(1:round(p*N)) = true;     
% tf = tf(randperm(N));       % randomise the order of '1's and '0's
% dataTraining = Graph(tf,:); 
% dataTesting  = Graph(~tf,:);
% disp('-----------------------------------------');

%% SVM classification with k-fold cross validation
% disp('SVM classification + k-fold cross validation in progress ...'); tic;
% % dataTraining is given to the SVM classifier to extract the model
% indices = crossvalind('Kfold', size(Graph,1), 10);
% eval_1=zeros(10,7);
% 
% ROC_total=struct([]);
% 
% for i = 1:10
%     tic
%     test = (indices == i); 
%     train = ~test;
%     % Select which feature do you want: ACO => dataTraining(:,3), CN => dataTraining(:,4), NLC => dataTraining(:,5)
%     FV_Train=cat(2,Graph(train,3),Graph(train,5));     
%     FV_Test=cat(2,Graph(test,3),Graph(test,5));
% %     FV_Train = Graph(train,4:5);     
% %     FV_Test = Graph(test,4:5);
%     RespV=Graph(train,6);        % Selecting response vector
%     SVMModel=fitcsvm(FV_Train, RespV);    % SVM classification
%     [test_label, scores] = predict(SVMModel,FV_Test);
%     
%     % EVAL = [accuracy sensitivity specificity precision recall f_measure gmean];
%     eval_1(i,:) = Evaluate(Graph(test,6),test_label); 
%     
% %     [X,Y,T,AUC] = perfcurve(test_label,scores(:,2),'1');
% %     plot(X,Y)
%     
%     ROC_data=roc_curve(scores(:,2), scores(:,1),0,0);
%     ROC_total=[ROC_total;ROC_data];
%     
% %     [tpr, tnr, info_roc] = vl_roc(test_label, scores(:,2));
% %     eval_2(i,1)=info_roc.auc;
% % 
% %     [rc, pr, info_pr] = vl_pr(test_label, scores(:,2)) ;
% %     eval_3(i,1)=info_pr.auc;
% %     eval_3(i,2)=info_pr.ap;
% %     eval_3(i,2)=info_pr.ap_interp_11;
% disp(['step', num2str(i),' elapsed time is ',num2str(toc),' sec']);
% end
% 
% disp('SVM classification finished');
% 
% %% Calculating final evaluation metrics (averaging)
% sum=0;
% for i=1:10
%     sum=sum+ROC_total(i).param.AROC;
% end
% Avg_Eval=mean(eval_1);
% T_Eval=table(...
%     sum/10,Avg_Eval(:,1),Avg_Eval(:,4),Avg_Eval(:,5),Avg_Eval(:,6),...
%     'VariableNames', ...
%     {'AUC','accuracy', 'precision', 'recall', 'f_measure'})
%% Preparing table for the classifier learner app
T_Graph=table(Graph(:,3), Graph(:,4), Graph(:,5), Graph(:,6),Graph(:,7), 'VariableNames', {'ACO', 'CN', 'CC', 'NLC', 'Label'});
% disp('Feature table created successfully and saved as T_Graph')
% disp('Do not forget to also save these variables: adj, dataset, Graph, T_Graph, tau, triangles')