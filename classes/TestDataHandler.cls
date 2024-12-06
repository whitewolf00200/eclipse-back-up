/*======================================
    Name           : TestDataHandler
    Author         : 
    Date           : 20th June 2014
    Description    : This controller provide test data
========================================*/

public class TestDataHandler{
    // create Auto Product Config
    public static Auto_Product_Config__c createTestAutoProductConfig(){
        Auto_Product_Config__c autoCon = new Auto_Product_Config__c();
        autoCon.Name = 'Service Sheet';
        return autoCon;
    }

    // create supplier
    public static Suppliers__c createTestSupplier(){
        Suppliers__c supp = new Suppliers__c();
        supp.Name = 'Test supplier';
        supp.Billing_Street__c = 'test street';
        supp.Billing_City__c = 'test city';
        supp.Billing_Country__c = 'UK';
        supp.Billing_State_Province__c = 'test province';
        supp.Billing_Zip_Postal_Code__c = '25489';
        supp.Sage_Code__c = 'st002';
        return supp;
    }
    
    // create site
    Public Static Account createTestSite(){
        Account newSite = new Account(Name='Test Site');
                
        return newSite;
    }
    
    //Create SiteContracts Record
    Public static SiteContracts__c createTestSiteContract(Id siteId){
        SiteContracts__c siteContract=new SiteContracts__c(); 
        siteContract.AM_Status__c='Hold';
        siteContract.Travel_Time__c=2;
        siteContract.Job_Time__c=2;
        siteContract.Site__c = siteId;
        
        return siteContract;
    }
    
    // create Test Technician
    public static Engineer__c createTestEngineer(){
        Engineer__c eng = new Engineer__c();
        eng.Name = 'test tech';
        eng.Disciplines__c = 'Disciplines';
        eng.Email_Address__c = 'test@test.com';
        eng.Engineer_ID__c = 'Tech001';
        eng.Target__c = 78;
        eng.Technician_Super_Group__c = 'North';
        eng.Technician_Group__c = 'Jo Fyffe';
        eng.Street__c = 'test';
        eng.City__c = 'test';
        eng.State_Province__c = 'test';
        eng.Postal_Code__c = '21584';
        eng.Country__c = 'UK';
        return eng;
    }
    
    //Create Visit Record
    Public static Visits__c createTestVisit(Id siteContractId, Id siteId,Id engId){
        Visits__c visit=new Visits__c(); 
        visit.Site__c=siteId;
        visit.Site_Contract__c = siteContractId;
        visit.Engineer2__c = engId;
        return visit;
    }
    
    //Create Opportunity Record
    Public static Opportunity createTestOpportunity(Id accId){
        RecordType oppRT;
        try{
            oppRT = [Select Id, Name, DeveloperName From RecordType Where DeveloperName = 'Order_Form'];
        } catch(Exception ex){}
        Date closeDate = Date.today()+2;
        Opportunity opp = new Opportunity(Name='test opp',AccountId = accId, CloseDate = closeDate, StageName='Proposal/Price Quote' ,Type='Catalogue Order');
        return opp;
    } 
    
    // create purchase order
    public static SFDC_Purchase_Order__c createTestPurchaseOrder(Id suppId,Id visitId){
        SFDC_Purchase_Order__c purchaseOrd = new SFDC_Purchase_Order__c(Supplier1__c=suppId,Visit__c=visitId);
        return purchaseOrd;
    }
}