/*============================================================================================================
*Class Name     : XeroController
*Description    : All the implementations are related to posting invoice to Xero.
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 29th Apr, 2020
*Version        : 2.0
*Change History : Xero Migration to 2.0
*Methods        : public void CheckConnection()
                  public void XeroBrandingTheme()
                  public List<OpportunityLineItem> OLiList(string opids)
                  public string contacts(string contactNmae,Boolean type )
                  public void InsertXero()
                  public string PostContact(string accids)
                  public pagereference PostOpportunity()
                  public String CheckTaxExist(String TaxId)
                  public string converttoXml(Opportunity o)
                  public String CheckItemAvail(String ProductCodes, String PrdDesc)
                  public pagereference postOpptoXero(string opid)
                  public pagereference cancel()
                  public void CheckDiscount(Decimal dis)
*============================================================================================================*/
public class XeroController{
public Id Accid;
public string orderId,XeroAcctId,TaxIds;
public opportunity Oppty{get;set;}
public string AmountType{get;set;}
public Account Acc{get;set;}  
public List<OpportunityLineItem> OLI{get;set;}
public List<String> ThemesId=new List<String>();
public List<SelectOption> ThemesName{get;set;}
public List<SelectOption> AccName{get;set;}
public List<SelectOption> TaxReates{get;set;}
public string Positions{get;set;}
public string tax{get;set;}
public string XerAccName{get;set;}
public string XerTax{get;set;}
boolean ErrFlag=false;
public List<Xero_Account__c> DefaultCode;
public Boolean ButtonFlag{get;set;}
public static Integer counter=0;
public  String ItemsInsert=''+'<Items>';
public String conid;
public static string tenantId;

public List<Xero_Account__c> defaultZeroPercentaeg=new List<Xero_Account__C>();
public List<Xero_Account__c> defaultXero=new List<Xero_Account__C>();
public Map<Decimal,Xero_Account__c> dynamicXero=new Map<Decimal,Xero_Account__c>();

