@isTest
public class customConfigTest{
    
    static testMethod void myTest(){
    
    test.starttest();
    
    Config__c cus=new Config__c();
    cus.Header__c='Test';
    cus.Background_Colour__c='#0FF123';
    cus.Product_Table_Colour__c='#0FF123';
    cus.Footer_Line_1__c='Test';
    cus.Footer_Line_2__c='Test';
    cus.Header_Title__c='Test';
    cus.Invoice_Background__c='#0FF123';
    
    insert cus;
    
    customConfig cusIng=new customConfig();
    cusIng.SAVE();
    cusIng.cust=cus;
    
    test.stoptest();
    }
}