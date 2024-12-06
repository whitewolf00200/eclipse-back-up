public class SalesLineHandler{

    
   
    public void AfterInsert(Map<Id,SalesOrderLineItems__c> newMap){
    system.debug('after insert==========='+newMap);
    UpddateExtendedSales(newMap);
   
    }
    
     
    
    public void UpddateExtendedSales(Map<Id,SalesOrderLineItems__c> newMap){
    system.debug('update newMap=========='+newMap.values());
        List<Id> ProductId=new List<Id>();
        Map<Id,OpportunityLineItem > PrdsList=new Map<Id,OpportunityLineItem >();
        Set<Id> soid=new Set<Id>();
        Set<Id> oppid=new Set<Id>();
        List<SalesOrderLineItems__c> olist=new List<SalesOrderLineItems__c>();
        Map<Id,Product2> PrdMap=new Map<Id,Product2>();
        List<SalesOrderLineItems__c> olistnew=new List<SalesOrderLineItems__c>();
        
        
        
        for(SalesOrderLineItems__c NewId:newMap.values()){
            soid.add(NewId.Sales_Order__c);
            ProductId.add(NewId.Product__c);
           
        }
        
        for(Product2 prd:[select id,Extended_Sales_Description__c,Sales_Description__c from product2 where id IN:ProductId])
            PrdMap.put(prd.id,prd);
       
        for(SalesOrder__c qu:[select id,name,Opportunity__c from SalesOrder__c where id IN:soid])
            oppid.add(qu.Opportunity__c );
        
        for(OpportunityLineItem ol:[select id,name,OpportunityId,Extended_Sales_Description__c,SalesDescription__c,Product2Id from OpportunityLineItem where OpportunityId IN:oppid])
             PrdsList.put(ol.Product2Id,ol);
        
        
       for(SalesOrderLineItems__c  NewId:[SELECT Id,Sales_Description__c,Extended_Sales_Description__c,Product__c FROM SalesOrderLineItems__c  WHERE Id IN: Trigger.newMap.keySet()] ){
           
           if(PrdsList.containskey(NewId.Product__c )){
               if(NewId.Extended_Sales_Description__c==null){
                   NewId.Extended_Sales_Description__c=PrdsList.get(NewId.Product__c ).Extended_Sales_Description__c;
               }
               if(NewId.Sales_Description__c==null){
                   NewId.Sales_Description__c=PrdsList.get(NewId.Product__c ).SalesDescription__c;
               }
               olist.add(NewId);
           }else{
           
                 if(NewId.Extended_Sales_Description__c==null){
                       NewId.Extended_Sales_Description__c=PrdMap.get(NewId.Product__c).Extended_Sales_Description__c;
                 }
                 if(NewId.Sales_Description__c==null){
                       NewId.Sales_Description__c=PrdMap.get(NewId.Product__c).Sales_Description__c;
                 }
               
               olist.add(NewId);
              }
       }
       
     
       
       if(olist.size()>0){
   
       update olist;
       }
    }
    
     
}