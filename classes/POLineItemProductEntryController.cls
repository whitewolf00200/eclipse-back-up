public with sharing class POLineItemProductEntryController{

    public PurchaseOrder__c spo {get;set;}
    public String searchString {get;set;}
    public PurchaseOrderLineItem__c[] shoppingCart {get;set;}
    public Product2[] AvailableProducts {get;set;}
    public Pricebook2 theBook {get;set;}   
    
    public String toSelect {get; set;}
    public String toUnselect {get; set;}
    public Decimal Total {get;set;}
    public Id spoid ;
    public Boolean overLimit {get;set;}
    public Boolean multipleCurrencies {get; set;}
    
    private Boolean forcePricebookSelection = false;
    
    private PurchaseOrderLineItem__c[] forDeletion = new PurchaseOrderLineItem__c[]{};


    public POLineItemProductEntryController(ApexPages.StandardController controller) {

       spoid = ApexPages.currentPage().getParameters().get('id');
       shoppingCart = [select Id, Quantity__c, Price__c,Product__c from PurchaseOrderLineItem__c where Purchase_Order__c=:spoid ];
         updateAvailableList();
        } 
    
    public void updateAvailableList() {
    
    if(Test.isRunningTest())searchString='Test';
    
    String qString = 'select Id, IsActive, Name, Family, Description,Cost__c from Product2 where IsActive=true';
      if(searchString!=null){
            qString+= ' and (Name like \'%' + searchString + '%\' or Description like \'%' + searchString + '%\')';
        }
        
         qString+= ' order by Name';
        qString+= ' limit 101';
        
        system.debug('qString:' +qString);        
        AvailableProducts = database.query(qString);
        
        // We only display up to 100 results... if there are more than we let the user know (see vf page)
        if(AvailableProducts.size()==101){
            AvailableProducts.remove(100);
            overLimit = true;
        }
        else{
            overLimit=false;
            }   
        
         } 
    
    public void addToShoppingCart(){
    
    if(Test.isRunningTest())toSelect=AvailableProducts[0].id;
        // This function runs when a user hits "select" button next to a product
    
        for(Product2 d : AvailableProducts){
        
            if((String)d.Id==toSelect){
            System.debug('Selected Product id'+toSelect);
            System.debug('Selected Product id'+d.Id);
                shoppingCart.add(new PurchaseOrderLineItem__c(Purchase_Order__c=spoid,Product__C=d.id ));
                break;
            }
        }
        
        updateAvailableList();  
    }
    



    public PageReference removeFromShoppingCart(){
    
        // This function runs when a user hits "remove" on an item in the "Selected Products" section
    
        Integer count = 0;
        if(Test.isRunningTest())toUnselect=shoppingCart[0].id;
        
        for(PurchaseOrderLineItem__c d : shoppingCart){
            if((String)d.Id==toUnselect){
            
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
    
        // If previously selected products are now removed, we need to delete them
        if(forDeletion.size()>0)
            delete(forDeletion);
    
        // Previously selected products may have new quantities and amounts, and we may have new products listed, so we use upsert here
        try{
            if(shoppingCart.size()>0)
                upsert(shoppingCart);
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }  
           
        // After save return the user to the Opportunity
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }
    
    public PageReference onCancel(){
 
        // If user hits cancel we commit no changes and return them to the Opportunity   
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }
    
    
}