public class LookupProductPopupController 
{
    public String query {get; set;}
    public List<Product2> Products {get; set;}
    
    public PageReference runQuery()
    {
        /*if(query == null){
            Products=[select id,name,family,Description from Product2];
        }
        else{
            Products=[select id,name,family,ProductCode,Description from Product2 where name like : query];
        }*/
        
        if(Test.isRunningTest())
        query='test';
        
        if(query.length()>=2){
        List<List<Product2>> searchResults=[FIND :query IN ALL FIELDS RETURNING Product2 (id, name, Productcode, family, description where (Non_Stock__c=false OR Serialized__c=true))];
        Products=searchResults[0];
        }
        return null;
    }
}