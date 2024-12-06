/*=============================================
*Page Name      : CameraAccess2
*Description    : Photo to be upload by capturing and upload from external source.
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 28th Jan, 2023
*Version        : 1.0
*Ticket No      : 101312
============================================= */
public with sharing class CameraAccess2 {
    public Id ParentId {get; set;}
    public Id recId {get; set;}
    public Blob fileBody { get; set; }
    public String fileName { get; set; }
    public String contentType { get; set; }
      
   
      public CameraAccess2() {
        
       recId= ApexPages.currentPage().getParameters().get('Id');
       PageReference detailPage = new PageReference('/' + recId);
       detailPage.setRedirect(true);
       }
   

    public PageReference uploadFile() {
        if(fileName!=null)
        {
        Attachment attachment = new Attachment();
        attachment.Body = fileBody;
        attachment.Name = fileName;
        attachment.ContentType = contentType;
        attachment.ParentId = recId;
        insert attachment;
        }
        
        PageReference detailPage = new PageReference('/' + recId);
        return detailPage;
    }
    

    public PageReference cancel() {
        PageReference detailPage = new PageReference('/' + recId);
        return detailPage;
    }
    
}