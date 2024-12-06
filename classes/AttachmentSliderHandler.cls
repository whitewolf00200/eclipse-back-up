public class AttachmentSliderHandler {
    public Id parentRecordId{get;set;}
    
    public List<Attachment> getAttachments(){
   
        return [SELECT id FROM Attachment WHERE ParentId=:parentRecordId  and ContentType = 'image/jpeg'];
    }
}