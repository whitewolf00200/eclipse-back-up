@isTest(SeeAllData=true)
    public class QuoteLineItemHandlerTest{
    static testMethod void myTest(){
    test.StartTest();
    Account acc=new Account();
    acc.name='test acc';
    insert acc;
    
    Product2 p = new Product2(Name='test',UniqueSageCode__c='test1',IsActive=true,Product_Name_Check__c='10 Person First Aid Kit Product 1_test1');
    insert p;
    
     PriceBook2  objPricebook2= new PriceBook2();
     objPricebook2.Name='Standard Price Book1';
     objPricebook2.IsActive=true;
     
     insert objPricebook2;
            
    Pricebook2 standardPB = [select id,Name from Pricebook2 where isStandard =true];
     Id stdPriceBookRecId = Test.getStandardPricebookId();
      system.debug('Pricebook2 =========='+standardPB );  
      system.debug('stdPriceBookRecId ======'+stdPriceBookRecId ); 
      
         //PricebookEntry objpricebookentry = [select id,Pricebook2Id,Product2Id from PricebookEntry where Product2Id=:p.id limit 1];
         PricebookEntry objpricebookentry = new PricebookEntry(UnitPrice=50, Pricebook2Id=standardPB.id, Product2Id=p.Id, IsActive=true); 
         insert objpricebookentry;
         
 /* PricebookEntry objpricebookentry =new PricebookEntry();
     objpricebookentry.Product2ID = p.id;
     objpricebookentry.Pricebook2ID = stdPriceBookRecId;
     objpricebookentry.UnitPrice=50;
     objpricebookentry.IsActive=true;
     insert objpricebookentry; */
     system.debug('PricebookEntry ==========='+objpricebookentry);
    
    Opportunity opp=new Opportunity();
    opp.Name='test opp';
    opp.AccountId=acc.id;
    opp.CloseDate=system.today();
    opp.StageName='Closed won';
    opp.Pricebook2ID=stdPriceBookRecId;
    insert opp;
    
  /*  OpportunityLineItem oli = new OpportunityLineItem(OpportunityId=opp.Id, Quantity=1, PricebookEntryId=pbe.Id, TotalPrice=50);
    insert oli; */

    Quote qu=new Quote();
    qu.Name='Test quote';
    qu.Service_Type__c='Air Compressor';
    qu.OpportunityId=opp.Id;
    qu.Pricebook2ID=stdPriceBookRecId;
    insert qu;
    
    
    
    QuoteLineItem Qli=new QuoteLineItem(QuoteId=qu.Id,Quantity=1, PricebookEntryId=objpricebookentry.Id, UnitPrice=50);
    insert Qli; 
    system.debug('Qli========'+Qli);
    QuoteLineItem Qlii=new QuoteLineItem(QuoteId=qu.Id,Quantity=2, PricebookEntryId=objpricebookentry.Id, UnitPrice=50,id=Qli.id);
    update Qlii;
    
    Test.StopTest();        
    }
    }