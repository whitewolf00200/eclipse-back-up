@isTest(seeAlldata=true)
Public Class XeroAccountTest{
     @isTest Public static void XeroAccountMethod() {  
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('NameOfStaticResourceContainingResponseBodyString');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
 
        Account a=[select id from Account limit 1];
        
        XeroAccount XeroAcc=new XeroAccount();
        XeroAcc.createAccount(a.id);
        }
}