public class SlowMovingItems {
    
    public List<Inventory__c> activeList{get;set;}
    public List<Inventory__c> ShowMovingList{get;set;}
    public List<Inventory__c> inActiveList{get;set;}
    public List<Inventory__c> ObsoleteList{get;set;}
    
    Public SlowMovingItems(){
        activeList=new List<Inventory__c>();
        ShowMovingList=new List<Inventory__c>();
        inActiveList=new List<Inventory__c>();
        ObsoleteList=new List<Inventory__c>();

    }
}