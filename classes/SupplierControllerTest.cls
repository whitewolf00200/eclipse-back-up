@isTest(SeeAllData=true)
public class SupplierControllerTest{
    
    static testMethod void myTest(){
    
    test.starttest();
    
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
    
    Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
    
    Account Acc1=new Account();
    Acc1.Name='Test';
    Acc1.Recordtypeid=devRecordTypeId;
    insert Acc1;
    
    SupplierProduct__c SP=new SupplierProduct__c();
    SP.Product__c=prd.id;
    SP.Supplier__c=Acc1.id;
    SP.Cost__c=112;
    Insert SP;
  
    PurchaseOrderLineItem__c POLine=new PurchaseOrderLineItem__c();
    POLine.Purchase_Order__c=PO.id;
    POLine.Product__c=prd.id;
    POLine.Quantity__c=1;
    POLine.Price__c=1;
    insert POLine;
    
    ApexPages.currentPage().getParameters().put('sid', prd.id);
    ApexPages.currentPage().getParameters().put('po', PO.id);
    SupplierController SC=new SupplierController();
    
    SC.getSupplier();
    SC.selectedSupplier();
    SC.continueProductDelete();
    SC.processSelected(true);
    SC.getSupplierPOProductList(String.valueOf(Acc1.id));
    
    test.stoptest();
    }
}