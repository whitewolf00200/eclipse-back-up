@isTest
/*============================================================================================================
*Class Name     : Purchase_Order_Preview_CtrlTest
*Description    : All implementation to test the class Purchase_Order_Preview_Controller.
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 29th Jan, 2017
*Version        : 2.0
*Change History : Initial Class
*Methods        : static testMethod void myTest()
*============================================================================================================*/
public class Purchase_Order_Preview_CtrlTest{

/*====================================================

*Method Name     : myTest
*Description     : This method test the Purchase_Order_Preview_Controller class
*Arguments       : No Arguments
*Ticket No       : 32042
====================================================*/
    
    static testMethod void myTest(){
    
    test.starttest();
    
    /*Config__c cnf=new Config__c();
    cnf.Background_Colour__c='#0FF123';
    cnf.Name='Test';
    insert cnf;
    
    ApexPages.StandardController sc = new ApexPages.standardController(cnf);
    Purchase_Order_Preview_Controller PP=new Purchase_Order_Preview_Controller(sc);
    */
    PurchaseOrder__c po=new PurchaseOrder__c();
    po.Created_By__c='Tim Loyn';
    po.Document_Creator__c='test@gmail.com';
    insert po;
    
    
    ApexPages.StandardController sc = new ApexPages.standardController(po);
    Purchase_Order_Preview_Controller PP=new Purchase_Order_Preview_Controller(sc);
    
    test.stoptest();
    }
}