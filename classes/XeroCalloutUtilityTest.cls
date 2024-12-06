@isTest
/*============================================================================================================
*Class Name     : XeroCalloutUtilityTest
*Description    : All the implementations are related to test XeroCalloutUtility class.
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 29th Apr, 2020
*Version        : 1.0
*Change History : Xero Migration to 2.0
*Methods        : public @isTest static void m1()
*============================================================================================================*/
public class XeroCalloutUtilityTest{
/*====================================================
*Method Name     : m1
*Description     : Test XeroCalloutUtility class.
*Arguments       : No Arguments.
*Ticket No       : 36814
====================================================*/
  public @isTest static void m1(){
     Test.setMock(HttpCalloutMock.class, new MockAuthHttpResponseGenerator());
     Test.StartTest();  
     XeroCalloutUtility.executeCallout('GET','Contacts','Test');
      Test.StopTest();
  }
}