@isTest(seeAlldata=true)
public class AccountTriggers_Test{
 
 @IsTest
 public static void AccountTriggers_Test(){       
     //Getting the     RecordType Id
        Id parentRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Id childRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        Id opportunityrecordtype = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Sales').getRecordTypeId();
        
     TriggerActive__c acct = New TriggerActive__c(Name='Test',IsActive__c=false); 
       insert acct;
     
     //Create Parent Record
        Account newParentAccount = new Account();
        newParentAccount.RecordTypeid = parentRecordTypeId;
        newParentAccount.Name = 'TestParentAccount';
        newParentAccount.Customer_type__c='Private Healthcare';
        Insert newParentAccount;
        
        //Create Child Record
        Account newChildAccount = new Account();
        newChildAccount.RecordTypeid = childRecordTypeId;
        newChildAccount.Name = 'TestChildAccount';
        newChildAccount.Customer_type__c='Supplier'; 
        newChildAccount.Parentid= newParentAccount.id;
        //  newChildAccount.Price_List_Correct__c = 29/02/2022;
        newChildAccount.Account_Notes__c='test';
        
        insert newChildAccount;
        
        //Update the PriceList
        newParentAccount.Price_List_Correct__c = system.today();
        newParentAccount.All_Site_Total_Amount__c=100;
         update newParentAccount;
        
        //Create Account 
        Account newAccount = new Account();
        newAccount.RecordTypeid = parentRecordTypeId;
        newAccount.Customer_type__c='Supplier';
        newAccount.Name = 'TestParentAccount';
       
        Insert newAccount;
        
        //Create the Opportunity
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = opportunityrecordtype;
        opp.Name ='Testopp';
        opp.AccountId = newAccount.id;
        datetime t2 = System.now();
        date clsDate = Date.newInstance(t2.year(),t2.month(),t2.day());
        opp.CloseDate= clsDate;
        //  opp.CreatedDate= crtDate;
        opp.StageName = 'Negotiation/Review';
        insert opp;
        
        newAccount.Company_mail__c = 'rak@gmail.com';    
        newAccount.Check_Status__c  ='PriceList: No SageCode: No AccAddOK : No';
        newAccount.Account_Status__c='Dormant';
        newAccount.Reason_Dormant_On_Hold__c='Testing';
        newAccount.Date_Account_Status_Changed__c=system.today();
         
        update newAccount;     
             
     
     //Check Dormant Trigger
    SiteContracts__c t_siteContract= new SiteContracts__c();
     t_siteContract.site__c=newParentAccount.id;  
        t_siteContract.AM_Status__c='Dormant';
        t_siteContract.Visit_Rescheduling__c='On Schedule';
        t_siteContract.Due__c='one';         
        t_siteContract.Number_of_Services__c=1;
        t_siteContract.Purchase_Order_Required__c='No';
        t_siteContract.Customer__c= newAccount.Id; 
        
        insert t_siteContract;
        t_siteContract.site__c=newAccount.id;
        update t_siteContract;
        Account acc=New Account();
        acc=[SELECT id,Account_Status__c,Customer_type__c from Account where id=:newParentAccount.id];
        acc.Account_Status__c='Dormant';
        acc.Customer_type__c='Prison'; 
        acc.Reason_Dormant_On_Hold__c='Testing Records';
        Update acc;
 
    acc=[SELECT id,Account_Status__c from Account where id=:newAccount.id];
    acc.Account_Status__c='Dormant';
    acc.Reason_Dormant_On_Hold__c='Testing Parent Records';
    Update acc;
    
    
    }
}