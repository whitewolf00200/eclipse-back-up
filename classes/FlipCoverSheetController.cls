public with sharing class FlipCoverSheetController {
Public List<Account> acc{set;get;}
Public List<Contact> con{set;get;}
 

    public FlipCoverSheetController(ApexPages.StandardController controller) {
acc= [select id,Name ,UPRN__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account];
con=[select id,MobilePhone,Email,Phone from Contact];
    }

}