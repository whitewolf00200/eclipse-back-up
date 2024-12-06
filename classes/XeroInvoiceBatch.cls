/*============================================================================================================
*Class Name     : XeroInvoiceBatch
*Description    : All the implementations are related Xero values will be collected from Xero Invoice and update to Opportunity fields.
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 29th Apr, 2020
*Version        : 3.0
*Change History : In Xero Migration to 2.0 there is a bug fixed for field update from response.
*Methods        : global Database.QueryLocator start(Database.BatchableContext BC)
                  global void execute(Database.BatchableContext BC, List<Opportunity> scope)
                  global void finish(Database.BatchableContext BC)
                  private static Date dateGenerator(String received)
                  private static Date StringToDate(String received)
*============================================================================================================*/
global class XeroInvoiceBatch implements Database.Batchable<sObject>,Database.AllowsCallouts{
/*====================================================
*Method Name     : start
*Description     : This methods collects unpaid invoices from salesforce.
*Arguments       : Database.BatchableContext BC
*Ticket No       : 46671
====================================================*/
         global Database.QueryLocator start(Database.BatchableContext BC){    
             String query = system.label.BatchQuery; //'SELECT Id,XeroOppId__c from opportunity where XeroOppId__c!=null and FullyPaidOnDate__c=null';       
             return Database.getQueryLocator(query);
         }
         
/*====================================================
*Method Name     : execute
*Description     : This methods process unpaid invoices from salesforce to xero.Collects data from xero and updates in salesforce opportunity
*Arguments       : Database.BatchableContext BC, List<Opportunity> scope
*Ticket No       : 46671
====================================================*/

         
         global void execute(Database.BatchableContext BC, List<Opportunity> scope){ 
            system.debug(scope.size());            
            List<Opportunity> OppList=new List<Opportunity>();
            List<String> InvId=new List<String>();
            List<Id> opportunityIds=new List<Id>();
            
            Map<Id,List<OpportunityLineItem>> OLI=new Map<Id,List<OpportunityLineItem>>();
            String XeroInvoiceId;
            List<OpportunityLineItem> Del=new List<OpportunityLineItem>();
            List<OpportunityLineItem> UpdateOLI=new List<OpportunityLineItem>();
            boolean InvoiceSent;
            String invoiceId;
            XeroInvoiceId='';
            Dom.Document doc;            
            Dom.XMLNode Inv; 
            Boolean loadeddate=false;
            String dateformat;
            String tenantId;
            string Respbody;
            string lastpay;
            string PayID;
            set<string>Payidset = new set<string>();
            set<string> getdate = new set<string>();
            
            try{
            
            for(Opportunity Opp:scope){
                 XeroInvoiceId+=Opp.XeroOppId__c+',';
                 opportunityIds.add(Opp.id);
            }
            
            for(Xero_Setting__mdt xero:[select id,Quickbook_date_format__c from Xero_Setting__mdt where Quickbook_date_format__c !=null  limit 1]){
                 dateformat=xero.Quickbook_date_format__c ;
                 loadeddate=true;
                 system.debug('dateformat=========='+dateformat);  
              }
            
            XeroInvoiceId=XeroInvoiceId.removeEnd(',');
            system.debug('XeroInvoiceId==========='+XeroInvoiceId);
            system.debug('opportunityIds---'+opportunityIds.size()+'-->'+opportunityIds);
            
            XeroBatchDate__c xeroUpdateManual = XeroBatchDate__c.getInstance();
            //Get tenantId after authorize
            XeroOAuthUtility  auth=new XeroOAuthUtility();
            tenantId=auth.connectToXero();
            HttpResponse response =new HttpResponse();
            HttpRequest request = new HttpRequest();
            request.setMethod('GET');
            request.setEndpoint('callout:XeroDev/api.xro/2.0/Invoices?IDs='+XeroInvoiceId);

            if(!loadeddate){
                Datetime today=system.now();
                Datetime cureentweek=today.adddays(-7);
                system.debug('cureentweek=========='+cureentweek);
                Integer day=cureentweek.day();
                String dayname=cureentweek.format('EEEE');
                String shortdayname=dayname.left(3);
                Integer year=cureentweek.year();
                String monthName= cureentweek.format('MMMMM');
                String shortmonthName=monthName.left(3);
                String extracttime = cureentweek.format('HH:mm:ss');
                dateformat=shortdayname+','+' '+day+' '+shortmonthName+' '+year+' '+extracttime+' '+'GMT';
                system.debug('Xerodateformat=========='+dateformat);

            }
           // request.setHeader('If-Modified-Since', +dateformat);
            request.setHeader('xero-tenant-id', tenantid);
            
            
           
            Http h=new Http();
            response=h.send(request);
            system.debug('response>>>>>>>>>>'+response);
            
            if(response.getStatusCode()==200){
                  JSONParser parser = JSON.createParser(response.getBody());
                  while (parser.nextToken() != null) {
                  system.debug(parser.nextToken());
                     if(parser.getCurrentName() == 'Invoices') {
                         while (parser.nextToken() != null) {
                             if(parser.getCurrentName() == 'InvoiceID'){                                        
                                parser.nextValue();
                                InvId.add(parser.getText());
                             }
                          }
                      }
                   } 
            }else{
                     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                     string SupportMail = Label.Support_Mail;
                     String[] toAddresses = new String[] {SupportMail };
                     mail.setToAddresses(toAddresses);
                     mail.setSubject('Xero Response Error');
                     mail.setPlainTextBody('The Xero Apex job processed Success' +response.getStatusCode()+'Status: '+response.getStatus()+' Xero Ids'+XeroInvoiceId);
                     Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
            
            Map<String,List<Opportunity>> OppMap=new Map<String,List<Opportunity>>();
            system.debug(InvId);
            system.debug(response.getBody());
            for(Opportunity Opp:[SELECT Id, Name,StageName,Reference__c,Date_last_payment_received__c,ExpectedPaymentDate__c,PlannedPaymentDate__c,FullyPaidOnDate__c, Amount_Paid__c,AmountCredited__c, Amount_Due__c,XeroOppId__c from opportunity where XeroOppId__c IN:InvId and id in:opportunityIds  and FullyPaidOnDate__c=null]){
                if(OppMap.containskey(Opp.XeroOppId__c))
                OppMap.get(Opp.XeroOppId__c).add(Opp);
                else
                OppMap.put(Opp.XeroOppId__c,new List<Opportunity>{Opp});
            }
            system.debug(OppMap);
            JSONParser parser = JSON.createParser(response.getBody());
            
            Respbody = response.getBody();
            system.debug('Respbody >>'+Respbody );
            
              while (parser.nextToken() != null) {
                if(parser.getCurrentName() == 'Invoices') {
                  while (parser.nextToken() != null) {
                      
                      if(parser.getCurrentName() == 'InvoiceID'){
                           invoiceId=parser.getText();    
                           if(OppMap.containskey(invoiceId)){
                              for(Opportunity Opp:OppMap.get(invoiceId)){
                                     system.debug(invoiceId);                                
                                     while(parser.nextToken()!=null && parser.getCurrentName()!='Type'){
                                             
                                           parser.nextToken();
                                           
                                           system.debug('111> '+parser.getCurrentName());
                                            
                                           if(parser.getCurrentName()=='AmountDue'){
                                               //system.debug(parser.nextValue());
                                               system.debug('AMDue>'+parser.getText());                                               
                                               opp.Amount_Due__c=parser.getDecimalValue();
                                               System.debug('9-->'+opp.id+'---'+opp.Amount_Due__c);
                                               
                                             }
                                           if(parser.getCurrentName()=='AmountPaid'){ 
                                               system.debug(parser.getText());                                              
                                               Opp.Amount_Paid__c=parser.getDecimalValue();
                                               System.debug('8-->'+opp.id+'---'+opp.Amount_Paid__c);
                                            }
                                            if(parser.getCurrentName()=='AmountCredited'){
                                               
                                               Opp.AmountCredited__c=parser.getDecimalValue();
                                               System.debug('7-->'+opp.id+'---'+opp.AmountCredited__c);
                                             }
                                            if(parser.getCurrentName()=='SentToContact'){
                                              
                                              if(parser.getText()=='true')
                                                 Opp.Invoice_Sent_to_Client__c=true;
                                              else
                                               Opp.Invoice_Sent_to_Client__c=false;
                                              System.debug('6-->'+opp.id+'---'+opp.Invoice_Sent_to_Client__c);
                                            }
                                            
                                            
                                            if(parser.getCurrentName()=='CreditNotes'){
                                               parser.skipChildren();
                                            }
                                            
                                            if(parser.getCurrentName()=='Overpayments'){
                                                system.debug(parser.nexttoken());
                                                parser.skipChildren();
                                                
                                            }
                                            
                                            if(parser.getCurrentName()=='Contact'){
                                                system.debug(parser.nexttoken());
                                                parser.skipChildren();
                                                
                                            }
                                            
                                            if(parser.getCurrentName()=='LineItems'){
                                                system.debug(parser.nexttoken());
                                                parser.skipChildren();
                                                
                                            }
                                            
                                            
                                            
                                            if(parser.getCurrentName()=='DateString'){                                                 
                                                  
                                                  parser.nextvalue();
                                                  Opp.Invoice_Date__c=StringToDate(parser.getText());
                                                  System.debug('5-->'+opp.id+'---'+opp.Invoice_Date__c);
                                               }
                                             if(parser.getCurrentName()=='DueDateString'){
                                                 
                                                 Opp.Due_Date__c=StringToDate(parser.getText());
                                                 System.debug('4-->'+opp.id+'---'+opp.Due_Date__c);
                                               }
                                                                                             
                                                 
                                                 if(parser.getCurrentName()=='ExpectedPaymentDateString'){
                                                   
                                                  
                                                   Opp.ExpectedPaymentDate__c=StringToDate(parser.getText());
                                                   System.debug('3-->'+opp.id+'---'+opp.ExpectedPaymentDate__c);
                                                 }
                                                 
                                                 if(parser.getCurrentName()=='PlannedPaymentDateString'){
                                                  
                                                  Opp.PlannedPaymentDate__c=StringToDate(parser.getText());
                                                  System.debug('2-->'+opp.id+'---'+opp.PlannedPaymentDate__c);
                                                }
                                                 
                                                 if(parser.getCurrentName()=='FullyPaidOnDate'){
                                                     if(!Test.isRunningTest()){
                                                       
                                                       parser.nextValue();
                                                       Opp.FullyPaidOnDate__c=dateGenerator(parser.getText());
                                                       System.debug('1-->'+opp.id+'---'+opp.FullyPaidOnDate__c);
                                                     }
                                              }
                                              
                                             
                                                                                       
                                      }
                                      
                                      System.debug('OPPID>>'+opp.id+'---'+'Due>> '+opp.Amount_Due__c);
                                      System.debug('OPPID>>'+opp.id+'---'+'Paid>> '+opp.Amount_Paid__c);
                                      System.debug('OPPID>>'+opp.id+'---'+'Cred>> '+opp.AmountCredited__c);
                                      System.debug('OPPID>>'+opp.id+'---'+'cli>> '+opp.Invoice_Sent_to_Client__c);
                                      System.debug('OPPID>>'+opp.id+'---'+'invd>> '+opp.Invoice_Date__c);
                                      System.debug('OPPID>>'+opp.id+'---'+'ADue>> '+opp.Amount_Due__c);
                                      System.debug('OPPID>>'+opp.id+'---'+'ADue>> '+opp.Due_Date__c);
                                      System.debug('OPPID>>'+opp.id+'---'+'ADue>> '+opp.ExpectedPaymentDate__c);
                                      System.debug('OPPID>>'+opp.id+'---'+'ADue>> '+opp.PlannedPaymentDate__c);
                                      System.debug('OPPID>>'+opp.id+'---'+'ADue>> '+opp.FullyPaidOnDate__c);
                                      System.debug('Date_last_payment_received__c##-->'+opp.id+'---'+opp.Date_last_payment_received__c);
                                      OppList.add(Opp);
                                    
                               }
                            }
                     }
                  }
                }
            }           
             
             system.debug('OppList>>'+OppList.size()+'>>>>'+OppList);
             if(OppList.size()>0){
                 try{
                     update OppList;
                     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                     string SupportMail = Label.Support_Mail;
                     String[] toAddresses = new String[] {SupportMail };
                     mail.setToAddresses(toAddresses);
                     mail.setSubject('Apex Job Execution Success');
                     mail.setPlainTextBody('The Xero Apex job processed Success' +OppList+'Response<<>>'+response.getBody());
                     Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                 }catch(Exception e){
                     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                     string SupportMail = Label.Support_Mail;
                     String[] toAddresses = new String[] {SupportMail };
                     mail.setToAddresses(toAddresses);
                     mail.setSubject('Apex Job Execution Failure');
                     mail.setPlainTextBody('The Xero Apex job processed failure due to' +e.getMessage()+'List of Opps'+OppList);
                     Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                 }
             }
           } catch(Exception e){
                     system.debug('exception========The Xero Apex job processed failure due to' +e.getMessage()+'List of Opps'+OppList);
                     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                     string SupportMail = Label.Support_Mail;
                     String[] toAddresses = new String[] {SupportMail };
                     mail.setToAddresses(toAddresses);
                     mail.setSubject('Apex Job Execution Failure');
                     mail.setPlainTextBody('The Xero Apex job processed failure due to' +e+'List of Opps'+OppList);
                     Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
                 } 
       }
/*====================================================
*Method Name     : dateGenerator
*Description     : This method related to collect the long as String and form that long to Date and return.
*Arguments       : String received
*Ticket No       : 36814
====================================================*/      
       private static Date dateGenerator(String received){
            system.debug('dategene>>');
            system.debug('daterec>> '+received);
            String milliSecond=received.substringBetween('(','+');                       
            Long longtime = long.valueOf(milliSecond);
            DateTime dt = DateTime.newInstance(longtime);
            Date formedDate=date.newinstance(dt.year(), dt.month(), dt.day());
            
            System.debug(formedDate);
            
            return formedDate;
       }
       
/*====================================================
*Method Name     : dateGenerator2
*Description     : This method related to collect the long as String and form that long to Date and return.
*Arguments       : String received
*Ticket No       : 76741
====================================================*/ 
       private static Date dateGenerator2(String received){
            system.debug('dategene>2>');
            system.debug('daterec>2> '+received);
            String milliSecond=received.substringBefore('+');                       
            Long longtime = long.valueOf(milliSecond);
            DateTime dt = DateTime.newInstance(longtime);
            Date formedDate=date.newinstance(dt.year(), dt.month(), dt.day());
            
            System.debug('date>> '+formedDate);
            
            return formedDate;
       }
/*====================================================
*Method Name     : StringToDate
*Description     : This method related to collect the String and form that to Date and return.
*Arguments       : String received
*Ticket No       : 36814
====================================================*/       
        private static Date StringToDate(String received){
            
            List<String> dtl=received.split('-');
            integer year=integer.valueof(dtl[0]);
            integer mon=integer.valueof(dtl[1]);
            integer day=integer.valueof(dtl[2].left(2));
            Date myDate = Date.newInstance(year, mon, day);
            system.debug(myDate);
            
            return myDate;
       }
       
/*====================================================
*Method Name     : finish
*Description     : This methods executes after execute() method executed.In last sends the execute details through mail.
*Arguments       : Database.BatchableContext BC
*Ticket No       : 46671
====================================================*/
       global void finish(Database.BatchableContext BC){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();      
            AsyncApexJob a = [Select a.TotalJobItems, a.Status, a.NumberOfErrors,
            a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById,
            a.CompletedDate From AsyncApexJob a WHERE id = :BC.getJobId()];
            string SupportMail = Label.Support_Mail;
            String[] email = new String[]{SupportMail };
            mail.setToAddresses(email);
            mail.setSubject('Xero Execution Report '+a.Status);
            mail.setPlainTextBody('The Batch Apex job processed '+ a.TotalJobItems+' batches with '+a.NumberOfErrors+' failures '+'Job Itemprocessed are '+a.JobItemsProcessed+'.');
            Messaging.sendEmail(new Messaging.Singleemailmessage [] {mail});
    }   
       
 
 }