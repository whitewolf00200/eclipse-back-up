public class QuoteHandler{
     
     public void OnBeforeInsert(List<Quote> NewList){
         UpdateQouteId(NewList);
     }
     
     public void OnBeforeUpdate(List<Quote> NewList){
         UpdateQouteId(NewList);
     }
     
       public void AfterUpdate(Map<id,Quote> newMap,Map<id,Quote> oldMap){
    
        showdesc(newMap,oldMap);
        
    }
    
    
     public void showdesc(Map<id,Quote> newMap,Map<id,Quote> oldMap){
        Set<id> quoid=new Set<id>();
        List<QuoteLineItem> qliList=new List<QuoteLineItem>();
        List<QuoteLineItem> qli=new List<QuoteLineItem>();
       for(Quote quo:newMap.values()){
          if(quo.Show_Description__c!=oldMap.get(quo.id).Show_Description__c){
              quoid.add(quo.id);
          }
          }
          
         
       if(quoid.size()>0){ 
         for(QuoteLineItem ql:[Select id,Show_Description__c,Quote.Show_Description__c,QuoteId from QuoteLineItem where QuoteId  IN:quoid]){
           ql.Show_Description__c=ql.Quote.Show_Description__c;
           qli.add(ql);
         } 
       }
       if(qli.size()>0){
           update qli;
       }  

    }
    
     public void UpdateQouteId(List<Quote> NewList){
         List<Id> QuoteIds=new List<Id>();
         Map<Id,Id> ContactIds=new Map<Id,Id>();
         
         for(Quote Qo:NewList){
             if(Qo.OpportunityId!=null){
                 QuoteIds.add(Qo.OpportunityId);
             }
         }
         
         if(QuoteIds.size()>0){
             for(Opportunity opp:[select id,Name,Shipping_Contact__c from Opportunity where id IN:QuoteIds]){
                 ContactIds.put(opp.Id,opp.Shipping_Contact__c );
             }
         }
         
         for(Quote Qo:NewList){
             if(Qo.OpportunityId !=null){
                 if(ContactIds.containskey(Qo.OpportunityId)){
                     Qo.ContactId=ContactIds.get(Qo.OpportunityId);
                     system.debug('ContactId======='+Qo.ContactId);
                 }
             }
         }
     }
     
}