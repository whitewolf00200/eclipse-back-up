public with sharing class UploadAttachmentController {
    public Id recordId { get; set; }
    public Blob fileContent { get; set; }
    public String fileName { get; set; }

    public UploadAttachmentController(ApexPages.StandardController controller) {
        this.recordId = controller.getId();
    }

    public PageReference uploadFile() {
        if (fileContent == null || fileName == null || recordId == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a file and ensure the record is valid.'));
            return null;
        }

        try {
            // Create a ContentVersion record
            ContentVersion cv = new ContentVersion();
            cv.Title = fileName;
            cv.PathOnClient = fileName;
            cv.VersionData = fileContent;
            insert cv;

            // Link the uploaded file to the record
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.LinkedEntityId = recordId;
            cdl.ContentDocumentId = [
                SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id
            ].ContentDocumentId;
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';
            insert cdl;

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'File uploaded successfully.'));
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error uploading file: ' + e.getMessage()));
        }

        return null;
    }
}