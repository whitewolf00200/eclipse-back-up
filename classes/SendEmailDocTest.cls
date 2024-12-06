@isTest
/*============================================================================================================
*Class Name     : SendEmailDocTest
*Description    : All the implementations related to test SendEmailDoc class.
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 2nd Mar, 2020
*Version        : 2.0
*Change History : 
*Methods        : static testMethod void myTest()
                  static testMethod void myTest1()
                  static testMethod void myTest2()
                  static testMethod void myTest3()
                 
*============================================================================================================*/
public class SendEmailDocTest{
 
 static Id BasicPropsalId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Equipment Proposal').getRecordTypeId();
 Static Id LongPrjId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Project Proposal').getRecordTypeId(); 
 Static Id ServicePrjId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Service Proposal').getRecordTypeId(); 
 Static Id ShortPrjId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Short Project Proposal').getRecordTypeId(); 

/*====================================================

*Method Name     : myTest
*Description     : All the implementations related to test SendEmailDoc class.
*Arguments       : No arguments
====================================================*/   
    static testMethod void myTest(){
        PriceBook__c pre =new PriceBook__c();
        pre.Region__c='BN Zone D';
        pre.Name ='BN Zone D';
        insert pre;
        
        Pricebook2 price =new Pricebook2();
        price.name='test';
        insert price;	
        
        Account ac=new Account();
        ac.name='Test Account';
        ac.Account_Status__c='live';
        ac.Price_List_Correct__c=system.today();
        ac.Customer_type__c='Prison';
        ac.Price_Book__c=price.Id;
        ac.Region__c='BN Zone D';
        insert ac;
       
       
        
        Contact cont=new Contact();
        cont.lastname='Test Contact';
        cont.AccountId=ac.id;
        insert cont;
        
        Campaign cmp=new Campaign();
        cmp.Name='Test Cmp';
        insert cmp;
        
        Warehouse__c ware3 =new Warehouse__c();
        ware3.Name='test';	
        ware3.CurrencyIsoCode ='EUR';
        ware3.Default__c =true;
        insert ware3;
 
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.StageName = 'Prospecting';
        opp.CloseDate = system.today();
        opp.AccountId=ac.id;
        opp.Sales_Type__c='Service';
        opp.InvoiceEmailTo__c='test@gmail.com';
        opp.Campaign=cmp;
        opp.CurrencyIsoCode ='EUR';
        insert opp;
       
        Quote quo = new Quote();
        quo.Name = 'Test Quote';
        quo.RecordTypeId=BasicPropsalId;
        quo.OpportunityId = opp.Id; 
        quo.Increase_Version__c=true; 
        quo.Version_Number__c=2;      
       
        Test.startTest();
        insert quo;
        
        Test.setCurrentPage(page.EquipmentProposal);
        Blob content = Blob.valueOf('UNIT.TEST');
        
        SendEmailDoc.saveAndSend(quo.id,'save');
        SendEmailDoc.saveAndSend(quo.id,'saveandsend');
        SendEmailDoc.saveAndSend(quo.id,'cancelQuote');
        Test.stopTest();
    }
/*====================================================

*Method Name     : myTest1
*Description     : All the implementations related to test SendEmailDoc class.
*Arguments       : No arguments
====================================================*/      
    static testMethod void myTest1(){
         PriceBook__c pre =new PriceBook__c();
        pre.Region__c='BN Zone D';
        pre.Name ='BN Zone D';
        insert pre;
        
         Pricebook2 price =new Pricebook2();
        price.name='test';
        insert price;
    
        Account ac=new Account();
        ac.name='Test Account';
        ac.Account_Status__c='live';
        ac.Customer_type__c='others';
        ac.Price_Book__c=price.Id;
          ac.Region__c='BN Zone D';
        insert ac;
        
        Contact cont=new Contact();
        cont.lastname='Test Contact';
        cont.AccountId=ac.id;
        insert cont;
        
        Campaign cmp=new Campaign();
        cmp.Name='Test Cmp';
        insert cmp;
        
        Warehouse__c ware2 =new Warehouse__c();
        ware2.Name='test';	
        ware2.CurrencyIsoCode ='EUR';
        ware2.Default__c =true;
        insert ware2;
 
 
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test Opportunity';
        opp1.StageName = 'Prospecting';
        opp1.CloseDate = system.today();
        opp1.AccountId=ac.id;
        opp1.Sales_Type__c='Service';
        opp1.InvoiceEmailTo__c='test@gmail.com';
        opp1.Campaign=cmp;
        opp1.CurrencyIsoCode ='EUR';
        insert opp1;
       
        Quote quo1 = new Quote();
        quo1.Name = 'Test Quote';
        quo1.RecordTypeId=LongPrjId;
        quo1.OpportunityId = opp1.Id; 
        quo1.Increase_Version__c=true; 
        quo1.Version_Number__c=2;        
       
        Test.startTest();
        insert quo1;
        
        Test.setCurrentPage(page.ProjectProposal);
        Blob content = Blob.valueOf('UNIT.TEST');
        
        SendEmailDoc.saveAndSend(quo1.id,'save');
        SendEmailDoc.saveAndSend(quo1.id,'saveandsend');
        SendEmailDoc.saveAndSend(quo1.id,'cancelQuote');
        Test.stopTest();
    }
/*====================================================

*Method Name     : myTest2
*Description     : All the implementations related to test SendEmailDoc class.
*Arguments       : No arguments
====================================================*/      
    static testMethod void myTest2(){
         PriceBook__c pre =new PriceBook__c();
        pre.Region__c='BN Zone D';
        pre.Name ='BN Zone D';
        insert pre;
        
       Pricebook2 price =new Pricebook2();
        price.name='test';
        insert price;
    
        Account ac=new Account();
        ac.name='Test Account';
        ac.Account_Status__c='live';
        ac.Customer_type__c='others';
        ac.Price_Book__c=price.Id;
        ac.Region__c='BN Zone D';
        insert ac;
        
        Contact cont=new Contact();
        cont.lastname='Test Contact';
        cont.AccountId=ac.id;
        insert cont;
        
        Campaign cmp=new Campaign();
        cmp.Name='Test Cmp';
        insert cmp;
        
        Warehouse__c ware1 =new Warehouse__c();
        ware1.Name='test';	
        ware1.CurrencyIsoCode ='EUR';
        ware1.Default__c =true;
        insert ware1;
 
 
        Opportunity opp2 = new Opportunity();
        opp2.Name = 'Test Opportunity';
        opp2.StageName = 'Prospecting';
        opp2.CloseDate = system.today();
        opp2.AccountId=ac.id;
        opp2.Sales_Type__c='Service';
        opp2.InvoiceEmailTo__c='test@gmail.com';
        opp2.Campaign=cmp;
        opp2.CurrencyIsoCode ='EUR';
        insert opp2;
       
        Quote quo2 = new Quote();
        quo2.Name = 'Test Quote';
        quo2.RecordTypeId=ServicePrjId;
        quo2.OpportunityId = opp2.Id;  
        quo2.Increase_Version__c=true; 
        quo2.Version_Number__c=2;       
       
        Test.startTest();
        insert quo2;
        
        
        Test.setCurrentPage(page.ServiceProposal);
        Blob content = Blob.valueOf('UNIT.TEST');
        
        SendEmailDoc.saveAndSend(quo2.id,'save');
        SendEmailDoc.saveAndSend(quo2.id,'saveandsend');
        SendEmailDoc.saveAndSend(quo2.id,'cancelQuote');
        Test.stopTest();
    }
/*====================================================

*Method Name     : myTest3
*Description     : All the implementations related to test SendEmailDoc class.
*Arguments       : No arguments
====================================================*/      
    static testMethod void myTest3(){
         PriceBook__c pre =new PriceBook__c();
        pre.Region__c='BN Zone D';
        pre.Name ='BN Zone D';
        insert pre;
        
         Pricebook2 price =new Pricebook2();
        price.name='test';
        insert price;
    
        Account ac=new Account();
        ac.name='Test Account';
        ac.Account_Status__c='live';
        ac.Customer_type__c='others';
        ac.Price_Book__c=price.Id;
          ac.Region__c='BN Zone D';
        insert ac;
        
        Contact cont=new Contact();
        cont.lastname='Test Contact';
        cont.AccountId=ac.id;
        insert cont;
        
        Campaign cmp=new Campaign();
        cmp.Name='Test Cmp';
        insert cmp;
      
        Warehouse__c ware =new Warehouse__c();
        ware.Name='test';	
        ware.CurrencyIsoCode ='EUR';
        ware.Default__c =true;
        insert ware;
 
        Opportunity opp3 = new Opportunity();
        opp3.Name = 'Test Opportunity';
        opp3.StageName = 'Prospecting';
        opp3.CloseDate = system.today();
        opp3.AccountId=ac.id;
        opp3.Sales_Type__c='Service';
        opp3.InvoiceEmailTo__c='test@gmail.com';
        opp3.Campaign=cmp;
        opp3.CurrencyIsoCode ='EUR';
        insert opp3;
       
        Quote quo3 = new Quote();
        quo3.Name = 'Test Quote';
        quo3.RecordTypeId=ShortPrjId;
        quo3.OpportunityId = opp3.Id; 
        quo3.Increase_Version__c=true;  
        quo3.Version_Number__c=2;       
       
        Test.startTest();
        insert quo3;
        
        Test.setCurrentPage(page.ShortProjectProposal);
        Blob content = Blob.valueOf('UNIT.TEST');
        
        SendEmailDoc.saveAndSend(quo3.id,'save');
        SendEmailDoc.saveAndSend(quo3.id,'saveandsend');
        SendEmailDoc.saveAndSend(quo3.id,'cancelQuote');
        Test.stopTest();
    }
}