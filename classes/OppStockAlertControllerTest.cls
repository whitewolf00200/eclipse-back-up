@isTest(SeeAllData=true)
public class OppStockAlertControllerTest{
    
    static testMethod void myTest(){
    
    test.starttest();

Id pricebookId = Test.getStandardPricebookId();

//Create your product
Product2 prod = new Product2(
     Name = 'Product X',
     ProductCode = 'Pro-X',
     isActive = true
);
insert prod;

//Create your pricebook entry
PricebookEntry pbEntry = new PricebookEntry(
     Pricebook2Id = pricebookId,
     Product2Id = prod.Id,
     UnitPrice = 100.00,
     IsActive = true
);
insert pbEntry;

Opportunity Opp=new Opportunity();
    Opp.Name='Test';
    Opp.CloseDate=system.today();
    Opp.StageName='Closed Won';
    insert Opp;

//create your opportunity line item.  This assumes you already have an opportunity created, called opp
OpportunityLineItem oli = new OpportunityLineItem(
     OpportunityId = opp.Id,
     Quantity = 5,
     PricebookEntryId = pbEntry.Id,
     unitprice= pbEntry.UnitPrice
);
insert oli;

    Warehouse__c WH=new Warehouse__c();
    WH.Name='Test';
    insert WH;
    
    Inventory__c Inv=new Inventory__c();
    Inv.Warehouse__c=WH.id;
    Inv.Product__c=prod.id;
    insert Inv;

    ApexPages.StandardController sc = new ApexPages.standardController(Opp);
    ApexPages.currentPage().getParameters().put('Id', Opp.id);
    OppStockAlertController StockC=new OppStockAlertController(sc);
    
    StockC.OppStockAlertOpp();
    
    test.stoptest();
    }
}