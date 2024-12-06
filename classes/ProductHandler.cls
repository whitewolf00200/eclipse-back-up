public class ProductHandler{
    
    public void onAfterInsert(List<Product2> newList){
        InsertPricebook(newList);
    }
    
    public void onAfterInsert1(Map<id,Product2> newMap,Map<id,Product2> oldMap){
        InsertSupplierProduct(newMap,oldMap);
    }
    
    public void onBeforeUpdate(Map<Id,Product2> NewMap,Map<Id,Product2> oldMap){
       UpdateSupplierCost(NewMap,oldMap);
                                UpdateSupplierCode(NewMap,oldMap);


    }
     public void onAfterUpdate(Map<Id,Product2> NewMap,Map<Id,Product2> oldMap){
      for(Product2 proFor : NewMap.values())
      {
         if(proFor.Suppliers__c!=oldmap.get(proFor.id).Suppliers__c)
         {
         InsertSupplierProduct(newMap,oldMap);

     //  DelateOldProduct(oldMap);
         }
      }
    }
     public void onBeforeDelete(Map<Id,Product2> oldMap){
       // DelateOldProduct(oldMap);
    }
    
    
/*====================================================================================
Method Name: InsertPricebook
Description: Insert New Pricebook for new product
======================================================================================*/
    public void InsertPricebook(List<Product2> newList){
        List<Pricebookentry> InsPEntry=new List<Pricebookentry>();
        
        Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true and isactive=true];
        
        for(Product2 Prd:newList){
         if(!prd.IsClone()){
            system.debug('InsPEntry clone ======'+InsPEntry);
           Pricebookentry NewPE=new Pricebookentry();
           if(Prd.IsActive){
           NewPE.Product2Id=Prd.Id;
           NewPE.Pricebook2Id=standardPB.id;
           NewPE.UnitPrice=0;
           NewPE.isActive=true;
           InsPEntry.add(NewPE);
           }
          } 
        }
        
        if(InsPEntry.size()>0 && !Test.isRunningTest()){
            system.debug('InsPEntry1======'+InsPEntry);
            insert InsPEntry;
        }
        
        InsPEntry=new List<Pricebookentry>();
        list<Pricebook2> pr =new list<Pricebook2>([select id,Name from Pricebook2 where isStandard=false]);
        for(Pricebook2 Pid:pr){
            for(Product2 Prd:newList){
             if(!prd.IsClone()){
            system.debug('InsPEntry clone ======'+InsPEntry);
                Pricebookentry NewPE=new Pricebookentry();
                if(Prd.IsActive){
                NewPE.Product2Id=Prd.Id;
                NewPE.Pricebook2Id=Pid.id;
                NewPE.UseStandardPrice=true;
                NewPE.UnitPrice=0;
                NewPE.isActive=true;
                InsPEntry.add(NewPE);
                }
            }
           } 
        }
        
        if(InsPEntry.size()>0 && !Test.isRunningTest()){
            system.debug('InsPEntry2======'+InsPEntry);
            insert InsPEntry;
        }
    }

