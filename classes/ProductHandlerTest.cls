@isTest(seeAlldata=true)
public class ProductHandlerTest{
    
    @isTest Public static void Method(){ 
        Account Acc=new Account();
        Acc.Name='Test Supplier';
        Acc.Recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
        Acc.Customer_type__c='test';
        insert Acc;
        
        Product2 Prd=new Product2();
        Prd.Name='Test Product';
        Prd.isActive=true;
        insert Prd;
        
        SupplierProduct__c SuppPrd=new SupplierProduct__c();
        SuppPrd.Product__c=Prd.Id;
        SuppPrd.Cost__c=12;
        SuppPrd.Supplier__c=Acc.id;
        insert SuppPrd;
        
        Product2 Prd1=new Product2();
        Prd1.Name='Test Product';
        Prd1.isActive=true;
        insert Prd1;
        delete Prd1;
        
        prd.Suppliers__c=Acc.id;
        update prd;
    }
}