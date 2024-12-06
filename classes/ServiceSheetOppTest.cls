@istest(SeeAllData=true)
public class ServiceSheetOppTest {

static Id PSPBId = Schema.SObjectType.Engineer_Checklist__c.getRecordTypeInfosByName().get('Air Compressor Service and Test Report').getRecordTypeId();

public static testMethod void Tester2() {

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
         
         Engineer_Checklist__c ec = new Engineer_Checklist__c();
         ec.Engineer__c = tmp_technician.id;
         ec.recordtypeid=PSPBId;
         ec.Date__c=system.today();
         ec.Visit__c = t_visit.id;
         ec.Site__c=t_visit.site__c;
         ec.Site_Contract__c = t_siteContract.id;
         ec.Start_Date_and_Time__c = System.Now();
         ec.End_Date_and_Time__c = System.Now()+1;
         ec.Start_Travel_Time__c=System.Now();
         ec.End_Travel_Time__c=System.Now()+1;
         ec.Email_Confirmation_to__c='test@merfantz.com';
         ec.Congestion_Charge__c=12;
         ec.Parking_Costs__c=12;
         ec.Fire_Extinguisher_Service_complete__c = false;
         ec.Date_Of_Manufacture__c=system.today();
         insert ec; 
         
         product2 prd=new product2(Name='Test Product');
         insert prd;
         
         Required_Parts__c Req=new Required_Parts__c(); 
         Req.Product_Name__c=prd.id;
         Req.Quantity__c=12;
         Req.Service_Sheet__c=ec.id;
         Req.Unit_Price__c=12;
         insert Req;

         ec.Fire_Extinguisher_Service_complete__c = true;
         ec.Variance_Checked__c=true;
         ec.End_Date_and_Time__c=system.now();
         ec.Close_Visit__c='No';
         update ec;
    }

}