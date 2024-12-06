/*============================================================================================================
*Trigger Name   : Purchase Order Triggers
*Description     : Define Trigger handler calls
*Company         : Puthuvannam Technology Solutions Pvt Ltd.
*Date            : 17 June, 2014
*Version        : 1.0
*Change History : Initial Trigger Handler
*============================================================================================================*/

trigger PurchaseOrderTrigger on SFDC_Purchase_Order__c(after Insert,after Update, before insert, before update){
  //Create the Instance for the PurchaseOrderTriggerHandler Class
  PurchaseOrderTriggerHandler handler = new PurchaseOrderTriggerHandler();
  if(Trigger.isAfter && Trigger.isInsert ){
        //Call the OnAfterInsert Method
       handler.OnAfterInsert(Trigger.newMap);     
    }
    if(Trigger.isAfter && Trigger.isUpdate){
       //Call the OnAfterUpdate Method
       handler.OnAfterUpdate(Trigger.newMap, trigger.oldMap);
    }
    
     if(Trigger.isBefore && Trigger.isInsert){
       //Call the OnAfterUpdate Method
       handler.OnBeforeInsert(Trigger.new);
    }
    
     if(Trigger.isBefore && Trigger.isUpdate){
       system.debug('Coming to trigger');
       //Call the OnAfterUpdate Method
       handler.OnBeforeUpdate(Trigger.new);
    }
}