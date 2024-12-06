/*============================================================================================================
*Class Name     : XeroCalloutUtility 
*Description    : All the implementations are related to connect to Xero and dynamically get the xero objects.
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 29th Apr, 2020
*Version        : 2.0
*Change History : Xero Migration to 2.0
*Methods        : executeCallout (String method, String resourceName, String requestBody) 
*============================================================================================================*/
public with sharing class XeroCalloutUtility {
/*====================================================
*Method Name     : executeCallout 
*Description     : Connect to Xero and dynamically get the xero objects and return response.
*Arguments       : String method, String resourceName, String requestBody
*Ticket No       : 36814
====================================================*/
    public static HttpResponse executeCallout (String method, String resourceName, String requestBody) {
        XeroOAuthUtility auth=new XeroOAuthUtility();
        String tenantid=auth.connectToXero();
        HttpRequest request = new HttpRequest();
        request.setMethod(method);
        request.setEndpoint('callout:XeroDev/api.xro/2.0/'+resourceName);
        request.setHeader('Accept', 'application/json');
        request.setHeader('xero-tenant-id', tenantid);
        system.debug('invoice body===='+requestBody);
        if (requestBody!=null) {
            request.setBody(requestBody);
            request.setHeader('Content-Type','text/xml; charset=utf-8');
            
        }
        HttpResponse response;
        Http http = new Http();
        try{
          response=http.send(request);
        }  
        catch(Exception e){
          System.debug(e);
        }      

        return response;
    }

}