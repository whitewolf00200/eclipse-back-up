@isTest(seeAlldata=true)
Public Class UpdateSalesOLITest{
     @isTest Public static void UpdateSalesOLIMethod() {  
    
        PricebookEntry priceBookEntryNew = new PricebookEntry();
        Product2 product = new Product2(); 
        
        Id pb2= Test.getStandardPricebookId();
        
        product.name = 'Test';
        product.ProductCode='Test';
        product.Nominal_Code__c='Test';
        insert product;
        
        priceBookEntryNew.Product2Id = product.Id;
        priceBookEntryNew.PriceBook2Id = pb2;
        priceBookEntryNew.UnitPrice = 20.00;
        priceBookEntryNew.isactive = true;
        insert priceBookEntryNew;
             
    Account a = new Account(Name = 'Test Account');
    PricebookEntry pbID = [select Id, name from PricebookEntry where isActive = True limit 1];
    Opportunity o = new Opportunity();
    OpportunityLineItem ol = new OpportunityLineItem();
        
    insert a;

    o.AccountId = a.Id;
    o.Name = 'Test';
    o.StageName = 'Prospecting';
    o.CloseDate = date.today();
    o.Pricebook2Id=pb2;
    o.Type = 'New Business';
    insert o;
                 
        OpportunityLineItem oli = new OpportunityLineItem
            (
                OpportunityId = o.Id,
                PricebookEntryId = priceBookEntryNew.Id,
                Quantity = 1,
                UnitPrice = priceBookEntryNew.UnitPrice, 
                ServiceDate = System.today()
            );
      insert oli;
    
    SalesOrder__c Sales=new SalesOrder__c();
    Sales.Account__c=a.Id;
    Sales.Opportunity__c=o.Id;
    Sales.Service_Type__c='Air Compressor';
    insert Sales;
    
    SalesOrderLineItems__c Soli=new SalesOrderLineItems__c();
    Soli.Product__c=product.Id;
    Soli.Quantity__c=1;
    Soli.Sales_Order__c=Sales.id;
    Soli.Price__c=12;
    insert Soli;
    
    UpdateSalesOLI  obj = new UpdateSalesOLI (new ApexPages.StandardController(Sales));
    obj.searchString='Test';
    obj.toSelect=product.Id;
    obj.addToShoppingCart();
    obj.removeFromShoppingCart();
    obj.onSave();
    obj.onCancel();
    
     }
}