@isTest(seeAlldata=true)
Public Class ReactiveSheetTriggerHandlerTest{

      public static testmethod void TestMethode(){
         Warehouse__c whhh=[Select id,name from Warehouse__c where default__c=true limit 1];
         Account newAccount =[select id,name, Account_Status__c from account limit 1];
//         newAccount.Name = 'Test Account';
  //       newAccount.Account_Status__c='Live';
    //     insert newAccount;
    //     
        Account a = new Account();
        a.Name='Test Customer';
        a.Customer_type__c='others';
        a.Survey_required__c=false;
        a.account_status__c='Live';
        a.Region__c='BN Zone D';
        insert a;
          
          
        Account a2 = new Account();
        a2.Name='Test site';
        a2.Customer_type__c='others';
        a2.parentid=a.id;
        a2.recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        a2.Survey_required__c=false;
        a2.Account_Status__c='Live';
        insert a2;
        
        Contact co = new Contact();
        co.LastName = 'test';
        co.CurrencyIsoCode = 'EUR';
        co.AccountId = a2.id;
        insert co;
        system.debug('contact======='+ co);
         
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
         
          //  Visits__c t_visit=  [select id, Actual_Service_Date__c,  site_Contract__c, Engineer2__c, Service_Type__c from Visits__c where site__c=:newAccount.id and Visit_Type__c='Service' limit 1];  //new Visits__c();
     Visits__c t_visit = new Visits__c();
        t_visit.Customer_Contact__c = co.id ;
        t_visit.Site__c=a2.id;
        t_visit.CurrencyIsoCode = 'EUR';
        t_visit.Site_Contract__c=t_siteContract.id;
        t_visit.Engineer2__c=tmp_technician.id;
        t_visit.Service_Type__c ='Storm Water Pump';
        t_visit.End_Date_Time__c=system.today();
        t_visit.Order_Value__c=2000;
       // t_visit.Asset__c=ass.id;
        t_visit.Booked_with_Customers__c='Yes';
        t_visit.Actual_Service_Date__c=system.today();
        t_visit.Visit_Type__c='Service';
          
        insert t_visit;
         System.runAs ( new User(Id = UserInfo.getUserId()) ) {
           BusinessHours defaultBH = [Select Id From BusinessHours Where IsDefault = True];
            Holiday hol = new Holiday();
            hol.Name='Test holiday';
            hol.activitydate = System.Today();
            insert hol;
           }
        Product2 Prd=new Product2();
        Prd.Name='Test Product';
        Prd.isActive=true;
        insert Prd;

        PartsConfig__c Part = new PartsConfig__c();
        Part.Product_Name__c=Prd.id;
        Part.isDefaultProduct__c	=false;
        Part.Service_Type__c='Reactive Sheet';
        insert Part;        

        Warehouse__c WH=new Warehouse__c();
        WH.Name='Test';
        WH.default__c=true;
        insert WH;
        
        Inventory__c inv=new Inventory__c();
    inv.Warehouse__c=WH.id;
    inv.Product__c=prd.id;
    insert inv;
    
    Inventory_Transaction__c invtr=new Inventory_Transaction__c();
    invtr.name=inv.name;
    invtr.qty__c=3;
    invtr.Inventory__c=inv.id;
    invtr.Transaction_Type__c='Received';
    insert invtr;

        Service_Sheet_STD__c newRASheet=new Service_Sheet_STD__c();  
        newRASheet.Technician__c=tmp_technician.id;        /*******Modified by Puthuvannam*******/
        newRASheet.Site_Contract__c=t_siteContract.id;     /*******Modified by Puthuvannam*******/                             
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
          newRASheet.CurrencyIsoCode='USD';
        newRASheet.Order_Date__c=system.today();
        newRASheet.All_parts_used_noted_above__c='Yes';
        insert newRASheet;  
        
         
       
        
        Required_Parts__c rp=new Required_Parts__c();
        rp.Warehouse__c=wh.id;
        rp.Product_Name__c=prd.id;
        rp.Quantity__c=2;
        rp.Maintenance_Reactive_Sheet__c=newRASheet.id;
        insert rp;

           Opportunity opp= new Opportunity();
          opp.Name='testname';
          opp.AccountId=newAccount.id;
          opp.Reactive_Sheet__c=newRASheet.id;
          opp.StageName='Closed Won';
          opp.CloseDate=System.Today();
          opp.Site_Visit_Time__c='test';
          insert opp; 
       
        Test.startTest();

        newRASheet.Serial_Number__c='1223';
            newRASheet.Make__c='1253';
            newRASheet.Model__c='1223';
            newRASheet.Arrive__c=date.valueof('2018-12-1');
       NewRASheet.Lead_URL__c=null;
        NewRASheet.Close_Visit__c='Yes';
        NewRASheet.Order_No__c='123654';
       NewRASheet.Comments_to_Sales__c ='Yes';
        NewRASheet.Start_Date_and_Time__c =System.now()+1;
        NewRASheet.End_Date_and_Time__c = System.now()+3;
        NewRASheet.Parking_Costs__c=10;
        NewRASheet.Fire_Extinguisher_Service_complete__c=True ;
        update newRASheet;        

        NewRASheet.Fire_Extinguisher_Service_complete__c=false;
        update newRASheet;
        
     
      
              
      
        //ReactiveSheetTriggerHandler RST= new ReactiveSheetTriggerHandler();
        
       
        

Test.StopTest();
} 
     
}