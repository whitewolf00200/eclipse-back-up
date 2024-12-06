@isTest(SeeAllData=True)
Public class AttachmentSliderHandlerTest{

    @isTest public static void AttachmentSliderHandler_Test(){
    
    Engineer_Checklist__c  SSheet=[Select id,Name, Site_Contract__c from Engineer_Checklist__c limit 1];
   
     AttachmentSliderHandler Att=New AttachmentSliderHandler();
     
    Att.parentRecordId=SSheet.id;
    Att.getAttachments();
    }


}