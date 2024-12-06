trigger complaitTrigger on Complaints__c (Before Insert,Before Update) {
//Create new instance of ComplaintTriggerHandler
ComplaintTriggerHandler handler=new ComplaintTriggerHandler();

    if(trigger.isBefore && trigger.isInsert){
        //Call OnBeforeUpdate Method
        handler.onBeforeInsert(trigger.new);
    }
    
    if(trigger.isBefore && trigger.isUpdate){
        //Call OnAAfterfterUpdate Method
        handler.onBeforeUpdate(trigger.new);
    }
}