@isTest
private class ServiceSheetTriggerHandler_Test{
    
    static Id PSPBId = Schema.SObjectType.Engineer_Checklist__c.getRecordTypeInfosByName().get('Suction Pump Service').getRecordTypeId();
    static Id merId = Schema.SObjectType.Engineer_Checklist__c.getRecordTypeInfosByName().get('Mechanical X-Ray Report').getRecordTypeId();
	
	@testSetup static void testDataSetup(){
		Id CustomerId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Id SiteId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        Id opId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Invoice (Sheets)').getRecordTypeId();
		
		RecursiveHandler.runOnce1();
		RecursiveHandler.runVT_UOPPOnce();
        
        
        TriggerActive__c customsetting = new TriggerActive__c();
        customsetting.IsActive__c =false;
        customsetting.Name ='TurnOff';
        Insert customsetting;
        
		List<ControlFetch__c> contFetchLst = new List<ControlFetch__c>();
        //Custom Setting ControlFetch - Record name: 'Lead Creation'
        ControlFetch__c con=new ControlFetch__c();
        con.name='Lead Creation';
        con.isEnable__c=true;
        contFetchLst.add(con);
        
        //Custom Setting ControlFetch - Record name: 'System Admin id'
        ControlFetch__c con1=new ControlFetch__c();
        con1.name='System Admin id';
        con1.TechnicianId__c='00558000000fdRW';
        contFetchLst.add(con1);   
        
        //Custom Setting ControlFetch - Record name: 'Parts Used Condition'
        ControlFetch__c con2=new ControlFetch__c();
        con2.name='Parts Used Condition'; 
        con2.Flag__c=true;
        contFetchLst.add(con2);
		
		ControlFetch__c con3=new ControlFetch__c();
        con3.name='Inventory check'; 
        con3.Flag__c=true;
        contFetchLst.add(con3);

		insert contFetchLst;
        
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
        insert sp;
        
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
        ec1.Make__c='testing';
        ec1.Model__c='testing';
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

	}
    
    static testmethod void techRecommendationToLeadCreationTest(){
        
        
        TriggerActive__c customsetting = new TriggerActive__c();
        customsetting.IsActive__c =false;
        customsetting.Name ='TurnOff';
        Insert customsetting;
        		
       Engineer_Checklist__c eng =  [SELECT Id FROM Engineer_Checklist__c LIMIT 1];
	   Engineer_Checklist__c ec1 = new Engineer_Checklist__c();
		
		ec1.Fire_Extinguisher_Service_complete__c = TRUE;
		ec1.Close_Visit__c='yes';
		ec1.Congestion_Charge__c=100;
        ec1.Parking_Costs__c=75;
		ec1.Id = eng.Id;
        
        Contact c1= [select id from contact LIMIT 1];
        Contact c2= new Contact();
        c2.LastName='test';
        c2.Id=c1.Id;
		//cn.accountId=newAccount.Id;
         
		Visits__c t_visit= [select Id from Visits__c LIMIT 1];
        Visits__c v1= new Visits__c();
        v1.Visit_Complete__c=true;
        v1.Visit_Completed__c=system.today()+1;
        v1.Id=t_visit.Id;
        v1.Last_Submitted_Service_Sheet__c=null;
        v1.Customer_Contact__c=c1.Id;
        
        SiteContracts__c s1=[select id from SiteContracts__c LIMIT 1];
        SiteContracts__c s2=New SiteContracts__c();
        s2.Id=s1.Id;
        s2.Visit_Rescheduling__c='Pre-Scheduled';
        
        
        
        Test.StartTest(); 
		update ec1;		
        //insert NewLead;
	    update  v1;
        update s2;
        
        Test.StopTest(); 
    } 

}