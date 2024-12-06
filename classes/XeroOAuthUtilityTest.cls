@isTest
/*============================================================================================================
*Class Name     : XeroOAuthUtilityTest
*Description    : All the implementations are related to test XeroOAuthUtilityTest.
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 29th Apr, 2020
*Version        : 1.0
*Change History : Xero Migration to 2.0
*Methods        : TestOAuth()
*============================================================================================================*/

public with sharing class XeroOAuthUtilityTest{
/*====================================================
*Method Name     : TestOAuth
*Description     : Test XeroOAuthUtility class.
*Arguments       : No Arguments
*Ticket No       : 36814
====================================================*/
        public Static TestMethod Void TestOAuth(){    
          Test.setMock(HttpCalloutMock.class, new MockAuthHttpResponseGenerator());   
          Test.StartTest();          
          XeroOAuthUtility auth=new XeroOAuthUtility();
          auth.connectToXero();
          Test.StopTest();
        }
}