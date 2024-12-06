trigger DeliveryNoteLineTrigger on Delivery_Note_Line_Item__c (after insert) {

DeliveryNoteLineHandler Handler=new DeliveryNoteLineHandler();
    
    if (trigger.isAfter && trigger.isInsert){
       Handler.OnAfterInsert(Trigger.newmap);
   }
}