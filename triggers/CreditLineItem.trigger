trigger CreditLineItem on Credit_Note_Line_Item__c(before insert) {
        
        CreditLineItemHandler handle=new CreditLineItemHandler();
        
          if(Trigger.isBefore && Trigger.isinsert){
            handle.BeforeInsert(Trigger.New);
          }
     }