    public XeroController(){
        ThemesName=new List<SelectOption>();
        AccName=new List<SelectOption>();
        TaxReates=new List<SelectOption>();
        AccName.add(new SelectOption('',''));
        TaxReates.add(new SelectOption('',''));
        orderId = apexpages.currentpage().getparameters().get('id');  
        Accid=apexpages.currentpage().getparameters().get('AccIds');  
        system.debug('Accid>>11 '+apexpages.currentpage().getparameters().get('AccIds'));
        system.debug('Accid>> '+Accid);
        if(Accid!=null){
           Acc=[select id,Name,Phone,Shippingcity,Shippingstate,ShippingPostalcode,Shippingcountry,AccountNumber,Company_mail__c,XeroId__c from Account where id=:Accid];
           conid=Acc.XeroId__c ;
           system.debug('exisitng conid======'+conid);
       }
        if(orderId!=null){                     
        Oppty=[select id,Name,Invoice_Number__c,Amount,Total_VAT__c,VAT_Rate__c,Xero_Tax_Type__c,Xero_Account__c,Xero_Account__r.Name,Account.Parent.Name,Xero_Account__r.Tax_Type__c,Invoice_Date__c,Due_Date__c,Reference__c,Invoice_Total__c,createddate from Opportunity where id=:orderId ];
        system.debug('Oppty========'+Oppty.Invoice_Number__c);
        OLI=OLiList(orderId );
        
        defaultZeroPercentaeg=[select Tax_Type__c,Name from Xero_Account__c where Percentage__c=0 and Default__c=true];
        defaultXero=[select Tax_Type__c,Name from Xero_Account__c where Percentage__c=20 and Default__c=true];
        for(Xero_Account__c xc:[Select id,name,Tax_type__c,percentage__c from Xero_Account__c]){
          dynamicXero.put(xc.percentage__C,xc);
        }
        system.debug(defaultXero);
        system.debug(dynamicXero);
        
        XeroOauthUtility auth=new XeroOauthUtility();
        tenantId=auth.connectToXero();
         
        if(!Test.isRunningTest())
        XeroBrandingTheme();
        }
       
        
    }
/*====================================================
*Method Name     : CheckConnection
*Description     : When render the page it checksxero connection established or not. Otherwise through error.
*Arguments       : No Argument
*Ticket No       : 36814
====================================================*/    
        public void CheckConnection(){
        ButtonFlag=true;
        
        Integer lit=Limits.getLimitHeapSize();
        Integer litt=Limits.getHeapSize();
        system.debug('Allowed Limit========='+lit);
        system.debug('used Limit========='+litt);
        
        
        system.debug('tenantid:::'+tenantid);
       
        if(tenantId==null || tenantId==''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Authroization Failed, Check Connection'));
            ButtonFlag=false;
        }
   }
 
/*====================================================
*Method Name     : XeroBrandingTheme
*Description     : Query all used Branding theme in Xero account and puts in the picklist.
*Arguments       : No Argument
*Ticket No       : 36814
====================================================*/  
    public void XeroBrandingTheme(){
        XeroOAuthUtility auth=new XeroOAuthUtility();
        tenantId=auth.connectToXero();
        
        HttpResponse response =new HttpResponse();
       
        HttpRequest request = new HttpRequest();

        request.setMethod('GET');
        request.setEndpoint('callout:XeroDev/api.xro/2.0/BrandingThemes');
        request.setHeader('Content-Type', 'text/xml; charset=utf-8');
        request.setHeader('xero-tenant-id', tenantid);
        
        Http h=new Http();
        response=h.send(request);
        system.debug(response.getBody());
        
        if(response.getStatusCode()==200){
        
            
            JsonParser parser = JSON.createParser(response.getBody());
              
              while (parser.nextToken() != null) {
                    
                    if(parser.getCurrentName() == 'BrandingThemes') {
                         while (parser.nextToken() != null) {
                            parser.nextToken();
                           
                            if(parser.getCurrentName() == 'BrandingThemeID') {
                              ThemesId.add(parser.getText());
                            }
                            if(parser.getCurrentName()=='Name'){
                                 ThemesName.add(new SelectOption(parser.getText(),parser.getText()));
                                 system.debug('selected theme======='+ThemesName);
                            }
                            
                         }
                     }
              }
            
        }
    }
/*====================================================
*Method Name     : OLiList
*Description     : Collect all lineitems from Current Opportunity and returns.
*Arguments       : string opids
*Ticket No       : 36814
====================================================*/    
    public List<OpportunityLineItem> OLiList(string opids){
        orderId=orderId;
        if(opids!=null)
        return [select product2.Name,Show_Description__c,opportunity.createddate,Vat_Rate__c,SalesDescription__c,Extended_Sales_Description__c,UnitPrice,Quantity,VAT__c,Discount,Product2.Nominal_Code__c,Product2.ProductCode,Product2.Description,TotalPrice from Opportunitylineitem where Opportunityid=:opids order by SortOrder,Pricebookentry.product2.Name];
        else
        return null;
    }
/*====================================================
*Method Name     : InsertXero
*Description     : This method call when the button click to post invoice to Xero. 
*Arguments       : No Arguments
*Ticket No       : 36814
====================================================*/  
    public void InsertXero(){
       if(orderId!=null){
           PostOpportunity();
       }
       
    }
/*====================================================
*Method Name     : PostContact
*Description     : If the Account related to Opportunity not posted to Xero then this method helpful for posting that Account to Xero.
*Arguments       : string accids
*Ticket No       : 36814
====================================================*/    
   public string PostContact(string accids){
           system.debug('post contact');
           Acc=[select id,Name,Phone,Shippingcity,Shippingstate,ShippingStreet,Site_Contact__r.Email,Site_Contact__r.FirstName,Site_Contact__r.LastName,ShippingPostalcode,Shippingcountry,AccountNumber,Company_mail__c,XeroId__c from Account where id=:accids];
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
               //update Acc;
             
               return ConRes.ContactID;
               }
               
           }
           return null;
   }

