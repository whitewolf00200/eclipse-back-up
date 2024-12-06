trigger LinkedServiceSheet on Linked_Service_Sheet__c (after insert,after update,before insert, before update,after delete,after undelete) {

LinkedServiceSheetHandler LSShandler=new LinkedServiceSheetHandler();

        if (trigger.isBefore && trigger.isUpdate){
          //Call the On Before Insert Method
          // TriggerHandler.OnBeforeUpdate(Trigger.NewMap, Trigger.OldMap);
        }
    
        if (trigger.isAfter && trigger.isUpdate){
        //Call the OnAfterUpdate Metho
          LSShandler.OnAfterUpdate(Trigger.NewMap, Trigger.OldMap);
        }
        if (trigger.isAfter && trigger.isInsert){
        //Call the On After Insert Method
        LSShandler.OnAfterInsert(Trigger.NewMap, Trigger.OldMap);
        
        }  
        if (trigger.isAfter && trigger.isDelete){
        //Call the On After Delete Method
        LSShandler.OnAfterDelete(Trigger.OldMap);
        
        }           
        if (trigger.isAfter && trigger.isUnDelete){
        //Call the On After UnDelete Method
        system.debug('Calling Fun');
        LSShandler.OnAfterUnDelete(Trigger.NewMap);
        
        } 
}