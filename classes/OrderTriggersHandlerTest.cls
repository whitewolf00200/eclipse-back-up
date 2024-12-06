@isTest(SeeAllData=true)
public class OrderTriggersHandlerTest{
    
    static testMethod void myTest(){
    
    test.starttest();
    
    Account Acc=new Account();
    Acc.Name='Test';
    insert Acc;
    
    Warehouse__c WH=new Warehouse__c();
    WH.Name='Test';
    insert WH;
    
    Contract cnt=new Contract();
    cnt.AccountId=Acc.id;
    cnt.Status='Draft';
    cnt.StartDate=system.today();
    cnt.ContractTerm=2;
    insert cnt;
    
    product2 prd=new product2();
    prd.Name='Test Product';
    prd.IsActive=true;
    prd.ProductCode='TES124';
    prd.Cost__c=12;
    insert prd;
    
     Id pricebookId = Test.getStandardPricebookId();
        
        // 1. Insert a price book entry for the standard price book.
        // Standard price book entries require the standard price book ID we got earlier.
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prd.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
      
    Order ord=new Order();
    ord.AccountId=Acc.id;
    ord.Contract=cnt;
    ord.EffectiveDate=system.today();
    ord.Status='Draft';
    ord.Warehouse__c=WH.id;
    ord.Pricebook2Id =pricebookId;
    insert ord;
    
    OrderItem OI=new OrderItem();
    OI.OrderId=ord.id;
    OI.UnitPrice=1;
    OI.Quantity=1;
    OI.PricebookEntryId=standardPrice.id;
    insert OI;
    
    Inventory__c Inv=new Inventory__c();
    Inv.Warehouse__c=WH.id;
    Inv.Product__c=prd.id;
    insert Inv;
    
    Inventory_Transaction__c InsTrns=new Inventory_Transaction__c();
    InsTrns.Inventory__c=Inv.id;
    //ord.Status='Proposal';
    insert InsTrns;
    
    update ord;
    
    test.stoptest();
    }
}