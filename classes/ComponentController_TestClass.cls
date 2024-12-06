@isTest(SeeAllData=true)
private class ComponentController_TestClass
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
        testMechanicalSheet.System_Type1__c = testVisit.Service_Type__c;         //'Hydrant;';
        testMechanicalSheet.Visit__c=testVisit.id;
        testMechanicalSheet.Technician__c=newEngineer.id;
        testMechanicalSheet.Site__c=newAccount.id;
        testMechanicalSheet.Site_Contract__c=newSiteContract.id;
        testMechanicalSheet.Quantity__c = '4;';
        testMechanicalSheet.Visit_Type__c ='Normal;';
        testMechanicalSheet.Inlet_Location__c = 'XYZ;';
        testMechanicalSheet.Type__c = 'Qwerty;';
        testMechanicalSheet.Cabinet__c = 'box;';
        testMechanicalSheet.Static_Pressure__c= '123;';
        testMechanicalSheet.Time__c= '123;';
        testMechanicalSheet.Final_Pressure__c= '123;';
        testMechanicalSheet.Pipework__c= 'Yes;';
        testMechanicalSheet.Pass_System_Location__c= 'false;';
        testMechanicalSheet.Fail_System_Location__c= 'true;';
        testMechanicalSheet.Outlet_Location_Long__c = 'london,Pass,Pass,Pass,Pass,Pass,Pass,12,21,4,30,12,true,false;paris,Pass,Pass,Pass,Pass,Pass,Pass,12,21,4,30,12,true,false;';
        testMechanicalSheet.System_Location__c= 'london;';
        testMechanicalSheet.No_of_Cycles__c = '2;';
        testMechanicalSheet.Capacity__c = '3;';
        testMechanicalSheet.Agent_Fill__c = '32;';
        testMechanicalSheet.Test_Date__c = '23-02-2014;';
        database.insert(testMechanicalSheet);
    }
    static testMethod void fireSuppressionTest()
    {
        init();
        FSComponentController con = new FSComponentController();
        con.mSSId = testMechanicalSheet.Id;
        con.getSystemLocation();
        
        
    }
    static testMethod void RiserTest()
    {
        init();
        RiserComponentController con = new RiserComponentController();
        con.mSSId = testMechanicalSheet.Id;
        con.getSystemDetails();
        con.getOutletLocations();
        
        
    }
    static testMethod void HydrantTest()
    {
        init();
        testMechanicalSheet.Outlet_Location_Long__c = 'loc1,Pass,Pass,Pass,Pass,Pass,Pass,5,5,5,5,5,true,false;Location2,Pass,Pass,Pass,Fail,Pass,Pass,3,5,5,5,5,true,false;';
        database.update(testMechanicalSheet);
        HydrantComponentController con = new HydrantComponentController ();
        con.mSSId = testMechanicalSheet.Id;
        con.getSystemDetails();
        con.getOutletLocations();
        
        
    }
      
    /* static testMethod void MechSFCertificate()
    {
        init();
        mechSFCertificateController con = new mechSFCertificateController ();
        con.mSSId = testMechanicalSheet.Id;
        con.getSystemLocation();
        
        
    }
    */
    
}