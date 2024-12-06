public class UpdateSheetsParts {

   
    public String searchString {get;set;}
    public Required_Parts__c[] shoppingCart {get;set;}
    public Product2[] AvailableProducts {get;set;}
    public List<product2> prd;   
    public String toSelect {get; set;}
    public String toUnselect {get; set;}
    public Decimal Total {get;set;}
    public List<String> Prdids;
    public List<String> pbid;
    public Engineer_Checklist__c  Eng;
    public Service_Sheet_STD__c reac;
    public Id CurrentId;
    public Boolean overLimit {get;set;}
    public Boolean multipleCurrencies {get; set;}
    String Soql='';
    Schema.SObjectType sObjName;
   // String pbook;
    private Boolean forcePricebookSelection = false;
    
    private Required_Parts__c[] forDeletion = new Required_Parts__c[]{};

    public UpdateSheetsParts(ApexPages.StandardController controller) {
        
        sObjName = controller.getRecord().Id.getSObjectType();
        system.debug('sObjName ='+sObjName );
        CurrentId=controller.getRecord().Id;
        system.debug('CurrentId='+CurrentId);
        Soql='select Id,Product_Name__c,Include_Invoice__c,Quantity__c,Parts_Used_Description__c,Location__c,Warehouse__c from Required_Parts__c where ';
        Soql+=String.valueof(sObjName)=='Engineer_Checklist__c'?'Service_Sheet__c=:CurrentId':'Maintenance_Reactive_Sheet__c=:CurrentId';
        system.debug('Soql===='+Soql);
        shoppingCart =database.query(Soql);
        system.debug('shoppingCart ='+shoppingCart );
        
        updateAvailableList();
    }
    
     public void updateAvailableList() {
        
        Prdids=new List<String>();
        pbid = new List<String>();
        system.debug('shoppingCart updateAvailableList='+ shoppingCart );
        for(Required_Parts__c ShopId:shoppingCart)
        Prdids.add(ShopId.Product_Name__c);
        system.debug('Prdids===='+Prdids);
        
       // String qString = 'select Id, Product_Name__r.Name,namefrom PartsConfig__c where isDefaultProduct__c=false and nameNOT IN:Prdids';
        //system.debug('qString ='+qString );
        if(String.valueof(sObjName) =='Engineer_Checklist__c'){
        Eng=[select id,name,Site_Contract__r.Price_Book_IdFormula__c from Engineer_Checklist__c where id=:CurrentId];
        String[] pbook= new String[]{Eng.Site_Contract__r.Price_Book_IdFormula__c};
        system.debug('pbook=='+pbook);
     
        List<PricebookEntry> pbe = new List<PricebookEntry>();
        pbe = [select id,name,Pricebook2Id from PricebookEntry where pricebook2Id =:pbook];
        system.debug('pbe===='+pbe );
         
        for(PricebookEntry pe :pbe){
          
                pbid.add(pe.name);
            
        }
          }
          
         else if(String.valueof(sObjName) =='Service_Sheet_STD__c'){
        reac=[select id,name,Site_Contract__r.Price_Book_IdFormula__c from Service_Sheet_STD__c where id=:CurrentId];
        String[] pbook= new String[]{reac.Site_Contract__r.Price_Book_IdFormula__c};
        system.debug('pbook=='+pbook);
     
        List<PricebookEntry> pbe = new List<PricebookEntry>();
        pbe = [select id,name,Pricebook2Id from PricebookEntry where pricebook2Id =:pbook];
        system.debug('pbe===='+pbe );
         
        for(PricebookEntry pe :pbe){
          
                pbid.add(pe.name);
            
        }
          }
         system.debug('pbid==='+pbid);
       String  qString='select id,name from product2 where name IN:pbid';
       system.debug('qString==='+qString);
       
        
        //system.debug('Eng====='+Eng.Site_Contract__r.Price_Book_IdFormula__c);
        
       /* for(Engineer_Checklist__c Eng:[select id,Site_Contract__r.Price_Book_IdFormula__c from Engineer_Checklist__c where id=:CurrentId]){
       if(Eng.Site_Contract__r.Price_Book_IdFormula__c!=null){
        site.add(Eng.Site_Contract__r.Price_Book_IdFormula__c);
        }
        } */
       // system.debug('Eng====='+Eng);
      // system.debug('site===='+site);
        if(searchString!=null){
        
            qString ='select name from product2 where name IN:pbid and (name like \'%' +searchString+ '%\' or Description like \'%' + searchString + '%\'  or ProductCode like \'%' + searchString + '%\' or Supplier_Product_Code__c  like \'%' + searchString + '%\')';
           // qString+= ' and (Product_Name__r.Name like \'%' + searchString + '%\')';
       // prd=[select name from product2 where name IN:pbid and name like '% searchString %' ];
        //system.debug('prd======='+prd);
            system.debug('qString inside='+qString);
        }
        
        Set<String> selectedEntries = new Set<String>();
        for(Required_Parts__c d:shoppingCart){
            selectedEntries.add(d.Product_Name__c);
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
                if(string.valueof(sObjName)=='Service_Sheet_STD__c')
                shoppingCart.add(new Required_Parts__c(Product_Name__c=d.id, Quantity__c=1,Location__c ='',Maintenance_Reactive_Sheet__c=CurrentId,Include_Invoice__c=true,Parts_Used_Description__c=''));
                else
                shoppingCart.add(new Required_Parts__c(Product_Name__c=d.id, Quantity__c=1,Location__c ='',Service_Sheet__c=CurrentId,Include_Invoice__c=true,Parts_Used_Description__c=''));
                break;
            }
        }
        
        updateAvailableList();  
    }
    

    public PageReference removeFromShoppingCart(){
    
        Integer count = 0;
    
        for(Required_Parts__c d : shoppingCart){
            if((String)d.Product_Name__c==toUnselect){
            
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