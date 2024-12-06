trigger DeliveryNoteTrigger on Delivery_Note__c (after update) {

    DeliveryNoteHandler DNHandler=new DeliveryNoteHandler();
    
    if(Trigger.isAfter && Trigger.isupdate){
        DNHandler.AfterUpdate(Trigger.NewMap,Trigger.OldMap);
    }
   
}