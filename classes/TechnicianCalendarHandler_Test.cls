@isTest(seealldata=true)
private class TechnicianCalendarHandler_Test {
    
    
    public static Account newAccount;
    public static Account newAccount1;
    public static Engineer__c tmp_technician;
    public static SiteContracts__c t_siteContract;
    public static Visits__c t_visit;
    
    public static testMethod void inserTestRecord(){
         /*Holiday hol = new Holiday();
         hol.Name='Test holiday';
         hol.activitydate = System.Today();
         insert hol;*/
         
         newAccount =new Account();
         newAccount.Name='Test Account';
         insert newAccount;
         
         newAccount1 =new Account();
         newAccount1.Name='Holidays';
         insert newAccount1;
         
         tmp_technician = new Engineer__c();
         tmp_technician.Name='Test Engineer';
         tmp_technician.Mobile_Phone__c='99999 999999';
         tmp_technician.Active_User__c='Yes';
         //tmp_technician.Start_Date_Long__c= '20/09/2015;2/09/2015';
         //tmp_technician.End_Date_Long__c   = '21/09/2015;12/09/2015';
         //tmp_technician.Cost_per_Hour__c = 1;
         tmp_technician.Target__c = 1;
         tmp_technician.Engineer_ID__c = 'test'; 
         //tmp_technician.Discipline_Group__c = 'Electrical';
         insert tmp_technician;
         
         t_siteContract= new SiteContracts__c();
         t_siteContract.site__c=newAccount.id;
         t_siteContract.Job_Time__c =10;
         t_siteContract.Number_of_Services__c =1;
         t_siteContract.Visit_Rescheduling__c = 'On Visit';
         insert t_siteContract;
         
         t_visit=new Visits__c(); 
         t_visit.site__c=newAccount.id;
         t_visit.site_Contract__c=t_siteContract.id;
         t_visit.Actual_Service_Date__c = date.today();
         t_visit.Engineer2__c=tmp_technician.id;
         t_visit.Service_Type__c='Testing';
         t_visit.Visit_Type__c='Small Works';
         t_visit.Order_Value__c=10;
         insert t_visit;
         
         t_visit=new Visits__c(); 
         t_visit.site__c=newAccount.id;
         t_visit.site_Contract__c=t_siteContract.id;
         t_visit.Actual_Service_Date__c = date.today();
         t_visit.Engineer2__c=tmp_technician.id;
         t_visit.Service_Type__c='Testing';
         t_visit.End_Date__c=null;
         t_visit.Visit_Type__c='Small Works';
         t_visit.Order_Value__c=10;
         
         t_visit=new Visits__c(); 
         t_visit.site__c=newAccount.id;
         t_visit.site_Contract__c=t_siteContract.id;
         t_visit.Booked_with_Customers__c='Yes';
         t_visit.Actual_Service_Date__c = date.today();
         t_visit.Engineer2__c=tmp_technician.id;
         t_visit.Service_Type__c='Testing';
         t_visit.Visit_Type__c='Small Works';
         t_visit.Order_Value__c=10;
         
         t_visit=new Visits__c(); 
         t_visit.site__c=newAccount.id;
         t_visit.site_Contract__c=t_siteContract.id;
         t_visit.Actual_Service_Date__c = date.today();
         t_visit.Engineer2__c=tmp_technician.id;
         t_visit.Service_Type__c='Testing';
         t_visit.End_Date__c=date.today();
         t_visit.Visit_Type__c='Small Works';
         t_visit.Order_Value__c=10;
         
         t_visit=new Visits__c(); 
         t_visit.site__c=newAccount.id;
         t_visit.site_Contract__c=t_siteContract.id;
         t_visit.Actual_Service_Date__c = date.today();
         t_visit.Engineer2__c=tmp_technician.id;
         t_visit.Service_Type__c='Testing';
         t_visit.Service_Sheet_Number__c='1000';
         t_visit.Visit_Complete__c=true;
         t_visit.Visit_Type__c='Small Works';
         t_visit.Order_Value__c=10;
         
         t_visit=new Visits__c(); 
         t_visit.site__c=newAccount.id;
         t_visit.site_Contract__c=t_siteContract.id;
         t_visit.Booked_with_Customers__c='Yes';
         t_visit.Actual_Service_Date__c = date.today()+1;
         t_visit.Engineer2__c=tmp_technician.id;
         t_visit.Service_Type__c='Testing';
         t_visit.Visit_Complete__c=false;
         t_visit.Visit_Type__c='Small Works';
         t_visit.Order_Value__c=10;
         
         t_visit=new Visits__c(); 
         t_visit.site__c=newAccount.id;
         t_visit.site_Contract__c=t_siteContract.id;
         t_visit.Booked_with_Customers__c='Waiting P/O';
         t_visit.Actual_Service_Date__c = date.today()+1;
         t_visit.Engineer2__c=tmp_technician.id;
         t_visit.Service_Type__c='Testing';
         t_visit.Visit_Complete__c=false;
         t_visit.Visit_Type__c='Small Works';
         t_visit.Order_Value__c=10;
         
         t_visit=new Visits__c(); 
         t_visit.site__c=newAccount.id;
         t_visit.site_Contract__c=t_siteContract.id;
         t_visit.Booked_with_Customers__c='Booked Via Schedule';
         t_visit.Actual_Service_Date__c = date.today()+1;
         t_visit.Engineer2__c=tmp_technician.id;
         t_visit.Service_Type__c='Testing';
         t_visit.Visit_Complete__c=false;
         t_visit.Visit_Type__c='Small Works';
         t_visit.Order_Value__c=10;
         
         t_visit=new Visits__c(); 
         t_visit.site__c=newAccount1.id;
         t_visit.site_Contract__c=t_siteContract.id;
         t_visit.Visit_Type__c='Holiday';
         t_visit.Actual_Service_Date__c = date.today()+1;
         t_visit.Engineer2__c=tmp_technician.id;
         t_visit.Service_Type__c='Testing';
         t_visit.Visit_Complete__c=false; 
         t_visit.Visit_Type__c='Small Works';
         t_visit.Order_Value__c=10;
         
         t_visit=new Visits__c(); 
         t_visit.site__c=newAccount.id;
         t_visit.site_Contract__c=t_siteContract.id;
         t_visit.Visit_Type__c='Projects';
         t_visit.Actual_Service_Date__c = date.today()+1;
         t_visit.Engineer2__c=tmp_technician.id;
         t_visit.Service_Type__c='Testing';
         t_visit.Visit_Complete__c=false;
         t_visit.Order_Value__c=10;
         insert t_visit; 
        
        BusinessHours defaultBH = [Select Id From BusinessHours Where IsDefault = True];
         
          ApexPages.currentPage().getParameters().put('id', tmp_technician.Id); 
          
                  
          t_visit.Booked_with_Customers__c = 'Yes';
          update t_visit; 
          ApexPages.currentPage().getParameters().put('id', tmp_technician.Id); 
          
           t_visit.Booked_with_Customers__c = 'Booked Via Schedule';
          update t_visit; 
          ApexPages.currentPage().getParameters().put('id', tmp_technician.Id); 
         
          t_visit.Actual_Service_Date__c = system.today();
          update t_visit; 
          ApexPages.currentPage().getParameters().put('id', tmp_technician.Id); 
         
          
         
          ApexPages.StandardController stdController = new ApexPages.StandardController(tmp_technician);
          TechnicianCalendarHandler con= new TechnicianCalendarHandler(stdController);
          con.pageLoad();
          TechnicianCalendarHandler.UpdateVisit('2014-10-08T01:02:03', '2014-10-08T01:03:03','/'+t_visit.id);  
   }
}