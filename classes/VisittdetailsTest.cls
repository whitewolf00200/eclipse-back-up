@isTest(seeAlldata=true)
Public Class VisittdetailsTest{
     @isTest Public static void Method1() { 

     List <Visits__c> lstVisit = new List<Visits__c>();
     
      Id CustomerId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Id SiteId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        
         Account Pacc = new Account();
         Pacc.Name='Test Customer';
         Pacc.RecordTypeId=CustomerId;
         insert Pacc;
         
         Account newAccount =new Account();
         newAccount.Name='Test Site';
         newAccount.Price_Book__c=Test.getStandardPricebookId();
         newAccount.RecordTypeId=SiteId;
         newAccount.Parent=Pacc;
         insert newAccount;
         
         Engineer__c tmp_technician = new Engineer__c();
         tmp_technician.Name='Test Engineer';
         tmp_technician.Mobile_Phone__c ='98989 898989';
         tmp_technician.Technician_Group__c='Contractor';
         insert tmp_technician;
         
         SiteContracts__c t_siteContract= new SiteContracts__c();
         t_siteContract.site__c=newAccount.id;
         t_siteContract.Number_of_Services__c= 5;
         t_siteContract.Visit_Rescheduling__c='On Visit';
         t_siteContract.Service_Charge__c = 25;
         insert t_siteContract;
         
         Visits__c t_visit= new Visits__c();
         t_visit.site__c=newAccount.id;
         t_visit.site_Contract__c=t_siteContract.id;
         t_visit.Engineer2__c=tmp_technician.id;
         t_visit.Service_Type__c='Testing';
         t_visit.Actual_Service_Date__c=System.Today();
         lstVisit.add(t_visit);
         
         Visits__c t_visit1= new Visits__c();
         t_visit1.site__c=newAccount.id;
         t_visit1.site_Contract__c=t_siteContract.id;
         t_visit1.Engineer2__c=tmp_technician.id;
         t_visit1.Service_Type__c='Testing';
         t_visit1.Actual_Service_Date__c=System.Today();
         lstVisit.add(t_visit1);
    
          insert lstVisit;
     
    Test.startTest();
      Test.setCurrentPage(Page.Export_Visit);
      ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(lstVisit);
      stdSetController.setSelected(lstVisit);
      Visittdetails VisDetails = new Visittdetails(stdSetController);
     Test.stopTest();
   }
}