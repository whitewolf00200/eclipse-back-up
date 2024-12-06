trigger SalesOrder on SalesOrder__c (after insert,after update,before insert) {

SalesOrderTriggerHandler Handler=new SalesOrderTriggerHandler();

       if (trigger.isAfter && trigger.isInsert){
          Handler.OnAfterInsert(Trigger.NewMap,Trigger.OldMap); 
       }
       
       if(Trigger.isAfter && Trigger.isupdate){
        Handler.AfterUpdate(Trigger.NewMap,Trigger.OldMap);
       }
     if (trigger.isBefore && trigger.isInsert){
          Handler.updatelon(Trigger.New); 
       }
}