public class NextVisitPrdController {

   
    public String searchString {get;set;}
    public Next_Visit_Product__c[] shoppingCart {get;set;}
    public Product2[] AvailableProducts {get;set;}
    public String toSelect {get; set;}
    public String toUnselect {get; set;}
    public Decimal Total {get;set;}
    public List<Id> Prdids;
    public Id CurrentId;
    public Boolean overLimit {get;set;}
    public Boolean multipleCurrencies {get; set;}
    String Soql='';
     public Service_Sheet_STD__c reac;
     public List<String> pbid;
    
    private Boolean forcePricebookSelection = false;
    
    private Next_Visit_Product__c[] forDeletion = new Next_Visit_Product__c[]{};

    public NextVisitPrdController(ApexPages.StandardController controller) {
        
        Schema.SObjectType sObjName = controller.getRecord().Id.getSObjectType();
        CurrentId=controller.getRecord().Id;
        
        Soql='select Id,Product__c,Quantity__c from Next_Visit_Product__c where ';
        Soql+='Maintenance_Reactive_Sheet__c=:CurrentId';
        shoppingCart =database.query(Soql);
        updateAvailableList();
    }
    
     public void updateAvailableList() {
        
        Prdids=new List<Id>();
   pbid=new List<String>();
        for(Next_Visit_Product__c ShopId:shoppingCart)
        Prdids.add(ShopId.Product__c);
        
       // String qString = 'select Id,Product_Name__r.Name, Product_Name__c from PartsConfig__c where isDefaultProduct__c=false and Product_Name__c NOT IN:Prdids';
        
        
                  
        reac=[select id,name,Site_Contract__r.Price_Book_IdFormula__c from Service_Sheet_STD__c where id=:CurrentId];       
        String[] pbook= new String[]{reac.Site_Contract__r.Price_Book_IdFormula__c};        
        system.debug('pbook=='+pbook);      
            
        List<PricebookEntry> pbe = new List<PricebookEntry>();      
        pbe = [select id,name,Pricebook2Id from PricebookEntry where pricebook2Id =:pbook];     
        system.debug('pbe===='+pbe );       
                if(pbe.size()>0){
        for(PricebookEntry pe :pbe){        
                if(pe.name!=null)
                pbid.add(pe.name);    
                  
                    
        }       
           }
         system.debug('pbid==='+pbid);      
       String  qString='select id,name from product2 where name IN:pbid';       
       system.debug('qString==='+qString);      
       
        
        if(searchString!=null){
           qString ='select name from product2 where name IN:pbid and name like \'%' +searchString+ '%\'';
        }
        
        Set<Id> selectedEntries = new Set<Id>();
        for(Next_Visit_Product__c d:shoppingCart){
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
        
        qString+= ' order by Name';
        qString+= ' limit 101';
        
        system.debug('qString:>>>' +qString);        
        AvailableProducts = database.query(qString);
        system.debug('AvailableProducts:>>>>'+AvailableProducts);
        
        if(AvailableProducts.size()==101){
            AvailableProducts.remove(100);
            overLimit = true;
        }
        else{
            overLimit=false;
        }
    }
    
    public void addToShoppingCart(){
    
        for(Product2 d : AvailableProducts){
            if((String)d.Id==toSelect){
                shoppingCart.add(new Next_Visit_Product__c(Product__c=d.id, Quantity__c=1,Maintenance_Reactive_Sheet__c=CurrentId));
                break;
            }
        }
        
        updateAvailableList();  
    }
    

    public PageReference removeFromShoppingCart(){
    
        Integer count = 0;
    
        for(Next_Visit_Product__c d : shoppingCart){
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