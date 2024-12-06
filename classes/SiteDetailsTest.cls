@isTest(seeAlldata=true)
Public Class SiteDetailsTest{
     @isTest Public static void Method1() { 

     List <SiteContracts__c> lstContract = new List<SiteContracts__c>();
     
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
        
         SiteContracts__c t_siteContract= new SiteContracts__c();
         t_siteContract.site__c=newAccount.id;
         t_siteContract.Number_of_Services__c= 5;
         t_siteContract.Visit_Rescheduling__c='On Visit';
         t_siteContract.Service_Charge__c = 25;
         lstContract.add(t_siteContract);
         
         SiteContracts__c t_siteContract1= new SiteContracts__c();
         t_siteContract1.site__c=newAccount.id;
         t_siteContract1.Number_of_Services__c= 5;
         t_siteContract1.Visit_Rescheduling__c='On Visit';
         t_siteContract1.Service_Charge__c = 25;
         lstContract.add(t_siteContract1);
    
         insert  lstContract;
     
    Test.startTest();
      Test.setCurrentPage(Page.Export_SiteContracts);
      ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(lstContract);
      stdSetController.setSelected(lstContract);
      SiteDetails SteDetails = new SiteDetails(stdSetController);
     Test.stopTest();
   }
}