trigger InventoryTransaction on Inventory_Transaction__c (Before insert, Before update,After Insert) {

InventoryTransactionHandler TriggerHandler=new InventoryTransactionHandler();

       if (trigger.isAfter && trigger.isInsert){
         TriggerHandler.OnAfterInsert(Trigger.newMap);
        }
       
        if (trigger.isBefore && trigger.isUpdate){
         TriggerHandler.OnBeforeUpdate(Trigger.NewMap);
        }

}