@isTest(seeAllData=true)
public with sharing class NextVisitTest {
    public static testMethod void Tester() {
        Account a = new Account();
      a.Name='Test Customer';
      insert a;
      
      SiteContracts__c b = new SiteContracts__c();
      b.Site__c=a.id;
      b.AM_Status__c='Live';
      b.Visit_Rescheduling__c='On Schedule';
      b.Due__c='FEB';
      b.Price_Book_Id__c=Test.getStandardPricebookId();
      insert b;
      
      SiteContracts__c b1 = new SiteContracts__c();
      b1.Site__c=a.id;
      b1.AM_Status__c='Live';
      b1.Visit_Rescheduling__c='On Visit';
      b1.Due__c='FEB';
      b1.Price_Book_Id__c=Test.getStandardPricebookId();
      insert b1;
      
      Engineer__c c = new Engineer__c();
      c.Name='Andrew';
      c.Engineer_ID__c='3a443d2f-f632-4d30-a60b-7eda067b958b';
      c.Active_User__c='Yes';
     
      c.Country__c= 'Australia';
      insert c;
      
      Engineer__c c1 = new Engineer__c();
      c1.Name='Test';
      c1.Engineer_ID__c='3a443d2f-f632-4d30-a60b-7eda067b958b';
      c1.Active_User__c='Yes';
     
      c1.Country__c= 'Australia';
      insert c1;
      
      
   
     
     Visits__c vist = new Visits__c();
     
     vist.Site__c=a.id;
     vist.Site_Contract__c=b1.id;
     vist.Engineer2__c=c.id;
     vist.Service_Type__c ='Storm Water Pump';
     insert vist;
     Engineer_Checklist__c d = new Engineer_Checklist__c();
     d.Visit__c = vist.id;
        
     Visits__c vist1 = new Visits__c();
     vist1.Site__c=a.id;
     vist1.Site_Contract__c=b.id;
     vist1.Engineer2__c=c.id;
     vist1.Service_Type__c ='Sewer pump';
     insert vist1;
     
     vist.Visit_Complete__c=false;
        update vist;
        vist.Actual_Service_Date__c=system.today();
        vist.Visit_Complete__c=true;
        update vist;       
            
        vist1.Visit_Complete__c=false;
        update vist1;
        vist1.Actual_Service_Date__c=system.today();
        vist1.Visit_Complete__c=true;
        update vist1;
   
    }
}