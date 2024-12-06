@isTest(SeeAllData=true)
public class LineItemControllerTest{
    
    static testMethod void myTest(){
    
    test.starttest();
    
    Account Acc=new Account();
    Acc.Name='Test';
    insert Acc;
    
    product2 prd=new product2();
    prd.Name='Test Product';
    prd.IsActive=true;
    prd.ProductCode='TES124';
    prd.Cost__c=12;
    insert prd;
    
    SalesOrder__c sales=new SalesOrder__c();
    sales.Account__c=Acc.id;
    insert sales;
    
    SalesOrderLineItems__c SL2=new SalesOrderLineItems__c();
    SL2.Product__c=prd.id;
    SL2.Quantity__c=1;
    SL2.Sales_Order__c=sales.id;
    insert SL2;
 
     Id pricebookId = Test.getStandardPricebookId();
        
        // 1. Insert a price book entry for the standard price book.
        // Standard price book entries require the standard price book ID we got earlier.
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prd.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
    
    ApexPages.StandardController sc = new ApexPages.standardController(SL2);
    LineItemController LCtrl=new LineItemController(sc);
    
    LCtrl.searchTxt='Test';
    LCtrl.SearchFun();
    LCtrl.getContacts();
    LCtrl.processSelected();
    LCtrl.getList(String.valueOf(prd.id));
    
    test.stoptest();
    }
}