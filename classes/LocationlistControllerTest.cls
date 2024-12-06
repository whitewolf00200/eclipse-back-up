@isTest(SeeAllData=true)
private class LocationlistControllerTest 
{
   
    static Location_List__c testLocationList;
    @isTest public static void init()
    {
        testLocationList = new Location_List__c ();
       
        testLocationList .Location_Description__c= 'location;';
        testLocationList .Area__c= 'chennai;';
        testLocationList .Zone__c='5;';
        testLocationList .Asset_Type__c= 'XYZ;';
      
       
        
        database.insert(testLocationList );
        
    }
    static testMethod void Locationtest()
    {
        init();
        PageReference pg = new PageReference('/apex/Locationlist?id='+testLocationList.id);
        Test.setCurrentPageReference(pg);
        ApexPages.StandardController sc = new ApexPages.standardController(testLocationList);
        LocationlistController controller = new LocationlistController (sc);
        //controller.getSystemDetails();
        controller.getItems();
        controller.getValue();
        
        controller.setZone(controller.getZone());
        controller.setassettyp (controller.getassettyp());
        controller.getSystemLocation();
        controller.addSystemLocations();
        //controller.saveSystemDetails();
        controller.editSystemLocations();
        controller.saveSystemLocations();
        controller.remove();
    }
}