trigger QuoteLineItemTrigger on QuoteLineItem (after insert) {

QuoteLineItemHandler QuoteHandler=new QuoteLineItemHandler();

     if(trigger.isAfter && trigger.isInsert){
         QuoteHandler.AfterInsert(Trigger.NewMap);
     }
     
     }