/*====================================================
*Method Name     : contacts
*Description     : This method helpful if the related account not posted to Xero but it's parent account's account number or it's account number already exist in xero under any other account, then the invoice post to Xero under that account.
*Arguments       : string contactNmae,Boolean type
*Ticket No       : 36814
====================================================*/     
   public string contacts(string contactNmae,Boolean type ){
        List<XeroContact> xeroContact = new List<XeroContact>();
        
        HttpResponse response =new HttpResponse();
       system.debug('creating contacts========'+contactNmae);
       
        HttpRequest request = new HttpRequest();
        if(contactNmae!=null){
            request.setMethod('GET');
            string uri_enc = EncodingUtil.urlEncode(contactNmae, 'UTF-8');
            if(type ==false){              
              request.setEndpoint('callout:XeroDev/api.xro/2.0/Contacts?where=Name%3D%3D%22'+uri_enc+'%22');              
            }
            else if(type ==true){               
               request.setEndpoint('callout:XeroDev/api.xro/2.0/Contacts?where=AccountNumber%3D%3D%22'+uri_enc+'%22');
            }
            system.debug('request.setEndpoint============='+request);
            request.setHeader('Accept', 'application/json');
            request.setHeader('Content-Type', 'text/xml');
            
            XeroOAuthUtility auth=new XeroOAuthUtility();
            tenantId=auth.connectToXero();
            request.setHeader('xero-tenant-id', tenantid);
            
    
            Http h=new Http();
            response=h.send(request);
            system.debug(response.getbody());
            List<XeroContact> conList=new List<XeroContact>();
            
             if (response.getStatusCode() == 200) {
                xeroContact = XeroCalloutResponseParser.parseContacts(response.getBody());
                system.debug('conac from parser======'+xeroContact );
                if(xeroContact!=null && xeroContact.size()>0)
                return xeroContact[0].ContactID;
                else
                return null;
            }
            return null;
        }
        
        return null;     
   }
   
   public class Items{
       public string code;
   }
   
/*====================================================
*Method Name     : PostOpportunity
*Description     : This method calls PostOpportunity method.
*Arguments       : No Arguments
*Ticket No       : 36814
====================================================*/ 
   public pagereference PostOpportunity(){
       try{
           postOpptoXero(orderId);
           PageReference ReturnPage = new PageReference('/' +orderId); 
           ReturnPage.setRedirect(true); 
           if(!ErrFlag)
           return ReturnPage;
           
           return null;
       }
       catch(CalloutException e){
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,+e.getMessage()));
          return null;
       }
       catch(Exception e){
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
          return null;
       }
       
       
   } 
   
/*====================================================
*Method Name     : CheckTaxExist
*Description     : This method Checks the tax exist in xero or not.
*Arguments       : String TaxId
*Ticket No       : 36814
====================================================*/ 
   public String CheckTaxExist(String TaxId){
        XeroOAuthUtility auth=new XeroOAuthUtility();
        tenantId=auth.connectToXero();
        
        HttpResponse response =new HttpResponse();
       
        HttpRequest request = new HttpRequest();

        request.setMethod('GET');
        request.setEndpoint('callout:XeroDev/api.xro/2.0/TaxRates/'+'TAX001');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Content-Type', 'text/xml');
        request.setHeader('xero-tenant-id', tenantid);
        

        Http h=new Http();
        response=h.send(request);
        System.debug(response.getBody());
        return String.valueof(response.getStatusCode());
   }
