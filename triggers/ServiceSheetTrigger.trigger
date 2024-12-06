trigger ServiceSheetTrigger on Engineer_Checklist__c (after insert, after update, before insert, before update) {
//Instance creation or the ServiceSheetTriggerHandler 
ServiceSheetTriggerHandler handler = new ServiceSheetTriggerHandler();

    if(trigger.isAfter && trigger.IsUpdate){
        //call the OnAfterUpdate method
        system.debug('Cursor Point===ServiceSheetTrigger-AU');
        handler.OnAfterUpdate(trigger.newmap, Trigger.OldMap);
    }
    
    if(trigger.isAfter && trigger.IsInsert){
        handler.OnAfterInsert(trigger.newmap,trigger.oldmap);
         
    }   
    
    if(trigger.isBefore && trigger.IsInsert){
        system.debug('Cursor Point===ServiceSheetTrigger-BU');
        handler.OnBeforeInsert(trigger.new);
    } 
      
    if(trigger.isBefore && trigger.IsUpdate){
        handler.OnBeforeUpdate(trigger.newmap,Trigger.OldMap);
    }
   
    }