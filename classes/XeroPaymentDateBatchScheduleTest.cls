@isTest
/*============================================================================================================
*Class Name     : XeroPaymentDateBatchScheduleTest 
*Description    : All the implementations are related to test XeroInvoiceBatchSchedule.
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 
*Version        : 1.0
*Change History : Initial class
*Methods        : static testmethod void schedulerTest()                 
*============================================================================================================*/
private class XeroPaymentDateBatchScheduleTest{
   
/*====================================================
*Method Name     : schedulerTest
*Description     : This method tests XeroPaymentDateBatchSchedule.
*Arguments       : No arguments
*Ticket No       : 
====================================================*/
    static testmethod void schedulerTest(){ 
    
        String CRON_EXP = '0 0 0 15 3 ? *';
        
        // Create your test data
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
        
        Test.startTest();

            String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new XeroPaymentDateBatchSchedule());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);

        Test.stopTest();
        
    }
}