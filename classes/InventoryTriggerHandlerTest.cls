@isTest(SeeAllData=true)
public class InventoryTriggerHandlerTest{
    
    static testMethod void myTest(){
    
    test.starttest();
    
    Warehouse__c WH=new Warehouse__c();
    WH.Name='Test';
    insert WH;
    
    Location__c Loc=new Location__c();
    Loc.Name='test';
    Loc.Warehouse__c=WH.id;
    insert Loc;
    
    
    Inventory__c inv=new Inventory__c();
    inv.Warehouse__c=WH.id;
    inv.Location__c=Loc.id;
    insert inv;
    
    inv.Zone__c='North';
    update inv;
    
    test.stoptest();
    }
}