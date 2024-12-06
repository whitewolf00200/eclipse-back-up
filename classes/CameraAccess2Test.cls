/*=============================================
*Page Name      : CameraAccess2Test
*Description    : Test sample data for coverage the class.
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 28th Jan, 2023
*Version        : 1.0
*Ticket No      : 101312
=============================================*/
@isTest
private class CameraAccess2Test {
    
    static testMethod void testUploadFile() {
     /*   Service_Sheet_STD__c sheet = new Service_Sheet_STD__c();
        insert sheet;*/
        
        PageReference pageRef = new PageReference('/apex/CameraAccess2');
        Test.setCurrentPage(pageRef);
        CameraAccess2 camera = new CameraAccess2();
        camera.recId = 'a0d4I00000RaNnB';
        camera.fileName = 'test.jpg';
        camera.contentType = 'image/jpeg';
        camera.fileBody = Blob.valueOf('Test Image Body');
        camera.uploadFile();
        
        Attachment attachment = [SELECT Id, Name, ContentType, ParentId FROM Attachment WHERE ParentId = :camera.recId];
        System.assertEquals(attachment.Name, 'test.jpg');
        System.assertEquals(attachment.ContentType, 'image/jpeg');
        System.assertEquals(attachment.ParentId, camera.recId);
    }
}