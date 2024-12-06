Public class CreditLineItemHandler{

 public void BeforeInsert(List<Credit_Note_Line_Item__c> newList){
   
        
        InsertExtendedSales(newList);
        
    }


 public void InsertExtendedSales(List<Credit_Note_Line_Item__c> newMap){
   
        List<Id> ProductId=new List<Id>();
       
        Map<Id,Product2> PrdsList=new Map<Id,Product2>();
        
       
        for(Credit_Note_Line_Item__c NewId:newMap)
        {
            ProductId.add(NewId.Product_credit__c);
           
         }
        system.debug('ProductId=========='+ProductId);
       
        
       
        for(Product2 prd:[select id,Extended_Sales_Description__c,Sales_Description__c from product2 where id IN:ProductId]){
               PrdsList.put(prd.id,prd);
               
         } 
       
         for(Credit_Note_Line_Item__c NewId:newMap){
           
           if(PrdsList.containskey(NewId.Product_credit__c)){
             if(NewId.Extended_Sales_Description__c==null){        
                NewId.Extended_Sales_Description__c=PrdsList.get(NewId.Product_credit__c).Extended_Sales_Description__c;
              }
              if(NewId.SalesDescription__c==null){
                 NewId.SalesDescription__c=PrdsList.get(NewId.Product_credit__c).Sales_Description__c;
               }
              
               
           }
           
          
       }
    }
  }