% In the name of ALLAH, the most merciful

function [ tau, adj_mat, Triangles ] = ACO_Feature_Extract( dataset_name )
%ACO_FEATURE_EXTRACT Summary of this function goes here
%   Input   : dataset
%   Output  : features of each edges in the form of adjacency matrix

tic

%% Scoring criteria definition
nSubgrB=2; % SubgrB's score is nSubgrB times greater than subgrA

result = zeros(20000,5);

%% Dataset definition
%--------------------------------------------------------
% Dolphin
load dolphins.txt
Adj_dolphins = zeros(max([max(dolphins(:,1)) max(dolphins(:,1))])); 
% This graph is become unidirected by creating adj_mat as below 
for ii=1:1:length(dolphins)
    Adj_dolphins(dolphins(ii,1),dolphins(ii,2))=1;
    Adj_dolphins(dolphins(ii,2),dolphins(ii,1))=1;
end
%--------------------------------------------------------
% Football
load FootballMatrix.mat
Adj_football=FootballMatrix;
%--------------------------------------------------------
% Karate
load karate.mat;
Adj_karate = zeros(max([max(karate_edges(:,1)) max(karate_edges(:,1))])); 
% This graph is become unidirected by creating adj_mat as below 
for ii=1:1:length(karate_edges)
    Adj_karate(karate_edges(ii,1),karate_edges(ii,2))=1;
    Adj_karate(karate_edges(ii,2),karate_edges(ii,1))=1;
end
%--------------------------------------------------------
% Jazz
load jazz.txt
Adj_jazz = zeros(max([max(jazz(:,1)) max(jazz(:,2))])); 
% This graph is become unidirected by creating adj_mat as below 
for ii=1:1:length(jazz)
    Adj_jazz(jazz(ii,1),jazz(ii,2))=1;
    Adj_jazz(jazz(ii,2),jazz(ii,1))=1;
end
%--------------------------------------------------------
load USAir.txt
Adj_USAir = zeros(max([max(USAir(:,1)) max(USAir(:,2))])); 
% This graph is become unidirected by creating adj_mat as below 
for ii=1:1:length(USAir)
    Adj_USAir(USAir(ii,1),USAir(ii,2))=1;
    Adj_USAir(USAir(ii,2),USAir(ii,1))=1;
end
%--------------------------------------------------------
% Astro-ph
% load astroph.mat;
% n_node=length(core_auth);
% Adj_astroph = zeros(n_node); 
% for ii=1:1:length(Eold)
%     Adj_astroph(Eold(ii,1),Eold(ii,2))=1;
%     Adj_astroph(Eold(ii,2),Eold(ii,1))=1;
% end
%--------------------------------------------------------
%Polblogs
load polblogs.txt;
Adj_polblogs = zeros(max(polblogs(:,1))); 
% This graph is become unidirected by creating adj_mat as below 
for ii=1:1:length(polblogs)
    Adj_polblogs(polblogs(ii,1),polblogs(ii,2))=1;
    Adj_polblogs(polblogs(ii,2),polblogs(ii,1))=1;
end
%---------------------------------------------------------
%%
%Polblogs
load powergrid.txt;
Adj_powergrid = zeros(max(powergrid(:,1))); 
% This graph is become unidirected by creating adj_mat as below 
for ii=1:1:length(powergrid)
    Adj_powergrid(powergrid(ii,1),powergrid(ii,2))=1;
    Adj_powergrid(powergrid(ii,2),powergrid(ii,1))=1;
end
%%
load celegans.txt
Adj_celegans = zeros(max([max(celegans(:,1)) max(celegans(:,2))])); 
% This graph is become unidirected by creating adj_mat as below 
for ii=1:1:length(celegans)
    Adj_celegans(celegans(ii,1),celegans(ii,2))=1;
    Adj_celegans(celegans(ii,2),celegans(ii,1))=1;
end
%%
load NS.txt
Adj_NS = zeros(max([max(NS(:,1)) max(NS(:,1))])); 
% This graph is become unidirected by creating adj_mat as below 
for ii=1:1:length(NS)
    Adj_NS(NS(ii,1),NS(ii,2))=1;
    Adj_NS(NS(ii,2),NS(ii,1))=1;
end
% Epinion
% load Epinions.txt
% Adj_epi = zeros(max([max(Epinions(:,1)) max(Epinions(:,1))])); 
% % This graph is become unidirected by creating adj_mat as below 
% for ii=1:1:length(Epinions)
%     Adj_epi(Epinions(ii,1),Epinions(ii,2))=1;
%     Adj_epi(Epinions(ii,2),Epinions(ii,1))=1;
% end

%% Adj matrice definition

fprintf ('Start of phromone feature extraction + triangle search based on ACO\n')

