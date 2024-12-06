@isTest (seeAllData=true)
private class OpportunityLineItemHandlerTest {

    public static testMethod void oliInsertNoOther() {
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
            
            SalesOrder__c Sales=new SalesOrder__c();
            Sales.Account__c=acc.Id;
            Sales.Service_Type__c='Air Compressor';
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
                       
            Opportunity opp = new Opportunity(Name='Test opp', StageName='New', CloseDate=Date.today(),Sales_Order__c=Sales.id,AccountId=[select id from Account where Price_Book__c!=null and Pricebook_Name__c='Standard Price Book' limit 1].id);
            insert opp;
            
            OpportunityLineItem oli = new OpportunityLineItem(OpportunityId=opp.Id, Quantity=1, PricebookEntryId=pbe.Id, TotalPrice=50);
            
            insert oli;
            
            opp.Show_Description__c=true;
            update opp;
            
            opp = [SELECT Other_Product_Qty__c FROM Opportunity WHERE Id = :opp.Id];
            
            system.assertEquals(0, opp.Other_Product_Qty__c);
        
    }
    
    public static testMethod void oliInsertOther() {
            
            Product2 p = new Product2(Name='test other', ProductCode = OpportunityLineItemHandler.OTHER_CODE,UniqueSageCode__c='test2',Product_Name_Check__c='10 Person First Aid Kit Product 2_test2',Isactive=true);
            insert p;
            
            Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true];
            
            PricebookEntry pbe = new PricebookEntry(UnitPrice=50, Pricebook2Id=standardPB.Id, Product2Id=p.Id, IsActive=true);
            insert pbe;
            
            Account acc=new Account();
            acc.name='test';
            acc.Price_Book__c=standardPB.id;
            acc.Price_List_Correct__c=system.today();
            acc.Customer_type__c='Private Healthcare';
            insert acc;
            
            SalesOrder__c Sales=new SalesOrder__c();
            Sales.Account__c=acc.Id;
            Sales.Service_Type__c='Air Compressor';
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
           
            Opportunity opp = new Opportunity(Name='Test opp', StageName='New', CloseDate=Date.today(),Sales_Order__c=Sales.id,AccountId=[select id from Account where Price_Book__c!=null and Pricebook_Name__c='Standard Price Book' limit 1].id);
            insert opp;
            
            OpportunityLineItem oli = new OpportunityLineItem(OpportunityId=opp.Id, Quantity=1, PricebookEntryId=pbe.Id, TotalPrice=50);
            
            insert oli;
           
    
            opp.Show_Description__c=true;
            update opp;
            
            opp = [SELECT Other_Product_Qty__c FROM Opportunity WHERE Id = :opp.Id];
    }

}