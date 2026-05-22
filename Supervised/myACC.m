

function [ACC,PRE,SEN,F1_score,MCC] = myACC( output,original,method )
      
   
    
    output=output(:);
    original=original(:);

   
    count1=length(find(original==1)); 
    count0=length(find(original==0));  

    [tpr,fpr,thresholds] = roc(original(:)',output(:)');  
    TP=count1*tpr;  
    FP=count0*fpr;  
    ACC= (TP+count0-FP)/(count1+count0); 
    F1_score=2*TP./(TP+count1);  
     
       
        if method=='sp0.99' 
            sp_value=0.99 ; 
            [~,position]=min(abs( fpr-(1-sp_value)));  

       
        elseif method=='sp0.95'
            sp_value=0.95 ; 
            [~,position]=min(abs( fpr-(1-sp_value)));

       
        elseif method=='youden'
            [~,position]=max(abs(tpr-fpr));  

        elseif method=='accMAX'
            [~,position]=max(ACC); 
        

        elseif method=='f1sMAX'
            [~,position]=max(F1_score);
        end
    
    thre=thresholds(position);
    TP=count1*tpr(position); 
    FP=count0*fpr(position);  
    FN=count1-TP;
    TN=count0-FP;

    
    PRE=TP/(TP+FP)  ;  
    SEN=tpr(position);
    ACC= (TP+count0-FP)/(count1+count0); 
    F1_score=2*TP/(count1+TP); 
    MCC=(TP*TN -FP*FN)/sqrt(count1*count0*(TP+FP)*(FN+TN));
    fprintf([ method,'：ACC=',num2str(ACC), '   PRE=',num2str(PRE), '   SEN=',num2str(SEN), '  F1 score=',num2str(F1_score), '   MCC=',num2str(MCC),  '\n']);

    end

