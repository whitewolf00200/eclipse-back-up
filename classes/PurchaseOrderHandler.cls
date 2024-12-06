public class PurchaseOrderHandler{
     
     public void OnBeforeInsert(List<PurchaseOrder__c> NewMap){
         UpdateSupplierId(NewMap);
     }
     
     public void OnBeforeUpdate(List<PurchaseOrder__c> NewMap){
         UpdateSupplierId(NewMap);
     }
     
      public void AfterUpdate(Map<id,PurchaseOrder__c> newMap,Map<id,PurchaseOrder__c> oldMap){
    
        showDescription(newMap,oldMap);
        CurrencyType(newMap,oldMap);
        
    }
    
     public void UpdateSupplierId(List<PurchaseOrder__c> NewMap){
         List<Id> SupplierIds=new List<Id>();
         Map<Id,Id> ContactIds=new Map<Id,Id>();
         
         for(PurchaseOrder__c Po:NewMap){
             if(Po.Supplier__c!=null){
                 SupplierIds.add(Po.Supplier__c);
             }
         }
         
         if(SupplierIds.size()>0){
             for(Account Acc:[select id,Name,Contact__c from Account where id IN:SupplierIds]){
                 ContactIds.put(Acc.Id,Acc.Contact__c);
             }
         }
         
         for(PurchaseOrder__c Po:NewMap){
             if(Po.Supplier__c!=null){
                 if(ContactIds.containskey(Po.Supplier__c)){
                     Po.Supplier_Contact__c=ContactIds.get(Po.Supplier__c);
                 }
             }
         }
     }
     
   /* ===============================================
       Method Name:showDescription
       Description: Update show description field
       Created Date:13.7.17
     ================================================= */  
     
    public void showDescription(Map<id,PurchaseOrder__c > newMap,Map<id,PurchaseOrder__c> oldMap){
        Set<id> poid=new Set<id>();
       
       List<PurchaseOrderLineItem__c> oli=new List<PurchaseOrderLineItem__c>();
       for(PurchaseOrder__c  po:newMap.values()) {
             if(po.Show_Description__c!=oldMap.get(po.id).Show_Description__c){
               poid.add(po.id);
             }
      }
          
       if(poid.size()>0){   
         for(PurchaseOrderLineItem__c ol:[Select id,Show_Description__c,Purchase_Order__r.Show_Description__c,Purchase_Order__c from PurchaseOrderLineItem__c where Purchase_Order__c IN:poid]){
            ol.Show_Description__c=ol.Purchase_Order__r.Show_Description__c;
            oli.add(ol);
         } 
       }
       if(oli.size()>0){
           update oli;
       }  

    }
    
    /* ===============================================
       Method Name:CurrencyType
       Description: Update CurrencyType of P.O.line items
       Created Date:30.8.17
     ================================================= */  
    
    public void CurrencyType(Map<id,PurchaseOrder__c > newMap,Map<id,PurchaseOrder__c> oldMap){
      
       Set<id> poid=new Set<id>();
       
       List<PurchaseOrderLineItem__c> poli=new List<PurchaseOrderLineItem__c>();
       for(PurchaseOrder__c  po:newMap.values()) {
             if(po.CurrencyIsoCode!=oldMap.get(po.id).CurrencyIsoCode){
               poid.add(po.id);
             }
         }
             
          if(poid.size()>0){   
             for(PurchaseOrderLineItem__c ol:[Select id,Purchase_Order__r.CurrencyIsoCode,CurrencyIsoCode  from PurchaseOrderLineItem__c where Purchase_Order__c IN:poid]){
               ol.CurrencyIsoCode =ol.Purchase_Order__r.CurrencyIsoCode;
               poli.add(ol);
              } 
           }
         if(poli.size()>0){
         update poli;
          }
     
     }
    
}