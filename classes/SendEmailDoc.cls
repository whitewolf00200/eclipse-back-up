/*============================================================================================================
*Class Name     : SendEmailDoc
*Description    : All the implementations related to save and send the pdf.
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 2nd Mar, 2020
*Version        : 2.0
*Change History : 
*Methods        : webservice static string saveAndSend(Id Currentid,string action)
                  
*============================================================================================================*/

global class SendEmailDoc
{
    global static string docId;
/*====================================================

*Method Name     : saveAndSend
*Description     : All the implementations related to save and send the pdf.
*Arguments       : Id Currentid,string action
*Ticket No       : 34179
====================================================*/

    webservice static string saveAndSend(Id Currentid,string action)
    { 
        System.debug('<<<<<action>>>>>> '+action);
        PageReference pr;
        String Recname;
        Document doc=new Document();
        Quote acc=[select id,name,RecordType.Name,Version_Number__c,Increase_Version__c from Quote where id=:Currentid];
       
        if(acc.RecordType.Name =='Equipment Proposal'){
            pr = new PageReference('/apex/EquipmentProposal?id='+Currentid);
        }else if(acc.RecordType.Name =='Project Proposal'){
            pr = new PageReference('/apex/ProjectProposal?id='+Currentid);
        }else if(acc.RecordType.Name =='Service Proposal'){
            pr = new PageReference('/apex/ServiceProposal?id='+Currentid);
        }else if(acc.RecordType.Name =='Short Project Proposal'){
            pr = new PageReference('/apex/ShortProjectProposal?id='+Currentid);
        }
        
        //PageReference pr = Page.QuotePage;
        Blob content;
        if(System.Test.isRunningTest()){
         content=Blob.valueof('Test Val');
         }else{
        content = pr.getContentAsPDF();
        }
        
       if(action=='saveandsend')
       {
            doc.AuthorId = UserInfo.getUserId();
            doc.FolderId = UserInfo.getUserId(); 
            doc.body=content;
            System.debug('<<<<<content>>>>>> '+content);
            doc.name=acc.Name+'.pdf';    
            insert doc;
        }
        
        PageReference myPdf;
        
        if(action=='saveandsend' || action=='save'){ 
        if(acc.RecordType.Name =='Equipment Proposal'){
            myPdf = new PageReference('/apex/EquipmentProposal?id='+Currentid);
            if(!Test.isRunningTest())
            content= myPdf.getContent();
        }else if(acc.RecordType.Name =='Project Proposal'){
            myPdf = new PageReference('/apex/ProjectProposal?id='+Currentid);
            if(!Test.isRunningTest())
            content= myPdf.getContent();
        }else if(acc.RecordType.Name =='Service Proposal'){
            myPdf = new PageReference('/apex/ServiceProposal?id='+Currentid);
            if(!Test.isRunningTest())
            content= myPdf.getContent();
        }else if(acc.RecordType.Name =='Short Project Proposal'){
            myPdf = new PageReference('/apex/ShortProjectProposal?id='+Currentid);
            if(!Test.isRunningTest())
            content= myPdf.getContent();
        }       
        
        QuoteDocument docPdfs = new QuoteDocument(Document = content, QuoteId = Currentid);
        system.debug('Currentid>>>>'+Currentid);
        insert docPdfs;
        }
        
        if(action=='cancelQuote' && acc.Increase_Version__c==true){ 
         
                acc.Version_Number__c=acc.Version_Number__c-1;
            
            update acc;
        }else if(action=='cancelQuote' && acc.Increase_Version__c==false && acc.Version_Number__c==1){
               acc.Version_Number__c=acc.Version_Number__c-1;
                update acc;
        }
        
       
        
        return  doc.id; 
                        
    }
}