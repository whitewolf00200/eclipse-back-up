@isTest(SeeAllData=true)
public class StockAlertControllerTest{
    
    static testMethod void myTest(){
    
    test.starttest();
    
    Account Acc=new Account();
    Acc.Name='Test';
    insert Acc;
    
    Warehouse__c WH=new Warehouse__c();
    WH.Name='Test';
    insert WH;
    
    product2 prd=new product2();
    prd.Name='Test Product';
    prd.IsActive=true;
    prd.ProductCode='TES124';
    prd.Cost__c=12;
    insert prd;
    
    Inventory__c Inv=new Inventory__c();
    Inv.Warehouse__c=WH.id;
    Inv.Product__c=prd.id;
    insert Inv;
    
    Opportunity Opp=new Opportunity();
    Opp.Name='Test';
    Opp.CloseDate=system.today();
    Opp.StageName='Closed Won';
    insert Opp;
    
    SalesOrder__c sales=new SalesOrder__c();
    sales.Account__c=Acc.id;
    sales.Opportunity__c=Opp.id;
    insert sales;
    
    SalesOrderLineItems__c salesLI=new SalesOrderLineItems__c();
    salesLI.Sales_Order__c=sales.id;
    salesLI.Product__c=prd.id;
    salesLI.Quantity__c=1;
    insert salesLI;
    
    ApexPages.StandardController sc = new ApexPages.standardController(sales);
    ApexPages.currentPage().getParameters().put('Id', sales.id);
    StockAlertController StockC=new StockAlertController(sc);
    
    StockC.StockAlertOpp();
    
    test.stoptest();
    }
}