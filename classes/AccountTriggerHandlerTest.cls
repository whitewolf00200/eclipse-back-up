/*
*Oraganization: Puthuvannam Technology Solutions
*/

@isTest(seeAlldata=true)
Public Class AccountTriggerHandlerTest{
    @isTest Public static void UpdatePriceListDateTest() {  
        
        TriggerActive__c customsetting = new TriggerActive__c();
        customsetting.IsActive__c =true;
        customsetting.Name ='test';
        Insert customsetting;
        
        Account acc=new Account();
        acc.name='test';
        acc.Price_List_Correct__c=system.today();
        acc.Customer_type__c='Prison';
        insert acc;
        acc.Customer_type__c='Prison';
        Update acc;

        //
 
        acc.Region__c='BN Zone D';
        update acc;
        
        acc.Region__c='BR Zone B';
        update acc;
        
        acc.Region__c='Central London (E,EC,WC,W)';
        update acc;
        
        acc.Region__c='BN Zone D';
        update acc;
        
        acc.Region__c='CM Zone C';
        update acc;
        
        acc.Region__c='HA Zone D';
        update acc;
        
        acc.Region__c='HP Zone D';
        update acc;
        
        acc.Region__c='CR Zone C';
        update acc;
        
        acc.Region__c='CT Zone C';
        update acc;
        
        acc.Region__c='CN Zone D';
        update acc;

        
        acc.Region__c='GU Zone D';
        update acc;
        
        acc.Region__c='DA Zone A';
        update acc;
        
        acc.Region__c='IG Zone C';
        update acc;
        
        acc.Region__c='KT Zone C';
        update acc;
        
        acc.Region__c='MK Zone D';
        update acc;
        
        acc.Region__c='ME Zone B';
        update acc;
        
        acc.Region__c='NL';
        update acc;
        
        acc.Region__c='North London (NW,N,EN)';
        update acc;
        
        acc.Region__c='Other';
        update acc;
        
        
        acc.Region__c='PO Zone E';
        update acc;
        
        
        acc.Region__c='RG Zone D';
        update acc;
        
        
        acc.Region__c='RM Zone B';
        update acc;
        
        
        acc.Region__c='RH Zone C';
        update acc;
        
        
        acc.Region__c='SE Zone C';
        update acc;
        
        
        acc.Region__c='SL Zone D';
        update acc;
        
        
        acc.Region__c='SG';
        update acc;
        
        
        acc.Region__c='SM Zone C';
        update acc;
        
        acc.Region__c='SO Zone D';
        update acc;
        
        acc.Region__c='S- Scotland';
        update acc;
        
        acc.Region__c='SS Zone C';
        update acc;
        
        acc.Region__c='SW Zone C&D';
        update acc;
        
        acc.Region__c='TW Zone D';
        update acc;
        
        acc.Region__c='UB Zone D';
        update acc;
        
        acc.Region__c='WF (NHS)';
        update acc;
        
        acc.Region__c='TN Zone B & C';
        update acc;

        acc.Region__c='E Zone C';
        update acc;
       
        acc.Region__c='AL Zone D';
        update acc;

        acc.Region__c='IP Zone D';
        update acc;
       
        acc.Region__c='CO Zone D';
        update acc;

        acc.Region__c='EN Zone C';
        update acc;

        acc.Region__c='WD Zone D';
        update acc;

        acc.Region__c='LU Zone D';
        update acc;

        acc.Region__c='OX Zone D';
        update acc;
  
        
        
        Account exAccount=[Select id,Price_List_Correct__c from Account LIMIT 1];
        //Update the 'Price_List_Correct__c' Field
        exAccount.Price_List_Correct__c=system.today();
        update exAccount;
        
        list<Account> ChildRecords = [Select id,Parentid,Price_List_Correct__c from account where parentid = :exAccount.id limit 1];
        
        /*   for (Account childrecord : ChildRecords) {            
system.assertEquals(childrecord.Price_List_Correct__c,system.today(),'Price List Correct is not Updated');
}  */
    }
}