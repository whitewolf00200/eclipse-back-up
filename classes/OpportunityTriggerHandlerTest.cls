@isTest (seeAllData=true)
/*============================================================================================================
*Class Name     : OpportunityTriggerHandlerTest
*Description    : All the implementations related to test OpportunityTriggerHandler.
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 25th Jun, 2020
*Version        : 1.0
*Change History : Initial class
*Methods        : public static testMethod void oliInsertNoOther() {
                  
*============================================================================================================*/
private class OpportunityTriggerHandlerTest {

/*====================================================
*Method Name     : oliInsertNoOther
*Description     : This method test OpportunityTriggerHandler class.
*Arguments       : No Arguments
*Ticket No       : 40744
====================================================*/
    public static testMethod void oliInsertNoOther() {
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
            
            Warehouse__c WH=new Warehouse__c();
            WH.Name='Test';
            insert WH;
            
            Inventory__c inv=new Inventory__c();
            inv.Warehouse__c=WH.id;
            inv.Product__c=p.id;
            insert inv;
            System.assertEquals(inv.Warehouse__c, WH.id);
            Inventory_Transaction__c invtr=new Inventory_Transaction__c();
            invtr.name=inv.name;
            invtr.qty__c=3;
            invtr.Inventory__c=inv.id;
            invtr.Transaction_Type__c='Received';
            
            insert invtr;          
            
            Opportunity opp = new Opportunity(Name='Test opp',recordTypeID=SalesRecTypeId, StageName='New', CloseDate=Date.today(),Sales_Order__c=Sales.id,AccountId=[select id from Account where Price_Book__c!=null and Pricebook_Name__c='Standard Price Book' limit 1].id);
                        insert opp;    
            Id opId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Invoice (To Invoice)').getRecordTypeId();
            opp.recordTypeID=opId;
            opp.StageName='sent';
            OpportunityLineItem oli = new OpportunityLineItem(OpportunityId=opp.Id, Quantity=1,Warehouse__c=WH.id,Product2id=p.id, PricebookEntryId=pbe.Id, TotalPrice=50);
            
            insert oli;
            System.assertEquals(oli.Warehouse__c, WH.id);

            opp.Show_Description__c=true;
            update opp;
            opp = [SELECT Other_Product_Qty__c FROM Opportunity WHERE Id = :opp.Id];
            
            system.assertEquals(0, opp.Other_Product_Qty__c);
        
    }
    }