switch (dataset_name)
    case 'Dolphins'
        adj_mat = Adj_dolphins;       
    case 'USAir'
        adj_mat = Adj_USAir;
    case 'Karate'
        adj_mat = Adj_karate;
    case 'Football'
        adj_mat = Adj_football;
    case 'Jazz'
        adj_mat = Adj_jazz;
    case 'polblogs'
        adj_mat = Adj_polblogs;
    case 'powergrid'
        adj_mat = Adj_powergrid;
    case 'NS'
         adj_mat = Adj_NS;
    case 'celegans'
         adj_mat = Adj_celegans;
    otherwise
        return;
end
%adj_mat = Adj_dolphins;
%adj_mat = Adj_karate;
%adj_mat = Adj_epi;
%adj_mat = Adj_polblogs;
%adj_mat = Adj_jazz;
%adj_mat = Adj_USAir;
%adj_mat = Adj_football;
%adj_mat = Adj_astroph;

%% ACO Parameters

n_tot=length(adj_mat); % total number of nodes
MaxIt=10;            % Maximum Number of Iterations

nAnt=10*n_tot;       % Number of Ants (Population Size)=10*Total number of nodes (Dynamically changed to become zero)
ntot_Ant=nAnt;       % Total number of the Ants (Static Value)
tau=adj_mat;         % Initial Phromone=Adjacency matrix of the graph
tau_temp=tau;        % Temporary saving of tau for symmetric inreasing

alpha=1;             % Phromone Exponential Weight
beta=0;              % Heuristic Exponential Weight
rho=0;               % Evaporation does not exist

%% ACO Initialization

% Empty Ant
empty_ant.Tour=[];
empty_ant.Triangles=[];

% Ant Colony Matrix
ant=repmat(empty_ant,nAnt,1);

% Checking the  calculated results and creating a report
correct_triangles=0;

% List of the ants (Health matrice of the ants)
Ant_list= ones(nAnt,1);

counter = 0; % if 3 last visited edges has ph>1, the ant is killed
c1=0;
flag=0;
temp_P=zeros(2,n_tot);

disp(['Initializtion elapsed time:',num2str(toc)])


