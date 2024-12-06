@isTest(SeeAllData=true)
public class LineItemTest{
    
    static testMethod void myTest(){
    
    test.starttest();
    
    Account Acc=new Account();
    Acc.Name='Test';
    insert Acc;
    
    SalesOrder__c sales=new SalesOrder__c();
    sales.Account__c=Acc.id;
    insert sales;
    
    product2 prd=new product2();
    prd.Name='Test Product';
    prd.IsActive=true;
    prd.ProductCode='TES124';
    prd.Cost__c=12;
    insert prd;
    
    List<SalesOrderLineItems__c> SL =new List<SalesOrderLineItems__c>();
    SalesOrderLineItems__c SL1=new SalesOrderLineItems__c();
    SL1.Product__c=prd.id;
    SL1.Quantity__c=1;
    SL1.Sales_Order__c=sales.id;
    SL.add(SL1);
    insert SL;
    
    SalesOrderLineItems__c SL2=new SalesOrderLineItems__c();
    SL2.Product__c=prd.id;
    SL2.Quantity__c=1;
    SL2.Sales_Order__c=sales.id;
    insert SL2;
    
    ApexPages.CurrentPage().getParameters().put('Products',string.valueOf(SL2));
    ApexPages.StandardController sc = new ApexPages.standardController(SL2);
    LineItem LI=new LineItem(sc);
    LI.getProducts();
       
    test.stoptest();
    }
}