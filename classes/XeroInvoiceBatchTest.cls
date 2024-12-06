@isTest
/*============================================================================================================
*Class Name     : XeroInvoiceBatchTest
*Description    : All the implementations are related test XeroInvoiceBatch.
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 29th Apr, 2020
*Version        : 3.0
*Change History : Warehouse object insertion.
*Methods        : @isTest Public static void XeroInvoiceBatchMethod()
                  @isTest Public static void XeroInvoiceBatchMethod2()
                  
*============================================================================================================*/
Public Class XeroInvoiceBatchTest{
/*====================================================
*Method Name     : XeroInvoiceBatchMethod
*Description     : This method test XeroInvoiceBatch class for success response.
*Arguments       : No Arguments
*Ticket No       : 36814
====================================================*/
     @isTest Public static void XeroInvoiceBatchMethod() { 
         Test.setMock(HttpCalloutMock.class, new MockAuthHttpResponseGenerator()); 
         
        
            Account a = new Account(Name = 'Test Account',Customer_type__c='Dental Practice',Account_Status__c='Live');
            insert a;
            
            Warehouse__c wh=new Warehouse__c();
            wh.name='Test';
            wh.default__c=true;
            insert wh;
        
        
            Opportunity o = new Opportunity();
            o.AccountId = a.Id;
            o.Name = 'Test';
            o.StageName = 'Prospecting';
            o.CloseDate = date.today();   
            o.Type = 'New Business';
            o.Invoice_Date__c=system.today()-6;
            o.Due_Date__c=system.today()-1;
            o.XeroOppId__c='123456INV';
            o.Reference__c=null;
            o.ExpectedPaymentDate__c=null;
            o.PlannedPaymentDate__c=null;
            o.FullyPaidOnDate__c=null;
            o.Amount_Paid__c=0;
            o.AmountCredited__c=0;
            o.Amount_Due__c=0;
            insert o;
        test.starttest();
            XeroInvoiceBatch xero=new XeroInvoiceBatch();
             Database.executeBatch(xero);
         test.stopTest();
      }
/*====================================================
*Method Name     : XeroInvoiceBatchMethod2
*Description     : This method test XeroInvoiceBatch class for failure response.
*Arguments       : No Arguments
*Ticket No       : 36814
====================================================*/   
    @isTest Public static void XeroInvoiceBatchMethod2() {  
        Test.setMock(HttpCalloutMock.class, new MockHttpErrResponseGenerator());
        Account a = new Account(Name = 'Test Account',Customer_type__c='Dental Practice',Account_Status__c='Live');
        insert a;
        Opportunity o = new Opportunity();
            
        o.AccountId = a.Id;
        o.Name = 'Test';
        o.StageName = 'Prospecting';
        o.CloseDate = date.today();
        
        Warehouse__c wh=new Warehouse__c();
        wh.name='Test';
        wh.default__c=true;
        insert wh;
       
        o.Type = 'New Business';
        o.Invoice_Date__c=system.today()-6;
        o.Due_Date__c=system.today()-1;
        o.XeroOppId__c='123456INV';
        insert o;
         
        test.starttest();        
             XeroInvoiceBatch xero=new XeroInvoiceBatch();
             Database.executeBatch(xero);

         test.stopTest();
        }
    
    
}