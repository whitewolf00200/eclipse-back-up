@isTest(seeAlldata=true)
Public Class UpdateDeliveryNoteNumberTest{
     @isTest Public static void UpdateDelNoteNumberMethod() {  
    
        PricebookEntry priceBookEntryNew = new PricebookEntry();
        Product2 product = new Product2(); 
        
       
        Id pb2 = Test.getStandardPricebookId();
        
        product.name = 'Test';
        product.ProductCode='Test';
        product.Nominal_Code__c='Test';
        product.IsActive=true;
        insert product;
        
        priceBookEntryNew.Product2Id = product.Id;
        priceBookEntryNew.PriceBook2Id = pb2;
        priceBookEntryNew.UnitPrice = 20.00;
        priceBookEntryNew.isactive = true;
        insert priceBookEntryNew;
             
    Account a = new Account(Name = 'Test Account',Customer_type__c='Others');
    a.recordtypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
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
    
    SiteContracts__c sc=new SiteContracts__c();
    sc.Site__c=a.id;
    sc.Customer__c=a.id;
    insert sc;
    
    Engineer__c tech = new Engineer__c(
    Name='tech',
    Engineer_ID__c='123',
    Active_User__c='Yes',
    Street__c='test',
    City__c='test',
    State_Province__c='test',
    Postal_Code__c='test',
    Country__c='test'
    
    );
    
    insert tech;
    
    Visits__c v=new Visits__c();
    v.Site__c=a.id;
    v.Site_Contract__c=sc.id;
    v.Actual_Service_Date__c=system.today();
    v.Engineer2__c=tech.id;
    insert v;
    
    Engineer_Checklist__c eng=new Engineer_Checklist__c();
    eng.Site__c=a.id;
    eng.Site_Contract__c=sc.id;
    eng.Visit__c=v.id;
    eng.Engineer__c=tech.id;
    insert eng;
                 
        OpportunityLineItem oli = new OpportunityLineItem
            (
                OpportunityId = o.Id,
                PricebookEntryId = priceBookEntryNew.Id,
                Quantity = 1,
                UnitPrice = priceBookEntryNew.UnitPrice, 
                Service_Sheet__c=eng.id,
                ServiceDate = System.today()
            );
      insert oli;
      
      OpportunityLineItem olii = new OpportunityLineItem
            (
                OpportunityId = o.Id,
                PricebookEntryId = priceBookEntryNew.Id,
                Quantity = 1,
                UnitPrice = priceBookEntryNew.UnitPrice, 
                ServiceDate = System.today()
            );
      insert olii;
      
      Delivery_Note__c DN=new Delivery_Note__c();
      DN.Opportunity__c=o.id;
      DN.Site__c=a.id;
      DN.Date__c=system.today();
      insert DN;
      Test.Starttest();
      SalesOrder__c Sales=new SalesOrder__c();
      Sales.Account__c=a.Id;
      Sales.Opportunity__c=o.Id;
      Sales.Service_Type__c='Air Compressor';
      insert Sales;
      
      UpdateDeliveryNoteNumber DelNo=new UpdateDeliveryNoteNumber();
      DelNo.getDelnoteid();
      DelNo.setDelnoteid(o.Id);
      DelNo.UpdateOppDelNoteNumber();
      Test.StopTest();
     }
     
     
}