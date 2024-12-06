public class QuoteLineItemHandler{

    
   
    public void AfterInsert(Map<Id,QuoteLineItem> newMap){
    UpddateExtendedSales(newMap);
   
    }
    
     
    
    public void UpddateExtendedSales(Map<Id,QuoteLineItem> newMap){
   
        List<Id> ProductId=new List<Id>();
        Map<Id,OpportunityLineItem > PrdsList=new Map<Id,OpportunityLineItem >();
        Set<Id> Qid=new Set<Id>();
        Set<Id> oppid=new Set<Id>();
        List<QuoteLineItem > olist=new List<QuoteLineItem >();
        Map<Id,Product2> PrdMap=new Map<Id,Product2>();
        List<QuoteLineItem > olistnew=new List<QuoteLineItem >();
        
        
        for(QuoteLineItem NewId:newMap.values()){
              Qid.add(NewId.QuoteId);
              ProductId.add(NewId.Product2Id);
        }
       for(Product2 prd:[select id,Extended_Sales_Description__c,Sales_Description__c from product2 where id IN:ProductId])
              PrdMap.put(prd.id,prd);
               
       for(Quote qu:[select id,name,OpportunityId from Quote where id IN:Qid])
              oppid.add(qu.OpportunityId );
        
       for(OpportunityLineItem ol:[select id,name,OpportunityId,SalesDescription__c,Extended_Sales_Description__c,Product2Id from OpportunityLineItem where OpportunityId IN:oppid])
             PrdsList.put(ol.Product2Id,ol);
        
      
       for(QuoteLineItem NewId:[SELECT Id, Extended_Sales_Description__c,Sales_Description__c,Product2Id FROM QuoteLineItem WHERE Id IN: Trigger.newMap.keySet()] ){
           
           if(PrdsList.containskey(NewId.Product2Id)){
              
               NewId.Extended_Sales_Description__c=PrdsList.get(NewId.Product2Id).Extended_Sales_Description__c;
               NewId.Sales_Description__c=PrdsList.get(NewId.Product2Id).SalesDescription__c;
               
               olist.add(NewId);
           }else{
               NewId.Extended_Sales_Description__c=PrdMap.get(NewId.Product2Id).Extended_Sales_Description__c;
               NewId.Sales_Description__c=PrdMap.get(NewId.Product2Id).Sales_Description__c;
               olist.add(NewId);
            }
       }
       
      
       if(olist.size()>0){
          update olist;
       }
    }
    
     
}