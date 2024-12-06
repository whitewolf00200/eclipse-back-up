/*Class Name :  SpecialAccountProductPricePageController 
Purpose    :  Controller for the SpecialAccountProductPricePage
Author     :  Sachin Chincoli
Created Date : 03/02/2014
Last Modified Date : 05/02/2014
Reason for Modification : Added Functionality
*/

public class SpecialAccountProductPricePageController {
    
    public Account_Product_Price__c appRecord{get;set;}
    
    public List<Account_Product_Price__c> appList{get;set;}
    public List<Account_Product_Price__c> appListAcc{get;set;}
    public Id curRecId {get;set;}
    
    public SpecialAccountProductPricePageController(ApexPages.StandardController controller) {
        appRecord = new Account_Product_Price__c ();
        appList =  new List<Account_Product_Price__c>();
        appListAcc =  new List<Account_Product_Price__c>();
        try{
            curRecId = ApexPages.currentPage().getParameters().get('id');
            appRecord = [SELECT id, name, Account__c from Account_Product_Price__c  where id=:curRecId];
            appList = [SELECT id, name, Account__c, Product__c, Price__c from Account_Product_Price__c   where Account__c =:appRecord.Account__c];
        }catch(Exception e){
            Account_Product_Price__c apRec = new Account_Product_Price__c();
            appList.add(apRec);
            appListAcc .add(apRec);
        }
    }
    
    public void addRow(){
        Account_Product_Price__c apRec = new Account_Product_Price__c(Price__c = 0.0);
        appList.add(apRec);
    }
    public void addRowAcc(){
        Account_Product_Price__c apRec = new Account_Product_Price__c();
        appListAcc.add(apRec);
    }   
    
    public PageReference SaveData(){
        saveHelperMethod();
        PageReference pageRef = new PageReference('/apex/SpecialAccountProductPricePage');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public PageReference SaveAndExit(){
        saveHelperMethod();
        Schema.DescribeSObjectResult result = Account_Product_Price__c.SObjectType.getDescribe();
        PageReference pageRef = new PageReference('/' + result.getKeyPrefix());
        pageRef.setRedirect(true);
        return pageRef;
    }
    public void saveHelperMethod(){
        List<Account_Product_Price__c>  listToSave = new List<Account_Product_Price__c>();
        if(!appListAcc.isEmpty()){
            for(Account_Product_Price__c apRecAcc :appListAcc ){
                for(Account_Product_Price__c apRec :appList){
                    Account_Product_Price__c apInstance = new Account_Product_Price__c();
                    apInstance .Account__c = apRecAcc.Account__c;
                    apInstance .Product__c = apRec.Product__c;
                    apInstance .Price__c = apRec.Price__c;
                    listToSave.add(apInstance );
                }
            }
        }
        else{
            for(Account_Product_Price__c apRec :appList){
                apRec .Account__c = appRecord.Account__c;
                apRec .Product__c = apRec.Product__c;
                apRec .Price__c = apRec.Price__c;
                listToSave.add(apRec);
            }    
        }
        try{
            upsert listToSave ;
        }catch(DMLException e){
            System.debug(e.getMessage());
        }  
    }
    
}