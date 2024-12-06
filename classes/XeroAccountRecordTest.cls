@isTest(seeAlldata=true)
Public Class XeroAccountRecordTest{
     @isTest Public static void XeroAccountRecordMethod() {  
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('AccountXmlsResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
 
        Account a=[select id from Account limit 1];
        
        XeroAccountRecord.XeroAccountRecord();
        }
}