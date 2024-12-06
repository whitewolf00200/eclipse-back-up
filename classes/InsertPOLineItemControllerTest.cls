@isTest(seeAllData=true)
/*============================================================================================================
*Class Name     : InsertPOLineItemControllerTest
*Description    : All the implementations related to test InsertPOLineItemController.
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 25th Jun, 2020
*Version        : 1.0
*Change History : Initial class
*Methods        : public static @isTest void m1()                  
*============================================================================================================*/
public class InsertPOLineItemControllerTest{
/*====================================================
*Method Name     : m1
*Description     : This method test InsertPOLineItemController class.
*Arguments       : No Arguments
*Ticket No       : 40744
====================================================*/
  public static @isTest void m1(){
        
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
        po.created_by__c='test';
        po.Document_Creator__c='test@gmail.com'; 

        insert PO;
        
        product2 prd=new product2();
        prd.Name='Test Product';
        prd.IsActive=true;
        prd.ProductCode='TES124';
        prd.Cost__c=12;
        prd.Supplier_Product_Code__c='Test1';
        prd.Min_Stock__c=2;
        prd.Maximum_stock_level__c=3;
        insert prd;
        Test.startTest();
        PurchaseOrderLineItem__c POLine=new PurchaseOrderLineItem__c();
        POLine.Purchase_Order__c=PO.id;
        POLine.Product__c=prd.id;
        POLine.Quantity__c=1;
        POLine.Total_Received_Quantity__c=1;
        POLine.Price__c=1;
        insert POLine;
        
        Pagereference pageref=Page.POScanner;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',po.id);
        ApexPages.StandardController sc=new ApexPages.StandardController(po);
        InsertPOLineItemController controller=new InsertPOLineItemController(sc);
        InsertPOLineItemController.insertPart('Test1','1',po.id);
        controller.pageRedirector();

       }
}