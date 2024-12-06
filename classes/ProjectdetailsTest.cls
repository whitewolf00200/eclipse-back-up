@isTest(seeAlldata=true)
Public Class ProjectdetailsTest{
     @isTest Public static void Method1() { 

     List <Project__c> lstProject = new List<Project__c>();
     
     Project__c Prj=new Project__c(Name='Test Project');
     lstProject.add(Prj);
     
     Project__c Prj1=new Project__c(Name='Test Project');
     lstProject.add(Prj1);
     
     insert  lstProject;
     
    Test.startTest();
      Test.setCurrentPage(Page.Export_Project);
      ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(lstProject);
      stdSetController.setSelected(lstProject);
      Projectdetails PrjDetails = new Projectdetails(stdSetController);
     Test.stopTest();
   }
}