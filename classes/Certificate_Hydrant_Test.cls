@isTest(SeeAllData=true)
private class Certificate_Hydrant_Test
{
    static Mechanical_Service_Sheet__c testMechanicalSheet;
    static Visits__c testVisit;
    static Engineer__c newEngineer;
    static Account newAccount;
    static SiteContracts__c newSiteContract;
    public static void init()    
    {
        newEngineer=new Engineer__c();
        newEngineer.Name='Test Engineer';
        database.insert(newEngineer);
        
        newAccount=new Account();
        newAccount.Name='Test Account';
        database.insert(newAccount);
        
        newSiteContract=new SiteContracts__c();
        newSiteContract.AM_Status__c='Live';
        database.insert(newSiteContract);
        
        testVisit = new Visits__c();
        testvisit.Site_Contract__c=newSiteContract.id;
        testVisit.Site__c=newAccount.id;
        testVisit.Engineer2__c=newEngineer.id;
        testVisit.Service_Type__c = 'Test Type';
        database.insert(testVisit);
        
        testMechanicalSheet = new Mechanical_Service_Sheet__c();
        testMechanicalSheet.System_Type__c = testVisit.Service_Type__c;         //'Hydrant;';
        testMechanicalSheet.Visit__c=testVisit.id;
        testMechanicalSheet.Technician__c=newEngineer.id;
        testMechanicalSheet.Site__c=newAccount.id;
        testMechanicalSheet.Site_Contract__c=newSiteContract.id;
        testMechanicalSheet.Outlet_Location_Long__c=';test;test1,test2,test3,teset4,test5;test6';
        /*
        testMechanicalSheet.System_Type__c = 'Hydrant;';
        testMechanicalSheet.Quantity__c = '4;';
        testMechanicalSheet.Visit_Type__c ='Normal;';
        testMechanicalSheet.Inlet_Location__c = 'XYZ;';
        testMechanicalSheet.Type__c = 'Qwerty;';
        testMechanicalSheet.Cabinet__c = 'box;';
        */
        //testMechanicalSheet.Outlet_Location__c = 'london,Pass,Pass,Pass,Pass,Pass,Pass,12,21,4,30,12,true,false;paris,Pass,Pass,Pass,Pass,Pass,Pass,12,21,4,30,12,true,false;';
        database.insert(testMechanicalSheet);
        
    }
    static testMethod void hydrantTest1()
    {
        init();
        PageReference pg = new PageReference('/apex/MechCertificatePreview2?id='+testMechanicalSheet.id);
        Test.setCurrentPageReference(pg);
        ApexPages.StandardController sc = new ApexPages.standardController(testMechanicalSheet);
        MechCertificatePreviewController2 controller = new MechCertificatePreviewController2 (sc);
        //controller.getSystemDetails();
       // controller.getOutletLocations();
        controller.pass=false;
    }
}