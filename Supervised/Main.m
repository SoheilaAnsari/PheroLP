% In the name of ALLAH!
tic; % tic1 (entire program)
disp('---   S   T   A   R   T   ---')
clc; clear; close all;

%% Dataset selection
%  'Dolphins', 'USAir', 'Karate', 'Football', 'Jazz', 'polblogs',
%  'powergrid','NS','celegans'
dataset='polblogs';

%% Which feature to calculate?
NLC_feat=1;
CN_feat =0;
ACO_feat=1;

%% Init
num_of_run=10;
sum_AUROC=0;
sum_AUPR=0;
EV1=zeros(num_of_run,4);
% sum_AUC_Par = zeros(1,3);
eval_par=zeros(num_of_run,7);
sum_eval_par=zeros(1, 7);
sum_EV1 = zeros(1, 4);
%%
adj=adj_gen(dataset);
G=graph(adj);
existing_edges=G.Edges{:,:}; % G_Test

[idxo prtA]=randDivide(existing_edges,10) ;
N_Extra= size(prtA{1,11},1);
 
% Splitting the 11th portion to the other first 10 portions
if N_Extra~=0
    for i=1:1:N_Extra
        prtA{1,i}=cat(1,prtA{1,i},prtA{1,11}(i,:));
    end
end
prtA{1,11}=[];

%%
for j=1:10
disp(['progress ',num2str((100*j/num_of_run)), ' pecent'])
%% Dividing edge_list (Graph with feature vectors) into feature and train sets
t_gr_extraction=tic;
disp('---START TO DIVIDING GRAPH TO FEATURE,TRAIN AND TEST---')

dataTraining=[];
    for jj=1:1:j
        if ~(j==jj)
            dataTraining=cat(1,dataTraining,prtA{1,jj});
        end
    end
    if (j~=10)
        for jj=j+1:1:10
            dataTraining=cat(1,dataTraining,prtA{1,jj});
        end
    end
    
S_Test_Pos= prtA{1,j}(:,1:2);

% New adj is needed to correctly calculate the feature
New_G = graph(dataTraining(:,1),dataTraining(:,2),dataTraining(:,3),length(adj));
adj_train=adjacency(New_G);

% Listing S_Test
adj_prime=~adj;
temp_zero=diag(true(1,length(adj_prime)),0);
adj_prime(temp_zero)=0; % Setting diagonal elements to zero
G_prime=graph(adj_prime);
S_Test_Neg=G_prime.Edges{:,:}; % Unexisting edges in train graph :S_Test

S_Test_Act_Label=cat(1,ones(length(S_Test_Pos),1),zeros(length(S_Test_Neg),1));
S_Test=cat(1,S_Test_Pos,S_Test_Neg);

CN_for_S_TEST=CN(S_Test(:,1:2),adj_train);

K = find(CN_for_S_TEST);

S_Test_Two_Hop = S_Test(K, :); 
S_Test_Act_Label_Two_Hop = S_Test_Act_Label(K,1);


S_Test_Two_Hop_with_ACT_Lable=cat(2,S_Test_Two_Hop,S_Test_Act_Label_Two_Hop);
%%
%%
q = 0.7;      % proportion of rows to select for training
M = size(dataTraining,1);  % total number of rows 
tf2 = false(M,1);    % create logical index vector
tf2(1:round(q*M)) = true ;    
tf2 = tf2(randperm(M));   % randomise order
dataFeaturing = dataTraining(tf2,:); 
S_Train_Pos = dataTraining(~tf2,1:2);

%%
%%
% New adj is needed to correctly calculate the feature
New_Ga = graph(dataFeaturing(:,1),dataFeaturing(:,2),dataFeaturing(:,3),length(adj));
adj_feature=adjacency(New_Ga);
% G1=graph(adj_feature);

