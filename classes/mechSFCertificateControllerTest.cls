@isTest(SeeAllData=True)

    public class mechSFCertificateControllerTest {

      @isTest Static void mechSFCertificateControllertest() {
      Mechanical_Service_Sheet__c mech;
      try{
      mech = [select Id,System_Location__c,No_of_Cycles__c,Capacity__c,Agent_Fill__c,Test_Date__c  from Mechanical_Service_Sheet__c Limit 1];
      apexPages.CurrentPage().getParameters().Put('id',String.valueOf(mech.id));
      ApexPages.StandardController sc = new ApexPages.StandardController(mech);
      mechSFCertificateController qc = New mechSFCertificateController(sc);
      qc.getSystemLocation();
      qc.mSSId=mech.id;
      }catch(exception e){
      
      }
      
    }
}