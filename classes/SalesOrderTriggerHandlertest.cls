@isTest(seeAllData=true)
public class SalesOrderTriggerHandlertest {
          
static testMethod void Test1()
{
   			Id SalesRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Sales').getRecordTypeId();

    		Product2 p = new Product2(Name='test other', ProductCode = OpportunityLineItemHandler.OTHER_CODE,UniqueSageCode__c='test2',Product_Name_Check__c='10 Person First Aid Kit Product 2_test2',Isactive=true);
            insert p;
            
            Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true];
            
            PricebookEntry pbe = new PricebookEntry(UnitPrice=50, Pricebook2Id=standardPB.Id, Product2Id=p.Id, IsActive=true);
            insert pbe;
            
            Account acc=new Account();
            acc.name='test';
            acc.Price_Book__c=standardPB.id;
            acc.Customer_type__c='Private Healthcare';
            acc.Price_List_Correct__c=system.today();
            insert acc;
    	
    		Warehouse__c WH=new Warehouse__c();
            WH.Name='Test';
            insert WH;
    
    		Opportunity opp = new Opportunity(Name='Test opp',recordTypeID=SalesRecTypeId, StageName='New', CloseDate=Date.today(),AccountId=[select id from Account where Price_Book__c!=null and Pricebook_Name__c='Standard Price Book' limit 1].id);
            insert opp;    
            
            OpportunityLineItem oli = new OpportunityLineItem(OpportunityId=opp.Id, Quantity=1,Warehouse__c=WH.id,Product2id=p.id, PricebookEntryId=pbe.Id, TotalPrice=50);
            insert oli;
    
    		SalesOrder__c Sales=new SalesOrder__c();
            Sales.Account__c=acc.Id;
            Sales.Service_Type__c='Air Compressor';
    		sales.Opportunity__c = opp.id;
    		sales.Show_Description__c = false;
            insert Sales;
    
            SalesOrderLineItems__c Soli=new SalesOrderLineItems__c();
            Soli.Product__c=p.Id;
    		
            Soli.Quantity__c=1;
            Soli.Sales_Order__c=Sales.id;
            Soli.Price__c=12;
            insert Soli;
            
            SalesOrderLineItems__c Soli1=new SalesOrderLineItems__c();
            Soli1.Product__c=p.Id;
            Soli1.Quantity__c=1;
            Soli1.Sales_Order__c=Sales.id;
            Soli1.Price__c=12;
            insert Soli1;
    
    		

    
    Map<Id,SalesOrder__c>son = new Map<Id,SalesOrder__c>();
    son.put(sales.id,sales);
    
    Map<Id,SalesOrder__c>soo = new Map<Id,SalesOrder__c>();
    soo.put(sales.id,sales);
    test.starttest();
    
    SalesOrderTriggerHandler SA= new SalesOrderTriggerHandler();
    SA.InsertOLIPrds(son,soo);
    SA.UpdateStage(son,soo);
    
    sales.Show_Description__c = true;
    update sales;
    
    SA.showdesc(son,soo);
    
    test.stoptest();

}
}