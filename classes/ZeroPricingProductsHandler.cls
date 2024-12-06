/*Name:ZeroPricingProductsHandler
Purpose : To Set Zero Pricing for the Selected Opportunity Products
Author: Sachin Chincholi
Version: 1.0
Created Date:30/01/2014
Last Modified On:31/01/2014 */

public class ZeroPricingProductsHandler{
    public static ZeroPricingProductsHandler instance;
    public List<OpportunityLineItem> newList =  new List<OpportunityLineItem>();
    List<ID> listOppid = new List<ID>();
    List <Account_Product_Price__c> listofAccountProducts = new List<Account_Product_Price__c>();
    Set<ID> discountedProducts = new Set<ID>();
    Set<Id> priceBookEntryIds = new Set<Id>();
    
    //Singleton Pattern
    public Static ZeroPricingProductsHandler getInstance(){
        if(instance== null){
            instance = new ZeroPricingProductsHandler();
        }
        return instance;
    }
    
    //Before Insert Method Begins Here
    public void onBeforeInsert(List<OpportunityLineItem> newList){
        this.newList = newList;
        /*
        for(OpportunityLineItem oli : newList){
            listOppid.add(oli.opportunityid);
            priceBookEntryIds.add(oli.PricebookEntryId);
        }
        
        //This will check, if there are any discounted products for current Opportunity's Account
        ID currentAccountID=  [SELECT AccountID from Opportunity where id IN : listOppid].AccountID;
        listofAccountProducts = [SELECT id,Product__c,Price__c from Account_Product_Price__c where Account__c = :currentAccountID];
        if(!listofAccountProducts.isEmpty()){
            for(Account_Product_Price__c app : listofAccountProducts){
                discountedProducts.add(app.Product__c);
            }
        }
        //This will check, if there are any discounted products for current Opportunity's Account's Parent Account
        else if(listofAccountProducts.isEmpty()){
        try{
            ID currentParentAccountID   =[ SELECT ParentID from Account where ID=:currentAccountID].ParentID;
            listofAccountProducts = [SELECT id,Product__c,Price__c from Account_Product_Price__c where Account__c = :currentParentAccountID];
            if(!listofAccountProducts.isEmpty()){
                for(Account_Product_Price__c app : listofAccountProducts){
                    discountedProducts.add(app.Product__c);
                }
            }
        }catch(Exception e){
            System.debug(e.getMessage());
        }
        }
        //This will verify the Product ID and Set the Price Accordingly
        Map<Id, PricebookEntry> mapPriceBookEntries = new Map<Id, PricebookEntry>([SELECT Name, ProductCode,Product2id FROM PricebookEntry WHERE Id IN : priceBookEntryIds]);
        for(OpportunityLineItem oli : newList){
            PricebookEntry pbe = mapPriceBookEntries.get(oli.PricebookEntryId);
            for(Account_Product_Price__c appRecord : listofAccountProducts){
                if(pbe.Product2id == appRecord.Product__c){
                    if(appRecord.Price__c !=null){
                    oli.UnitPrice = appRecord.Price__c; 
                    }
                    else if(appRecord.Price__c==null){
                    oli.UnitPrice =0.00;
                    }
                }
            }
        } 
        */
        
    }
}