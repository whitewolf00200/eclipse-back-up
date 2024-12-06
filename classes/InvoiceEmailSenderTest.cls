@IsTest
public class InvoiceEmailSenderTest {

    @IsTest
    public static void testInvoiceEmailWithLinkedMRSheet() {
        System.debug('Starting testInvoiceEmailWithLinkedMRSheet test.');

        TriggerActive__c customSetting = new TriggerActive__c();
        customSetting.IsActive__c = false;
        customSetting.Name = 'TurnOff';
        insert customSetting;

        ControlFetch__c controlFetch = new ControlFetch__c();
        controlFetch.Name = 'Lead Creation';
        controlFetch.isEnable__c = true; 
        insert controlFetch;

        ControlFetch__c sysAdminSetting = new ControlFetch__c();
        sysAdminSetting.Name = 'System Admin id';
        sysAdminSetting.TechnicianId__c = UserInfo.getUserId(); 
        insert sysAdminSetting;

        PriceBook2 pb = new PriceBook2(Id = Test.getStandardPricebookId(), IsActive = true);
        update pb;

        Warehouse__c warehouse = new Warehouse__c();
        warehouse.Name = 'Test Warehouse';
        warehouse.default__c = true;
        insert warehouse;

        Engineer__c engineer = new Engineer__c(Name = 'John Doe');
        insert engineer;

        Account site = new Account(
            Name = 'Test Site',
            Account_Status__c = 'Active',
            Customer_Type__c = 'New'
        );
        insert site;

        Contact customerContact = new Contact(
            LastName = 'Doe',
            AccountId = site.Id,
            CurrencyIsoCode = 'USD'
        );
        insert customerContact;

        SiteContracts__c siteContract = new SiteContracts__c(
            Customer__c = site.Id, 
            CurrencyIsoCode = 'USD',
            AM_Status__c = 'Active',
            Number_of_Services__c = 5,
            Price_Book__c = pb.Id
        );
        insert siteContract;

        Visits__c visit = new Visits__c(
            Site__c = site.Id,
            Engineer2__c = engineer.Id,
            Visit_Type__c = 'Initial',
            Actual_Service_Date__c = Date.today(),
            CurrencyIsoCode = 'USD',
            Site_Contract__c = siteContract.Id,
            Customer_Contact__c = customerContact.Id  
        );
        insert visit;

        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity for Invoice',
            StageName = 'Prospecting',
            CloseDate = Date.today(),
            AccountId = site.Id,
            Sales_Type__c = 'Service',
            Approval_status__c = 'Approved',
            InvoiceEmailTo__c = 'test@example.com',
            HQ_Invoice_Email_To__c = 'hq@example.com',
            CurrencyIsoCode = 'USD',
            Site_Contract__c = siteContract.Id,
            Shipping_Contact__c = customerContact.Id
        );
        insert opp;

        Service_Sheet_STD__c mrSheet = new Service_Sheet_STD__c(
            Order_Date__c = Date.today(),
            Technician__c = engineer.Id,
            Site__c = site.Id,
            CurrencyIsoCode = 'USD',
            All_parts_used_noted_above__c = 'Yes',
            Re_Visit_Required__c = 'No',
            Start_Date_and_Time__c = System.now(),
            Fire_Extinguisher_Service_complete__c = false, 
            Comments_to_Sales__c = 'Sample comment',
            Lead_URL__c = null,
            Site_Contract__c = siteContract.Id
        );
        insert mrSheet;

        Linked_Maintenance_Sheet__c linkedSheet = new Linked_Maintenance_Sheet__c(
            Opportunity__c = opp.Id, 
            Maintenance_Reactive_Sheet__c = mrSheet.Id
        );
        insert linkedSheet;

        List<InvoiceEmailSender.Request> requests = new List<InvoiceEmailSender.Request>();
        InvoiceEmailSender.Request request = new InvoiceEmailSender.Request();
        request.primaryOpportunityId = opp.Id;
        requests.add(request);

        Test.startTest();
        InvoiceEmailSender.sendInvoiceEmail(requests);
        Test.stopTest();

