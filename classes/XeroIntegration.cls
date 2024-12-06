public class XeroIntegration{
   public void connectToXero(){         
         
         //authorize
        
        Http http = new Http();

        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:XeroDev/connections');
        request.setMethod('GET');
        request.setHeader('Authorization','Bearer {!$Credential.OAuthToken}');
        request.setHeader('Content-Type','application/json');
                 
        string tenantid=null;  
         
         try{  
             HttpResponse response = http.send(request);
             System.debug(response.getBody());  
   
             //get tenant id
                JSONParser parser = JSON.createParser(response.getBody());
                
                while (parser.nextToken() != null) {
                        
                        if(parser.getCurrentName() == 'tenantId') {
                            parser.nextValue();
                            tenantid=parser.getText();
                            System.debug(parser.getText());
                        }
                        
                }      
                system.debug(tenantid);
               /* //post account
                HttpRequest req2 = new HttpRequest();
                req2.setEndpoint('callout:XeroDev/api.xro/2.0/Contacts');
                req2.setMethod('GET');                
                req2.setHeader('Content-Type', 'text/xml; charset=utf-8');
                req2.setBody('<Contact><Name>Eclipse  Limited3</Name><Code>1150</Code></Contact>');
                req2.setHeader('xero-tenant-id', tenantid);
                Http http2 = new Http();
                HTTPResponse res2 = http2.send(req2);
                System.debug(res2.getBody());
                */
                //post invoice
                HttpRequest req3 = new HttpRequest();
                req3.setEndpoint('callout:XeroDev/api.xro/2.0/Invoices');
                req3.setMethod('GET');                
                req3.setHeader('Content-Type', 'text/xml; charset=utf-8');
                //req3.setBody('<Invoice><Type>ACCREC</Type><Contact><ContactID>46901454-249e-405a-8159-1a62f55c0157</ContactID></Contact><Date></Date><DueDate></DueDate><LineAmountTypes>Exclusive</LineAmountTypes><LineItems><LineItem><Description>Consulting services as not agreed</Description><Quantity>5.0000</Quantity><UnitAmount>120.00</UnitAmount><TaxType>NONE</TaxType><AccountCode>1100</AccountCode></LineItem></LineItems></Invoice>');
                req3.setBody('<Invoice><Type>ACCREC</Type><Contact><ContactID>46901454-249e-405a-8159-1a62f55c0157</ContactID></Contact><Date>2009-08-30</Date><DueDate>2009-09-20</DueDate><LineAmountTypes>Exclusive</LineAmountTypes><LineItems><LineItem><Description>Red Sweater</Description><Quantity>5</Quantity><UnitAmount>120.00</UnitAmount><ItemCode>FAIRFIELD Y2.3 12</ItemCode></LineItem></LineItems></Invoice>');
                
                //test
                
                //test
                req3.setHeader('xero-tenant-id', tenantid);
                Http http3 = new Http();
                HTTPResponse res3 = http3.send(req3);
                System.debug(res3.getBody());
                
                if(res3.getStatusCode()==200){
                  JSONParser parser2 = JSON.createParser(res3.getBody());
                  while (parser2.nextToken() != null) {
                     if(parser2.getCurrentName() == 'Invoices') {
                         while (parser2.nextToken() != null) {
                             if(parser2.getCurrentName() == 'InvoiceID')                                         
                                System.debug(parser2.getText());
                             if(parser2.getCurrentName() == 'InvoiceNumber')                                         
                                System.debug(parser2.getText());
                             if(parser2.getCurrentName() == 'AmountPaid')                                         
                                System.debug(parser2.getText());
                          }
                      }
                   } 
            }
                               
                                                         
         }//try
         catch(Exception e){
           System.debug(e);
         }
         
   }
   
   public string PostContact(string accids){
           system.debug('post contact');
           Account Acc=[select id,Name,Phone,Shippingcity,Shippingstate,ShippingStreet,Site_Contact__r.Email,Site_Contact__r.FirstName,Site_Contact__r.LastName,ShippingPostalcode,Shippingcountry,AccountNumber,Company_mail__c,XeroId__c from Account where id=:accids];
           if(Acc.XeroId__c==null){
           system.debug('Acc================'+Acc);
               XeroContact ConRes;
               XeroContact newContact = new XeroContact();
               newContact.Name=Acc.Name;
               newContact.ContactNumber='';
               newContact.AccountNumber=Acc.AccountNumber;
               newContact.FirstName=Acc.Site_Contact__r.FirstName;
               newContact.LastName=Acc.Site_Contact__r.LastName;
               newContact.EmailAddress=Acc.Site_Contact__r.Email;
               newContact.Address.AddressType='POBOX';
               newContact.Address.AddressLine1=Acc.ShippingStreet;
               newContact.Address.City=Acc.Shippingcity;
               newContact.Address.PostalCode=Acc.ShippingPostalcode;
               newContact.Address.Country=Acc.Shippingcountry;
               newContact.Address.Region=Acc.ShippingState ;
               
               system.debug('newContact>>>>>>'+newContact);
               ConRes=XeroAccountingApi.createContact(XeroXmlUtility.serialize(newContact, 'Contact'));
               system.debug('ConRes=========='+ConRes);
                if(ConRes!=null){
               Acc.XeroId__c=ConRes.ContactID;
               system.debug('contact post==='+ConRes);
               update Acc;
             
               return ConRes.ContactID;
               }
               
           }
           return null;
   }
}