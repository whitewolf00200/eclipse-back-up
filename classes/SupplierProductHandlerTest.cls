@isTest(SeeAllData=true)
    private class SupplierProductHandlerTest{
      public  static testMethod void method1() {
        
        
        
        Account acc=new Account();
        Id RecordTypeIdProduct = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
        acc.Name='test';
        acc.RecordTypeId=RecordTypeIdProduct;
        acc.Customer_type__c ='Prison';
            insert acc;
        
        Product2 prd=new Product2();
        prd.name='test';
        prd.Suppliers__c=acc.id;
        insert prd;
        
        SupplierProduct__c sp=new SupplierProduct__c();
        sp.Product__c=prd.id;
        sp.Supplier__c=acc.id;
        sp.cost__c=40;
        insert sp;
        
        sp.cost__c=45;
        update sp;
        
      }
     
    }