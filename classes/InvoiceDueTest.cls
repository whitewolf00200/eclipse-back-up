@isTest (seeAllData=true)
private class InvoiceDueTest{

    public static testMethod void method1() {
            Product2 p = new Product2(Name='test other', IsActive=true,ProductCode = OpportunityLineItemHandler.OTHER_CODE,UniqueSageCode__c='test2',Product_Name_Check__c='10 Person First Aid Kit Product 2_test2');
            insert p;
            
          //  Pricebook2 standardPB = [select id from Pricebook2 where isStandard=false limit 1];
           Id standardPB = Test.getStandardPricebookId();
           
            
          //  PricebookEntry pbe = [select id,Pricebook2Id,Product2Id from PricebookEntry where Product2Id=:p.id limit 1];
               PricebookEntry pbe = new PricebookEntry(UnitPrice=50, Pricebook2Id=standardPB, Product2Id=p.Id, IsActive=true);
            insert pbe;
            
            Account acc=new Account();
            acc.name='test';
            acc.Price_Book__c=standardPB;
            acc.Price_List_Correct__c=system.today();
            acc.Due_Days__c=10;
            insert acc;
            
         
                       
            Opportunity opp = new Opportunity(Name='Test opp',Amount_Due__c=20,Due_Date__c=system.today()-1, StageName='New', CloseDate=Date.today(),AccountId=acc.id);
            insert opp;
            
            OpportunityLineItem oli = new OpportunityLineItem(OpportunityId=opp.Id, Quantity=1, PricebookEntryId=pbe.Id, TotalPrice=50);
            
            insert oli;
            
            Opportunity opp1 = new Opportunity(Name='Test opp',Amount_Due__c=20,Due_Date__c=system.today()-32, StageName='New', CloseDate=Date.today(),AccountId=acc.id);
            insert opp1;
            
              PageReference pageRef = Page.InvoiceDue ;
                Test.setCurrentPage(pageRef);
                pageRef.getParameters().put('Id', String.valueOf(acc.Id));
                ApexPages.StandardController sc = new ApexPages.StandardController(acc);
                InvoiceDue inv =new InvoiceDue(sc);

     
            
           
            
            
        
    }
    }