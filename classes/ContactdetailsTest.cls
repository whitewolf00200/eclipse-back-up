@isTest(seeAlldata=true)
Public Class ContactdetailsTest{
     @isTest Public static void Method1() { 

     List <Contact> lstContact = new List<Contact>();
     
     Contact testContact = new Contact();
     testContact.LastName='Test Account' ;
     lstContact.add(testContact);
     
     Contact testContact1 = new Contact();
     testContact1.LastName='Test Account' ;
     lstContact.add(testContact1);
     
     insert lstContact;
     
    Test.startTest();
      Test.setCurrentPage(Page.Export_Contact);
      ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(lstContact);
      stdSetController.setSelected(lstContact);
      Contactdetails ContactDetails = new Contactdetails(stdSetController);
     Test.stopTest();
   }
}