%% ACO Main Loop
tic
m=1;
while nAnt > 0
    for it=1:MaxIt
        %% Stage 1: Put & Move (Putting the ants randomly in the graph and moving them)
        for k=1:ntot_Ant % Do it for all of the ants
            % Check if the selected ant is alive or not
            if (Ant_list(k,1) == 1)
                ant(k).Tour=randi([1 n_tot]); %% putting ant in a node randomly
                for l=2:n_tot
                    i=ant(k).Tour(end); %% Where does the ant exist now?(node number)
                    
                    % P = the probability of the ant movement from node i to all
                    % other neighbour nodes (p is a vector 1*n_tot)
                    P=(1./tau(i,:)).^alpha;
                    P(isinf(P)) = 0;
                    P(isnan(P)) = 0;
                    P(i)=0; %% Probability of going to the current node is zero (no self loops)
                    P=P/sum(P); %% Exchange to probability (between 0 to 1)
                    P(isinf(P)) = 0;
                    P(isnan(P)) = 0;
                    
                    % We should choose the node with most probability value
                    [x,j] = max(P); % j=indice, x=value
                    if x == max(P(j:end)) && x>0
                        % Check if there is more than one Max value, choose one of them randomly
                        for kk=1:1:n_tot
                            if( P(kk) > 0)
                                % counting unzero elements & using as an indice for temp_P
                                c1=c1+1;
                                % temp_P = the indice & value of the unzero elements of the P matrice
                                temp_P(1,c1) =P(kk);
                                temp_P(2,c1) = kk;
                            end
                        end
                        j = temp_P(2,randi([1 c1]));
                        c1=0;
                    end
                    if x == 0
                        % Ant is located in a node which there is no edges to go(fringe node)
                        % kill the ant=> Remove it from Ant_list
                        Ant_list (k,1)= 0;
                        nAnt=nAnt-1;
                        break;
                    end
                    ant(k).Tour=[ant(k).Tour j]; % Extending tour of k-th ant
                    Tour_len=length(ant(k).Tour);% Finding the last indice of the matrice(ant(k).tour)
                    
                    % If 3 successive pheromones are more than 1, kill the ant
                    if (Tour_len>2 && tau(ant(k).Tour(Tour_len-1),ant(k).Tour(end)) > 1 )
                        counter = counter +1;
                        if counter == 3
                            % kill the ant=> Remove it from Ant_list
                            Ant_list (k,1)= 0;
                            nAnt=nAnt-1;
                            % Ant(k) is dead, don't go through another tours
                            break;
                        end;
                    else
                        counter =0;
                    end;
                    
                    % If an ant moved in a self-loop kill it
                    if (Tour_len > 3)&&(ant(k).Tour(end) == ant(k).Tour(Tour_len-1))
                        % kill the ant=> Remove it from Ant_list
                        Ant_list (k,1)= 0;
                        nAnt=nAnt-1;
                        break; %Ant(k) is dead, don't go through another tours
                        
                        % Check if a triangle has been found
                    else if (Tour_len>4)&&(ant(k).Tour(end) == ant(k).Tour(Tour_len-3))
                            % Updating triangle list
                            ant(k).Triangles = [ant(k).Triangles; ant(k).Tour(Tour_len-3) ant(k).Tour(Tour_len-2) ant(k).Tour(Tour_len-1)];
                            % The ant matrice is going to be overwritten in next iteration, so save
                            % result in result matrice (search to ignore repeated matrices)
                            [cur_len,x]=size(ant(k).Triangles);
                            
                            %%
                            % found triangle node #
                            cur_triangle= sort([ant(k).Triangles(cur_len,1),ant(k).Triangles(cur_len,2),ant(k).Triangles(cur_len,3)]);
                            
                            % Adding triangle to the list & increasing the
                            % pertained pheromone if it is not repeated
                            % before
                            if (Is_Rep_Triangle(cur_triangle, result(:,1:3)) == 0)
                                % The found triangle is a new one
                                result(m,:) = [ant(k).Triangles(cur_len,1),ant(k).Triangles(cur_len,2),ant(k).Triangles(cur_len,3),k,it];
                                m=m+1;
                                % increase the pheromone of 3 edges of the triangle
                                tau(ant(k).Tour(Tour_len-3),ant(k).Tour(Tour_len-2)) = tau(ant(k).Tour(Tour_len-3),ant(k).Tour(Tour_len-2))+1;
                                tau(ant(k).Tour(Tour_len-2),ant(k).Tour(Tour_len-1)) = tau(ant(k).Tour(Tour_len-2),ant(k).Tour(Tour_len-1))+1;
                                tau(ant(k).Tour(Tour_len-1),ant(k).Tour(Tour_len-3)) = tau(ant(k).Tour(Tour_len-1),ant(k).Tour(Tour_len-3))+1;
                                % tau temp is considered to be symmetric-----------
                                tau_temp(ant(k).Tour(Tour_len-2),ant(k).Tour(Tour_len-3)) = tau_temp(ant(k).Tour(Tour_len-2),ant(k).Tour(Tour_len-3))+1;
                                tau_temp(ant(k).Tour(Tour_len-1),ant(k).Tour(Tour_len-2)) = tau_temp(ant(k).Tour(Tour_len-1),ant(k).Tour(Tour_len-2))+1;
                                tau_temp(ant(k).Tour(Tour_len-3),ant(k).Tour(Tour_len-1)) = tau_temp(ant(k).Tour(Tour_len-3),ant(k).Tour(Tour_len-1))+1;
                                % Providing symmetircity
                                tau_temp(ant(k).Tour(Tour_len-3),ant(k).Tour(Tour_len-2)) = tau_temp(ant(k).Tour(Tour_len-3),ant(k).Tour(Tour_len-2))+1;
                                tau_temp(ant(k).Tour(Tour_len-2),ant(k).Tour(Tour_len-1)) = tau_temp(ant(k).Tour(Tour_len-2),ant(k).Tour(Tour_len-1))+1;
                                tau_temp(ant(k).Tour(Tour_len-1),ant(k).Tour(Tour_len-3)) = tau_temp(ant(k).Tour(Tour_len-1),ant(k).Tour(Tour_len-3))+1;
                                % Command window display-------------------
                                if(m>2)
                                    fprintf(repmat('\b', 1, 17+length(num2str(m))));%fprintf(repmat('\n', 1, 1));
                                    disp(['found triangles:',num2str(m)]);
                                else
                                    %fprintf(repmat('\n', 1, 3));
                                    disp(['     found triangles:',num2str(m)]);
                                end
                            end
                        end
                    end
                end % end of k-th matrice tours
            end % end of if (ant E Ant_List)
        end
    end
end %while

result(m:end,:)=[];

disp(['Elapsed time for triangle search:',num2str(toc)])

tic
% Sorting nodes of each triangle ascendingly-------------------------------
for i=1:length(result)
    result(i,1:3)=sort(result(i,1:3));
end

%% Finding subgraph b

% Removing repeated values
fin_res=unique(result(:,1:3), 'rows');

%% Check Results (Always correct triangles are found, so may be ignored)
% for jj=1:1:length(fin_res)
%     if adj_mat(fin_res(jj,1), fin_res(jj,2)) && ...
%             adj_mat(fin_res(jj,2), fin_res(jj,3)) && ...
%             adj_mat(fin_res(jj,3), fin_res(jj,1))
%         correct_triangles = correct_triangles+1;
%     end
% end
% 
% wrong_triangles = length(fin_res)-correct_triangles;
% disp ('Correctly found triangle number:');
% disp (correct_triangles);
% 
% disp ('Wrongly found triangle number:');
% disp (wrong_triangles);
%%
tic

% Sorting fin_res matrice ascendingly
Triangles = sort_column1(fin_res);
tau=tau_temp;

m=1;
for k=1:length(Triangles)            % Sweeping all triangles
    for i=1:length(adj_mat)          % Sweeping all nodes of the graph
        tau = Tau_update_by_Subgr1(Triangles(k,:),tau,adj_mat, i, nSubgrB);
    end
end

disp(['Elapsed time for score calculation:',num2str(toc)])



end

