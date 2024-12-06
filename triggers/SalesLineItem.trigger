trigger SalesLineItem on SalesOrderLineItems__c (after insert) {
       SalesLineHandler sa=new SalesLineHandler();
        if(trigger.isAfter && trigger.isInsert){
         sa.AfterInsert(Trigger.NewMap);
     }
    }