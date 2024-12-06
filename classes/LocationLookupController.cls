public class LocationLookupController {
    public String queryKey{get;set;}
    public String whId{get;set;}
    public String locId{get;set;}
    public List<Product2> location{get;set;}
    
    public LocationLookupController(){
        whId=apexpages.currentpage().getparameters().get('Warehouse');        
        location=new List<Product2>();
        String searchKey=queryKey+'%';
        if(whId != null){  
            location=getLoc();
        } 
    }
    
    public PageReference search() {        
        if(whId != null){  
            location=getLoc();
            system.debug('---location---'+location);
        }      
        return null;
    }

    
    public void viewTech(){
        location=getLoc();
        system.debug('---location---'+location);
    }
    public List<Product2> getLoc(){
       //return [select id,Product__c,Warehouse__c,Warehouse_Location__c from Inventory__c where  Warehouse__c=:whId];
      if(queryKey != null){
            return [select id,Name from Product2 where id IN(select Product__c from Inventory__c where Warehouse__c=:whId) And Name like : queryKey+'%'];       
        }
        else{
        //Warehouse_Location__c =:locId AND
            return [select id,Name from Product2 where id IN(select Product__c from Inventory__c where Warehouse__c=:whId)];
        }
    }
}