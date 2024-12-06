Public class PurchaseLineHandler{


    public void AfterInsert(Map<Id,PurchaseOrderLineItem__c > newMap){
   
    UpddateExtendedSales(newMap);
   }
    
  /* =======================================
  Method Name: UpddateExtendedSales
  Description: Update currency type and extended sales description
  ========================================== */
  

  public void UpddateExtendedSales(Map<Id,PurchaseOrderLineItem__c> newMap){
        List<Id> ProductId=new List<Id>();
        List<PurchaseOrderLineItem__c> olist=new List<PurchaseOrderLineItem__c>();
        Map<Id,Product2> PrdMap=new Map<Id,Product2>();
        
       for(PurchaseOrderLineItem__c  NewId:newMap.values())
            ProductId.add(NewId.Product__c);
       
       for(Product2 prd:[select id,Extended_Sales_Description__c,Extended_Supplier_Description__c ,Sales_Description__c from product2 where id IN:ProductId]){
               PrdMap.put(prd.id,prd);
       }  
       
       
       for(PurchaseOrderLineItem__c   NewId:[SELECT Id,CurrencyIsoCode,Purchase_Order__r.CurrencyIsoCode, Extended_Sales_Description__c,Sales_Description__c,Extended_Supplier_Description__c,Product__c FROM PurchaseOrderLineItem__c  WHERE Id IN: Trigger.newMap.keySet()]){
           
           NewId.CurrencyIsoCode=NewId.Purchase_Order__r.CurrencyIsoCode;
           
          if(PrdMap.ContainsKey(NewId.Product__c )){
             
                  NewId.Extended_Sales_Description__c=PrdMap.get(NewId.Product__c ).Extended_Sales_Description__c;
                  NewId.Sales_Description__c=PrdMap.get(NewId.Product__c ).Sales_Description__c;
                  NewId.Extended_Supplier_Description__c=PrdMap.get(NewId.Product__c ).Extended_Supplier_Description__c;
               
               
               
             }
             olist.add(NewId);
           
       }
       
       if(olist.size()>0){
       update olist;
       }
    }
    
  
 }