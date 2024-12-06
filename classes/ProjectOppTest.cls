public class ProjectOppTest {
        public static testMethod void Tester() {
        
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
         insert t_visit;
         
        Project_Sheet__c ps2 = new Project_Sheet__c();
        ps2.Technician__c=tmp_technician.id;       
        ps2.Site_Contract__c=t_siteContract.id;  
        ps2.Site__c=newAccount.id;
        ps2.Visit__c=t_visit.id;                       
        ps2.Sales_Quote_Required__c='No';
        insert ps2;
    }
}