        List<EmailMessage> emails = [SELECT Id, Subject FROM EmailMessage WHERE Subject = 'Invoice' LIMIT 1];
    }

    @IsTest
    public static void testInvoiceEmailWithMergedMRSHeets() {
        System.debug('Starting testInvoiceEmailWithMergedMRSHeets test.');

        TriggerActive__c customSetting = new TriggerActive__c();
        customSetting.IsActive__c = false;
        customSetting.Name = 'TurnOff';
        insert customSetting;

        ControlFetch__c controlFetch = new ControlFetch__c();
        controlFetch.Name = 'Lead Creation';
        controlFetch.isEnable__c = true; 
        insert controlFetch;

        ControlFetch__c sysAdminSetting = new ControlFetch__c();
        sysAdminSetting.Name = 'System Admin id';
        sysAdminSetting.TechnicianId__c = UserInfo.getUserId(); 
        insert sysAdminSetting;

        PriceBook2 pb = new PriceBook2(Id = Test.getStandardPricebookId(), IsActive = true);
        update pb;

        Warehouse__c warehouse = new Warehouse__c();
        warehouse.Name = 'Test Warehouse';
        warehouse.default__c = true;
        insert warehouse;

        Engineer__c engineer = new Engineer__c(Name = 'John Doe');
        insert engineer;

        Account site = new Account(
            Name = 'Test Site',
            Account_Status__c = 'Active',
            Customer_Type__c = 'New'
        );
        insert site;

        Contact customerContact = new Contact(
            LastName = 'Doe',
            AccountId = site.Id,
            CurrencyIsoCode = 'USD'
        );
        insert customerContact;

        SiteContracts__c siteContract = new SiteContracts__c(
            Customer__c = site.Id, 
            CurrencyIsoCode = 'USD',
            AM_Status__c = 'Active',
            Number_of_Services__c = 5,
            Price_Book__c = pb.Id
        );
        insert siteContract;

        Visits__c visit = new Visits__c(
            Site__c = site.Id,
            Engineer2__c = engineer.Id,
            Visit_Type__c = 'Initial',
            Actual_Service_Date__c = Date.today(),
            CurrencyIsoCode = 'USD',
            Site_Contract__c = siteContract.Id,
            Customer_Contact__c = customerContact.Id  
        );
        insert visit;

        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity for Merged Sheets',
            StageName = 'Prospecting',
            CloseDate = Date.today(),
            AccountId = site.Id,
            Sales_Type__c = 'Service',
            Approval_status__c = 'Approved',
            InvoiceEmailTo__c = 'test@example.com',
            HQ_Invoice_Email_To__c = 'hq@example.com',
            CurrencyIsoCode = 'USD',
            Site_Contract__c = siteContract.Id,
            Shipping_Contact__c = customerContact.Id
        );
        insert opp;

        List<Service_Sheet_STD__c> mrSheets = new List<Service_Sheet_STD__c>();
        for (Integer i = 0; i < 2; i++) {
            mrSheets.add(new Service_Sheet_STD__c(
                Order_Date__c = Date.today(),
                Technician__c = engineer.Id,
                Site__c = site.Id,
                CurrencyIsoCode = 'USD',
                All_parts_used_noted_above__c = 'Yes',
                Re_Visit_Required__c = 'No',
                Start_Date_and_Time__c = System.now(),
                Fire_Extinguisher_Service_complete__c = false, 
                Comments_to_Sales__c = 'Sample comment ' + i,
                Lead_URL__c = null,
                Site_Contract__c = siteContract.Id
            ));
        }
        insert mrSheets;

        List<Linked_Maintenance_Sheet__c> linkedSheets = new List<Linked_Maintenance_Sheet__c>();
        for (Service_Sheet_STD__c sheet : mrSheets) {
            linkedSheets.add(new Linked_Maintenance_Sheet__c(
                Opportunity__c = opp.Id, 
                Maintenance_Reactive_Sheet__c = sheet.Id
            ));
        }
        insert linkedSheets;

        List<InvoiceEmailSender.Request> requests = new List<InvoiceEmailSender.Request>();
        InvoiceEmailSender.Request request = new InvoiceEmailSender.Request();
        request.primaryOpportunityId = opp.Id;
        requests.add(request);

        Test.startTest();
        InvoiceEmailSender.sendInvoiceEmail(requests);
        Test.stopTest();

        List<EmailMessage> emails = [SELECT Id, Subject FROM EmailMessage WHERE Subject = 'Invoice' LIMIT 1];
    }
}