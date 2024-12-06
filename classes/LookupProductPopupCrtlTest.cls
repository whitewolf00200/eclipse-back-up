@isTest(seeAlldata=true)
public class LookupProductPopupCrtlTest{
    
    static testMethod void myTest(){
    
    test.starttest();
    
    product2 prd=new product2();
    prd.Name='test';
    prd.IsActive=true;
    prd.ProductCode='TES124';
    prd.Cost__c=12;
    insert prd;
    
    ApexPages.currentPage().getParameters().put('query', String.valueOf(prd.id));
    ApexPages.currentPage().getParameters().put('Products ', String.valueOf(prd.id));
    LookupProductPopupController Lookctrl=new LookupProductPopupController();
    Lookctrl.runQuery();
    
    test.stoptest();
    }
}