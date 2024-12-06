trigger OpportunityProduct on OpportunityLineItem (before insert,before update) {
     OpportunityProductHandler handle=new OpportunityProductHandler();
      if(trigger.isBefore && trigger.isInsert){
         handle.BeforeInsert(Trigger.New);
     }
     if(trigger.isbefore && trigger.isUpdate){
         handle.BeforeUpdate(Trigger.NewMap);
     }
      
    }