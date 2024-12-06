public class StockVerification {
    
    public String selectedLoc{get;set;}
    public Inventory__c invT{get;set;}
    public List<Inventory__c> invList{get;set;}
    public List<SelectOption> locList{get;set;}
    public Location__c loc{get;set;}
    public StockVerification(){
        invT=new Inventory__c(); 
        loc=new Location__c();
        locList=new List<SelectOption>(); 
        locList.add(new SelectOption('None','None')); 
        if(Test.isRunningTest())loc=[select id,name,Warehouse__c from Location__c limit 1];        
    }
    
    public void locLists(){
        if(loc.Warehouse__c !=null){
            for(Location__c lo:[select id,name from Location__c where Warehouse__c=:loc.Warehouse__c]){
                locList.add(new SelectOption(lo.id,lo.Name));
            }
        }
    }
    
    public void changePrd(){
        if(invT != null){
        
        }
    }
    
    public void invLists(){        
        invList=new List<Inventory__c>();  
        if(invT.Product__c != null && loc.Warehouse__c != null && selectedLoc !='None'){
            for(Inventory__c inv : [select id,Total_Delivered__c,Total_Invoiced__c,Total_Received__c,Warehouse_Location__c,Product__c,Out_Of_Stocks__c,Product__r.name,name,Warehouse__c,Warehouse__r.name,In_Hand_Quantity__c,Maximum_Stock_Level__c,Minimum_Stock_Level__c from Inventory__c where (Product__c=:invT.Product__c AND Warehouse__c=:loc.Warehouse__c) AND Warehouse_Location__c=:selectedLoc]){
                invList.add(inv);
            }
        }
        else if(invT.Product__c == null && loc.Warehouse__c != null && selectedLoc !='None'){
            for(Inventory__c inv : [select id,Total_Delivered__c,Total_Invoiced__c,Total_Received__c,Warehouse_Location__c,Product__c,Out_Of_Stocks__c,Product__r.name,name,Warehouse__c,Warehouse__r.name,In_Hand_Quantity__c,Maximum_Stock_Level__c,Minimum_Stock_Level__c from Inventory__c where Warehouse__c=:loc.Warehouse__c AND Warehouse_Location__c=:selectedLoc]){
                invList.add(inv);
            }
        }
        else if(invT.Product__c != null && loc.Warehouse__c != null && selectedLoc =='None'){
            for(Inventory__c inv : [select id,Total_Delivered__c,Total_Invoiced__c,Total_Received__c,Warehouse_Location__c,Product__c,Out_Of_Stocks__c,Product__r.name,name,Warehouse__c,Warehouse__r.name,In_Hand_Quantity__c,Maximum_Stock_Level__c,Minimum_Stock_Level__c from Inventory__c where (Product__c=:invT.Product__c AND Warehouse__c=:loc.Warehouse__c) OR Warehouse_Location__c=:selectedLoc]){
                invList.add(inv);
            }
        } 
        else if(invT.Product__c != null && selectedLoc =='None'){
            for(Inventory__c inv : [select id,Total_Delivered__c,Total_Invoiced__c,Total_Received__c,Warehouse_Location__c,Product__c,Out_Of_Stocks__c,Product__r.name,name,Warehouse__c,Warehouse__r.name,In_Hand_Quantity__c,Maximum_Stock_Level__c,Minimum_Stock_Level__c from Inventory__c where Product__c=:invT.Product__c OR Warehouse__c=:loc.Warehouse__c OR Warehouse_Location__c=:selectedLoc]){
                invList.add(inv);
            }
            //invT=new Inventory__c();
        }
        else if(loc.Warehouse__c != null && selectedLoc =='None'){
            for(Inventory__c inv : [select id,Total_Delivered__c,Total_Invoiced__c,Total_Received__c,Warehouse_Location__c,Product__c,Out_Of_Stocks__c,Product__r.name,name,Warehouse__c,Warehouse__r.name,In_Hand_Quantity__c,Maximum_Stock_Level__c,Minimum_Stock_Level__c from Inventory__c where Warehouse__c=:loc.Warehouse__c OR Warehouse_Location__c=:selectedLoc]){
                invList.add(inv);
            }
        }            
    }
}