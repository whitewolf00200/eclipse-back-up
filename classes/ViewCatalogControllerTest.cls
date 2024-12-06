@isTest(SeeAllData=true)
public class ViewCatalogControllerTest{
    
    static testMethod void myTest(){
    
    test.starttest();
    
    product2 prd=new product2();
    prd.Name='Test Product';
    prd.IsActive=true;
    prd.ProductCode='TES124';
    prd.Cost__c=12;
    insert prd;
    
    product2 prd1=new product2();
    prd1.Name='Test Product';
    prd1.IsActive=true;
    prd1.ProductCode='TES124';
    prd1.Cost__c=12;
    insert prd1;
    
     Id pricebookId = Test.getStandardPricebookId();
        
        // 1. Insert a price book entry for the standard price book.
        // Standard price book entries require the standard price book ID we got earlier.
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prd.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
    Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
    
    Account Acc1=new Account();
    Acc1.Name='Test';
    Acc1.Recordtypeid=devRecordTypeId;
    insert Acc1;
    
    SupplierProduct__c SP=new SupplierProduct__c();
    SP.Product__c=prd.id;
    SP.Supplier__c=Acc1.id;
    SP.Cost__c=45;
    insert SP;
    
    Opportunity Opp=new Opportunity();
    Opp.Name='Test';
    Opp.CloseDate=system.today();
    Opp.StageName='Closed Won';
    insert Opp;
    
    OpportunityLineItem OLI=new OpportunityLineItem();
    OLI.OpportunityId=Opp.id;
    OLI.UnitPrice=1;
    OLI.Quantity=1;
    OLI.PricebookEntryId=standardPrice.id;
    insert OLI;
    
    Id pricebookId1 = Test.getStandardPricebookId();
        
        // 1. Insert a price book entry for the standard price book.
        // Standard price book entries require the standard price book ID we got earlier.
        PricebookEntry standardPrice1 = new PricebookEntry(
            Pricebook2Id = pricebookId1, Product2Id = prd1.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice1;
        
    Opportunity Opp1=new Opportunity();
    Opp1.Name='Test';
    Opp1.CloseDate=system.today();
    Opp1.StageName='Closed Won';
    insert Opp1;
    
    OpportunityLineItem OLI1=new OpportunityLineItem();
    OLI1.OpportunityId=Opp.id;
    OLI1.UnitPrice=1;
    OLI1.Quantity=1;
    OLI1.PricebookEntryId=standardPrice1.id;
    insert OLI1;
    
    ApexPages.currentPage().getParameters().put('OPPId', Opp.id);
    ViewCatalogController VC=new ViewCatalogController();
    
    VC.getProductCatalogs();
    VC.getcatLists();
    
    ApexPages.currentPage().getParameters().put('OPPId', Opp1.id);
    VC.getcatLists();
    
    test.stoptest();
    }
}