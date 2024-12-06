trigger ProductTrigger on Product2 (after insert,before update,After update,Before Delete) {

    ProductHandler Handler=new ProductHandler();

     if (trigger.isAfter && trigger.isInsert){
          Handler.onAfterInsert(Trigger.new);
        }
     if (trigger.isBefore && trigger.isUpdate){
          Handler.onBeforeUpdate(Trigger.newMap,Trigger.oldMap);
          
     }
     if (trigger.isAfter && trigger.isInsert){
       Handler.onAfterInsert1(Trigger.newMap,Trigger.oldMap);
     }
     if (trigger.isAfter && trigger.isUpdate){
      Handler.onAfterUpdate(Trigger.newMap,Trigger.oldMap);
     }
      if (trigger.isBefore && trigger.isDelete){
          Handler.onBeforeDelete(Trigger.oldMap);
     }

}