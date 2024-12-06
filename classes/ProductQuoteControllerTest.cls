/*============================================================================================================
*Class Name     : ProductQuoteControllerTest
*Description    : all the implementation to test what Quote have been made for a particular product through ProductQuote Visualforce page
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 18th September, 2021
*Version        : 5.0
*============================================================================================================*/
@istest(seeAlldata=true)
public class ProductQuoteControllerTest{
static testMethod void myTest(){
    
    	test.starttest();
    	Account a = new Account();
        a.Name='Test Customer';
        a.Customer_type__c='others';
        a.Survey_required__c=false;
        a.account_status__c='Live';
        insert a;
        
        Account a2 = new Account();
        a2.Name='Test site';
        a2.Customer_type__c='others';
        a2.parentid=a.id;
        a2.recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        a2.Survey_required__c=false;
        a2.Account_Status__c='Live';
        insert a2;
        
        SiteContracts__c b = new SiteContracts__c();
        b.Site__c=a2.id;
        b.AM_Status__c='Live';
        b.Customer__c=a.id;
        insert b;
        
    	Engineer__c c = new Engineer__c();
        c.Name='Andrew';
        c.Engineer_ID__c='3a443d2f-f632-4d30-a60b-7eda067b958b';
        c.Active_User__c='Yes';
        
        c.Country__c= 'Australia';
        insert c;
        
        Engineer__c c1 = new Engineer__c();
        c1.Name='Test';
        c1.Engineer_ID__c='3a443d2f-f632-4d30-a60b-7eda067b958b';
        c1.Active_User__c='Yes';
        
        c1.Country__c= 'Australia';
        insert c1;
        
        Contact cont = new Contact();
        cont.AccountId = a2.id;
        cont.Email = 'test@email.com';
        cont.Relationship__c = 'Average';          
        cont.Description = 'Test comment';
        cont.Lastname = 'Test ';
        insert cont;
        
        Visits__c vist = new Visits__c();
       	vist.Site__c=a2.id;
        vist.Site_Contract__c=b.id;
        vist.Engineer2__c=c.id;
        vist.Service_Type__c ='Storm Water Pump';
        vist.End_Date_Time__c=system.today();
        vist.Order_Value__c=2000;
        vist.Customer_Contact__c=cont.id;
        vist.Booked_with_Customers__c='Yes';
        vist.Actual_Service_Date__c=system.today();
        vist.Visit_Type__c='Service';
        vist.Visit_Complete__c=true;
        insert vist;
        
    	product2 prd=new product2();
    	prd.Name='Test Product';
    	prd.IsActive=true;
    	prd.ProductCode='TES124';
    	insert prd;
    
    	Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true and isactive=true]; 
    
    	PricebookEntry pbe = new PricebookEntry(UnitPrice=50, Pricebook2Id=standardPB.Id, Product2Id=prd.Id, IsActive=true);
    	insert pbe;
    
    	Opportunity Opp=new Opportunity ();
    	Opp.AccountId = a2.Id;
    	Opp.Name='Test Opportunity';
    	Opp.StageName='Qualification';
    	Opp.Pricebook2Id = standardPB.Id;
    	Opp.CloseDate=system.today();
    	insert Opp;
    
    	OpportunityLineItem oli = new OpportunityLineItem(OpportunityId=Opp.Id, Quantity=1, PricebookEntryId=pbe.Id, TotalPrice=50);
    	insert oli;
    
    	Quote qu=new Quote();
    	qu.Name='Test quote';
    	qu.Service_Type__c='Air Compressor';
    	qu.OpportunityId=Opp.Id;
    	qu.Pricebook2ID=standardPB.Id;
    	insert qu;
    
    	QuoteLineItem Qli=new QuoteLineItem(QuoteId=qu.Id,Quantity=1, PricebookEntryId=pbe.Id, UnitPrice=50);
    	insert Qli; 
    
    	system.debug('Qli========'+Qli);
    
    	ApexPages.CurrentPage().getParameters().put('id',prd.id);
    	ApexPages.StandardController prod = new ApexPages.StandardController(prd);
    	ProductQuoteController pq=new ProductQuoteController(prod);
    	test.stoptest();
    }
 }