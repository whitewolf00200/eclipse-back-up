@isTest(SeeAllData=true)
public class PurchaseOrderHandlerTest{
 @isTest Public static void Method() {
  Id parentRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
      Contact co=new Contact();
      co.LastName='test contact';
      co.Description='comments';
      insert co;
      
     Account acc=new Account();
     acc.RecordTypeId=parentRecordTypeId ;
     acc.name='testacc';
     acc.Contact__c=co.id;
     insert acc;
     
    PurchaseOrder__c po=new PurchaseOrder__c();
    po.Department__c='test';
    po.Supplier__c=acc.id;
    insert po;
    }
    
    }