trigger ProjectSheetTriggers on Project_Sheet__c(after insert , after update, before Insert, before update) {
    ProjectSheetTriggerHandler handler = new ProjectSheetTriggerHandler();
    if (trigger.isAfter && trigger.isUpdate){
        //Call the OnAfterUpdate Method
        handler.OnAfterUpdate(Trigger.NewMap, Trigger.OldMap);
    }
    if (trigger.isAfter && trigger.isInsert){
        //Call the On After Insert Method
        handler.OnAfterInsert(Trigger.NewMap, Trigger.OldMap);
    }
    
    
    if (trigger.isBefore && trigger.isInsert){
        //Call the On After Insert Method
        handler.OnBeforeInsert(Trigger.NewMap);
    }
    
    if (trigger.isBefore && trigger.isUpdate){
        //Call the On After Insert Method
        handler.OnBeforeUpdate(Trigger.NewMap, Trigger.OldMap);
    }
    
}