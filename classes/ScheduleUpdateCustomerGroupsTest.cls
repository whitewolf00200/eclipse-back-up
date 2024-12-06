@isTest(seeAllData=true)
public class ScheduleUpdateCustomerGroupsTest {
    Public static testmethod void batchtest()
    {
        product2 prd=new product2();
        prd.name='test';
        prd.Isactive=true;
        insert prd;
        
        PriceBook2 price = new PriceBook2();
        price.Name ='test';
        insert price;
        
        List<Account> testAccounts = new List<Account>();
        
        Account acc = new Account();
        acc.name='Testing';
        acc.Customer_Group__c='New Customers';
        acc.Region__c='BN Zone D';
        acc.Customer_type__c='others';
        acc.Survey_required__c=false;
        acc.account_status__c='Live';
        testAccounts.add(acc);
        
        Account acc1 = new Account();
        acc1.name='Testing1';
        acc1.Customer_Group__c='New Customers';
        acc1.Region__c='BR Zone B';
        acc1.Customer_type__c='others';
        acc1.Survey_required__c=false;
        acc1.account_status__c='Live';
        testAccounts.add(acc1);
        
        insert testAccounts;
        
        List<Opportunity> testOpportunities = new List<Opportunity>();
        
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Invoice_Date__c = Date.today().addMonths(-12), 
            AccountId = acc.Id
        );
        testOpportunities.add(opp);
        Opportunity opp1 = new Opportunity(
            Name = 'Test Opportunity1',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Invoice_Date__c = Date.today().addMonths(-40), 
            AccountId = acc1.Id
        );
        testOpportunities.add(opp1);
        Opportunity opp2 = new Opportunity(
            Name = 'Test Opportunity1',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Invoice_Date__c = Date.today().addMonths(-70), 
            AccountId = acc1.Id
        );
        testOpportunities.add(opp2);
        
        insert testOpportunities;
        
        Test.startTest();
        String cronExp = '0 0 0 1 1 ?'; 
        System.schedule('Test Update Customer Groups', cronExp, new ScheduleUpdateCustomerGroups());
        Test.stopTest();
        
        
    }
}