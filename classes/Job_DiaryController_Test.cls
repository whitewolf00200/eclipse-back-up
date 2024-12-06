@isTest(seeAlldata=true)
/*=========================================================================================================
    *Class Name     : Job_DiaryControllerTest
    *Description    : Test class for SchedulateHandler
    *Company        : Merfantz
    *Date           : 11 Nov 2018  
 ============================================================================================================== */    

    
/*=========================================================================================================
    *Class Name     : Job_DiaryControllerTest
    *Description    : Test class for SchedulateHandler
    *Company        : Merfantz
    *Date           : 11 Nov 2018  
 ============================================================================================================== */    

private class Job_DiaryController_Test {        
   
    
/*================================================================
Method Name: inserScheduleTestRecord
Parameters : Null
Description: 
Date       : 11 Nov 2018  
================================================================*/
    
    public static testMethod void inserJob_DiaryController(){
    
//user
    User u = new User();
             u.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id;
             u.LastName = 'test';
             u.Email = 'test@test.com';
             u.Username = 'test@test.com' + System.currentTimeMillis();
             u.CompanyName = 'TEST';
             u.Title = 'title';
             u.Alias = 'alias';
             u.TimeZoneSidKey = 'America/Los_Angeles';
             u.EmailEncodingKey = 'UTF-8';
             u.LanguageLocaleKey = 'en_US';
             u.LocaleSidKey = 'en_US';
			insert u;

    
    
       //RecordType 
    Id siteId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
    Id siteId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
    Id psp = Schema.SObjectType.Engineer_Checklist__c.getRecordTypeInfosByName().get('Air Compressor Service and Test Report').getRecordTypeId();
    Id opId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Invoice (To Invoice)').getRecordTypeId();




//Account customer
    Account acc=new Account();
    acc.Name='test account';
    acc.Account_Status__c='Live';
    acc.recordtypeid=siteId1 ;
    acc.Customer_type__c='MOD/Barracks' ;   
    insert acc;

//Account Site
    Account ac=new Account();
    ac.Name='test account';
    ac.Account_Status__c='Live';
    ac.recordtypeid=siteId ;
    ac.Customer_type__c='MOD/Barracks' ;  
    insert ac;

//Contact
    Contact cn=new Contact();
    cn.LastName='test';
    cn.AccountID=ac.id; 
    insert cn;  
    
//SiteContracts 
    SiteContracts__c si=new SiteContracts__c();
    si.Site__c=ac.id;
    si.Customer__c=acc.id;
    si.Visit_Rescheduling__c='On Schedule';
    si.Number_of_Services__c=2;
    si.AM_Status__c='Live';
    si.Price_Book__c=Test.getStandardPricebookId();
    si.Due__c='march';    
    insert si;

//Technician
    Engineer__c technician=new Engineer__c();
    technician.Name='test';
    technician.Engineer_ID__c='1234';
    technician.Active_User__c='Yes';
    technician.Street__c='test address';
    technician.City__c='test city';
    technician.Salesforce_User__c=u.id;
    technician.Country__c='test country';
    technician.Postal_Code__c='1245';
    technician.State_Province__c='test state';
    insert technician;
	 
//Visit
    Visits__c vi=new Visits__c();
    vi.Site__c=ac.id;
    vi.Customer_Contact__c=cn.id;
    vi.Customer_Contact__c=cn.id;
    //system.assertEquals(vi.Site__c,vi.Customer_Contact__c.AccountId);    
    vi.Site_Contract__c=si.id;
    vi.Visit_Completed__c=System.now();
    vi.Visit_Complete__c=true;
    vi.Visit_Type__c='Service';
    vi.Actual_Service_Date__c=system.today();
    vi.Engineer2__c=technician.id;
    insert vi;

	Job_DiaryController ec1=new Job_DiaryController();
    ec1.loadVisits();
    }
    
 }