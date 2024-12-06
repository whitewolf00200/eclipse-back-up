@isTest(SeeAllData=true)
private class EmailTriggerWithAttachmentsTest {
    
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        RecordType rec=[SELECT id FROM RecordType WHERE SobjectType=:'Mechanical_Service_Sheet__c' AND Name=:'Sprinkler Service Sheet'];
        
        Engineer__c newEngineer=new Engineer__c();
        newEngineer.Name='Test Engineer';
        insert newEngineer;
        
        Account newAccount=new Account();
        newAccount.Name='Test Account';
        insert newAccount;
        
        SiteContracts__c newSiteContract=new SiteContracts__c();
        newSiteContract.AM_Status__c='Live';
        insert newSiteContract;
        
        Visits__c newVisit=new Visits__c();
        newVisit.Site__c=newAccount.id;
        newVisit.Service_Type__c='Test Type';
        newVisit.Engineer2__c=newEngineer.id;
        newVisit.Site_Contract__c=newSiteContract.id;
        insert newVisit;
        
        Mechanical_Service_Sheet__c newMechanicalServiceSheet=new Mechanical_Service_Sheet__c();
        newMechanicalServiceSheet.Date__c=system.today();
        newMechanicalServiceSheet.Start_Date_and_Time__c=Datetime.now();
        newMechanicalServiceSheet.Technician__c=newEngineer.id;
        newMechanicalServiceSheet.Visit__c=newVisit.id;
        newMechanicalServiceSheet.System_Type__c=newVisit.Service_Type__c;
        newMechanicalServiceSheet.Site__c=newAccount.id; 
        newMechanicalServiceSheet.Email_Confirmation_to__c = 'test@test.com';
        newMechanicalServiceSheet.Email_for_HQ_Notification__c = 'test@test.com';
        newMechanicalServiceSheet.Engineer_s_Email_Address__c = 'test@test.com';
        // insert newMechanicalServiceSheet;
        List<Mechanical_Service_Sheet__c> newListMechanicalServiceSheetList=new List<Mechanical_Service_Sheet__c>();
        newListMechanicalServiceSheetList.add(newMechanicalServiceSheet);
        insert newListMechanicalServiceSheetList;
        
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=newListMechanicalServiceSheetList[0].id;
        insert attach;
        
        Test.startTest();
        EmailTriggerWithAttachmentsController toTestAttachmentsController=new EmailTriggerWithAttachmentsController();
        toTestAttachmentsController.emailAttachmentsMethod(newListMechanicalServiceSheetList);
        EmailTriggerWithAttachmentsController.getRecordTypeId('Sprinkler Service Sheet');
        List<Attachment> attachments=[select id, name from Attachment where parent.id=:newListMechanicalServiceSheetList[0].id];
        toTestAttachmentsController.fetchAttachments(newListMechanicalServiceSheetList[0].id);
        Test.stopTest(); 
    }
}