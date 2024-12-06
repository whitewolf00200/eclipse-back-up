@isTest(SeeAllData=true)
public class VisitAlertPageController_Test{
 
  @isTest(SeeAllData=true)
  public static void CheckAvailabilityWarnings()
    {
        Visits__c vistrecord = [select id,Engineer2__c,Actual_Service_Date__c,End_Date__c,Site__c,Site_Contract__c,Booked_with_Customers__c  
                                FROM Visits__c 
                                limit 1];
        PageReference pageRef =  Page.VisitWarningAlerts;
        //vistrecord.Booked_with_Customers__c ='Booked Via Schedule'; 
        Test.setCurrentPage(pageRef); 
        apexpages.currentpage().getParameters().put('id', String.valueOf(vistrecord.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(vistrecord );
        VisitAlertPageController vp = new VisitAlertPageController (sc);
        
         
    }
    
    
}