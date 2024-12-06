public class LinkedServiceSheetHandler{

   public void OnAfterInsert(Map<id,Linked_Service_Sheet__c> newLssMap,Map<id,Linked_Service_Sheet__c> oldLssMap){
         if(RecursiveHandler.runACC_UALOnce())
         RollupSumOnLss(newLssMap);
    }
    public void OnAfterUpdate(Map<id,Linked_Service_Sheet__c> newLssMap,Map<id,Linked_Service_Sheet__c> oldLssMap){
        if(RecursiveHandler.runOnce())
        RollupSumOnLss(newLssMap);
    }
    
    public void OnAfterDelete(Map<id,Linked_Service_Sheet__c> oldMap){
        if(RecursiveHandler.runCTH_UPCOnce())
        RollupSumOnLss(oldMap);
    }
    
    public void OnAfterUnDelete(Map<id,Linked_Service_Sheet__c> newLssMap){
        if(RecursiveHandler.runRSTH_UPONOnce())
        RollupSumOnLss(newLssMap);
    }
    
    public void RollupSumOnLss(Map<id,Linked_Service_Sheet__c> newLssMap){
        
        List<Id> LssIds=new List<Id>();
        Map<Id,Engineer_Checklist__c> Sheets;
        
        for(Linked_Service_Sheet__c Lss:newLssMap.values()){
            LssIds.add(Lss.Service_Sheet__c);
        }
        system.debug('LssIds>>>>>'+LssIds);
        if(LssIds.size()>0){
            
            Sheets=new Map<Id,Engineer_Checklist__c>([select id,Linked_SS_Count__c from Engineer_Checklist__c where id IN:LssIds]);
            system.debug('Sheets>>>>>'+Sheets);
            AggregateResult[] Result=[select Count(Id)cnt,Service_Sheet__c from Linked_Service_Sheet__c where Service_Sheet__c IN:LssIds GROUP BY Service_Sheet__c];
            
            system.debug('Result>>>>>'+Result);
            
            if(Result.size()>0){
            for(AggregateResult agg:Result){
                if(Sheets.containskey((Id)agg.get('Service_Sheet__c'))){
                    Sheets.get((Id)agg.get('Service_Sheet__c')).Linked_SS_Count__c=(Decimal)agg.get('cnt');
                }else{
                    Sheets.get((Id)agg.get('Service_Sheet__c')).Linked_SS_Count__c=0;
                }
            }
            }else{
                for(Engineer_Checklist__c SS:Sheets.values()){
                    SS.Linked_SS_Count__c=0;
                }
            }
            
        }
        if(Sheets.size()>0){
            update Sheets.values();
        }
    }
}