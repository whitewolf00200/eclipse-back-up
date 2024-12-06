@isTest(SeeAllData=true)
public class POLineItemProductEntryCtrlTest{
    
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
    
    ApexPages.StandardController sc = new ApexPages.standardController(PO);
    ApexPages.currentPage().getParameters().put('id', PO.id);
    ApexPages.currentPage().getParameters().put('searchString', prd.Name);
    ApexPages.currentPage().getParameters().put('toSelect', prd.id);
    ApexPages.currentPage().getParameters().put('toUnselect', POLine.id);  
    POLineItemProductEntryController POLineobj=new POLineItemProductEntryController(sc);
    
    POLineobj.updateAvailableList();
    POLineobj.addToShoppingCart();
    POLineobj.removeFromShoppingCart();
    POLineobj.onSave();
    POLineobj.onCancel();
    
    test.stoptest();
    }
}