/*====================================================================================
Method Name: InsertPricebook
Description: Insert New Pricebook for new product
======================================================================================*/
    
    public void UpdateSupplierCost(Map<Id,Product2> NewMap,Map<Id,Product2> oldMap){
        List<Id> SupplierIds=new List<Id>();
        Map<String,Decimal> SupplierCostMap=new Map<String,Decimal>();
        String SupCost;
        
        for(Product2 Prd:NewMap.values()){
            if(Prd.Suppliers__c!=null && Prd.Suppliers__c!=oldMap.get(Prd.Id).Suppliers__c){
                SupplierIds.add(Prd.Suppliers__c);
            }
        }
        
        if(SupplierIds.size()>0){
            list<SupplierProduct__c> supp=new list<SupplierProduct__c>([Select Supplier__c,Cost__c,Product__c from SupplierProduct__c where Supplier__c IN:SupplierIds]);
            for(SupplierProduct__c SpCos:supp){
                SupCost=String.valueof(SpCos.Supplier__c)+String.valueof(SpCos.Product__c);
                 system.debug('<<>>'+ SupCost);
                if(!SupplierCostMap.containskey(SupCost)){
                    SupplierCostMap.put(SupCost,SpCos.Cost__c);
                }
            }
        } 
        
        for(Product2 Prd:NewMap.values()){
            if(Prd.Suppliers__c!=null && Prd.Suppliers__c!=oldMap.get(Prd.Id).Suppliers__c){
                SupCost=String.valueof(Prd.Suppliers__c)+String.valueof(Prd.Id);
                system.debug('<<>>'+ SupCost);
                if(SupplierCostMap.containskey(SupCost)){
                    Prd.Supplier_Cost_Price__c=SupplierCostMap.get(SupCost);
                }
            }
        }
    }
    
    
    
    public void InsertSupplierProduct(Map<id,Product2> NewMap,Map<id,Product2> oldMap)
    {   
        
        Map<id,SupplierProduct__c> SupplierProductMap = new Map<id,SupplierProduct__c>();
        List<SupplierProduct__c> splist = new List<SupplierProduct__c>();
        Map<id,Decimal> supplierId = new Map<id,Decimal>();
        Map<id,Product2> productmap = new Map<id,Product2>();
        Map<id,SupplierProduct__c> splmap = new Map<id,SupplierProduct__c>();
        List<Id> productId = new List<Id>();
        Integer Temp=0;
        for(Product2 pro : newMap.values())
        {
            productId.add(pro.id);
            supplierId.put(pro.Suppliers__c,pro.Cost__c);
        }
        list<Product2> prod =new list<Product2>([select id,name,Cost__c,Suppliers__c,CurrencyIsoCode from Product2 where id =: productId]);
        for(Product2 pro :prod )
        {system.debug('<<000>>'+pro.id);
            productmap.put(pro.id,pro);
        }
        list<SupplierProduct__c> suppl =new list<SupplierProduct__c>([select id,name,Supplier__c,Product__c,Product__r.name,Cost__c,CurrencyIsoCode from SupplierProduct__c where Supplier__c =: supplierId.keyset()]);
        for(SupplierProduct__c sp : suppl)
        {
            SupplierProductMap.put(sp.id,sp);
        }
        for(Product2 pro : productmap.values())
            {
            
        for(SupplierProduct__c si : SupplierProductMap.values())
        {
            if(si.Product__r.name == pro.name || pro.name==null|| pro.Suppliers__c==null)
            {
              temp=1;
            }
          
        }
        if(temp==0)
        {
        splist.add(new SupplierProduct__c(Product__c = pro.id,Supplier__c = pro.Suppliers__c,Cost__c = pro.Cost__c));
        temp=0;
        }
        }
        if(splist.size()>0)
        {
            try
            {
                insert splist;
            }
            catch(exception e)
            {
                system.debug(e.getDmlMessage(0));
            }
        }
    }
 /*public void DelateOldProduct(Map<id,Product2> NewMap)
    {
        Map<id,SupplierProduct__c> SupplierProductMap = new Map<id,SupplierProduct__c>();
        List<SupplierProduct__c> splist = new List<SupplierProduct__c>();
        Map<id,Product2> productmap = new Map<id,Product2>();
        Map<id,Decimal> supplierId = new Map<id,Decimal>();
        Map<id,SupplierProduct__c> splmap = new Map<id,SupplierProduct__c>();
        List<Id> productId = new List<Id>();
        Integer Temp=0;
        for(Product2 pro : newMap.values())
        {
            productId.add(pro.id);
            supplierId.put(pro.Suppliers__c,pro.Cost__c);
        }
        
        for(Product2 pro : [select id,name,Cost__c,Suppliers__c,CurrencyIsoCode from Product2 where id =: productId])
        {
            productmap.put(pro.id,pro);
        }
        
        for(SupplierProduct__c sp : [select id,name,Supplier__c,Product__c,Product__r.name,Cost__c,CurrencyIsoCode from SupplierProduct__c where Supplier__c =: supplierId.keyset()])
        {
            SupplierProductMap.put(sp.id,sp);
        }
        for(Product2 pro : productmap.values())
            {
        for(SupplierProduct__c si : SupplierProductMap.values())
        {
            if(si.Product__r.Name == pro.Name)
            {
             splist.add(si); 
            }
        }
        
       
        }
        if(splist.size()>0)
        {
            try
            {
                Delete splist;
            }
            catch(exception e)
            {
                system.debug(e.getDmlMessage(0));
            }
        }
    }   */
    
   public void UpdateSupplierCode(Map<Id,Product2> NewMap,Map<Id,Product2> oldMap){
        List<Id> SupplierIds=new List<Id>();
        Map<String,String> SupplierCostMap=new Map<String,String>();
        String SupCost;
        
        for(Product2 Prd:NewMap.values()){
            if(Prd.Suppliers__c!=oldMap.get(Prd.Id).Suppliers__c){
                SupplierIds.add(Prd.Suppliers__c);
            }
        }
        
        if(SupplierIds.size()>0){
            list<SupplierProduct__c> suppp=new list<SupplierProduct__c>([Select Supplier__c,Cost__c,Product__c,Supplier_Product_Code__c from SupplierProduct__c where Supplier__c IN:SupplierIds]);
            for(SupplierProduct__c SpCos:suppp){
                SupCost=String.valueof(SpCos.Supplier__c)+String.valueof(SpCos.Product__c);
                 system.debug('<<>>'+ SupCost);
                if(!SupplierCostMap.containskey(SupCost)){
                    SupplierCostMap.put(SupCost,SpCos.Supplier_Product_Code__c);
                }
            }
        } 
        
        for(Product2 Prd:NewMap.values()){
            if(Prd.Suppliers__c!=null && Prd.Suppliers__c!=oldMap.get(Prd.Id).Suppliers__c){
                SupCost=String.valueof(Prd.Suppliers__c)+String.valueof(Prd.Id);
                system.debug('<<>>'+ SupCost);
                if(SupplierCostMap.containskey(SupCost)){
                    Prd.Supplier_Product_Code__c=SupplierCostMap.get(SupCost);
                }
            }
        }
    }
    
     
    
    
    
    
    
    
    
}