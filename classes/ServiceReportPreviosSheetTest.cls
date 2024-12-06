@isTest (SeeAllData=true)
private class ServiceReportPreviosSheetTest{

static Id PSPBId = Schema.SObjectType.Engineer_Checklist__c.getRecordTypeInfosByName().get('Air Compressor Service and Test Report').getRecordTypeId();
     
    static testMethod void test_ServiceSheetTriggerHandler() {
         
        Id CustomerId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Id SiteId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
         
         product2 prd=new Product2(Name='Test Prd');
         prd.IsActive=true;
         insert prd;
         
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
         insert t_visit;
         
         Service_Sheet_STD__c MainSS=new Service_Sheet_STD__c();
         MainSS.Order_Date__c=system.today();
         MainSS.Site__c=newAccount.id;
         MainSS.Site_Contract__c=t_siteContract.id;
         MainSS.Visit__c=t_visit.id;
         MainSS.Re_Visit_Required__c='No';
         MainSS.Technician__c=tmp_technician.id;
         MainSS.Arrive__c=system.now();
         MainSS.Depart__c=system.now()+10;
         insert MainSS;
         
         Next_Visit_Product__c NextPrd=new Next_Visit_Product__c();
         NextPrd.Product__c=prd.id;
         NextPrd.Quantity__c=2;
         NextPrd.Maintenance_Reactive_Sheet__c=MainSS.id;
         insert NextPrd;
         
         ServiceReportPreviosSheet ServiceReport=new ServiceReportPreviosSheet(); 
         ServiceReport.getSheetid();
         ServiceReport.setSheetid(MainSS.id);
    }
}