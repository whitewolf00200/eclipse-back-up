@isTest(seeAllData=true)
/*============================================================================================================
*Class Name     : InsertPartControllerTest
*Description    : All the implementations related to test InsertPartController.
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 25th Jun, 2020
*Version        : 1.0
*Change History : Initial class
*Methods        : public static @isTest void m1() 
                  public static @isTest void m2(){                 
*============================================================================================================*/
public class InsertPartControllerTest{
    
    static Id PSPBId = Schema.SObjectType.Engineer_Checklist__c.getRecordTypeInfosByName().get('Suction Pump Service').getRecordTypeId();
    static Id merId = Schema.SObjectType.Engineer_Checklist__c.getRecordTypeInfosByName().get('Mechanical X-Ray Report').getRecordTypeId();
/*====================================================
*Method Name     : m1
*Description     : This method test InsertPartController class.
*Arguments       : No Arguments
*Ticket No       : 40744
====================================================*/
   public static @isTest void m1(){
         
          
          //get standard pricebook
          Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];

          
          Product2 prod=new Product2();
          prod.name='Test';
          prod.isActive=true;
          prod.productcode='Test';
          insert prod;
          
          PricebookEntry pbe1 = new PricebookEntry (Product2ID=prod.id,Pricebook2ID=standardPb.id,UnitPrice=50, isActive=true);
          insert pbe1;
         
         Account newAccount=new Account();
         newAccount.Name = 'Test Account';
         newAccount.Account_Status__c='Live';
         newAccount.Customer_type__c='Others';
         newAccount.recordtypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
         insert newAccount;
       
         Contact cn=new Contact();
         cn.LastName='test';
		 cn.accountId=newAccount.Id;
         insert cn; 
         
         Engineer__c tmp_technician = new Engineer__c();
         tmp_technician.name='Test';
         tmp_technician.Active_User__c='Yes';
         tmp_technician.Disciplines__c='FE';
         tmp_technician.Target__c=0;
         tmp_technician.Technician_Group__c='North East';
         tmp_technician.Third_Party_Technician__c=false;
         tmp_technician.Engineer_ID__c='1234';
         tmp_technician.Mobile_Phone__c='99999 999999';
         insert tmp_technician;
         
         SiteContracts__c t_siteContract= new SiteContracts__c();
         t_siteContract.Number_of_Services__c=1;
         t_siteContract.Due__c='Test';
         t_siteContract.Visit_Rescheduling__c='On Schedule';
         t_siteContract.site__c=newAccount.id;
         t_siteContract.Customer__C=newAccount.id;
         insert t_siteContract;
          
          Asset ass= new Asset();
          ass.name='test assest';
          ass.Accountid=newAccount.id;
          ass.Site_Contract__c=t_siteContract.id;
          insert ass;
          
         Visits__c t_visit = new Visits__c();
         t_visit.site__c=newAccount.id;
         t_visit.site_Contract__c=t_siteContract.id;
         t_visit.Asset__c=ass.id;
         t_visit.Engineer2__c=tmp_technician.id;
         t_visit.Visit_Type__c='Service';
         t_visit.Customer_Contact__c=cn.id;
         t_visit.Service_Type__c ='Fire Alarm';
         
         t_visit.Actual_Service_Date__c=System.Today();
         insert t_visit; 
         
         Warehouse__c WH=new Warehouse__c();
        WH.Name='Test';
        wh.default__c=true;
        insert WH;
 
        
        Service_Sheet_STD__c newRASheet=new Service_Sheet_STD__c();  
        newRASheet.Technician__c=tmp_technician.id;        
        newRASheet.Site_Contract__c=t_siteContract.id;                                 
        newRASheet.Visit__c=t_visit.id; 
        newRASheet.site__c=newAccount.id;
        newRASheet.Email_Confirmation_To__c='commercial.reception@hentland.com';
        newRASheet.Return_Visit_Reason__c='Testing';
        newRASheet.Re_Visit_Required__c='No';
        newRASheet.Maintenance_Type__c = t_visit.Service_Type__c; 
        newRASheet.System_Type__c= t_visit.Service_Type__c; 
        NewRASheet.Start_Date_and_Time__c =System.now();
        NewRASheet.End_Date_and_Time__c = System.now()+0.3;
        NewRASheet.Order_No__c='123';
        newRASheet.Serial_Number__c='123';
        newRASheet.Make__c='123';
        newRASheet.Model__c='123';
        
