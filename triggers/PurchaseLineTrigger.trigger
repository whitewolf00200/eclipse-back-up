trigger PurchaseLineTrigger on PurchaseOrderLineItem__c (after insert) {
    
      PurchaseLineHandler handle=new PurchaseLineHandler();
    
         if(trigger.isAfter && trigger.isInsert){
             handle.AfterInsert(Trigger.NewMap);
         }
     }