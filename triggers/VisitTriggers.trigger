trigger VisitTriggers on Visits__c (after insert,after update, before insert, before update) {
    //Create the Instance for the AccountTriggerHandler Class
    VisitTriggerHandler handler= new VisitTriggerHandler(); 
  
    if (trigger.isAfter && trigger.isUpdate){
        //Call the OnAfterUpdate Method
            system.debug('Cursor Point===VisitTriggers -AU');
        handler.OnAfterUpdate(Trigger.newmap,Trigger.oldmap);
    }
    if (trigger.isAfter && trigger.isInsert){
        //Call the OnAfterUpdate Method
            system.debug('Cursor Point===VisitTriggers -AU');
        handler.OnAfterInsert(Trigger.newmap,Trigger.oldmap);
    }
    if (trigger.isBefore && trigger.isInsert){
        //Call the OnAfterUpdate Method
        handler.OnBeforeInsert(Trigger.new);
    }
        
  if (trigger.isBefore && trigger.isUpdate){
        //Call the OnBeforeUpdate Method
        handler.OnBeforeUpdate(Trigger.newmap,Trigger.oldMap);
    } 

}