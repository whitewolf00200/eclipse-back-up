/*============================================================================================================
*Class Name     : XeroPaymentDateBatchSchedule
*Description    : All the implementations are related to schedule XeroPaymentDateBatch.
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 
*Version        : 1.0
*Change History : XeroInvoiceBatch converted from future to Batch Apex.
*Methods        : global void execute(SchedulableContext sc)                 
*============================================================================================================*/
global class XeroPaymentDateBatchSchedule implements schedulable{
/*====================================================
*Method Name     : execute
*Description     : This method executes XeroInvoice Batch class.
*Arguments       : SchedulableContext sc
*Ticket No       : 
====================================================*/
    global void execute(SchedulableContext sc)
    {
      system.debug('calling batch=======');
      XeroPaymentDateBatch xero=new XeroPaymentDateBatch();
      database.executebatch(xero,50);
    }
}