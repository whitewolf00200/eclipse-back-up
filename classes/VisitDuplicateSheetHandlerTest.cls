@isTest(SeeAllData=true)
public class VisitDuplicateSheetHandlerTest{
 
  @isTest(SeeAllData=true)
  public static void VisitDuplicateSheetMethodTest()
    {
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
                               
        PageReference pageRef =  Page.VisitDuplicateSheets;
        Test.setCurrentPage(pageRef); 
        apexpages.currentpage().getParameters().put('id', String.valueOf(t_visit.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(t_visit);
        VisitDuplicateSheetHandler vdh = new VisitDuplicateSheetHandler (sc);
    }
}