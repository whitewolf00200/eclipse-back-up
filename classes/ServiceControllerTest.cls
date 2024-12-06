@istest(seealldata=true)

public class ServiceControllerTest{
    
    static Id PSPBId = Schema.SObjectType.Engineer_Checklist__c.getRecordTypeInfosByName().get('Air Compressor Service and Test Report').getRecordTypeId();
    
    @isTest public static void TestMethode(){
        
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
        //newAccount.Parent=Pacc;
        newAccount.ParentId=Pacc.Id;
        
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
        t_siteContract.Customer__c = newAccount.id;
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
        //insert ec; 
        
        product2 prd=new product2(Name='Test Product',IsActive = true);
        insert prd;
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(), Product2Id = prd.Id,
            UnitPrice = 100, IsActive = true);
        insert standardPrice;
        
        Warehouse__c wc = new Warehouse__c();
        wc.Name = 'test Warehouse';
        Insert wc;
        
        Required_Parts__c Req=new Required_Parts__c();
        Req.Product_Name__c=prd.id;
        Req.Service_Sheet__c=ec.id;
        Req.Quantity__c=2;
        Req.Warehouse__c = wc.id;
        Req.Include_Invoice__c=true;
        insert Req;
        
        ec.Close_Visit__c='Yes';
        ec.Fire_Extinguisher_Service_complete__c=true;
        // update ec;  
        
        Test.StartTest();
        Engineer_Checklist__c env = [Select id,Name,Engineer__c,Visit__c,Site__c,Site_Contract__c,Engineer__r.Signature__c FROM Engineer_Checklist__c Where Engineer__c != null limit 1];
        Service_Sheet_STD__c rs = new Service_Sheet_STD__c();
        
        PageReference pref = Page.Annual_Mechanical_Service_Report;
        pref.getParameters().put('id', env.id);
        pref.getParameters().put('Type', 'Engineer_Checklist__c');
        Test.setCurrentPage(pref);
        
        ServiceController sc = new ServiceController();
        sc.ss = env;
        sc.rs = new Service_Sheet_STD__c();
        //sc.ServiceController();
        sc.getsheetid();
        sc.setsheetid(ec.id);
        
        Test.StopTest();
    }
    
}