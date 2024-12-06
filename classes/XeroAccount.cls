public class XeroAccount{
    
    public String createAccount (String Ids){
     String XeroAccId,Taxids;   
        if(Ids!=null){
          
                    Xero_Settings__c xeroSettings = Xero_Settings__c.getInstance();
                    HttpResponse response =new HttpResponse();
                    HttpRequest request = new HttpRequest();
                    string uri_enc = EncodingUtil.urlEncode(Ids, 'UTF-8');
                    request.setMethod('GET');
                    request.setEndpoint('https://api.xero.com/api.xro/2.0/Accounts?where=Code%3D%3D"'+uri_enc+'"');
                    request.setHeader('Content-Type', 'text/xml');
                    //request = XeroOAuthUtility.signRequest(request, xeroSettings.Consumer_Key__c);
            
                    Http h=new Http();
                    response=h.send(request);
                    system.debug('response1>>>>'+response);
                    if(response.getStatusCode()==200){
                    Dom.Document doc = response.getBodyDocument();            
                    Dom.XMLNode Inv= doc.getRootElement(); 
                    system.debug('InvInv>>>>.'+Inv);
                        for(Dom.XMLNode child : Inv.getChildElements()){
                            for(Dom.XMLNode child1 : child.getChildren()){
                                for(Dom.XMLNode child2 : child1.getChildren()){
                            if(child2.getName()=='TaxType')
                            XeroAccId=child2.getText();
                            system.debug('XeroAccId>>>>>>>>>'+XeroAccId);
                            }
                            }
                        }
                        if(XeroAccId==null)
                        XeroAccId='Error';
                    }
               else{
                  XeroAccId='Error';
                }
        }
        system.debug('XeroAccId>>>>>>'+XeroAccId);
        return XeroAccId;
    }
  
}