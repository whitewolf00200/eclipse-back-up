public class CameraAccess{
    
    public Attachment attachmentObj {get;set;}
    public String AttachmentName {get;set;}
    public String currentRecordId;
    
    public CameraAccess(ApexPages.StandardController controller) {
                attachmentObj = new Attachment();
                currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
    }


    public PageReference saveFile()
    {    

        system.debug('****attachmentObj****'+attachmentObj );
        attachmentObj.ParentId = currentRecordId  ;
        attachmentObj.Name = AttachmentName +'.jpg';
        insert attachmentObj;
        return new PageReference('/' + currentRecordId  );
    }
}