%%
%%
% Listing Unexisting edges
adj_prime2=~adj_train;
temp2_zero=diag(true(1,length(adj_prime2)),0);
adj_prime2(temp2_zero)=0; % Setting diagonal elements to zero
G2_prime=graph(adj_prime2);
S_Train_Neg=G2_prime.Edges{:,:}; % Unexisting edges in feature graph :S_Train

S_Train_Act_Label=cat(1,ones(length(S_Train_Pos),1),zeros(length(S_Train_Neg),1));
S_Train=cat(1,S_Train_Pos,S_Train_Neg);

CN_for_S_Train=CN(S_Train(:,1:2),adj_feature);

K = find(CN_for_S_Train);

S_Train_Two_Hop = S_Train(K, :); 
S_Train_Act_Label_Two_Hop = S_Train_Act_Label(K,1);




disp(['Elapsed time for EXTRACTING THREE SUBGRAPHS:',num2str(toc(t_gr_extraction))])
disp('-----------------------------------------')


%% Feature calc
FV_Train=[];
FV_Test=[];

%% CN_FEATURE
t_train_feat=tic; % Feature Extraction Time
disp('Feature Extraction Time :');
if (CN_feat == 1)
    t_CN_train=tic;
    disp('---START TO CALCULATE CN FEATURE FOR TRAINING MODEL---')
    CN_feature=CN(S_Train_Two_Hop(:,1:2),adj_feature);
    disp(['Elapsed time for CN calculation:',num2str(toc(t_CN_train))])
 
    FV_Train=CN_feature;

    t_CN_test=tic;
    disp('---START TO CALCULATE CN FEATURE FOR FV_TEST---')
    CN_feature_S_TEST=CN(S_Test_Two_Hop(:,1:2),adj_train);
    disp(['Elapsed time for CN calculation FOR FV_TEST:',num2str(toc(t_CN_test))])
   
    FV_Test=CN_feature_S_TEST;
end
%% NLC_FEATURE
if (NLC_feat == 1)
    t_NLC_train=tic;
    disp('---START TO CALCULATE NLC FEATURE FOR TRAINING MODEL---')
    disp('NLC feature Calculation');
    NLC_feature=NLC(adj_feature);
    NLC_value=conv_ACO_list(NLC_feature,S_Train_Two_Hop);
    disp(['NLC feature added to the Graph table successfully:',num2str(toc(t_NLC_train))]);
 
    FV_Train = cat(2,FV_Train,NLC_value);

    t_NLC_test=tic;
    disp('---START TO CALCULATE NLC FEATURE FOR FV_TEST---')
    disp('NLC feature Calculation');
    NLC_feature_S_TEST=NLC(adj_train);
    NLC_value_Test=conv_ACO_list(NLC_feature_S_TEST,S_Test_Two_Hop);
    disp(['NLC feature added to the Graph table successfully FOR FV_TEST:',num2str(toc(t_NLC_test))]);
 
    FV_Test = cat(2,FV_Test,NLC_value_Test);
end

%% ACO_FEATURE
t_ACO_train=tic;

if (ACO_feat == 1)
    
    disp('---START TO CALCULATE ACO FEATURE FOR TRAINING MODEL---')
    [tau]=ACO_Feature_Extract(adj_feature);
    ACO=conv_ACO_list(tau,S_Train_Two_Hop);
    disp(['Elapsed time for ACO calculation:',num2str(toc(t_ACO_train))])
    
    FV_Train = cat(2,FV_Train,ACO);

   t_ACO_test= tic;
    disp('---START TO CALCULATE ACO FEATURE FOR FV_TEST---')
    % ACO_FEATURE_for S_TEST
    [tau]=ACO_Feature_Extract(adj_train);
    ACO_S_TEST=conv_ACO_list(tau,S_Test_Two_Hop);
    disp(['Elapsed time for ACO calculation FOR FV_TEST:',num2str(toc(t_ACO_test))])
    
    FV_Test= cat(2,FV_Test,ACO_S_TEST);
