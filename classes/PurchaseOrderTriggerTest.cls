/*======================================================================================
        Name            : PurchaseOrderTriggerTest
        Author          : 
        Date            : 20th June 2014
        Description     : This controller is test class of PurchaseOrderTrigger
==========================================================================================
*/

// @isTest
public class PurchaseOrderTriggerTest{
    // Test metod
  /*  @isTest
    private static void test(){
        Auto_Product_Config__c auto = TestDataHandler.createTestAutoProductConfig();
        insert auto;
    
        Account site = TestDataHandler.createTestSite();
        insert site;
        
        SiteContracts__c siteContact = TestDataHandler.createTestSiteContract(site.Id);
        insert siteContact;
        
        //Opportunity opp = TestDataHandler.createTestOpportunity(site.id);
        //insert opp;
        
        Engineer__c eng = TestDataHandler.createTestEngineer();
        insert eng;
        
        Visits__c visit = TestDataHandler.createTestVisit(siteContact.Id,site.Id,eng.Id);
        //visit.Opportunity__c = opp.Id;
        insert visit;
        
        Suppliers__c supp = TestDataHandler.createTestSupplier();
        insert supp;
        
        SFDC_Purchase_Order__c purchase=new SFDC_Purchase_Order__c ();
        purchase.Supplier1__c=supp.id;
        purchase.Visit__c=visit.id;
        purchase.Department__c='test';
        insert purchase;
        
        SFDC_Purchase_Order__c purchaseOrd = TestDataHandler.createTestPurchaseOrder(supp.Id,visit.Id);
        
        insert purchaseOrd;
    }*/
}