/*====================================================
*Method Name     : converttoXml
*Description     : This method forms the request to post to Xero.
*Arguments       : Opportunity o
*Ticket No       : 36814
====================================================*/   
   public string converttoXml(Opportunity o){
       String ThemeIds,Accode,StatusAcc,Service;
       Decimal Disnts;
           if(ThemesName.size()>0 && positions!=null){
               for(Integer i=0;i<ThemesName.size();i++){
                   if(positions==String.valueof(ThemesName[i].getValue()))
                   ThemeIds=ThemesId[i];
                   system.debug(ThemeIds);
               }
           }else{
           ThemeIds=ThemesId[0];
           system.debug(ThemeIds);
           }
           
       ErrFlag=false;
       
       if(Oppty.createddate<date.newInstance(2020,5,29)){
       if(Oppty.Xero_Account__c!=null){       
           TaxIds=Oppty.Xero_Account__r.Tax_Type__c;
           Accode=Oppty.Xero_Account__r.Name;
           
           system.debug('Accode============'+Accode);
           StatusAcc=CheckTaxExist(TaxIds);
           System.debug('StatusAcc======'+StatusAcc);
           if(StatusAcc!='200'){
               return 'Not Found';
           }
       }else{
         system.debug('Oppty.VAT_Rate__c>>>>>>'+Oppty.VAT_Rate__c);
         if(Oppty.VAT_Rate__c==20.00){
         DefaultCode=new List<Xero_Account__c>([select Tax_Type__c,Name from Xero_Account__c where Percentage__c=:Oppty.VAT_Rate__c and Default__c=true]);
         system.debug('DefaultCode========'+DefaultCode);
         }
         if(Oppty.VAT_Rate__c==0){
         DefaultCode=new List<Xero_Account__c>([select Tax_Type__c,Name from Xero_Account__c where Percentage__c=:Oppty.VAT_Rate__c and Default__c=true]);
         system.debug('DefaultCode========'+DefaultCode);
         }
         if(Oppty.VAT_Rate__c!=20.00 && Oppty.VAT_Rate__c!=0){
         DefaultCode=new List<Xero_Account__c>([select Tax_Type__c,Name from Xero_Account__c where Percentage__c=:Oppty.VAT_Rate__c]);
         system.debug('DefaultCode========'+DefaultCode);
         }
        if(DefaultCode.size()>0){
             TaxIds=DefaultCode[0].Tax_Type__c;
             Accode=String.valueof(DefaultCode[0].Name);
             system.debug('else TaxIds==== '+TaxIds);
             StatusAcc=CheckTaxExist(TaxIds);
             if(StatusAcc!='200'){
             system.debug('else TaxIds==== '+TaxIds); // return 'Not Found';
               }
         }
         else{
               system.debug('else TaxIds==== '+TaxIds);//return 'Not Found';
           }
       }
      }
       
       
       
       if(AmountType=='Tax Exclusive')
       AmountType='Exclusive';
       else if(AmountType=='Tax Inclusive')
       AmountType='Inclusive';
       else
       AmountType='NoTax';
       
       system.debug('conid>>'+conid+'o.account.AccountNumber>> '+o.account.AccountNumber+'o.accountid>> '+o.accountid);
      
       string contactXml =''+
       '<Invoice>'+  
       '<Contact>'+  
       '<ContactID>'+(conid!=null?conid:contacts(o.account.AccountNumber,true)!=null?contacts(o.account.AccountNumber,true):PostContact(o.accountid))+'</ContactID>'+  
       //'<ContactID>'+(PostContact(o.accountid))+'</ContactID>'+  
       '</Contact>'+ 
       '<Type>ACCREC</Type>'+   
       '<Date>'+Oppty.Invoice_Date__c+'</Date>'+
       '<DueDate>'+Oppty.Due_Date__c+'</DueDate>'+
       '<Reference>'+Oppty.Reference__c+'</Reference>'+
       '<BrandingThemeID>'+ThemeIds+'</BrandingThemeID>'+
       '<LineAmountTypes>'+AmountType+'</LineAmountTypes>'+
       '<InvoiceDate>'+Oppty.Invoice_Date__c+'</InvoiceDate>'+ '<LineItems>';
       
     system.debug('conid1==='+conid);
     conid=contactXml.substring(contactXml.indexOf('<ContactID>')+11,contactXml.indexOf('</ContactID>'));
       system.debug('conid2================'+conid);
       for(OpportunityLineItem oliitms :OLI){
                
                string subStr = oliitms.Product2.Nominal_Code__c!=null?oliitms.Product2.Nominal_Code__c:oliitms.Product2.Name;
                
                String[] SpecialChar=ControlFetch__c.getInstance('Xero Special Char').Xero_Special_Character__c.split('|');
                
                for(String str:SpecialChar){
                    subStr=subStr.replace(str, '');
                }
                subStr=subStr.replace(' ','');
                
                subStr=subStr.length()<30?subStr:subStr.substring(0,30);
                system.debug('product======'+oliitms.Product2.name+'====code========'+oliitms.Product2.Nominal_Code__c);
            
                   Service= CheckItemAvail(subStr,oliitms.Product2.Name);
                   system.debug('2nd service========='+subStr);
                   if(Service=='Service Unavailable'){
                   return 'Service Unavailable';
                   }
                
                CheckDiscount(oliitms.Discount);
                if(oliitms.Discount== NULL)
                Disnts=0;
                else
                Disnts=oliitms.Discount;
                
                String Pname,Exdesc;
                if(oliitms.Show_Description__c==true){
                    Exdesc=oliitms.Extended_Sales_Description__c;
                    if(Exdesc!=null){
               
                    if(Exdesc.Contains('<br>') || Exdesc.Contains('<li>') ||  Exdesc.Contains('&') || Exdesc.Contains('£')){
          
                          Exdesc=Exdesc.Replace('<br>', 'hgjkl077').Replace('<li>','hgjkl077&#8226;').Replace('£', '\\£').Replace('&', '&amp;');  // hgjkl077 is random letter used for \n replacement
      
                    } 
       
        
                   Exdesc=Exdesc.stripHtmlTags();
                  Exdesc=Exdesc.Replace('hgjkl077','\n');
                  }
              }
        Pname=oliitms.SalesDescription__c!=null?oliitms.SalesDescription__c:oliitms.product2.Name;
        if(Pname.Contains('&') || Pname.Contains('£') || Pname.Contains('<') || Pname.Contains('>')){
            Pname=Pname.Replace('&', '&amp;').Replace('>', '&gt;').Replace('<', '&lt;').Replace('£', '\\£');
        }
        
      
    if(oliitms.Show_Description__c==true ){
        String ext=Exdesc!=null?Exdesc:'';
        Pname=Pname+'\n'+ ext;
    }
   
   
                contactXml = contactXml +   
                '<LineItem>'+  
                    '<Description>'+Pname+'</Description>'+
                    '<Quantity>'+oliitms.Quantity+'</Quantity>'+
                    '<UnitAmount>'+oliitms.UnitPrice+'</UnitAmount>';
                    
                    if(oliitms.opportunity.createddate>=date.newInstance(2020,5,29)){
                        
                         system.debug('oliitms.VAT_Rate__c>>>>>>'+oliitms.VAT_Rate__c);
                         if(oliitms.VAT_Rate__c==20.00){
                           if(defaultXero.size()>0){
                                 TaxIds=defaultXero[0].Tax_Type__c;
                                 Accode=String.valueof(defaultXero[0].Name);
                                 system.debug('else TaxIds==== '+TaxIds);
                                 StatusAcc=CheckTaxExist(TaxIds);
                                 if(StatusAcc!='200'){
                                   return 'Not Found';
                                   }
                           }
                            else{
                               return 'Not Found';
                           }
                         
                         system.debug('defaultXero========'+defaultXero);
                         }
                         else if(oliitms.VAT_Rate__c==0){
                           
                           if(defaultZeroPercentaeg.size()>0){
                                 TaxIds=defaultZeroPercentaeg[0].Tax_Type__c;
                                 Accode=String.valueof(defaultZeroPercentaeg[0].Name);
                                 system.debug('else TaxIds==== '+TaxIds);
                                 StatusAcc=CheckTaxExist(TaxIds);
                                 if(StatusAcc!='200'){
                                   return 'Not Found';
                                   }
                           }
                            else{
                               return 'Not Found';
                           }
                         
                         system.debug('defaultZeroPercentaeg========'+defaultZeroPercentaeg);
                         }
                         else if(oliitms.VAT_Rate__c!=20.00 && oliitms.VAT_Rate__c!=0){
                            system.debug(oliitms.vat_rate__c);
                            system.debug(dynamicXero.get(oliitms.VAT_Rate__c));
                            
                            
                            
                              if(dynamicXero.containskey(oliitms.VAT_Rate__c)){
                                
                                 TaxIds=dynamicXero.get(oliitms.VAT_Rate__c).Tax_Type__c;
                                 Accode=String.valueof(dynamicXero.get(oliitms.VAT_Rate__c).Name);
                                 system.debug('else TaxIds==== '+TaxIds);
                                 StatusAcc=CheckTaxExist(TaxIds);
                                 if(StatusAcc!='200'){
                                   return 'Not Found';
                                 }
                               }
                                else{
                                   return 'Not Found';
                               }
                         
                            }
                        
                   }
                    
                    contactXml = contactXml +//'<TaxType>'+TaxIds+'</TaxType>'+
                    //'<AccountCode>'+Accode+'</AccountCode>'+
                    '<AccountCode>'+200+'</AccountCode>'+
                    '<DiscountRate>'+Disnts+'</DiscountRate>'+
                    '<ItemCode>'+subStr+'</ItemCode>'+
                '</LineItem>'; 
      
          
          }//for
          contactXml = contactXml +   '</LineItems>'+  
          '<InvoiceNumber>'+Oppty.Invoice_Number__c+'</InvoiceNumber>'+
          '<Status>AUTHORISED</Status>'+ 
          '<SentToContact>true</SentToContact>'+
          '</Invoice>'; 
          contactXml = contactXml + '</Invoices>';
          contactXml = '<Invoices>' + contactXml ;
          contactXml ='<?xml version="1.0" encoding="utf-8"?>' +  contactXml;     
          system.debug('contactXml>>>>'+contactXml); 
          return contactXml;  
   
   }
