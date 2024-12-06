/*============================================================================================================
*Class Name     : VisitTriggerHandlerTest
*Description    : All the implementations related to Visit Object's Triggers should be handled here
*Company        : Merfantz Technologies Pvt. Ltd
*Date           : 12th Feb, 2021
*Version        : 2.0
*Change History : Initial Trigger Handler
*Methods        : Public Class VisitTriggerHandlerTest
                  Public static void CreateServiceSheetTest()
                  CreateServiceSheetTest()
                  
*============================================================================================================*/

@isTest(seeAlldata=true)
Public Class VisitTriggerHandlerTest{
    
    static Id merId = Schema.SObjectType.Engineer_Checklist__c.getRecordTypeInfosByName().get('Mechanical X-Ray Report').getRecordTypeId();
     @isTest Public static void UpdateOrderValueTest() {  
         Visits__c visit=  [SELECT Id,Sales_Opportunity__c,Notes_from_Previous_Service__c,Order_Value__c,Customer_Contact__c FROM Visits__c where Order_Value__c=NULL AND Sales_Opportunity__c = NULL And Customer_Contact__r.id !=Null  limit 1 ];             
         Opportunity opp =[select id,amount from Opportunity where Amount=0 LIMIT 1];                
         visit.Sales_Opportunity__c=opp.id;         
         update visit;                           
         system.assertNOTEquals([SELECT id, Order_Value__c,Customer_Contact__c from Visits__c where id =:visit.id].Order_Value__c,NULL,'Order value is not updated');             
     }

    @isTest Public static void CreateServiceSheetTest() {
         
        product2 prd=new product2();
        prd.name='test';
        prd.Isactive=true;
        insert prd;
        
                  Pricebook2 standardPricebook = new Pricebook2(Name= 'Zone D Region',IsActive = true);
        
      

Account acc = new Account();
acc.Name = 'test';
acc.Price_List_Correct__c = System.today();
acc.Customer_type__c = 'Prison';
acc.Region__c = 'BN Zone D';

acc.Price_Book__c=standardPricebook.id;
insert acc;

        Contact co = new Contact();
        co.LastName = 'test';
        co.CurrencyIsoCode = 'EUR';
        co.AccountId = acc.id;
        insert co;
        system.debug('contact======='+ co);
        
        SiteContracts__c b = new SiteContracts__c();
        b.Site__c=acc.id;
        b.CurrencyIsoCode = 'EUR';
        b.AM_Status__c = 'Hold';
        b.Visit_Rescheduling__c ='On Visit';
        b.Number_of_Services__c	=3;
        b.AM_Status__c='Live';
        b.Customer__c=acc.id;
        b.Price_Book__c	=standardPricebook.id;
        insert b;
        
        system.debug('sidecontact======='+ b);
       
          Asset ass= new Asset();
        ass.name='test';
        ass.Accountid=acc.id;
        ass.Product2Id=prd.id;
        ass.Annual_Service_Due_Date__c = System.today();
        ass.Location__c='test';
        ass.Make__c='test';
        ass.Model__c='test';   
        ass.Date_Of_Manufacture__c =System.today(); 
        ass.SerialNumber='123';   
        ass.Site_Contract__c=b.id;
        ass.Booked_Date__c =System.today();
        ass.Site_Contract__c = b.Id;
        insert ass;
         
        Engineer__c c = new Engineer__c();
        c.Name='Andrew';
        c.Engineer_ID__c='3a443d2f-f632-4d30-a60b-7eda067b958b';
        c.Active_User__c='Yes';
        c.Country__c= 'Australia';
        
        insert c;
        system.debug('Engineer======='+ c); 
        
        Engineer__c c1 = new Engineer__c();
        c1.Name='Test';
        c1.Engineer_ID__c='3a443d2f-f632-4d30-a60b-7eda067b958b';
        c1.Active_User__c='Yes';
        c1.Country__c= 'Australia';
        
        insert c1;

         Visits__c vis = new Visits__c();
         vis.Customer_Contact__c = co.id ;
         vis.Site__c=acc.id;
         vis.CurrencyIsoCode = 'EUR';
         vis.Site_Contract__c=b.id;
         vis.Engineer2__c=c.id;
         vis.Service_Type__c ='Storm Water Pump';
         vis.End_Date_Time__c=system.today();
         vis.Order_Value__c=2000;
         vis.Asset__c=ass.id;
         vis.Booked_with_Customers__c='Yes';
         vis.Actual_Service_Date__c=system.today();
         vis.Visit_Type__c='Service';
         insert vis;
        
         Visits__c vist = new Visits__c();
         vist.Customer_Contact__c = co.id ;
         vist.Site__c=acc.id;
         vist.CurrencyIsoCode = 'EUR';
         vist.Site_Contract__c=b.id;
         vist.Engineer2__c=c.id;
         vist.Service_Type__c ='Storm Water Pump';
         vist.End_Date_Time__c=system.today();
         vist.Order_Value__c=2000;
         vist.Asset__c=ass.id;
         vist.Booked_with_Customers__c='Yes';
         vist.Actual_Service_Date__c=system.today();
         vist.Visit_Type__c='Service';
         insert vist;
         
          
        
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
         t_siteContract.site__c=acc.id;
         t_siteContract.Customer__C=acc.id;
         insert t_siteContract;
        
        Service_Sheet_STD__c mrsheet=new Service_Sheet_STD__c();  
        mrsheet.Technician__c=c.id;        /*******Modified by Puthuvannam*******/
        mrsheet.Site_Contract__c=b.id;     /*******Modified by Puthuvannam*******/                             
        mrsheet.Visit__c=vist.id; 
        mrsheet.site__c=acc.id;
        mrsheet.Email_Confirmation_To__c='commercial.reception@hentland.com';
        mrsheet.Return_Visit_Reason__c='Testing';
        mrsheet.Re_Visit_Required__c='No';
        mrsheet.Maintenance_Type__c = vist.Service_Type__c; 
        mrsheet.System_Type__c= vist.Service_Type__c; 
        mrsheet.Start_Date_and_Time__c =System.now();
        mrsheet.End_Date_and_Time__c = System.now()+0.3;
        mrsheet.Order_No__c='123';
        mrsheet.Serial_Number__c='123';
        mrsheet.Make__c='123';
        mrsheet.Model__c='123';
        mrsheet.CurrencyIsoCode='USD';
        mrsheet.All_parts_used_noted_above__c='Yes';
        mrsheet.Order_Date__c=system.today();
        mrsheet.All_parts_used_noted_above__c='Yes';
        insert mrsheet;
 
         
         
        vist.Engineer2__c=c1.id;
        vist.End_Date_Time__c=system.today()+3;
        vist.Asset__c=ass.id;
        vist.Actual_Service_Date__c=system.today();
        vist.Booked_with_Customers__c='Yes';
        vist.Visit_Type__c='Service';
        vist.Previous_Visit__c = vis.id;
        vist.Site_Contract__c = b.Id;
        vist.Reactive_Sheet_Number__c = mrsheet.name;
        vist.M_R_Sheet_Id__c = mrsheet.Id;
        Update vist ;
         

        ass.Booked_Date__c =vist.Actual_Service_Date__c; 
        update ass;
    }
                
}