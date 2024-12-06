@isTest
private class DispatchBoardClsTest{        
    
    
   @isTest Public static void DispatchBoardTest() { 
       Profile p = [SELECT Id FROM Profile where name LIKE '%system%']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');


     
    product2 prd=new product2();
       prd.name='test';
       prd.Isactive=true;
       //insert prd;
       
     
      Account a = new Account();
      a.Name='Test Customer';
      a.Customer_type__c='others';
      a.Survey_required__c=false;
      a.account_status__c='Live';
      insert a;
      
      Account a2 = new Account();
      a2.Name='Test site';
      a2.Customer_type__c='others';
      a2.parentid=a.id;
      a2.recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
      a2.Survey_required__c=false;
      a2.Account_Status__c='Live';
      insert a2;
      
      SiteContracts__c b = new SiteContracts__c();
      b.Site__c=a2.id;
      b.AM_Status__c='Live';
      b.Customer__c=a.id;
      insert b;
      
      Asset ass=new Asset();
      ass.name='test';
      ass.Site_Contract__c=b.id;
      ass.Product2Id=prd.id;
      ass.AccountId=a2.id;
      //insert ass;
      
      Engineer__c c = new Engineer__c();
      c.Name='Andrew';
      c.Engineer_ID__c='3a443d2f-f632-4d30-a60b-7eda067b958b';
      c.Active_User__c='Yes';
     
      c.Country__c= 'Australia';
      insert c;
      
      Engineer__c c1 = new Engineer__c();
      c1.Name='Test';
      c1.Engineer_ID__c='3a443d2f-f632-4d30-a60b-7eda067b958b';
      c1.Active_User__c='Yes';
     
      c1.Country__c= 'Australia';
      insert c1;
      
      
   
     
     Visits__c vist = new Visits__c();
     
     vist.Site__c=a2.id;
     vist.Site_Contract__c=b.id;
     vist.Engineer2__c=c.id;
     vist.Service_Type__c ='Storm Water Pump';
     vist.End_Date_Time__c=system.today();
     vist.Order_Value__c=2000;
    // vist.Asset__c=ass.id;
     vist.Booked_with_Customers__c='Yes';
     vist.Actual_Service_Date__c=system.today();
     vist.Visit_Type__c='Service';
     insert vist;
     
     
     
     Visits__c vist1 = new Visits__c();
     vist1.Site__c=a2.id;
     vist1.Site_Contract__c=b.id;
     vist1.Engineer2__c=c.id;
     vist1.Service_Type__c ='Sewer pump';
     vist1.Previous_Visit__c=vist.id;
     //insert vist1;
     
     insert new list<Visits__c>{vist1};
     
     vist.End_Date_Time__c=system.today()+1;
     vist.Engineer2__c=c1.id;
     //update vist;
     
     Engineer_Checklist__c d = new Engineer_Checklist__c();
     d.Visit__c = vist.id;
     d.Site__c=a2.id;
     d.Site_Contract__c=b.id;
     d.Date_Of_Manufacture__c=system.today();
     d.Start_Date_and_Time__c=system.now();
     d.End_Date_and_Time__c=system.now()+3;
     d.Start_Travel_Time__c =system.now()+1;
     d.End_Travel_Time__c=system.now()+2;
     d.Email_Confirmation_to__c='test@gmail.com';
     d.Notes_for_next_service__c='Test';
     d.Engineer__c=c1.id;
    // insert d;
    
     
     
     
      DispatchBoardCls DispatchBoard = new DispatchBoardCls();        
      DispatchBoardCls.getDispatchBoardSettings();
      DispatchBoardCls.getAssignmentsByUser(u.id);


}        
    
     
     
      

    
}