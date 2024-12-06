Public class SupplierProductHanndler{
      
      public void OnAfterInsert(Map<id,SupplierProduct__c> Newmap){
       CurrenyType(Newmap);
       InsertSupplierCost(Newmap);
      // InsertSupplierCode(Newmap);
      
      }
      
      Public void OnAfterUpdate(Map<Id,SupplierProduct__c> Newmap,Map<Id,SupplierProduct__c> OldMap){
        
       UpdateSupplierCost(Newmap,OldMap);
       // UpdateSupplierCode(Newmap,OldMap);
      
      }
      
 /*====================================================

*Method Name     : CurrenyType
*Description     : Update the currency type based on supplier
*Arguments       : newmap 
====================================================*/

 
      Public void CurrenyType(Map<id,SupplierProduct__c> Newmap ){
        List<SupplierProduct__c> sprod=new List<SupplierProduct__c>();
        
        for(SupplierProduct__c sp:[Select id,CurrencyIsoCode,Supplier__c,Supplier__r.CurrencyIsoCode from SupplierProduct__c where 
                                     id In:Trigger.newMap.keySet()]){
            sp.CurrencyIsoCode=sp.Supplier__r.CurrencyIsoCode;
            sprod.add(sp);                       
        
        }
        if(sprod.size()>0){
          
            update sprod;  
        }
       
      }
      
      /*====================================================

*Method Name     : InsertSupplierCost
*Description     : Update Supplier cost on product
*Arguments       : newmap 
====================================================*/
      
    Public void InsertSupplierCost(Map<id,SupplierProduct__c> Newmap){
       List<Id> supid =new List <Id>();
       List<product2> prdcost=new List<product2>();
       String SupCost;
        Map<String,Decimal> SupplierCostMap=new Map<String,Decimal>();
       
       for(SupplierProduct__c sp:Newmap.values()){
         if(sp.Supplier__c!=null && sp.Product__c!=null && sp.Cost__c!=null){
             supid.add(sp.Supplier__c);
             SupCost=String.valueof(sp.Supplier__c )+String.valueof(sp.Product__c);
             if(!SupplierCostMap.containskey(SupCost)){
                    SupplierCostMap.put(SupCost,sp.Cost__c);
              }
         }
       }
       
       if(supid.size()>0){
          for(Product2 prdlist: [select id,Supplier_Cost_Price__c,Suppliers__c from Product2 where Suppliers__c IN:supid]){
               SupCost=String.valueof(prdlist.Suppliers__c)+String.valueof(prdlist.Id);
               if(SupplierCostMap.ContainsKey(SupCost)){
                  prdlist.Supplier_Cost_Price__c=SupplierCostMap.get(SupCost);
                  prdcost.add(prdlist);
               }
             
          }
          
          if(prdcost.size()>0){
                update prdcost;
             }  
         
       }
    }
    /*-----------------------------------------------------
    For default checkbox
    --------------------------------------
     Public void InsertSupplierCode(Map<id,SupplierProduct__c> Newmap){
       List<Id> supid =new List <Id>();
       List<product2> prdcost=new List<product2>();
       String SupCost;
        Map<String,String> SupplierCostMap=new Map<String,String>();
       
       for(SupplierProduct__c sp:Newmap.values()){
         if(sp.Supplier__c!=null && sp.Product__c!=null && sp.Supplier_Product_Code__c!=null){
             supid.add(sp.Supplier__c);
             SupCost=String.valueof(sp.Supplier__c )+String.valueof(sp.Product__c);
             if(!SupplierCostMap.containskey(SupCost)){
                    SupplierCostMap.put(SupCost,sp.Supplier_Product_Code__c);
              }
         }
       }
       
       if(supid.size()>0){
          for(Product2 prdlist: [select id,Supplier_Cost_Price__c,Suppliers__c,Supplier_Product_Code__c from Product2 where Suppliers__c IN:supid]){
               SupCost=String.valueof(prdlist.Suppliers__c)+String.valueof(prdlist.Id);
               if(SupplierCostMap.ContainsKey(SupCost)){
                  prdlist.Supplier_Product_Code__c=SupplierCostMap.get(SupCost);
                  prdcost.add(prdlist);
               }
             
          }
          
          if(prdcost.size()>0){
                update prdcost;
             }  
         
       }
    }*/
   /*====================================================
        
        *Method Name     : UpdateSupplierCost
        *Description     : Update Supplier cost on product
        *Arguments       : newmap 
        ====================================================*/
      
       Public void UpdateSupplierCost(Map<Id,SupplierProduct__c> Newmap,Map<Id,SupplierProduct__c> OldMap){
            
         List<Id> supid =new List <Id>();
         List<product2> prdcost=new List<product2>();
         String SupCost;
         Map<String,Decimal> SupplierCostMap=new Map<String,Decimal>();
       
         for(SupplierProduct__c sp:Newmap.values()){
             if(sp.Supplier__c!=null && sp.Product__c!=null && sp.Cost__c!=null && OldMap.get(sp.id).Cost__c!=sp.Cost__c){
                supid.add(sp.Supplier__c);
                SupCost=String.valueof(sp.Supplier__c )+String.valueof(sp.Product__c);
               if(!SupplierCostMap.containskey(SupCost)){
                    SupplierCostMap.put(SupCost,sp.Cost__c);
               }
             }
          }
          
          
          if(supid.size()>0){
            for(Product2 prdlist: [select id,Supplier_Cost_Price__c,Suppliers__c from Product2 where Suppliers__c IN:supid]){
               SupCost=String.valueof(prdlist.Suppliers__c)+String.valueof(prdlist.Id);
               if(SupplierCostMap.ContainsKey(SupCost)){
                  prdlist.Supplier_Cost_Price__c=SupplierCostMap.get(SupCost);
                  prdcost.add(prdlist);
               }
             
            }
          
            if(prdcost.size()>0){
                update prdcost;
            }  
         
         }
         
       }
 
 }