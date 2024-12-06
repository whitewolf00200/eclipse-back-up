@isTest(SeeAllData=true)
public class SitePartsUpdateTest{
    static testMethod void SitePartsUpdateMethod(){
        Test.startTest();
        List<PricebookEntry> NewEntry=new List<PricebookEntry>();
        PricebookEntry priceBookEntryNew;
        List<Product2> PrdList=new List<Product2>();
        
        Product2 product;        
        Id pb2= Test.getStandardPricebookId();
        
        product = new Product2();
        product.name = 'Test';
        product.ProductCode='Test';
        product.Nominal_Code__c='Test';
        product.isactive=true;
        PrdList.add(product);
        
        product = new Product2();
        product.name = 'Test Nonstock';
        product.ProductCode='Test Non';
        product.Nominal_Code__c='Test Non';
        product.Non_Stock__c=true;
        product.isactive=true;
        PrdList.add(product);
        
        product = new Product2();
        product.name = 'Test Serial';
        product.ProductCode='Test Ser';
        product.Nominal_Code__c='Test Ser';
        product.Serialized__c=true;
        product.isactive=true;
        PrdList.add(product);
        
        insert PrdList;
        
        for(Product2 Prd:PrdList){
            priceBookEntryNew = new PricebookEntry();
            priceBookEntryNew.Product2Id = Prd.Id;
            priceBookEntryNew.PriceBook2Id = pb2;
            priceBookEntryNew.UnitPrice = 20.00;
            priceBookEntryNew.isactive = true;
            NewEntry.add(priceBookEntryNew);
        }
        
        insert NewEntry;
        
        Account a = new Account(Name = 'Test Account');
        a.Customer_type__c='Others';
        insert a;
        
        Opportunity o = new Opportunity();        
        o.AccountId = a.Id;
        o.Name = 'Test';
        o.StageName = 'Prospecting';
        o.CloseDate = date.today();
        o.Pricebook2Id=pb2;
        o.Type = 'New Business';
        insert o;
        
        List<OpportunityLineItem> Listol = new List<OpportunityLineItem>();               
        for(PricebookEntry Pe:NewEntry){
        OpportunityLineItem oli = new OpportunityLineItem
            (
                OpportunityId =o.Id,
                PricebookEntryId = Pe.Id,
                Quantity = 2,
                UnitPrice = Pe.UnitPrice, 
                ServiceDate = System.today()
            );
            Listol.add(oli);
        }
      insert Listol;
    
    SalesOrder__c Sales=new SalesOrder__c();
    Sales.Account__c=a.Id;
    Sales.Opportunity__c=o.Id;
    Sales.Service_Type__c='Air Compressor';
    insert Sales;
    
    Warehouse__c wa=new Warehouse__c();
    wa.Name='Ware';
    insert wa;
    
    List<Inventory__c> NewINvList=new List<Inventory__c>();
    Inventory__c inv;
    for(Product2 Prd:PrdList){
        inv=new Inventory__c();
        inv.Product__c=Prd.Id;
        inv.Warehouse__c=wa.id;
        NewINvList.add(inv);
    }    
    insert NewINvList;
    

        
    List<Inventory_Transaction__c> InvList=new List<Inventory_Transaction__c>();
    Inventory_Transaction__c IT;
    for(Inventory__c InvLoop:NewINvList){
        IT=new Inventory_Transaction__c();
        IT.Name=InvLoop.Id;
        IT.Qty__c=1;
        IT.Inventory__c=InvLoop.id;
        IT.Items__c=Invloop.Product__c;
        IT.Transaction_Type__c='Received';
        InvList.add(IT);    
    }
    
    insert InvList;
    
    Test.setCurrentPageReference(new PageReference('Page.UpdateSiteParts'));    
    System.currentPageReference().getParameters().put('id',String.valueof(Sales.Id));
    System.currentPageReference().getParameters().put('oid',String.valueof(o.Id));
    System.currentPageReference().getParameters().put('AccId',String.valueof(a.Id));
        
    ApexPages.StandardController sc = new ApexPages.StandardController(Sales);
    SitePartsUpdate Spu=new SitePartsUpdate(sc);    
     
    for(SalesOrderLineItems__c Nonstock:[select Id,Product__c,Price__c,Product__r.Name,Quantity__c,Remaining_Quantity__c,Total_Number_of_Product_Delivered__c from SalesOrderLineItems__c where Non_Stock__c=true and Sales_Order__c=:Sales.id and Remaining_Quantity__c>0]){
       SitePartsUpdate.NotStockWrap Wrapvar = new SitePartsUpdate.NotStockWrap(Nonstock.Id,Nonstock.Product__c,Nonstock.Quantity__c,Nonstock.Product__r.Name,1,Nonstock.Total_Number_of_Product_Delivered__c!=null?Nonstock.Total_Number_of_Product_Delivered__c:0,Nonstock.Remaining_Quantity__c,true,Nonstock.Price__c,'','');
       Spu.NewStock.add(Wrapvar);
   }   
    
   for(SalesOrderLineItems__c NonSerial:[select Id,Product__c,Price__c,Product__r.Name,Quantity__c,Remaining_Quantity__c,Total_Number_of_Product_Delivered__c from SalesOrderLineItems__c where Serialized__c=false and Non_Stock__c=false and Sales_Order__c=:Sales.id and Remaining_Quantity__c>0]){
       SitePartsUpdate.NonSerializeWrap Wrapvar1=new SitePartsUpdate.NonSerializeWrap(NonSerial.Id,NonSerial.Product__c,NonSerial.Quantity__c,NonSerial.Product__r.Name,1,NonSerial.Total_Number_of_Product_Delivered__c!=null?NonSerial.Total_Number_of_Product_Delivered__c:0,NonSerial.Remaining_Quantity__c,true,NonSerial.Price__c,'','');
       Spu.NewNonSerial.add(Wrapvar1);
   }
            
   for(SalesOrderLineItems__c Serial:[select Id,Product__c,Price__c,Product__r.Name,Quantity__c,Remaining_Quantity__c,Total_Number_of_Product_Delivered__c from SalesOrderLineItems__c where Serialized__c=true and Sales_Order__c=:Sales.id and Remaining_Quantity__c>0]){
       SitePartsUpdate.SerializeWrap Wrapvar2=new SitePartsUpdate.SerializeWrap(Serial.Id,Serial.Product__c,'',Serial.Quantity__c,Serial.Product__r.Name,1,Serial.Total_Number_of_Product_Delivered__c!=null?Serial.Total_Number_of_Product_Delivered__c:0,Serial.Remaining_Quantity__c,true,Serial.Price__c,'','');
       Spu.NewSerial.add(Wrapvar2);
   } 
                      
    Spu.NonStockQtyCheck();
    Spu.SaveAction();     
    Test.stopTest();
    }
    


}