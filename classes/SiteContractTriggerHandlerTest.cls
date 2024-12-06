@isTest(seeAllData=true)
public class SiteContractTriggerHandlerTest{

    public static testMethod void Tester() {
      Account a = [select Id,Site_Contact__c from Account where parentId!=null And Site_Contact__c!=null limit 1];
      SiteContracts__c sc=new SiteContracts__c();
      sc.AM_Status__c='Live';
      sc.Site__c=a.id;
      insert sc;
    }
}