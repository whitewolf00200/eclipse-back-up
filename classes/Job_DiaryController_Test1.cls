/*=========================================================================================================
    *Class Name     : Job_DiaryControllerTest
    *Description    : Test class for SchedulateHandler
    *Company        : Merfantz
    *Date           : 11 Nov 2018  
 ============================================================================================================== */    

@isTest
private class Job_DiaryController_Test1 {        
   
    
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
    Id siteId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
    Id psp = Schema.SObjectType.Engineer_Checklist__c.getRecordTypeInfosByName().get('Air Compressor Service and Test Report').getRecordTypeId();
    Id opId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Invoice (To Invoice)').getRecordTypeId();

//Contact
    Contact cn=new Contact();
    cn.LastName='test';
    insert cn;  



//Account Supplier
    Account acc=new Account();
    acc.Name='test account';
    acc.Account_Status__c='Live';
    acc.recordtypeid=siteId1 ;
    insert acc;

//Account Site
    Account ac=new Account();
    ac.Name='test account';
    ac.Account_Status__c='Live';
    ac.recordtypeid=siteId ;
    insert ac;

//SiteContracts 
    SiteContracts__c si=new SiteContracts__c();
    si.Site__c=ac.id;
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
    vi.Site_Contract__c=si.id;
    vi.Visit_Type__c='Service';
    vi.Actual_Service_Date__c=system.today();
    vi.Engineer2__c=technician.id;
    insert vi;

//Lead
    Lead li=new Lead();
    li.Status='Unqualified';
    li.LastName='kc';
    li.Company='testcompany';
    insert li;

//Custom Setting ControlFetch - Record name: 'Lead Creation'
    ControlFetch__c con=new ControlFetch__c();
    con.name='Lead Creation';
    con.isEnable__c=true;
    insert con;

//Custom Setting ControlFetch - Record name: 'System Admin id'
    ControlFetch__c con1=new ControlFetch__c();
    con1.name='System Admin id';
    con1.TechnicianId__c='00558000000fdRW';
    insert con1;   

//Custom Setting ControlFetch - Record name: 'Parts Used Condition'
    ControlFetch__c con2=new ControlFetch__c();
    con2.name='Parts Used Condition'; 
    con2.Flag__c=true;
    insert con2;

//Service Sheet 
    Engineer_Checklist__c sheet=new Engineer_Checklist__c();
    sheet.recordtypeid=psp;
    sheet.Site__c=ac.id;
    sheet.Site_Contract__c=si.id;
    sheet.Visit__c=vi.id;
    sheet.Engineer__c=technician.id;
    sheet.Date_Of_System_Manufacture__c=system.today();
    sheet.Start_Date_and_Time__c=system.now();
    sheet.End_Date_and_Time__c=system.now()+10;
    sheet.Start_Travel_Time__c=system.now();
    sheet.End_Travel_Time__c=system.now()+10;
    sheet.Email_Confirmation_to__c='test@gmail.com';
    sheet.Congestion_Charge__c=12;
    sheet.Parking_Costs__c=12;
    sheet.Fire_Extinguisher_Service_complete__c = false;
    sheet.Date_Of_Manufacture__c=system.today();
    insert sheet; 
          
    }
}