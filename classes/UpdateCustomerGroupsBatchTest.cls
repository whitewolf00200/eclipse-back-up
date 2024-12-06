@isTest(seeAlldata=true)
public class UpdateCustomerGroupsBatchTest 
{
    Public static testmethod void batchtest()     
    {
        List<Account> testAccounts = new List<Account>();
        Account acc = new Account();
        acc.name='Testing';
        acc.Customer_Group__c='New Customers';
        acc.Region__c='BN Zone D';
        acc.Customer_type__c='others';
        acc.Survey_required__c=false;
        acc.account_status__c='Live';
        insert acc;
        
               
        acc.Region__c='BR Zone B';
        update acc;
        
        acc.Region__c='Central London (E,EC,WC,W)';
        update acc;
        
        acc.Region__c='BN Zone D';
        update acc;
        
        acc.Region__c='CM Zone C';
        update acc;
        
        acc.Region__c='HA Zone D';
        update acc;
        
        acc.Region__c='HP Zone D';
        update acc;
        
        acc.Region__c='CR Zone C';
        update acc;
        
        acc.Region__c='CT Zone C';
        update acc;
        
        acc.Region__c='GU Zone D';
        update acc;
        
        acc.Region__c='DA Zone A';
        update acc;
        
        acc.Region__c='IG Zone C';
        update acc;
        
        acc.Region__c='KT Zone C';
        update acc;
        
        acc.Region__c='MK Zone D';
        update acc;
        
        acc.Region__c='ME Zone B';
        update acc;
        
        acc.Region__c='NL';
        update acc;
        
        acc.Region__c='North London (NW,N,EN) Zone D';
        update acc;
        
        
        acc.Region__c='Other';
        update acc;
        
        
        acc.Region__c='PO Zone E';
        update acc;
        
        
        acc.Region__c='RG Zone D';
        update acc;
        
        
        acc.Region__c='RM Zone B';
        update acc;
        
        
        acc.Region__c='RH Zone C';
        update acc;
        
        
        acc.Region__c='SE Zone C';
        update acc;
        
        
        acc.Region__c='SL Zone D';
        update acc;
        
        
        acc.Region__c='SG';
        update acc;
        
        
        acc.Region__c='SM Zone C';
        update acc;
        
        
        acc.Region__c='SO Zone D';
        update acc;
        
        acc.Region__c='S- Scotland';
        update acc;
        
        acc.Region__c='SS Zone C';
        update acc;
        
        acc.Region__c='SW Zone C&D';
        update acc;
        
        acc.Region__c='TW Zone D';
        update acc;
        
        acc.Region__c='UB Zone D';
        update acc;
        
        acc.Region__c='WF (NHS)';
        update acc;
        
        acc.Region__c='TN Zone B & C';
        update acc;

        Account exAccount=[Select id,Price_List_Correct__c from Account LIMIT 1];
        exAccount.Price_List_Correct__c=system.today();
        update exAccount;
        
        list<Account> ChildRecords = [Select id,Parentid,Price_List_Correct__c from account where parentid = :exAccount.id];
        
        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 standardPricebook = new Pricebook2(
            Id = pricebookId,
            IsActive = true
        );
        update standardPricebook;
        
        Pricebook2 testPriceBook = new Pricebook2();
        testPriceBook.Name = 'TestPricebook2';
        testPriceBook.IsActive = true;
        insert testPriceBook;
        

        Product2 pro = new Product2(Name = 'iPhone X', Family = 'Mobile', IsActive = true);
        Insert pro;
        
    
       
        
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
        UpdateCustomerGroupsBatch batch = new UpdateCustomerGroupsBatch(); 
        Database.executeBatch(batch);
        Test.stopTest();
        
    }
    
}