/*====================================================
*Method Name     : CheckItemAvail
*Description     : This method gets the opportunity Product details and post to xero.
*Arguments       : String ProductCodes, String PrdDesc
*Ticket No       : 36814
====================================================*/ 
   public String CheckItemAvail(String ProductCodes, String PrdDesc){
       
        
       system.debug('original prod special char======='+PrdDesc);
        if(PrdDesc.Contains('&') || PrdDesc.Contains('<') || PrdDesc.Contains('£') || PrdDesc.Contains('>')){
        PrdDesc=PrdDesc.Replace('&', '&amp;').Replace('£', '\\£').Replace('<', '&lt;').Replace('>', '&gt');
        
        }
           
         ItemsInsert=ItemsInsert+'<Item>'+
                                '<Code>'+ProductCodes+'</Code>'+
                                '<Description>'+PrdDesc+'</Description>'+
                                '</Item>';
                                
          
         system.debug('ItemsInsert ======'+ItemsInsert );
         system.debug('OLI Size===='+OLI.size());
        Integer local=++counter;
        system.debug('counter===='+local);
         if(OLI.size()==local){
         ItemsInsert ='<?xml version="1.0" encoding="utf-8"?>' +  ItemsInsert +'</Items>';
         system.debug('final item insert========'+ItemsInsert );
         
         XeroOAuthUtility auth=new XeroOAuthUtility();
        tenantId=auth.connectToXero();
        
         HttpResponse response =new HttpResponse();
          HttpRequest request = new HttpRequest();  
          request.setMethod('POST');
          request.setEndpoint('callout:XeroDev/api.xro/2.0/Items');
          request.setHeader('Content-Type', 'text/xml; charset=utf-8');
          request.setBody(ItemsInsert);
          request.setHeader('xero-tenant-id', tenantid);
          
          Http h=new Http();
          
          response=h.send(request);
          system.debug('response:::'+response.getBody());
        system.debug('pro Response==='+response);
          system.debug('Item status==========='+response.getStatusCode());
          if(response.getStatusCode() == 200){
          system.debug('Success!!!!!!!!!!!!!!!');
          }
          return null;
         } 
         return null;
       
        
      
   }
