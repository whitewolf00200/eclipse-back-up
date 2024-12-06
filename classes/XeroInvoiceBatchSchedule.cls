/*============================================================================================================
*Class Name     : XeroInvoiceBatchSchedule 
*Description    : All the implementations are related to schedule XeroInvoiceBatch.
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 9th Nov, 2016
*Version        : 2.0
*Change History : XeroInvoiceBatch converted from future to Batch Apex.
*Methods        : global void execute(SchedulableContext sc)                 
*============================================================================================================*/
global class XeroInvoiceBatchSchedule implements schedulable{
/*====================================================
*Method Name     : execute
*Description     : This method executes XeroInvoice Batch class.
*Arguments       : SchedulableContext sc
*Ticket No       : 46671
====================================================*/
    global void execute(SchedulableContext sc)
    {
      system.debug('calling batch=======');
      XeroInvoiceBatch xero=new XeroInvoiceBatch();
      database.executebatch(xero,50);
    }
}