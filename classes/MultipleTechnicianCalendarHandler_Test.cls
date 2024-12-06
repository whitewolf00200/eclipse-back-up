@isTest(SeeAllData=true)
private class MultipleTechnicianCalendarHandler_Test {
    static testMethod void CallCalendar() {
        
         Contact cc = new Contact();
         cc.LastName='Test';
         //cc.CurrencyIsoCode='';
         cc.Description='Description';
         insert cc;
        
        
         Account newAccount =new Account();
         newAccount.Name='Test Account';
         newAccount.Account_Status__c='Live';
         newAccount.Customer_type__c='OPG';
         newAccount.Contact__c=cc.Id;
         insert newAccount;
         
         
         Account newAccountH =new Account();
         newAccountH.Name='Holidays';
         newAccountH.Account_Status__c='Live';
         newAccountH.Customer_type__c='OPG';	
         newAccountH.Contact__c=cc.Id;
         insert newAccountH;
         
     
         Engineer__c tmp_technician=new Engineer__c();
         tmp_technician.Name='Test Engineer';
         tmp_technician.Active_User__c='Yes';
         tmp_technician.Technician_Group__c = 'Mel Jones';
         tmp_technician.Mobile_Phone__c='99999 999999';
         tmp_technician.Target__c  =1;
         tmp_technician.Engineer_ID__c = 'test';
         insert tmp_technician;        
         
         
         SiteContracts__c t_siteContract= new SiteContracts__c();
         t_siteContract.site__c=newAccount.id;
         t_siteContract.Number_of_Services__c = 1;
         t_siteContract.Number_of_Services__c=1;
         t_siteContract.Visit_Rescheduling__c='On Schedule';
         t_siteContract.Due__c='Test';
         t_siteContract.AM_Status__c='Live';
         t_siteContract.Customer__c=newAccount.id;
         insert t_siteContract;
         
         SiteContracts__c t_siteContractH= new SiteContracts__c();
         t_siteContractH.site__c=newAccountH.id;
         t_siteContractH.Number_of_Services__c = 1;
         t_siteContractH.Number_of_Services__c=1;
         t_siteContractH.Visit_Rescheduling__c='On Schedule';
         t_siteContractH.Due__c='Test';
         t_siteContractH.AM_Status__c='Live';
         t_siteContractH.Customer__c=newAccountH.id;
         insert t_siteContractH;
         
         Visits__c t_visit= new Visits__c();
         t_visit.site__c=newAccount.id;
         t_visit.site_Contract__c=t_siteContract.id;
         t_visit.Actual_Service_Date__c = date.today();
         t_visit.Engineer2__c=tmp_technician.id;
         t_visit.Visit_Type__c='Small Works';
         t_visit.Booked_with_Customers__c='Booked Via Schedule';
         t_visit.Order_Value__c=10;
         insert t_visit;
         
         Visits__c t_visit1= new Visits__c();
         t_visit1.site__c=newAccount.id;
         t_visit1.site_Contract__c=t_siteContract.id;
         t_visit1.Actual_Service_Date__c = date.today();
         t_visit1.Engineer2__c=tmp_technician.id;
         t_visit1.Visit_Type__c ='Projects';
         t_visit1.Booked_with_Customers__c='Yes';
         t_visit1.Actual_Service_Date__c = date.today();
         t_visit1.Order_Value__c=10;
        
         
         Visits__c t_visit2= new Visits__c();
         t_visit2.site__c=newAccountH.id;
         t_visit2.site_Contract__c=t_siteContractH.id;
         t_visit2.Actual_Service_Date__c = date.today();
         t_visit2.Engineer2__c=tmp_technician.id;
         t_visit2.Visit_Type__c ='Holiday';
         t_visit2.Booked_with_Customers__c='Waiting P/O';
         
         Visits__c t_visit3= new Visits__c();
         t_visit3.site__c=newAccountH.id;
         t_visit3.site_Contract__c=t_siteContractH.id;
         t_visit3.Actual_Service_Date__c = date.today();
         t_visit3.Engineer2__c=tmp_technician.id;
         t_visit3.X2nd_Technician__c=tmp_technician.id;
         t_visit3.Visit_Type__c ='Holiday';
         
         Visits__c t_visit4= new Visits__c();
         t_visit4.site__c=newAccountH.id;
         t_visit4.site_Contract__c=t_siteContractH.id;
         t_visit4.Actual_Service_Date__c = date.today();
         t_visit4.Engineer2__c=tmp_technician.id;
         t_visit4.Visit_Type__c ='Holiday';
         t_visit4.Booked_with_Customers__c='Yes';
         t_visit4.Actual_Service_Date__c = Date.valueof('2015-09-01');
         insert t_visit4;    
         
         Visits__c t_visit5= new Visits__c();
         t_visit5.site__c=newAccountH.id;
         t_visit5.site_Contract__c=t_siteContractH.id;
         t_visit5.Actual_Service_Date__c = date.today();
         t_visit5.Engineer2__c=tmp_technician.id;
         t_visit5.Visit_Type__c ='Holiday';
         
         Visits__c t_visit6= new Visits__c();
         t_visit6.site__c=newAccount.id;
         t_visit6.site_Contract__c=t_siteContract.id;
         t_visit6.Actual_Service_Date__c = date.today();
         t_visit6.Engineer2__c=tmp_technician.id;
         t_visit6.Visit_Type__c ='Projects';
         t_visit6.Order_Value__c=10;
         
         Visits__c t_visit7= new Visits__c();
         t_visit7.site__c=newAccount.id;
         t_visit7.site_Contract__c=t_siteContract.id;
         t_visit7.Actual_Service_Date__c = date.today();
         t_visit7.Engineer2__c=tmp_technician.id;
         t_visit7.Visit_Type__c ='Small Works';
         t_visit7.Order_Value__c=10;
         
         Visits__c t_visit8= new Visits__c();
         t_visit8.site__c=newAccount.id;
         t_visit8.site_Contract__c=t_siteContract.id;
         t_visit8.Actual_Service_Date__c = date.today();
         t_visit8.Engineer2__c=tmp_technician.id;
         t_visit8.Visit_Complete__c=true;
         t_visit8.Service_Sheet_Number__c='1000';
         t_visit8.Order_Value__c=10;
       
         
         
          Visits__c t_visit9= new Visits__c();
         t_visit9.site__c=newAccount.id;
         t_visit9.site_Contract__c=t_siteContract.id;
         t_visit9.Actual_Service_Date__c = date.today();
         t_visit9.Engineer2__c=tmp_technician.id;
         t_visit9.Visit_Type__c ='no-work';
          
      /*  Technician_On_Call_Period__c TechOnCalPeriod= new Technician_On_Call_Period__c();
         TechOnCalPeriod.Call_Out_Start_Date__c=Date.valueof('2015-09-01');
         TechOnCalPeriod.Call_Out_End_Date__c=Date.valueof('2015-09-06');
         TechOnCalPeriod.Technician_name__c=tmp_technician.id;
         insert TechOnCalPeriod;*/
     List<Visits__c> Vis=new List<Visits__c>([select id from Visits__c limit 2]);
     String visitURL='/'+Vis[0].id+'/'+Vis[1].id;
     String oldtechId='['+tmp_technician.id+']';
     
      MultipleTechnicianCalendarHandler con= new MultipleTechnicianCalendarHandler();  
      Date tday=con.setStringToDateFormat('07/14/2015');
      con.SelectedTechId= tmp_technician.id;       
      con.LoadVisit();
      MultipleTechnicianCalendarHandler.UpdateTimeAllowed(string.valueof(system.today()),string.valueof(system.today()+1),visitURL,'12','12:30');
      MultipleTechnicianCalendarHandler.UpdateVisit(string.valueOf( t_visit2.Actual_Service_Date__c+' 12:00'),string.valueOf( t_visit2.Actual_Service_Date__c),visitURL,string.valueOf(t_visit2.id),+oldtechId);           
      
    }
}