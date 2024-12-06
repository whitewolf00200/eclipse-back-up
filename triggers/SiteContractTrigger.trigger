trigger SiteContractTrigger on SiteContracts__c (before insert,after update,after insert,before update) {
    
  SiteContractTriggerHandler handler = new SiteContractTriggerHandler();
  if(Trigger.isInsert && Trigger.isBefore) {    
    handler.OnBeforeInsert(Trigger.New);
  }
  
}