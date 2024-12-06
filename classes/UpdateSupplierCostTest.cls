@isTest(seeAlldata=true)
Public Class UpdateSupplierCostTest{
     @isTest Public static void UpdateSupplierCostMethod() {  
        
         Id SuppId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
        
         Account Pacc = new Account();
         Pacc.Name='Test Customer';
         Pacc.RecordTypeId=SuppId;
         insert Pacc;
         
         Account a=new Account();
         a.Name='Test site';
         a.RecordTypeId=SuppId;
         insert a;
         
        Product2 product = new Product2(); 
        
        Id pb2= Test.getStandardPricebookId();
        
        product.name = 'Test';
        product.ProductCode='Test';
        product.Nominal_Code__c='Test';
        insert product;
        
        product.Suppliers__c=null;
        product.Supplier_Cost_Price__c=null;
        update product;
        
        SupplierProduct__c Spoli=new SupplierProduct__c();
        Spoli.Product__c=product.Id;
        Spoli.Supplier__c=Pacc.Id;
        Spoli.Cost__c=12;
        insert Spoli;
        
        
        product.Suppliers__c=Pacc.Id;
        update product;
     }
}