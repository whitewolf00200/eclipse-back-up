@isTest(SeeAllData=true)
    public class DeliveryNoteHandlerTest{
    
    public static testMethod void method1(){
    
    Delivery_Note__c Dn=new Delivery_Note__c (Date__c=system.today());
    insert Dn;
    
    Product2 prd=new Product2(name='test',IsActive=true);
    insert prd;
    
    Delivery_Note_Line_Item__c Dnoli=new Delivery_Note_Line_Item__c(Delivery_Note__c=Dn.id,Product__c=prd.id);
    insert Dnoli;
    
    Dn.Show_Description__c=true;
    update Dn;
    
    }
    
    }