trigger CreditTrigger on Credit_Notes__c (After update,After Insert) {
        
        CreditHandler handle=new CreditHandler();
        
        if(Trigger.isAfter && Trigger.isupdate){
            handle.AfterUpdate(Trigger.NewMap,Trigger.OldMap);
        }
        
         if(Trigger.isAfter && Trigger.isInsert){
            handle.AfterInsert(Trigger.NewMap);
        }
     }