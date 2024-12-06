@isTest(SeeAllData=true)
public class InventoryprojectionsTest{
    
    static testMethod void myTest(){
    
    test.starttest();
    
    Account Acc=new Account();
    Acc.Name='Test';
    insert Acc;
    
    Warehouse__c WH=new Warehouse__c();
    WH.Name='Test';
    insert WH;
    
    PurchaseOrder__c PO=new PurchaseOrder__c();
    PO.Shipping_Warehouse__c=WH.id;
    PO.Create_Date__c=system.today();
    insert PO;
    
    product2 prd=new product2();
    prd.Name='Test Product';
    prd.IsActive=true;
    prd.ProductCode='TES124';
    prd.Cost__c=12;
    insert prd;
    
    PurchaseOrderLineItem__c POLine=new PurchaseOrderLineItem__c();
    POLine.Purchase_Order__c=PO.id;
    POLine.Product__c=prd.id;
    POLine.Quantity__c=1;
    POLine.Price__c=1;
    insert POLine;
    
    Contract cnt=new Contract();
    cnt.AccountId=Acc.id;
    cnt.Status='Draft';
    cnt.StartDate=system.today();
    cnt.ContractTerm=2;
    insert cnt;
    
    Order ord=new Order();
    ord.AccountId=Acc.id;
    ord.Contract=cnt;
    ord.EffectiveDate=system.today();
    ord.Status='Draft';
    ord.Warehouse__c=WH.id;
    insert ord;
  
    Inventory__c Inv=new Inventory__c();
    Inv.Warehouse__c=WH.id;
    insert Inv;
    
    ApexPages.StandardController sc = new ApexPages.standardController(WH);
    ApexPages.currentPage().getParameters().put('Id', WH.id);
    Inventoryprojections InventPrj=new Inventoryprojections(sc);
    InventPrj.SelectDated=system.today()+1;
    InventPrj.individual();
    

    
    test.stoptest();
    }
    
    static testMethod void myTest1(){
    
    test.starttest();
    
    Account Acc1=new Account();
    Acc1.Name='Test';
    insert Acc1;
    
    Warehouse__c WH1=new Warehouse__c();
    WH1.Name='Test';
    insert WH1;
    
    PurchaseOrder__c PO1=new PurchaseOrder__c();
    PO1.Shipping_Warehouse__c=WH1.id;
    PO1.Create_Date__c=system.today();
    insert PO1;
    
    product2 prd1=new product2();
    prd1.Name='Test Product';
    prd1.IsActive=true;
    prd1.ProductCode='TES124';
    prd1.Cost__c=12;
    insert prd1;
    
    PurchaseOrderLineItem__c POLine1=new PurchaseOrderLineItem__c();
    POLine1.Purchase_Order__c=PO1.id;
    POLine1.Product__c=prd1.id;
    POLine1.Quantity__c=1;
    POLine1.Price__c=1;
    insert POLine1;
    
    Contract cnt1=new Contract();
    cnt1.Accountid=Acc1.id;
    cnt1.Status='Draft';
    cnt1.StartDate=system.today();
    cnt1.ContractTerm=2;
    insert cnt1;
    
    Order ord1=new Order();
    ord1.Accountid=Acc1.id;
    ord1.Contract=cnt1;
    ord1.EffectiveDate=system.today();
    ord1.Status='Draft';
    ord1.Warehouse__c=WH1.id;
    insert ord1;
  
    Inventory__c Inv1=new Inventory__c();
    Inv1.Warehouse__c=WH1.id;
    insert Inv1;
    
    ApexPages.StandardController sc1 = new ApexPages.standardController(WH1);
    ApexPages.currentPage().getParameters().put('Id', WH1.id);
    Inventoryprojections InventPrj1=new Inventoryprojections(sc1);
    InventPrj1.individual();
    

    
    test.stoptest();
    }
}