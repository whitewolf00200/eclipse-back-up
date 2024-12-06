@isTest(SeeAllData=true)
public class PartsReplenishmentTest{
    
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
    
    Inventory__c Inv1=new Inventory__c();
    Inv1.Warehouse__c=WH.id;
    Inv1.Minimum_Stock_Level__c=4;
    insert Inv1;
    
    product2 prd1=new product2();
    prd1.Name='Test Product';
    prd1.IsActive=true;
    prd1.ProductCode='TES124';
    prd1.Cost__c=12;
    insert prd1;
    
    SupplierProduct__c SP=new SupplierProduct__c();
    SP.product__c=prd1.id;
    SP.Supplier__c=Acc1.id;
    insert SP;
    
    PurchaseOrder__c PO=new PurchaseOrder__c();
    PO.Supplier__c=Acc1.id;
    insert PO;
    
    ApexPages.currentPage().getParameters().put('Id', WH.id);
    ApexPages.currentPage().getParameters().put('prd', prd1.id);
    ApexPages.StandardController sc = new ApexPages.standardController(WH);
    PartsReplenishment PR=new PartsReplenishment(sc);
    
    PR.LineItems();
    PR.CreatePO();
    PR.ListPrdNotSupply();
    PR.supChange();
    PR.Cancel();
    PR.ClickCheckBox();
    PR.qtyChange();
    PR.spo=PO;
    
    test.stoptest();
    }
}