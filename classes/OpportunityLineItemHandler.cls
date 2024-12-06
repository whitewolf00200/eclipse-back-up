public with sharing class OpportunityLineItemHandler {
    private Boolean m_isExecuting = false;
    private Integer BatchSize = 0;
    public static string OTHER_CODE = 'OTHER7';
    
    public OpportunityLineItemHandler(Boolean isExecuting, Integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    
    public void OnBeforeInsert(List<OpportunityLineItem> newList){
        Set<Id> pbIds = new Set<Id>();
        for(OpportunityLineItem oli : newList){
            pbIds.add(oli.PricebookEntryId);
        }
        Map<Id, PricebookEntry> pbEntries = new Map<Id, PricebookEntry>([SELECT Name, ProductCode FROM PricebookEntry WHERE Id IN : pbIds]);
        
        for(OpportunityLineItem oli : newList){
            PricebookEntry pbe = pbEntries.get(oli.PricebookEntryId);
            if(pbe.ProductCode == OTHER_CODE){
                oli.Is_Other_Product__c = true;
            }
        }
    }

}