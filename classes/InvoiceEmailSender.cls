public with sharing class InvoiceEmailSender {
    
    public class Request {
        @InvocableVariable(required=true)
        public Id primaryOpportunityId;
    }
    
    @InvocableMethod(label='Send Merged Invoice' description='Sends the merged invoice with M&R sheets for the given opportunities.')
    public static void sendInvoiceEmail(List<Request> requestList) {
       
        for (Request req : requestList) {
            Id primaryOpportunityId = req.primaryOpportunityId;
            
           
            List<Linked_Maintenance_Sheet__c> linkedSheets = [
                SELECT Id, Opportunity__c, Maintenance_Reactive_Sheet__c 
                FROM Linked_Maintenance_Sheet__c 
                WHERE Opportunity__c = :primaryOpportunityId
            ];
            
           
            Opportunity opportunity = [
                SELECT Id, InvoiceEmailTo__c, HQ_Invoice_Email_To__c
                FROM Opportunity
                WHERE Id = :primaryOpportunityId
                LIMIT 1
            ];
            
            List<String> emailAddresses = new List<String>();
            
           
            if (opportunity.InvoiceEmailTo__c != null) {
                emailAddresses.add(opportunity.InvoiceEmailTo__c);
            }
            if (opportunity.HQ_Invoice_Email_To__c != null) {
                emailAddresses.add(opportunity.HQ_Invoice_Email_To__c);
            }            
           
            if (!linkedSheets.isEmpty()) {
                sendInvoiceWithMRSheetPDFs(linkedSheets, primaryOpportunityId, emailAddresses, opportunity);
            }
        }
    }
    
    private static void sendInvoiceWithMRSheetPDFs(List<Linked_Maintenance_Sheet__c> linkedSheets, Id primaryOpportunityId, List<String> emailAddresses, Opportunity opportunity) {
        
       
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSubject('Invoice with M&R Sheets');
        
       
        email.setToAddresses(emailAddresses);
        
       
        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
        
        
        Set<Id> mrSheetIds = new Set<Id>();
        for (Linked_Maintenance_Sheet__c sheet : linkedSheets) {
            if (sheet.Maintenance_Reactive_Sheet__c != null) {
                mrSheetIds.add(sheet.Maintenance_Reactive_Sheet__c);
            }
        }
        
        
        for (Id mrSheetId : mrSheetIds) {
            PageReference pdfPage = Page.Service_Call_Page; 
            pdfPage.getParameters().put('id', mrSheetId); 
            
            Blob pdfBlob;
            
            
            if (!Test.isRunningTest()) {
                pdfBlob = pdfPage.getContentAsPDF();
            } else {
                
                pdfBlob = Blob.valueOf('Test PDF Content');
            }
            
            Messaging.EmailFileAttachment pdfAttachment = new Messaging.EmailFileAttachment();
            pdfAttachment.setFileName('MR_Sheet_' + mrSheetId + '.pdf');
            pdfAttachment.setBody(pdfBlob);
            pdfAttachment.setContentType('application/pdf');
            
            attachments.add(pdfAttachment);
        }
        
        
        sendInvoicePDF(primaryOpportunityId, attachments);
        
      
        String htmlBody = '<messaging:htmlEmailBody>' +
            '<style>' +
            'body {font-family:Verdana;font-size: 14px;}' +
            '</style>' +
            '<table border="0" cellspacing="0" cellpadding="0" width="100%" id="table1">' +
            '<td>' +
            '<div style="font-size:13px;font-family:Verdana;">' +
            'Dear Sir/Madam,<br/><br/>' +
            '<p>Thank you for your business it is greatly appreciated.</p>' +
            '<p>Please find attached your invoice. This is due for payment by return. Please make the payment into the bank details shown on the invoice or call us to pay by card.</p>' +
            '<p>If you have any queries regarding your invoice please contact either the Accounts team on accounts@eclipse-dental.com or the Service team on service@eclipse-dental.com</p>' +
            '<p>Please be free to contact us with your feedback. We are always looking to improve our services and your thoughts and comments are very valuable.</p>' +
            '<p>We look forward to working with you again soon.</p>' +
            'Kind Regards' +
            '</div>' +
            '</td>' +
            '</table>' +
            '<br/>' +
            '<table>' +
            '<tr>' +
            '<td style=" font-family:Verdana;color: #48164d; font-size:16px; "><b>Service Department</b><br/>' +
            '<strong style="color:#696969;font-weight:normal;font-size:11px;">DDI </strong>' +
            '<strong style="color:#696969;font-size:12px;"> 01322 421156 | <a style="font-size:13px;color:#696969;text-decoration: none;" href="http://service@eclipse-dental.com">service@eclipse-dental.com</a></strong>' +
            '</td>' +
            '</tr>' +
            '<tr>' +
            '<td style="font-family:Verdana;color: #48164d;font-size:13px;"><br/><b>Eclipse Dental Engineering Ltd</b><br/>' +
            '<strong style="font-weight:normal;color:#696969;font-size:10px;">Westview Court  10-14 Kent Road  Dartford  Kent  DA1 2AJ</strong>' +
            '</td>' +
            '</tr>' +
            '<tr>' +
            '<td style="font-family:Verdana;color: #696969;font-size:12px;">Tel:' +
            '<strong style="font-size:12px;color:#48164d;">01322 292222&nbsp;&nbsp;&nbsp;<a style="color:#48164d;text-decoration: none;" href="http://www.eclipse-dental.com">www.eclipse-dental.com</a>' +
            '</strong>' +
            '</td>' +
            '</tr>' +
            '<tr>' +
            '<td style="font-family:Verdana;"> <a  href="https://eclipse-dental.com/service/maintenance/"><apex:image id="Email_Template" width="520px" value="https://eclipse-dental--unifier.sandbox.file.force.com/servlet/servlet.ImageServer?id=0157Z000001KJlL&oid=00D4E0000008dLf&lastMod=1674233642000" /></a></td>' +
            '</tr>' +
            '<tr>' +
            '<td><p style="text-align:justify"><font style="font-family:Verdana;font-size:10px;background:white">This e-mail is confidential and may also be legally privileged. If you are not the intended recipient, please contact us. The sender does not accept any responsibility for any interception, loss, late arrival or incompleteness with any of the information contained in this email or for its incorrect delivery or non-delivery. Any statements presented are solely those of the author and do not necessarily represent those of the company.</font></p></td>' +
            '</tr>' +
            '</table>' +
            '</messaging:htmlEmailBody>';
        
        email.setHtmlBody(htmlBody);
        email.setFileAttachments(attachments);
        
      
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
    }
    
   
    private static void sendInvoicePDF(Id primaryOpportunityId, List<Messaging.EmailFileAttachment> attachments) {
        
        PageReference invoicePage = Page.Invoice; 
        invoicePage.getParameters().put('id', primaryOpportunityId); 
        
        Blob invoicePdfBlob;
        
        
        if (!Test.isRunningTest()) {
            invoicePdfBlob = invoicePage.getContentAsPDF();
        } else {
           
            invoicePdfBlob = Blob.valueOf('Test Invoice PDF Content');
        }
        
      
        Messaging.EmailFileAttachment invoiceAttachment = new Messaging.EmailFileAttachment();
        invoiceAttachment.setFileName('Invoice_' + primaryOpportunityId + '.pdf');
        invoiceAttachment.setBody(invoicePdfBlob);
        invoiceAttachment.setContentType('application/pdf');
        
     
        attachments.add(invoiceAttachment);
    }
}