trigger QuoteTrigger on Quote (before insert,before update,after update) {
QuoteHandler Qo=new QuoteHandler();

     if (trigger.isBefore && trigger.isUpdate){
         Qo.OnBeforeInsert(Trigger.New);
     }
     
     if (trigger.isBefore && trigger.isInsert){
         Qo.OnBeforeUpdate(Trigger.New);
     }
     
       if(Trigger.isAfter && Trigger.isupdate){
        Qo.AfterUpdate(Trigger.NewMap,Trigger.oldMap);
    }

}