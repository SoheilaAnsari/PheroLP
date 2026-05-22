function [ sim ] = NLC( train)
tic
   degrees = sum(train,1);
   
   cn = train*train;
   
   egonetLinksNum = sum(train.*cn,1);
   
   C = egonetLinksNum./(degrees.*(degrees-1));
   
   n = size(train,1);

   degrees_1 = degrees-1;

   C_deg_1 = C./degrees_1;

   C_deg_1(isinf(C_deg_1))=0;
   C_deg_1(isnan(C_deg_1))=0;

   rep_M = repmat(C_deg_1,[n,1]);

   LC = cn.*rep_M;

   sim1 = train.*LC;
   sim1 = sim1*train;
   

   
   sim = sim1+sim1';
   
disp(['NLC calculation finished:',num2str(toc)]);

end