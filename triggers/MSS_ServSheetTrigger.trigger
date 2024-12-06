/*============================================================================================================
*Trigger Name   : Mechanical Service Sheet Triggers
*Description    : Define Trigger handler calls
*Company        : Puthuvannam Technology Solutions Pvt Ltd.
*Date           : 19th May, 2014
*Version        : 1.0
*Change History : Initial Trigger Handler
*============================================================================================================*/

trigger MSS_ServSheetTrigger on Mechanical_Service_Sheet__c (before Insert,before Update,after Insert,after Update) {
//Create a new Instance of MSS_ServSheetTriggerHandler 
MSS_ServSheetTriggerHandler handler = new MSS_ServSheetTriggerHandler();   
    if(Trigger.isBefore && Trigger.isInsert ){
        //Call the OnBeforeInsert Method
       handler.OnBeforeInsert(Trigger.new);     

    }
    if(Trigger.isBefore && Trigger.isUpdate){
       //Call the OnBeforeUpdate Method
       handler.OnBeforeUpdate(Trigger.new, trigger.old);
    }
    
    if(Trigger.isAfter && Trigger.isInsert ){
        //Call the OnAfterInsert Method
       handler.OnAfterInsert(Trigger.newMap);     

    }
    if(Trigger.isAfter && Trigger.isUpdate){
       //Call the OnAfterUpdate Method
       handler.OnAfterUpdate(Trigger.newMap, trigger.oldMap);
    }

}