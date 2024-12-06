trigger InventoryTrigger on Inventory__c (after insert,after update,before insert, before update,after delete,after undelete) {

InventoryTriggerHandler TriggerHandler  = new InventoryTriggerHandler(); 
             
        if (trigger.isBefore && trigger.isInsert){
        //Call the On Before Insert Method
         TriggerHandler.OnBeforeInsert(Trigger.new);
        }
    
        if (trigger.isBefore && trigger.isUpdate){
          //Call the On Before Insert Method
          // TriggerHandler.OnBeforeUpdate(Trigger.NewMap, Trigger.OldMap);
        }
    
        if (trigger.isAfter && trigger.isUpdate){
        //Call the OnAfterUpdate Metho
          TriggerHandler.OnAfterUpdate(Trigger.NewMap, Trigger.OldMap);
        }
        if (trigger.isAfter && trigger.isInsert){
        //Call the On After Insert Method
        TriggerHandler.OnAfterInsert(Trigger.NewMap, Trigger.OldMap);
        
        }  
        if (trigger.isAfter && trigger.isDelete){
        //Call the On After Delete Method
        TriggerHandler.OnAfterDelete(Trigger.OldMap);
        
        }           
        if (trigger.isAfter && trigger.isUnDelete){
        //Call the On After UnDelete Method
        TriggerHandler.OnAfterUnDelete(Trigger.NewMap);
        
        } 
        
    }