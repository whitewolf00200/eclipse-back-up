@isTest(seeAlldata=true)
Public Class UpdateSheetsPartsTest{
     @isTest Public static void UpdateSheetsPartsMethod() {  
        
        Id CustomerId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Id SiteId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        
         Account Pacc = new Account();
         Pacc.Name='Test Customer';
         Pacc.RecordTypeId=CustomerId;
         Pacc.Customer_type__c='Others';
         insert Pacc;
         
         Account newAccount =new Account();
         newAccount.Name='Test Site';
         newAccount.Price_Book__c=Test.getStandardPricebookId();
         newAccount.RecordTypeId=SiteId;
         newAccount.Parent=Pacc;
         newAccount.Customer_type__c='Others';
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
         t_siteContract.Customer__c=Pacc.id;
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
         
         PricebookEntry priceBookEntryNew = new PricebookEntry();
         Product2 product = new Product2(); 
        
        Id pb2= Test.getStandardPricebookId();
        
        product.name = 'Test';
        product.ProductCode='Test';
        product.Nominal_Code__c='Test';
        product.IsActive=true;
        insert product;
        
        priceBookEntryNew.Product2Id = product.Id;
        priceBookEntryNew.PriceBook2Id = pb2;
        priceBookEntryNew.UnitPrice = 20.00;
        priceBookEntryNew.isactive = true;
        insert priceBookEntryNew;
        
         Warehouse__c wh=new Warehouse__c();
         wh.name='Test Warehouse';
         insert wh;
        
         Required_Parts__c Req=new Required_Parts__c();
         Req.Product_Name__c=product.id;
         Req.Quantity__c=1;
         Req.Service_Sheet__c=ec.id;
         Req.Unit_Price__c=12;
         Req.Warehouse__c=wh.id;
         insert Req;
         
         Test.Starttest();
         UpdateSheetsParts  obj = new UpdateSheetsParts (new ApexPages.StandardController(ec));
         obj.addToShoppingCart();
         obj.removeFromShoppingCart();
         obj.onSave();
         obj.onCancel();
    
     }
     @isTest Public static void UpdateSheetsPartsMethod1() {  
        
        Id CustomerId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Id SiteId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        
         Account Pacc = new Account();
         Pacc.Name='Test Customer';
         Pacc.RecordTypeId=CustomerId;
         Pacc.Customer_Type__c='Others';
         insert Pacc;
         
         Account newAccount =new Account();
         newAccount.Name='Test Site';
         newAccount.Price_Book__c=Test.getStandardPricebookId();
         newAccount.RecordTypeId=SiteId;
         newAccount.Parent=Pacc;
         newAccount.Customer_Type__c='Others';
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
         t_siteContract.Customer__c=Pacc.id;
         insert t_siteContract;
         
         Visits__c t_visit= new Visits__c();
         t_visit.site__c=newAccount.id;
         t_visit.site_Contract__c=t_siteContract.id;
         t_visit.Engineer2__c=tmp_technician.id;
         t_visit.Service_Type__c='Testing';
         t_visit.Actual_Service_Date__c=System.Today();
         insert t_visit;
         
         Service_Sheet_STD__c ec = new Service_Sheet_STD__c();
         ec.Technician__c= tmp_technician.id;
         ec.Visit__c = t_visit.id;
         ec.Arrive__c=system.now();
         ec.Re_Visit_Required__c='No';
         ec.Site__c=t_visit.site__c;
         ec.Site_Contract__c = t_siteContract.id;
         ec.Fire_Extinguisher_Service_complete__c= false;
         ec.Order_Date__c=system.today();
         insert ec;   
         
         PricebookEntry priceBookEntryNew = new PricebookEntry();
         Product2 product = new Product2(); 
        
        Id pb2= Test.getStandardPricebookId();
        
        product.name = 'Test';
        product.ProductCode='Test';
        product.Nominal_Code__c='Test';
        product.IsActive=true;
        insert product;
        
        priceBookEntryNew.Product2Id = product.Id;
        priceBookEntryNew.PriceBook2Id = pb2;
        priceBookEntryNew.UnitPrice = 20.00;
        priceBookEntryNew.isactive = true;
        insert priceBookEntryNew;
        
        Warehouse__c wh=new Warehouse__c();
         wh.name='Test Warehouse';
         insert wh;
    
        
         Required_Parts__c Req=new Required_Parts__c();
         Req.Product_Name__c=product.id;
         Req.Quantity__c=1;
         Req.Maintenance_Reactive_Sheet__c=ec.id;
         Req.Unit_Price__c=12;
         Req.Warehouse__c=wh.id;
         insert Req;
         
         Test.Starttest();
         UpdateSheetsParts  obj = new UpdateSheetsParts (new ApexPages.StandardController(ec));
         obj.addToShoppingCart();
         obj.removeFromShoppingCart();
         obj.onSave();
         obj.onCancel();
    
     }
}