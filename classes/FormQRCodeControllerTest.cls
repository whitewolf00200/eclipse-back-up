@isTest(seeAllData=true)
/*============================================================================================================
*Class Name     : FormQRCodeControllerTest
*Description    : All the implementations related to test Generate Label For Product.
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 25th Jun, 2020
*Version        : 1.0
*Change History : Initial class
*Methods        : public static @isTest void m1()
*============================================================================================================*/
public class FormQRCodeControllerTest {
/*====================================================
*Method Name     : m1
*Description     : This method test InsertPOLineItemController class.
*Arguments       : No Arguments
*Ticket No       : 40744
====================================================*/
    public static @isTest void m1(){
        
        
        product2 prd=new product2();
        prd.Name='Test Product';
        prd.IsActive=true;
        prd.ProductCode='TES124';
        prd.Cost__c=12;
        prd.Supplier_Product_Code__c='Test1';
        prd.Min_Stock__c=2;
        prd.Maximum_stock_level__c=3;
        insert prd;
        
        
        
        Pagereference pageref=Page.FormLabel;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',prd.id);
        FormQRCodeController controller=new FormQRCodeController();
        
        
        }
}