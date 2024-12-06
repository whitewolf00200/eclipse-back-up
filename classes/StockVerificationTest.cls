@isTest(SeeAllData=true)
public class StockVerificationTest{
    
    static testMethod void myTest(){
    
    test.starttest();
    
    Warehouse__c WH=new Warehouse__c();
    WH.Name='Test';
    insert WH;
    
    product2 prd=new product2();
    prd.Name='Test Product';
    prd.IsActive=true;
    prd.ProductCode='TES124';
    prd.Cost__c=12;
    insert prd;
    
    Inventory__c Inv=new Inventory__c();
    Inv.Warehouse__c=WH.id;
    Inv.Product__c=prd.id;
    insert Inv;
    
    Location__c Loc=new Location__c();
    Loc.Name='test';
    Loc.Warehouse__c=WH.id;
    insert Loc;
    
    ApexPages.currentPage().getParameters().put('selectedLoc', Loc.Name);
    StockVerification SV=new StockVerification(); 
    
    SV.locLists();
    SV.changePrd();
    SV.invLists();
    
    SV.invT=Inv;
    ApexPages.currentPage().getParameters().put('selectedLoc', 'None');
    SV.invLists();
    
    test.stoptest();
    }

   
}