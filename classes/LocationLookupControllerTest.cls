@isTest(SeeAllData=true)
public class LocationLookupControllerTest{
    
    static testMethod void myTest(){
    
    test.starttest();
    
    Warehouse__c WH=new Warehouse__c();
    WH.Name='Test';
    insert WH;
    
    Inventory__c Inv=new Inventory__c();
    Inv.Warehouse__c=WH.id;
    insert Inv;
    
    ApexPages.currentPage().getParameters().put('Warehouse', WH.id);
    LocationLookupController Loc=new LocationLookupController();
    Loc.search();
    Loc.viewTech();
    
    test.stoptest();
    }
}