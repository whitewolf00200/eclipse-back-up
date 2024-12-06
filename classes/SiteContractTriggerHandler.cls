public class SiteContractTriggerHandler{

    public SiteContractTriggerHandler(){}
    public void OnBeforeInsert(List<SiteContracts__c> newSC){
        ContactUpdate(newSC);
    }
    
    public void ContactUpdate(List<SiteContracts__c> newSC){        
        List<Id> accid=new List<Id>();
        for(SiteContracts__c sc:newSC){
            if(sc.Site__c!=null){
                accid.add(sc.Site__c);                
            }
        }
        
        if(accid.size()>0){
            Map<Id,Account> accMap=new Map<Id,Account>([select id,Site_Contact__c from Account where id IN :accid]);
            System.debug('accMap===='+accMap);
            for(SiteContracts__c sc:newSC){
                if(accMap.containskey(sc.Site__c)){
                System.debug('contact===='+accMap.get(sc.Site__c).Site_Contact__c);
                    sc.Contact_Site_Contracts__c=accMap.get(sc.Site__c).Site_Contact__c;
                }
            }    
        }
    }
}