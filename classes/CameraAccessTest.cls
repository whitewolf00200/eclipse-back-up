@isTest(seeAlldata=true)
Public Class CameraAccessTest{
   
   @isTest public static void CameraAccessTest(){
      
   Engineer_Checklist__c  ec=[Select id,Name, Site_Contract__c from Engineer_Checklist__c limit 1];

   ApexPages.CurrentPage().getParameters().put('Id',String.valueOf(ec.id)); 
  
   ApexPages.StandardController sc = new ApexPages.StandardController(ec);
   
   CameraAccess ca=new CameraAccess(sc);
   ca.AttachmentName = 'TestImage';
   Blob bdy=Blob.valueOf('test');
   ca.attachmentObj.Body=bdy;
   ca.saveFile();
   
   }

}