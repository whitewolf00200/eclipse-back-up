/*
        Name           : TestMonthlyTargetTrigger
        Author         : 
        Date           : 23rd June 2014
        Description    : Test class of MonthlyTargetTrigger
*/

@isTest(SeeAllData=true)
public class TestMonthlyTargetTrigger{
    // test method
    @isTest
    private static void test(){
        // create test auto product config
        Auto_Product_Config__c auto = TestDataHandler.createTestAutoProductConfig();
        insert auto;
        
        // create test account
        Account site = TestDataHandler.createTestSite();
        insert site;
        
        // create test site contract
        SiteContracts__c siteContact = TestDataHandler.createTestSiteContract(site.Id);
        insert siteContact;
        
        // create test engineer
        Engineer__c eng = TestDataHandler.createTestEngineer();
        insert eng;
        
        // create test visit
        List<Visits__c> listVisit = new List<Visits__c>();
        for(Integer counter = 1 ; counter <= 12 ; counter++){
            Visits__c visit = TestDataHandler.createTestVisit(siteContact.Id,site.Id,eng.Id);
            visit.Order_Value__c = 500;
            visit.Purchase_Order__c = 'Test';
            listVisit.add(visit);
        }
        insert listVisit;
        
        Map<Integer,String> mapMonths = new Map<Integer,String>{1=>'January__c',2=>'February__c',3=>'March__c',4=>'April__c',5=>'May__c',6=>'June__c',7=>'July__c',8=>'August__c',9=>'September__c',10=>'October__c',11=>'November__c',12=>'December__c'};
        Integer currentMonth = system.today().month();
        for(Integer counter=1 ; counter <= 12 ; counter++){
            if(currentMonth > 12){
                currentMonth = 1;
            }
            listVisit[0].put(mapMonths.get(currentMonth),0);
            update listVisit[0];
            currentMonth++;
        }
        for(Visits__c visit : listVisit){
            visit.Order_Value__c = null;
        }
        update listVisit;
    }
}