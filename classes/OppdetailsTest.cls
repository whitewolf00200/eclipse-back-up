@isTest(seeAlldata=true)
Public Class OppdetailsTest{
     @isTest Public static void Method1() { 

     List <Opportunity> lstOpportunity = new List<Opportunity>();
     
     Account acc = new Account();
     acc.Name='Test Account1';
     insert acc;
     
     Opportunity newOpp = new Opportunity(Name = 'newOpp',Type = 'New Customer',stageName='Prospecting',CloseDate=Date.Today(),AccountID = acc.id);
     lstOpportunity.add(newOpp);
     
     Opportunity newOpp1 = new Opportunity(Name = 'newOpp',Type = 'New Customer',stageName='Prospecting',CloseDate=Date.Today(),AccountID = acc.id);
     lstOpportunity.add(newOpp1);
     
     insert  lstOpportunity;
     
    Test.startTest();
      Test.setCurrentPage(Page.Export_Opportunity);
      ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(lstOpportunity);
      stdSetController.setSelected(lstOpportunity);
      Oppdetails AccDetails = new Oppdetails(stdSetController);
     Test.stopTest();
   }
}