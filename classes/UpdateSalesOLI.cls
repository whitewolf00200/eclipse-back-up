public class UpdateSalesOLI {

public Opportunity theOpp {get;set;}
    public String searchString {get;set;}
    public SalesOrderLineItems__c[] shoppingCart {get;set;}
    public priceBookEntry[] AvailableProducts {get;set;}
    public Pricebook2 theBook {get;set;}   
    public Id Salesids;
    
    public String toSelect {get; set;}
    public String toUnselect {get; set;}
    public Decimal Total {get;set;}
    
    public Boolean overLimit {get;set;}
    public Boolean multipleCurrencies {get; set;}
    
    private Boolean forcePricebookSelection = false;
    
    private SalesOrderLineItems__c[] forDeletion = new SalesOrderLineItems__c[]{};

    public UpdateSalesOLI(ApexPages.StandardController controller) {
        theOpp=new Opportunity();
        Salesids=controller.getRecord().Id;
        String OppId=[select Opportunity__c from SalesOrder__c where id=:controller.getRecord().Id].Opportunity__c;
        if(OppId!=null){
            theOpp = database.query('select Id, Pricebook2Id, Pricebook2.Name from Opportunity where Id = \'' + OppId + '\' limit 1');
        }
        shoppingCart = [select Id, Product__c, Quantity__c, Price__c from SalesOrderLineItems__c where Sales_Order__c=:controller.getRecord().Id];

        if(theOpp.Pricebook2Id == null){
            Pricebook2[] activepbs = [select Id, Name from Pricebook2 where isActive = true limit 2];
            if(activepbs.size() == 2){
                forcePricebookSelection = true;
                theBook = new Pricebook2();
            }
            else{
                theBook = activepbs[0];
            }
        }
        else{
            theBook = theOpp.Pricebook2;
        }
        
        if(!forcePricebookSelection)
            updateAvailableList();
    }
    
     public void updateAvailableList() {
    
        String qString = 'select Id, Pricebook2Id, IsActive, Product2.Name, Product2.Family, Product2.IsActive, Product2.Description, UnitPrice from PricebookEntry where IsActive=true and Pricebook2Id = \'' + theBook.Id + '\'';
        
        if(searchString!=null){
            qString+= ' and (Product2.Name like \'%' + searchString + '%\' or Product2.Description like \'%' + searchString + '%\')';
        }
        
        Set<Id> selectedEntries = new Set<Id>();
        for(SalesOrderLineItems__c d:shoppingCart){
            selectedEntries.add(d.Product__c);
        }
        
        if(selectedEntries.size()>0){
            String tempFilter = ' and Id not in (';
            for(Id i : selectedEntries){
                tempFilter+= '\'' + (String)i + '\',';
            }
            String extraFilter = tempFilter.substring(0,tempFilter.length()-1);
            extraFilter+= ')';
            
            qString+= extraFilter;
        }
        
        qString+= ' order by Product2.Name';
        qString+= ' limit 101';
        
        system.debug('qString:' +qString);        
        AvailableProducts = database.query(qString);
        
        if(AvailableProducts.size()==101){
            AvailableProducts.remove(100);
            overLimit = true;
        }
        else{
            overLimit=false;
        }
    }
    
    public void addToShoppingCart(){
    
        for(PricebookEntry d : AvailableProducts){
            if((String)d.Id==toSelect){
                shoppingCart.add(new SalesOrderLineItems__c(Product__c=d.product2Id, Quantity__c=1,Sales_Order__c=Salesids,Price__c=d.UnitPrice));
                break;
            }
        }
        
        updateAvailableList();  
    }
    

    public PageReference removeFromShoppingCart(){
    
        Integer count = 0;
    
        for(SalesOrderLineItems__c d : shoppingCart){
            if((String)d.Product__c==toUnselect){
            
                if(d.Id!=null)
                    forDeletion.add(d);
            
                shoppingCart.remove(count);
                break;
            }
            count++;
        }
        
        updateAvailableList();
        
        return null;
    }
    
    public PageReference onSave(){
    
        if(forDeletion.size()>0)
            delete(forDeletion);
    
        try{
            if(shoppingCart.size()>0)
                upsert(shoppingCart);
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }  
           
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }
    
    public PageReference onCancel(){
 
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }
}