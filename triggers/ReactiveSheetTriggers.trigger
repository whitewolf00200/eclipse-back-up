trigger ReactiveSheetTriggers on Service_Sheet_STD__c(after insert , after update, before Insert, before update) {
    ReactiveSheetTriggerHandler handler = new ReactiveSheetTriggerHandler();

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
        handler.OnBeforeInsert(Trigger.New);
    }
    
    if (trigger.isBefore && trigger.isUpdate){
        //Call the On After Insert Method
        handler.OnBeforeUpdate(Trigger.New, Trigger.OldMap);
    }
    
}