end
 disp(['Elapsed time for Feature Extraction:',num2str(toc(t_train_feat))])
 disp('-----------------------------------------')
 
 
 [FV_Train_Syn, S_Train_Act_Label_Two_Hop_Syn] = ADASYN(FV_Train, S_Train_Act_Label_Two_Hop, [], [], [], false);
 
 FV_Train_Final = cat(1,FV_Train,FV_Train_Syn);
 S_Train_Act_Label_Two_Hop_Final = cat(1,S_Train_Act_Label_Two_Hop,S_Train_Act_Label_Two_Hop_Syn);
%  
%% TRAIN SVM MODEL 
t_both_training_predicting=tic; % Training model & Prediction
t_training =tic;
disp('---START TO TRAIN THE MODEL---')
SVMModel=fitcsvm(FV_Train_Final, S_Train_Act_Label_Two_Hop_Final);    % SVM classification


% SVMModel = fitcsvm(FV_Train_Final,S_Train_Act_Label_Two_Hop_Final,'Standardize',true,'KernelFunction','RBF',...
%     'KernelScale','auto');
% Mdl = fitensemble(FV_Train_Final,S_Train_Act_Label_Two_Hop_Final,'AdaBoostM1',50,'Tree');
% Mdl = fitcensemble(FV_Train_Final,S_Train_Act_Label_Two_Hop_Final);
% Mdl = fitcnb(FV_Train_Final,S_Train_Act_Label_Two_Hop_Final);
% Mdl = fitctree(FV_Train_Final,S_Train_Act_Label_Two_Hop_Final);




disp(['FINAL TIME FOR TRAINING MODEL:',num2str(toc(t_training))]);
disp('-----------------------------------------');
%% PREDICTION WITH TRAINED MODEL
t_prediction=tic;
disp('---START TO PREDICTING---')
[test_label, scores] = predict(SVMModel,FV_Test);
% [test_label, scores] = predict(Mdl,FV_Test);
disp([' TIME FOR PREDICTING:',num2str(toc(t_prediction))]);
disp('-----------------------------------------');
disp([' TIME FOR Training Model & prediction:',num2str(toc(t_both_training_predicting))]);

%%
%% Calculating evaluation metrics

disp('---START TO EVALUATION---')

disp(': Accuracy, Precision, Recall, F-Measure');

[ACC,PRE, Recall, F1_score] = myACC( scores(:,2),S_Test_Act_Label_Two_Hop,'sp0.95' );
EV1(j,:)=[ACC,PRE, Recall, F1_score];

%% AREA UNDER PRECISION_RECALL CURVE

disp('-------AUPR : ');
[X,Y,T,AUROC] = perfcurve(S_Test_Act_Label_Two_Hop, scores(:,2),'1');
AUPR =pr_curve(scores(:,2),S_Test_Act_Label_Two_Hop,'b')


sum_AUPR = AUPR + sum_AUPR;
sum_AUROC = AUROC + sum_AUROC;
disp(num2str(AUROC))
end


disp('Avg_EV1 = [ Accuracy, Precision, Recall, F-Measure]')
QQ = ~(any(isnan(EV1),2));

Out1 = EV1(~any(isnan(EV1),2),:);
for i=1:length(Out1)
    sum_EV1 = sum_EV1 + Out1(i,:);
end


Avg_EV1=sum_EV1./length(Out1)
% Avg_eval_par=sum_eval_par./length(Out2)
AUROC_final=sum_AUROC/num_of_run
AUPR_final=sum_AUPR/num_of_run
% Avg_AUC_Par = sum_AUC_Par/length(AUC_Par)
% disp([' TIME FOR EVALUATION:',num2str(toc)]);
% disp('-----------------------------------------');
disp(['Elapsed time for ENTIRE PROGRAM:',num2str(toc)])
disp('-----------------------------------------')