/*====================================================
*Method Name     : postOpptoXero
*Description     : This method plays main role in posting invoice to Xero.
*Arguments       : string opid
*Ticket No       : 36814
====================================================*/    
   public pagereference postOpptoXero(string opid){
       String invoiceId,InvoiceNo;
       Opportunity opp=new Opportunity();
       system.debug('conid>>'+conid);
       if(Oppty.Invoice_Date__c==null){
           ErrFlag=true;
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter Invoice Date'));
           return null;
       }else if(Oppty.Due_Date__c==null){
           ErrFlag=true;
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter Due Date'));
           return null;
       }
       if(Oppty.Invoice_Date__c>Oppty.Due_Date__c){
           ErrFlag=true;
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Due Date must be greaterthan Invoice Date'));
           return null;
       }
       if(Oppty.Due_Date__c<system.today()){
           ErrFlag=true;
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Due Date is already passed'));
           return null;
       }
  
       List<opportunityLineItem> OppOLI=new List<opportunityLineItem>([select id,Name,productcode,unitprice,quantity,opportunityid from opportunitylineitem where opportunityid=:opid]);
       opp=[Select id,StageName,Invoice_Sent_to_Xero__c,Xero_Invoice_Number__c,Invoice_Date__c,closedate,Name,account.name,Account.Parent.Name,account.AccountNumber,accountid,XeroOppId__c,createddate,Account.Site_Contact__c,Account.Site_Contact__r.name from Opportunity where id=:opid];
       if(opp.XeroOppId__c==null){
       XeroOAuthUtility auth=new XeroOAuthUtility();
        tenantId=auth.connectToXero();
       HttpResponse response =new HttpResponse();
       
        HttpRequest request = new HttpRequest();

        request.setMethod('POST');
        request.setEndpoint('callout:XeroDev/api.xro/2.0/Invoices');
        request.setHeader('Content-Type', 'text/xml; charset=utf-8');
        String Status=converttoXml(opp);
        request.setBody(Status);
        
        
        
        system.debug('Expecting Status=='+Status);
        if(Status=='Not Found'){
           ErrFlag=true;
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'The given Opportunity Xero Account Id not available in Xero'));
           return null;
        }
       
  
        System.debug('request:::'+request.getBody());
        request.setHeader('xero-tenant-id', tenantid);
       
        Http h=new Http();
        response=h.send(request);
        system.debug('response:::'+response.getBody());
        system.debug('inv Response==='+response);
        system.debug('Status CODE==='+response.getStatusCode());
        if(response.getStatusCode()==200){
             
            
            JSONParser parser = JSON.createParser(response.getBody());
                      while (parser.nextToken() != null) {
                            if(parser.getCurrentName() == 'Invoices') {
                                 while (parser.nextToken() != null) {
                                    if(parser.getCurrentName() == 'InvoiceID')                                         
                                        invoiceId=parser.getText();
                                     if(parser.getCurrentName()=='InvoiceNumber')
                                       InvoiceNo=parser.getText();
                    }
                }
            } 
                      
            opp.Invoice_Date__c=Oppty.Invoice_Date__c;
            opp.Due_Date__c=Oppty.Due_Date__c;
            opp.Xero_Invoice_Number__c=InvoiceNo;
            opp.StageName='Sent';
            opp.XeroOppId__c=invoiceId;
            try{
            update opp;
            system.debug('conid for acc=========='+conid);
            if(conid!=null && conid!=''){
            Acc.XeroId__c=conid;
             update Acc;
            
            
            } 
            }
            catch(Exception e){
              System.debug(e);
              ErrFlag=true;
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
            }
        } 
        else{
             ErrFlag=true;
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Bad Request to sent invoice to xero'));
             return null;
        } 
       }  
       PageReference ReturnPage = new PageReference('/' +opp.id); 
         system.debug(opp.id);
         ReturnPage.setRedirect(true);         
         return ReturnPage;
         
   }
/*====================================================
*Method Name     : cancel
*Description     : This method is for cancelling the page.
*Arguments       : No Arguments.
*Ticket No       : 36814
====================================================*/  
   public pagereference cancel(){
   PageReference ReturnPage = new PageReference('/' +orderId); 
   ReturnPage.setRedirect(true); 
   return ReturnPage;
   }
/*====================================================
*Method Name     : CheckDiscount
*Description     : This method checks is the discount grater than 100% then shows error.
*Arguments       : Decimal dis.
*Ticket No       : 36814
====================================================*/    
   public void CheckDiscount(Decimal dis){
       if(dis>100){
          ErrFlag=true;
       }
   }
  
}