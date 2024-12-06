/*============================================================================================================
*Class Name     : XeroOAuthUtility 
*Description    : This calss used as helper class in other classes and helpful to return tenant id after connect to Xero.
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 29th Apr, 2020
*Version        : 2.0
*Change History : Xero Migration to 2.0
*Methods        : public String connectToXero()
*============================================================================================================*/
 
public with sharing class XeroOAuthUtility {
/*====================================================
*Method Name     : connectToXero
*Description     : This class is helpful for connecting to Xero and return tenantid.
*Arguments       : No Arguments
*Ticket No       : 38614
====================================================*/
  public String connectToXero(){  
        //Authorize to Xero and get tenant id
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:XeroDev/connections');
        request.setMethod('GET');
        request.setHeader('Authorization','Bearer {!$Credential.OAuthToken}');
        request.setHeader('Content-Type','application/json');                 
        string tenantid=null; 
         
         try{  
             HttpResponse response = http.send(request);
             System.debug(response);     
                //Get tenant id from response body
                JSONParser parser = JSON.createParser(response.getBody());
                
                while (parser.nextToken() != null) {
                    if(parser.getCurrentName() == 'tenantId') {
                        parser.nextValue();
                        tenantid=parser.getText();
                        System.debug(tenantid);
                    }
                    
                }  
                system.debug('tenantid'+tenantid);             
                                                         
           }//try
           catch(Exception e){
               System.debug(e);
           }
           return tenantid;
     }//method end  

}