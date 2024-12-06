/* Class Name : EmailTriggerWithAttachmentsController.
Purpose : Controller for EmailTriggerWithAttachments Trigger,To Send a VF Template and attachments from Notes and Attachments.
Author : Sachin Chincholi , Version : 1.0 ;
Created Date : 
Last Modified Date : 
*/
public class EmailTriggerWithAttachmentsController{
    
    // ****** Attributes ******
    public static EmailTriggerWithAttachmentsController instance;
    private List<Attachment> listOfAttachments;
    private EmailTemplate templateId;
    private List<String> toAddresses = new List<String>();
    private Map<Id,List<String>> mapOfMechIdEmailFields;
    private List<String> liOfEmails;
    private List<Attachment> liofAttachments= new List<Attachment>();
    private Map<id,List<Attachment>> mapMSSIdAttachments = new map<id,List<Attachment>>();
    private List<Messaging.Emailfileattachment> fileAttachments;
    private  Messaging.SingleEmailMessage mail;
    private list<Messaging.Singleemailmessage>  lEmailMessageList = new list<Messaging.Singleemailmessage>();
    
    private Static Final  String TEMPLATE_NAME = 'Storm water Report - Copy';
    private static final String SOBJECT_NAME = 'Mechanical_Service_Sheet__c';
    
    // ****** Singleton Pattern ******
    public static emailTriggerWithAttachmentsController getInstance(){
        if(instance == null){
            instance = new emailTriggerWithAttachmentsController();
        }
        return instance;    
    }
    
    // ** Generic Method to get RecordTypeId's with Sobject Name
    public static String getRecordTypeId(String recordTypeName){
        List<RecordType> rtypes = [SELECT Name, id FROM RecordType WHERE sObjectType=:SOBJECT_NAME and isActive=true];
        Map<String, String> mssRecTypes = new Map<String, String>();
        for(RecordType rt: rtypes){
        mssRecTypes.put(rt.name, rt.id);
        }
        return mssRecTypes.get(recordTypeName); 
    }
    
    
    // ****** Method to Send Email ******
    public void emailAttachmentsMethod(List<Mechanical_Service_Sheet__c> listOfMSS){
        mapOfMechIdEmailFields = new Map<Id,List<String>>();
        try{
        templateId = [Select id from EmailTemplate where name = : TEMPLATE_NAME];
        
        }
        catch(QueryException e){
            System.debug('****'+e.getMessage());
        }
        catch(Exception e){
            System.debug('****'+e.getMessage());
        }
        try{     
        for(Mechanical_Service_Sheet__c ms : [SELECT Ownerid, Email_Confirmation_to__c,Email_for_HQ_Notification__c,Engineer_s_Email_Address__c from Mechanical_Service_Sheet__c where Id IN :listOfMSS]){
            liOfEmails = new List<String>();
            if(ms.Email_Confirmation_to__c !=null){
                liOfEmails.add(ms.Email_Confirmation_to__c);
            }
            if(ms.Email_for_HQ_Notification__c!=null){ 
                liOfEmails.add(ms.Email_for_HQ_Notification__c);
            }
            if(ms.Engineer_s_Email_Address__c!=null){ 
                liOfEmails.add(ms.Engineer_s_Email_Address__c);
            }
            mapOfMechIdEmailFields.put(ms.id,liOfEmails);
            
            mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(mapOfMechIdEmailFields.get(ms.id));
            mail.setWhatId(ms.Id);
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setTargetObjectId(ms.OwnerId);
            mail.setTemplateId(templateId.id);
            mail.setSaveAsActivity(false);  
            mail.setFileAttachments(fetchAttachments(ms.id));
            lEmailMessageList.add(mail);
        }
        }
        catch(QueryException e){
             System.debug('****'+e.getMessage());
        }
        catch(Exception e){
            System.debug('****'+e.getMessage());
        }
        
        // ****** Send Email ******
        try{
            if(!lEmailMessageList.isEmpty()){
            Messaging.sendEmail(lEmailMessageList);   
            }
        }catch(EmailException emailExc){
            System.debug(emailExc.getMessage()+'### Email Not Sent, Exception Handled');
        }
    }
    
    // ****** Helper method to Fetch Email File Attachments ******
    @Testvisible private List<Messaging.Emailfileattachment> fetchAttachments(ID recordId){
         fileAttachments = new List<Messaging.Emailfileattachment>();
         if(recordId != null || recordId!=''){
         try{
            for (Attachment a : [select Name,ParentId, Body, BodyLength from Attachment where ParentId = :recordId])
            {
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                efa.setFileName(a.Name);
                efa.setBody(a.Body);
                fileAttachments.add(efa);
            }
            }
            catch(Exception e){
                System.debug(e.getMessage()+'** Exception in Attachments **');
            }
         }
         return fileAttachments;
    }
}