        insert newRASheet;
        
       PageReference pageref=Page.MRScanner;
          Test.setCurrentPage(pageRef);
          
          ApexPages.StandardController conts=new ApexPages.StandardController(newRASheet); 
          InsertPartController controller=new InsertPartController(conts);
          controller.code=Apexpages.currentPage().getParameters().put('myParam','test');
          controller.verifyCode();
          controller.prdcode='test';
          controller.selectedWH=WH.id;
          controller.count=2;
          InsertPartController.checkAvailibility('test');
          controller.SheetId=newRASheet.Id;
          controller.onSave();
          Controller.onCancel();
          controller.pageRedirector();  
   }
    
/*====================================================
*Method Name     : m2
*Description     : This method test InsertPartController class.
*Arguments       : No Arguments
*Ticket No       : 40744
====================================================*/
/*
    public static @isTest void m2(){
        
       Id CustomerId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Id SiteId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        Id opId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Invoice (Sheets)').getRecordTypeId();
		
		RecursiveHandler.runOnce1();
		RecursiveHandler.runVT_UOPPOnce();
       
        
        PriceBook2 pb = New PriceBook2(Id = test.getStandardPricebookId(), isActive = true);
        update pb;
        
        Account Pacc = new Account();
        Pacc.Name='Test Customer';
        Pacc.Customer_type__c='Private Healthcare';
        Pacc.RecordTypeId=CustomerId;
        insert Pacc;
		
 		Warehouse__c WH=new Warehouse__c();
        WH.Name='Test';
        WH.default__c=true;
        insert WH;
        
		Account newAccount =new Account();
        newAccount.Name='Test Site';
        newAccount.Price_Book__c=Test.getStandardPricebookId();
        newAccount.Account_Status__c='Live';
        newAccount.RecordTypeId=SiteId;
        newAccount.Customer_type__c='Private Healthcare';
        //newAccount.Site_Contact__c=cn.id;
        newAccount.Survey_Required__c=false;
        newAccount.Parent=Pacc;
        insert newAccount;
		
		Contact cn=new Contact();
        cn.LastName='test';
		cn.accountId=newAccount.Id;
        insert cn; 
		
        //SiteContracts 
        SiteContracts__c si=new SiteContracts__c();
        si.Site__c=newAccount.id;
        si.Visit_Rescheduling__c='Pre-Scheduled';
        si.Number_of_Services__c=2;
        si.Price_book__c=pb.id;
        si.AM_Status__c='Live';
        si.Price_Book__c=Test.getStandardPricebookId();
        si.Due__c='march'; 
        si.Customer__c=Pacc.id;   
        insert si;
        
        Engineer__c tmp_technician = new Engineer__c();
        tmp_technician.Name='Test Engineer';
        tmp_technician.Mobile_Phone__c ='98989 898989';
        tmp_technician.Technician_Group__c='Contractor';
        insert tmp_technician;
                
        product2 prd=new product2(Name='Test Product');
        prd.Type__c='Dry Pump';
        prd.ProductCode='test';
        prd.IsActive = true;
        prd.Cost__c=1000;
        insert prd;
        
        PricebookEntry sp = new PricebookEntry();
        sp.Pricebook2Id = pb.Id;
        sp.Product2Id = prd.Id;
        sp.UnitPrice = 10000; 
        sp.IsActive = true;
        //insert sp;
        
        Asset ass= new Asset();
        ass.name='test';
        ass.Accountid=newAccount.id;
        ass.Product2Id=prd.id;
        ass.Annual_Service_Due_Date__c = System.today();
        ass.Location__c='test';
        ass.Make__c='test';
        ass.Model__c='test';   
        ass.Date_Of_Manufacture__c =System.today(); 
        ass.SerialNumber='123';   
        ass.Site_Contract__c=si.id;
        insert ass;
        
        Visits__c t_visit= new Visits__c();
        t_visit.site__c=newAccount.id;
        t_visit.site_Contract__c=si.id;
        t_visit.Engineer2__c=tmp_technician.id;
        t_visit.Service_Type__c='Testing';
        t_visit.asset__c=ass.id;
        t_visit.Customer_Contact__c=cn.id;
        t_visit.Actual_Service_Date__c=System.Today();
        insert t_visit;
        
        Lead NewLead1 = new Lead();
        
        NewLead1.FirstName    = 'Technician_recommendations';
        NewLead1.LastName     = 'Servicesheet_Lead';
        NewLead1.Company      = 'WaterWeels';
        NewLead1.Description  = 'Tested by Merfantz Technologies';
        NewLead1.LeadSource   = 'Technician Onsite';
        NewLead1.Status       = 'Pending - Other';
        //insert NewLead1;
        
        PartsConfig__c par=new PartsConfig__c();
        par.Service_Type__c = 'Mechanical X-Ray Report ';
        par.Product_Name__c=prd.id;
        par.Call_out__c=false;
        par.Reactive__c=false;
        par.Parking__c=false;
        par.isDefaultProduct__c=false;
        insert par;
        
		PartsConfig__c Part = new PartsConfig__c();
        Part.isDefaultProduct__c	=true;
        Part.Service_Type__c='All Service';
        insert Part;  
        
        Engineer_Checklist__c ec1 = new Engineer_Checklist__c();
        ec1.Engineer__c = tmp_technician.id;
        ec1.recordtypeid=merId;
        ec1.Date_Of_System_Manufacture__c=system.today();
        ec1.Room_Name__c='test1';   
        ec1.Tube_No__c='test';
        ec1.Visit__c = t_visit.id;
        ec1.Site__c=t_visit.site__c;
        ec1.Purchase_Order_Number__c='test';
        ec1.Site_Contract__c = si.id;
        //ec1.Actual_Service_date__c=System.Now();
        ec1.Start_Date_and_Time__c = System.Now();
        ec1.End_Date_and_Time__c = System.Now()+1;
        ec1.Start_Travel_Time__c=System.Now();
        ec1.End_Travel_Time__c=System.Now()+1;
        ec1.Email_Confirmation_to__c ='test@merfantz.com';
        ec1.Fire_Extinguisher_Service_complete__c = false;
        insert ec1;   
        
		//ec1.Fire_Extinguisher_Service_complete__c=true;
        //ec1.Close_Visit__c='yes';
        //ec1.Congestion_Charge__c=100;
        //ec1.Parking_Costs__c=75;
        //update ec1;
		
        //t_visit.Visit_Complete__c=true;
        //t_visit.Visit_Completed__c=system.Now();
        
        //update  t_visit;
        
        Required_Parts__c Req=new Required_Parts__c();
        Req.Product_Name__c=prd.id;
        Req.Service_Sheet__c=ec1.id;
        Req.Quantity__c=2;
        Req.Include_Invoice__c=true;
        Req.Warehouse__c=WH.id;
        insert Req;
                
        //Campaingn
        Campaign ca=new Campaign();
        ca.Name='test';
        //insert ca;
        
        Opportunity op=new Opportunity();
        op.recordtypeid=opId;
        op.Name='test';
        op.Service_Sheet__c=ec1.id;
        op.Purchase_order_number2__c='1234';
        op.CloseDate=system.today()+5;
        op.StageName='Qualification';
        op.AccountID =newAccount.id;
        op.CampaignID=ca.id;
        //insert op; 	
		
		Inventory__c Inv=new Inventory__c();
		Inv.Warehouse__c=WH.id;
		Inv.Product__c=prd.id;
		insert Inv;
        
        PageReference pageref=Page.SSScanner;
          Test.setCurrentPage(pageRef);
          
            ApexPages.StandardController cont=new ApexPages.StandardController(ec1); 
            InsertPartController controller=new InsertPartController(cont);
            controller.selectedWH=WH.id;
            controller.verifyCode();
            controller.count=0;
            controller.code=Apexpages.currentPage().getParameters().put('myParam','test');
            controller.SheetId=ec1.id;
            controller.prdcode='test';
            InsertPartController.checkAvailibility('');  
            controller.onSave();
            Controller.onCancel();
          
          controller.pageRedirector();   }*/
}