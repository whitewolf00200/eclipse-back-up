@isTest(seeAlldata=true)
public class RaisePOControllerTest{
    
    static testMethod void myTest(){
    
    test.starttest();
    
    Account Acc=new Account();
    Acc.Name='Test';
    insert Acc;
    
    Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
    
    Account Acc1=new Account();
    Acc1.Name='Test';
    Acc1.Recordtypeid=devRecordTypeId;
    insert Acc1;
    
    Warehouse__c WH=new Warehouse__c();
    WH.Name='Test';
    insert WH;
    
    product2 prd=new product2();
    prd.Name='Test Product';
    prd.IsActive=true;
    prd.ProductCode='TES124';
    prd.Cost__c=12;
    insert prd;
    
    Opportunity Opp=new Opportunity();
    Opp.Name='Test';
    Opp.CloseDate=system.today();
    Opp.StageName='Closed Won';
    insert Opp;
    
    Id pricebookId = Test.getStandardPricebookId();
        
        // 1. Insert a price book entry for the standard price book.
        // Standard price book entries require the standard price book ID we got earlier.
       //PricebookEntry standardPrice = [select id,Pricebook2Id,Product2Id from PricebookEntry where Product2Id=:prd.id limit 1];
            
       PricebookEntry standardPrice = new PricebookEntry(UnitPrice=50, Pricebook2Id=pricebookId , Product2Id=prd.Id, IsActive=true); 
       insert standardPrice ;
    
    OpportunityLineItem OLI=new OpportunityLineItem();
    OLI.OpportunityId=Opp.id;
    OLI.UnitPrice=1;
    OLI.Quantity=1;
    OLI.PricebookEntryId=standardPrice.id;
    insert OLI;
        
    Inventory__c Inv=new Inventory__c();
    Inv.Warehouse__c=WH.id;
    Inv.Product__c=prd.id;
    insert Inv;
    
    PurchaseOrder__c PO=new PurchaseOrder__c();
    PO.Shipping_Warehouse__c=WH.id;
    PO.Create_Date__c=system.today();
    PO.Opportunity__c=Opp.id;
    PO.Supplier__c=Acc1.id;
    insert PO;
    
    SupplierProduct__c SP=new SupplierProduct__c();
    SP.Product__c=prd.id;
    SP.Supplier__c=Acc1.id;
    insert SP;
    
    SalesOrder__c so=new SalesOrder__c();
    so.Account__c=Acc1.id;
    so.Opportunity__c=Opp.id;
    so.Service_Type__c='Air Compressor';
    insert so;
    
    
    SalesOrderLineItems__c sl=new SalesOrderLineItems__c();
    sl.Product__c=prd.id;
    sl.Quantity__c=2;
    sl.Sales_Order__c=so.id;
    insert sl;
    
    //SalesOrderLineItems__c so=new SalesOrderLineItems__c();
    //so.Sales_Order__c=
    ApexPages.currentPage().getParameters().put('OppId', Opp.id);
    ApexPages.currentPage().getParameters().put('SOId', so.id);
    ApexPages.currentPage().getParameters().put('woid', WH.id);
    
    ApexPages.StandardController sc = new ApexPages.standardController(Opp);
    RaisePOController RP=new RaisePOController(sc);
    RP.addSPO.Shipping_Warehouse__c=WH.id;
    RP.addSPO.Supplier__c=Acc1.id;
    
    RP.AddPOLI();
    RP.CreatePO();
   
    RP.AddPOLI();
    RP.CreatePO(); 
     
    
    test.stoptest();
    }
}