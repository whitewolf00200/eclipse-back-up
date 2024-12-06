/*============================================================================================================
*Trigger Name   : AccountTriggers
*Description    : Define Trigger handler calls
*Company        : Puthuvannam Technology Solutions Pvt Ltd.
*Date           : 23th May, 2014
*Version        : 1.0
*Change History : Initial Trigger Handler
*============================================================================================================*/

trigger AccountTriggers on Account (after insert,after update,before insert, before update) {
//Create the Instance for the AccountTriggerHandler Class

    if(TriggerActive__c.getvalues('TurnOff').IsActive__c){
      
AccountTriggerHandler TriggerHandler  = new AccountTriggerHandler(); 
        if (trigger.isAfter && trigger.isUpdate){
     if(!System.isScheduled() ||!System.isBatch() )  {
    TriggerHandler.OnAfterUpdate(Trigger.newmap,Trigger.oldmap);
         
            TriggerHandler.Updatetotalamount(Trigger.newmap,Trigger.oldmap);
            }
        }
        
         if (trigger.isBefore && trigger.isUpdate){
      if(!System.isScheduled() ||!System.isBatch() )  {
            TriggerHandler.OnBeforeUpdate(Trigger.newmap,Trigger.oldmap);
             } 
        }
        
        if (trigger.isBefore && trigger.isInsert) {
    // Retrieve the custom setting instance
 
        // Call the OnBeforeInsert method
        TriggerHandler.OnBeforeInsert(Trigger.new);
        return;
    }


        }
    }