@isTest(seeAlldata=true)
Public Class UpdateSupplierProductCodeTest{
     @isTest Public static void UpdateSupplierProductCodeMethod() {  
        
        Id SuppId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
        
         Account Pacc = new Account();
         Pacc.Name='Test Customer';
         Pacc.RecordTypeId=SuppId;
         insert Pacc;
         
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
             
        Opportunity o = new Opportunity();
        OpportunityLineItem ol = new OpportunityLineItem();
        
        o.AccountId = Pacc.Id;
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
    
    PurchaseOrder__c Po=new PurchaseOrder__c();
    Po.Supplier__c=Pacc.Id;
    insert Po;
    
    PurchaseOrderLineItem__c Poli=new PurchaseOrderLineItem__c();
    Poli.Product__c=product.id;
    Poli.Price__c=12;
    Poli.Quantity__c=2;
    Poli.Purchase_Order__c=Po.Id;
    insert Poli;
    
    SupplierProduct__c Spoli=new SupplierProduct__c();
    Spoli.Product__c=product.Id;
    Spoli.Supplier__c=Pacc.Id;
    Spoli.Cost__c=12;
    insert Spoli;
    
    UpdateSupplierProductCode Usup=new UpdateSupplierProductCode();
    Usup.getPoid();
    Usup.setPoid(Po.id);
    
    }
}