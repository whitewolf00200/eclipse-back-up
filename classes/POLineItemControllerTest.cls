@isTest(SeeAllData=true)
/*============================================================================================================
*Class Name     : POLineItemControllerTest
*Description    : All the implementations are related tp test POLineItemController
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 29th Apr, 2020
*Version        : 3.0
*Change History : No change history
*Methods        : static testMethod void myTest()                  
*============================================================================================================*/
public class POLineItemControllerTest{
    
/*====================================================
*Method Name     : myTest
*Description     : This method responsible to test POLineItemController.
*Arguments       : No Arguments
*Ticket No       : 46803
====================================================*/    
    static testMethod void myTest(){
    
    test.starttest();
    
    Account Acc=new Account();
    Acc.Name='Test';
    Acc.Customer_type__c='Others';
    insert Acc;
    
    Warehouse__c WH=new Warehouse__c();
    WH.Name='Test';
    insert WH;
 
    PurchaseOrder__c PO=new PurchaseOrder__c();
    PO.Shipping_Warehouse__c=WH.id;
    PO.Create_Date__c=system.today();
    PO.Created_By__c='Tim Boyt';
    PO.Document_Creator__c='test@gmail.com';
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
    ApexPages.currentPage().getParameters().put('POId', PO.id);
    ApexPages.currentPage().getParameters().put('searchString', prd.Name);
    ApexPages.currentPage().getParameters().put('toSelect', prd.id);
    ApexPages.currentPage().getParameters().put('toUnselect', POLine.id);  
    POLineItemController POLineobj=new POLineItemController(sc);
    
    POLineobj.updateAvailableList();
    POLineobj.addToShoppingCart();
    POLineobj.removeFromShoppingCart();
    POLineobj.onSave();
    POLineobj.CompareSupplier();
    POLineobj.onCancel();
    
    test.stoptest();
    }
}