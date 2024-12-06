@isTest(seeAllData=true)
/*============================================================================================================
*Class Name     : TransferPartsAdvancedControllerTest
*Description    : All the implementations related to test TransferPartsAdvancedController.
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 28th Nov, 2022
*Version        : 1.0
*Change History : No change history
*Methods        : public @isTest static void m1()
                  public @isTest static void m2()
                  public @isTest static void m3()
*============================================================================================================*/
public class TransferPartsAdvancedControllerTest {
/*====================================================
*Method Name     : m1
*Description     : This method test TransferPartsAdvancedController class.
*Arguments       : No Argument.
*Ticket No       : 40744
====================================================*/
    public @isTest static void m1(){
        //get standard pricebook
          Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        
         
          Product2 prod=new Product2();
          prod.name='Test';
          prod.isActive=true;
          prod.productcode='Test';
          prod.Supplier_Product_Code__c='Test';
          insert prod;
          
          PricebookEntry pbe1 = new PricebookEntry (Product2ID=prod.id,Pricebook2ID=standardPb.id,UnitPrice=50, isActive=true);
          insert pbe1;
        
        
        
        
        Warehouse__c WH=new Warehouse__c();
        WH.Name='Test';
        wh.default__c=true;
        insert WH;
        
        
        
        Warehouse__c WH2=new Warehouse__c();
        WH2.Name='Test';
        
        insert WH2;
        
        Inventory__c inv=new Inventory__c();
        inv.Product__c=prod.id;
        inv.Warehouse__c=wh.id;
        insert inv;
        
        Inventory__c inv2=new Inventory__c();
        inv2.Product__c=prod.id;
        inv2.Warehouse__c=wh2.id;
        insert inv2;
        
        PageReference pageRef=Page.TransferPartsAdvanced;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController controller=new ApexPages.StandardController(WH);
        TransferPartsAdvancedController con=new TransferPartsAdvancedController(controller);
        TransferPartsAdvancedController.getAvailableQty('Test',wh.id);
        TransferPartsAdvancedController.partsTransfer('Test',wh2.id,'2',wh.id);
        con.verifyCode();
        con.selectedWH=WH.id;
        con.onCancel();
        con.pageRedirector();
        
        	
    }
/*====================================================
*Method Name     : m2
*Description     : This method test TransferPartsAdvancedController class.
*Arguments       : No Argument.
*Ticket No       : 96456
====================================================*/    
    public @isTest static void m2(){
        //get standard pricebook
          Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];

          
          Product2 prod=new Product2();
          prod.name='Test';
          prod.isActive=true;
          prod.productcode='Test';
          prod.Supplier_Product_Code__c='Test';
          insert prod;
          
          PricebookEntry pbe1 = new PricebookEntry (Product2ID=prod.id,Pricebook2ID=standardPb.id,UnitPrice=50, isActive=true);
          insert pbe1;
        
        
        
        
        Warehouse__c WH=new Warehouse__c();
        WH.Name='Test';
        wh.default__c=true;
        insert WH;
        
        
        
        Warehouse__c WH2=new Warehouse__c();
        WH2.Name='Test';
        
        insert WH2;
        
        Inventory__c inv=new Inventory__c();
        inv.Product__c=prod.id;
        inv.Warehouse__c=wh.id;
        insert inv;
        
        
        
        PageReference pageRef=Page.TransferPartsAdvanced;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController controller=new ApexPages.StandardController(WH);
        TransferPartsAdvancedController con=new TransferPartsAdvancedController(controller);
        TransferPartsAdvancedController.getAvailableQty('','');
        TransferPartsAdvancedController.partsTransfer('Test',wh2.id,'2',wh.id);
        con.verifyCode();
        con.count=1;
        con.selectedWH=WH.id;
        con.onCancel();
        con.pageRedirector();
        
        
    }
/*====================================================
*Method Name     : m3
*Description     : This method test TransferPartsAdvancedController class.
*Arguments       : No Argument.
*Ticket No       : 96456
====================================================*/
public @isTest static void m3(){
        //get standard pricebook
          Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];

          
          Product2 prod=new Product2();
          prod.name='Test';
          prod.isActive=true;
          prod.productcode='Test';
          prod.Supplier_Product_Code__c='Test';
          insert prod;
          
          PricebookEntry pbe1 = new PricebookEntry (Product2ID=prod.id,Pricebook2ID=standardPb.id,UnitPrice=50, isActive=true);
          insert pbe1;
        
        
        
        
        Warehouse__c WH=new Warehouse__c();
        WH.Name='Test';
        wh.default__c=true;
        insert WH;
        
        
        
        Warehouse__c WH2=new Warehouse__c();
        WH2.Name='Test';
        
        insert WH2;
        
        Inventory__c inv=new Inventory__c();
        inv.Product__c=prod.id;
        inv.Warehouse__c=wh.id;
        insert inv;
        
        
        
        PageReference pageRef=Page.TransferPartsAdvanced;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController controller=new ApexPages.StandardController(WH);
        TransferPartsAdvancedController con=new TransferPartsAdvancedController(controller);
        TransferPartsAdvancedController.getAvailableQty('Test',wh.id);
        TransferPartsAdvancedController.partsTransfer('Test',wh2.id,'2',wh.id);
        con.verifyCode();
        con.count=0;
        con.selectedWH=WH.id;
        con.onCancel();
        con.pageRedirector();
        
        
    }    
}