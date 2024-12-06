trigger PurchaseOrder on PurchaseOrder__c (before insert,before update,after update) {

PurchaseOrderHandler Po=new PurchaseOrderHandler();

     if (trigger.isBefore && trigger.isUpdate){
         Po.OnBeforeInsert(Trigger.New);
     }
     
     if (trigger.isBefore && trigger.isInsert){
         Po.OnBeforeUpdate(Trigger.New);
     }
     
      if (trigger.isafter  && trigger.isupdate){
         Po.AfterUpdate(Trigger.newMap,Trigger.oldMap);
     }
}