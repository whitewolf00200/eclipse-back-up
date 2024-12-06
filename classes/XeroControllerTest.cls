@isTest(seeAllData=true)
/*============================================================================================================
*Class Name     : XeroController
*Description    : All the implementations are related to test XeroController.
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 29th Apr, 2020
*Version        : 2.0
*Change History : Xero Migration to 2.0
*Methods        : @isTest Public static void XeroControllerMethod()
                  @isTest Public static void XeroControllerMethod2()
                  @isTest Public static void XeroControllerMethod3()
                  @isTest Public static void XeroControllerMethod4()
                  @isTest Public static void XeroControllerMethod5()
                  @isTest Public static void XeroControllerMethod6()
*============================================================================================================*/
Public Class XeroControllerTest{
/*====================================================
*Method Name     : XeroControllerMethod
*Description     : If Invoice Date null test Xero Controller.
*Arguments       : No Arguments
*Ticket No       : 36814
====================================================*/
     @isTest Public static void XeroControllerMethod() {  
       
        PricebookEntry priceBookEntryNew = new PricebookEntry();
        Product2 product = new Product2(); 
        
        Id pb2= Test.getStandardPricebookId();
        
        product.name = 'Test';
        product.ProductCode='Test';
        product.Nominal_Code__c='Test';
        product.IsActive=true;
        insert product;
        
        priceBookEntryNew.Product2Id = product.Id;
        priceBookEntryNew.PriceBook2Id = pb2;
        priceBookEntryNew.UnitPrice = 20.00;
        priceBookEntryNew.isactive = true;
        insert priceBookEntryNew;
        
        Contact newContact=new Contact(LastName='Test Contact');
        insert newContact;
             
        Account a = new Account(Name = 'Test Account',Customer_type__c='Dental Practice', Account_Status__c ='Live');
        PricebookEntry pbID = [select Id, name from PricebookEntry where isActive = True limit 1];
        Opportunity o = new Opportunity();
        OpportunityLineItem ol = new OpportunityLineItem();
            
        insert a;
    
        o.AccountId = a.Id;
        o.Name = 'Test';
        o.StageName = 'Prospecting';
        o.CloseDate = date.today();
        o.Pricebook2Id=pb2;
        o.Type = 'New Business';
        
        
        insert o;
                 
        OpportunityLineItem oli = new OpportunityLineItem
            (
                OpportunityId = o.Id,
                PricebookEntryId = priceBookEntryNew.Id,
                Quantity = 1,
                UnitPrice = priceBookEntryNew.UnitPrice, 
                ServiceDate = System.today()
            );
         oli.Product2Id=product.id;
         oli.Discount=34;
         insert oli;
         string taxid;
          Xero_Account__c xa=new Xero_Account__c();
          xa.Tax_Type__c='OUTPUT2';
          xa.name='7033';
          insert xa;
          taxid=xa.Tax_Type__c;
      
        test.starttest();
            Test.setMock(HttpCalloutMock.class, new MockAuthHttpResponseGenerator());   
            apexpages.currentpage().getparameters().put('AccIds',String.valueof(a.id));
            apexpages.currentpage().getparameters().put('id',String.valueof(o.id));
            
             XeroController XeroCtrl=new XeroController();
             XeroOAuthUtility auth=new XeroOAuthUtility();
             auth.connectToXero();
            XeroCtrl.ThemesId.add('');
            
             XeroCtrl.CheckConnection();
            XeroCtrl.XeroBrandingTheme();
            XeroCtrl.InsertXero();
             XeroCtrl.PostOpportunity();
             
            XeroCtrl.contacts('Test',true);
            XeroCtrl.PostContact(a.id);
            XeroCtrl.converttoXml(o);
            XeroCtrl.cancel();
        Test.stopTest();
    }
/*====================================================
*Method Name     : XeroControllerMethod2
*Description     : If Invoice due Date null test Xero Controller.
*Arguments       : No Arguments
*Ticket No       : 36814
====================================================*/    
     @isTest Public static void XeroControllerMethod2() {  
       
             
        Account a = new Account(Name = 'Test Account',Customer_type__c='Dental Practice', Account_Status__c ='Live');
        PricebookEntry pbID = [select Id, name from PricebookEntry where isActive = True limit 1];
        Opportunity o = new Opportunity();
        OpportunityLineItem ol = new OpportunityLineItem();
            
        insert a;
    
        o.AccountId = a.Id;
        o.Name = 'Test';
        o.StageName = 'Prospecting';
        o.CloseDate = date.today();
        
        o.Type = 'New Business';
        o.Invoice_Date__c=system.today();
        
        insert o;
                 
        
        string taxid;
          Xero_Account__c xa=new Xero_Account__c();
          xa.Tax_Type__c='OUTPUT2';
          xa.name='7033';
          insert xa;
          taxid=xa.Tax_Type__c;
      
        test.starttest();
            Test.setMock(HttpCalloutMock.class, new MockAuthHttpResponseGenerator());   
            apexpages.currentpage().getparameters().put('AccIds',String.valueof(a.id));
            apexpages.currentpage().getparameters().put('id',String.valueof(o.id));
            XeroController XeroCtrl=new XeroController();
            XeroOAuthUtility auth=new XeroOAuthUtility();
             auth.connectToXero();
             XeroCtrl.ThemesId.add('');
             XeroCtrl.CheckConnection();
             XeroCtrl.XeroBrandingTheme();
             XeroCtrl.InsertXero();
             XeroCtrl.PostOpportunity();
             
        Test.stopTest();
    }
/*====================================================
*Method Name     : XeroControllerMethod3
*Description     : If Invoice date greater than invoice due Date test Xero Controller.
*Arguments       : No Arguments
*Ticket No       : 36814
====================================================*/      
    @isTest Public static void XeroControllerMethod3() {  
        Xero_Account__c xc=new Xero_Account__c();
         xc.Default__c=true;
         xc.Percentage__c=20.00;
         xc.Name__c='200';
         xc.Tax_Type__c='OUTPUT2';
         insert xc;
        
        Account a = new Account(Name = 'Test Account',Customer_type__c='Dental Practice', Account_Status__c ='Live');
        PricebookEntry pbID = [select Id, name from PricebookEntry where isActive = True limit 1];
        Opportunity o = new Opportunity();
        OpportunityLineItem ol = new OpportunityLineItem();
            
        insert a;
    
        o.AccountId = a.Id;
        o.Name = 'Test';
        o.StageName = 'Prospecting';
        o.CloseDate = date.today();
       
        o.Type = 'New Business';
        o.Invoice_Date__c=system.today()+1;
        o.Due_Date__c=system.today();
        insert o;
                 
        
        string taxid;
          Xero_Account__c xa=new Xero_Account__c();
          xa.Tax_Type__c='OUTPUT2';
          xa.name='7033';
          insert xa;
          taxid=xa.Tax_Type__c;
      
        test.starttest();
            Test.setMock(HttpCalloutMock.class, new MockAuthHttpResponseGenerator());   
            apexpages.currentpage().getparameters().put('AccIds',String.valueof(a.id));
            apexpages.currentpage().getparameters().put('id',String.valueof(o.id));
            XeroController XeroCtrl=new XeroController();
            XeroOAuthUtility auth=new XeroOAuthUtility();
            auth.connectToXero();
            XeroCtrl.ThemesId.add('');
            XeroCtrl.CheckConnection();
            XeroCtrl.XeroBrandingTheme();
            XeroCtrl.InsertXero();
            XeroCtrl.PostOpportunity();
         
        Test.stopTest();
    }
/*====================================================
*Method Name     : XeroControllerMethod4
*Description     : If Invoice due Date less than today test Xero Controller.
*Arguments       : No Arguments
*Ticket No       : 36814
====================================================*/     
    @isTest Public static void XeroControllerMethod4() {  
       
        
        Account a = new Account(Name = 'Test Account',Customer_type__c='Dental Practice', Account_Status__c ='Live');
        PricebookEntry pbID = [select Id, name from PricebookEntry where isActive = True limit 1];
        Opportunity o = new Opportunity();
        OpportunityLineItem ol = new OpportunityLineItem();
            
        insert a;
    
        o.AccountId = a.Id;
        o.Name = 'Test';
        o.StageName = 'Prospecting';
        o.CloseDate = date.today();
       
        o.Type = 'New Business';
        o.Invoice_Date__c=system.today();
        o.Due_Date__c=system.today();
        insert o;
                 
        
          string taxid;
          Xero_Account__c xa=new Xero_Account__c();
          xa.Tax_Type__c='OUTPUT2';
          xa.name='7033';
          insert xa;
          taxid=xa.Tax_Type__c;
      
        test.starttest();
            Test.setMock(HttpCalloutMock.class, new MockAuthHttpResponseGenerator());   
            apexpages.currentpage().getparameters().put('AccIds',String.valueof(a.id));
            apexpages.currentpage().getparameters().put('id',String.valueof(o.id));
            XeroController XeroCtrl=new XeroController();
            XeroOAuthUtility auth=new XeroOAuthUtility();
            auth.connectToXero();
            XeroCtrl.ThemesId.add('');
            XeroCtrl.CheckConnection();
            XeroCtrl.XeroBrandingTheme();
            XeroCtrl.InsertXero();
            XeroCtrl.PostOpportunity();
        Test.stopTest();
    }
/*====================================================
*Method Name     : XeroControllerMethod5
*Description     : This method executes when above method not executes, test Xero Controller.
*Arguments       : No Arguments
*Ticket No       : 36814
====================================================*/     
    @isTest Public static void XeroControllerMethod5() {  
       
        
        Account a = new Account(Name = 'Test Account',Customer_type__c='Dental Practice', Account_Status__c ='Live');
        PricebookEntry pbID = [select Id, name from PricebookEntry where isActive = True limit 1];
        Opportunity o = new Opportunity();
        OpportunityLineItem ol = new OpportunityLineItem();
            
        insert a;
    
        o.AccountId = a.Id;
        o.Name = 'Test';
        o.StageName = 'Prospecting';
        o.CloseDate = date.today();
       
        o.Type = 'New Business';
        o.Invoice_Date__c=system.today()-6;
        o.Due_Date__c=system.today()-1;
        insert o;
                 
        
        string taxid;
          Xero_Account__c xa=new Xero_Account__c();
          xa.Tax_Type__c='OUTPUT2';
          xa.name='7033';
          insert xa;
          taxid=xa.Tax_Type__c;
      
        test.starttest();
            Test.setMock(HttpCalloutMock.class, new MockAuthHttpResponseGenerator());   
            apexpages.currentpage().getparameters().put('AccIds',String.valueof(a.id));
            apexpages.currentpage().getparameters().put('id',String.valueof(o.id));
            XeroController XeroCtrl=new XeroController();
            XeroOAuthUtility auth=new XeroOAuthUtility();
            auth.connectToXero();
            XeroCtrl.ThemesId.add('');
            XeroCtrl.CheckConnection();
            XeroCtrl.XeroBrandingTheme();
            XeroCtrl.InsertXero();
            XeroCtrl.PostOpportunity();
        Test.stopTest();
    }
/*====================================================
*Method Name     : XeroControllerMethod6
*Description     : This method mainly for testing converttoXml method in XeroController.
*Arguments       : No Arguments
*Ticket No       : 36814
====================================================*/ 
    @isTest Public static void XeroControllerMethod6() {  
       
        
        Account a = new Account(Name = 'Test Account',Customer_type__c='Dental Practice', Account_Status__c ='Live');
        PricebookEntry pbID = [select Id, name from PricebookEntry where isActive = True limit 1];
        Opportunity o = new Opportunity();
        OpportunityLineItem ol = new OpportunityLineItem();
            
        insert a;
        Xero_Account__c xa=new Xero_Account__c();
        xa.Tax_Type__c='OUTPUT2';
        xa.name='7033';
        insert xa;

        o.AccountId = a.Id;
        o.Name = 'Test';
        o.StageName = 'Prospecting';
        o.CloseDate = date.today();
        o.Xero_Account__c=xa.id;
        o.Type = 'New Business';
        o.Invoice_Date__c=system.today()-6;
        o.Due_Date__c=system.today()-1;
        insert o;
                 
        
        string taxid;
          
        taxid=xa.Tax_Type__c;
      
        test.starttest();
            Test.setMock(HttpCalloutMock.class, new MockAuthHttpResponseGenerator());   
            apexpages.currentpage().getparameters().put('AccIds',String.valueof(a.id));
            apexpages.currentpage().getparameters().put('id',String.valueof(o.id));
            XeroController XeroCtrl=new XeroController();
            XeroOAuthUtility auth=new XeroOAuthUtility();
            auth.connectToXero();
            XeroCtrl.ThemesId.add('');
            XeroCtrl.converttoXml(o);
        Test.stopTest();
    }
    

}