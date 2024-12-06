Public class OpportunityProductHandler{

 public void BeforeInsert(List<OpportunityLineItem > newList){
    system.debug('newlist==========='+newList);
        
        InsertExtendedSales(newList);
        
    }
    public void BeforeUpdate(Map<Id,OpportunityLineItem> newMap){
    
        UpddateExtendedSales(newMap);
     
    }
 
 /* =================================================================
    Method Name:UpddateExtendedSales
    Description: Update Extended sales description
    Created Date: 13.7.17
    =====================================================================  */
    
  public void UpddateExtendedSales(Map<Id,OpportunityLineItem> newMap){
        system.debug('update newMap=========='+newMap.values());
        List<Id> ProductId=new List<Id>();
        Map<Id,Product2> PrdsList=new Map<Id,Product2>();
        
        for(OpportunityLineItem NewId:newMap.values()){
            ProductId.add(NewId.Product2Id);
            
            }
       
        for(Product2 prd:[select id,Extended_Sales_Description__c,Sales_Description__c from product2 where id IN:ProductId]){
            PrdsList.put(prd.id,prd);
        }  
       
        for(OpportunityLineItem NewId:newMap.values()){
           
           if(PrdsList.containskey(NewId.Product2Id)){
              if(NewId.Extended_Sales_Description__c==null){
                 NewId.Extended_Sales_Description__c=PrdsList.get(NewId.Product2Id).Extended_Sales_Description__c;
               }
               if(NewId.SalesDescription__c==null){
                  NewId.SalesDescription__c=PrdsList.get(NewId.Product2Id).Sales_Description__c;
               }
           }
       }
    } 
    
    /* =================================================================
    Method Name:InsertExtendedSales and Update sales price based on customer
    Description: InsertExtendedSales description
    Created Date: 13.7.17
    =====================================================================  */
    
     public void InsertExtendedSales(List<OpportunityLineItem> newMap){
   
        List<Id> ProductId=new List<Id>();
        Set<Id> Accid=new Set<Id>();
        Map<Id,Product2> PrdsList=new Map<Id,Product2>();
        Map<Id,Account_Product_Price__c > SProd=new Map<Id,Account_Product_Price__c >();
       
        for(OpportunityLineItem NewId:newMap)
        {
            ProductId.add(NewId.Product2Id);
            Accid.add(NewId.Site_Id__c);
            Accid.add(NewId.Customer_Id__c);
            
        }
        system.debug('ProductId=========='+ProductId);
        system.debug('Accid============'+Accid);
        
          for(Account_Product_Price__c ap:[Select id,Account__c,Price__c,Product__c from Account_Product_Price__c where Product__c IN:ProductId AND Account__c IN:Accid]){
            SProd.put(ap.Product__c,ap); 
      }
        for(Product2 prd:[select id,Extended_Sales_Description__c,Sales_Description__c from product2 where id IN:ProductId]){
               PrdsList.put(prd.id,prd);
               
         } 
       
         for(OpportunityLineItem NewId:newMap){
           
           if(PrdsList.containskey(NewId.Product2Id)){
             if(NewId.Extended_Sales_Description__c==null){        
                NewId.Extended_Sales_Description__c=PrdsList.get(NewId.Product2Id).Extended_Sales_Description__c;
              }
              if(NewId.SalesDescription__c==null){
                 NewId.SalesDescription__c=PrdsList.get(NewId.Product2Id).Sales_Description__c;
               }
              
               
           }
           
          if(SProd.containskey(NewId.Product2Id)){
               NewId.UnitPrice=SProd.get(NewId.Product2Id).Price__c;
          }
       }
    }
}