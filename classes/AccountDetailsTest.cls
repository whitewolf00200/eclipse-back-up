@isTest(seeAlldata=true)
Public Class AccountDetailsTest{
     @isTest Public static void Method1() { 

     List <Account> lstAccount = new List<Account>();
     
     Account testAccount = new Account();
     testAccount.Name='Test Account' ;
     lstAccount.add(testAccount);
     
     Account testAccount1 = new Account();
     testAccount1.Name='Test Account1' ;
     lstAccount.add(testAccount1);
    
     insert  lstAccount;
     
    Test.startTest();
      Test.setCurrentPage(Page.Export_Account);
      ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(lstAccount);
      stdSetController.setSelected(lstAccount);
      AccountDetails AccDetails = new AccountDetails(stdSetController);
     Test.stopTest();
   }
}