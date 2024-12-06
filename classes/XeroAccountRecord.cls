public class XeroAccountRecord{
    
  @future(callout=true)
    public static void XeroAccountRecord(){
            
            Map<String,List<Xero_Account__c>> TexRateUpdate=new Map<String,List<Xero_Account__c>>();
            
            Xero_Settings__c xeroSettings = Xero_Settings__c.getInstance();
            HttpResponse response =new HttpResponse();
            HttpRequest request = new HttpRequest();
 
          for(Xero_Account__c Tax:[select id,Name,Tax_Type__c,Percentage__c from Xero_Account__c]){
               if(TexRateUpdate.containskey(Tax.Name)){
               TexRateUpdate.get(Tax.Name).add(Tax);
               }else{
               TexRateUpdate.put(Tax.Name,new List<Xero_Account__c>{Tax});
               }
           }
            request.setMethod('GET');
            request.setEndpoint('https://api.xero.com/api.xro/2.0/TaxRates');
            request.setHeader('Content-Type', 'text/xml; charset=utf-8');
            request = XeroOAuthUtility.signRequest(request, xeroSettings.Consumer_Key__c);
            Http htp=new Http();
            response=htp.send(request);
            Dom.Document docs = response.getBodyDocument(); 
            
            Dom.XMLNode Invs= docs.getRootElement(); 
            
            String TaxCode,TaxRates,TaxName,AccCode,AccTaxCode;
            Map<String,String> RatesTax=new Map<String,String>();
            Map<String,String> RatesCode=new Map<String,String>();
            Map<String,String> RatesName=new Map<String,String>();
            
            for(Dom.XMLNode child : Invs.getChildElements()){
                for(Dom.XMLNode childField : child.getChildren()){
                    TaxCode='';TaxRates='';TaxName='';AccCode='';
                    for(Dom.XMLNode childField1 : childField.getChildren()){
                        if(childField1.getName()=='TaxType'){
                            TaxCode=childField1.getText();
                        }
                        if(childField1.getName()=='DisplayTaxRate'){
                            TaxRates=childField1.getText();
                        }
                        if(TaxCode!='' && TaxRates!=''){
                        RatesTax.put(TaxCode,TaxRates);
                        }
                    }
                }
           }
           
           List<Xero_Account__c> InsXero=new List<Xero_Account__c>();
           
            request.setMethod('GET');
            request.setEndpoint('https://api.xero.com/api.xro/2.0/Accounts');
            request.setHeader('Content-Type', 'text/xml; charset=utf-8');
            request = XeroOAuthUtility.signRequest(request, xeroSettings.Consumer_Key__c);
            
            Http h=new Http();
            response=h.send(request);
            Dom.Document doc = response.getBodyDocument();            
            Dom.XMLNode Inv= doc.getRootElement(); 
            
            for(Dom.XMLNode child : Inv.getChildElements()){
                for(Dom.XMLNode childField : child.getChildren()){
                    for(Dom.XMLNode childField1 : childField.getChildren()){
                        if(childField1.getName()=='Code'){
                            AccCode=childField1.getText();
                         }
                        if(childField1.getName()=='Name'){
                            TaxName=childField1.getText();
                        }
                        if(childField1.getName()=='TaxType'){
                            AccTaxCode=childField1.getText();
                        }
                        if(AccCode!=null && TaxName!=null && AccTaxCode!=null){
                            RatesCode.put(AccCode,TaxName);
                            RatesName.put(AccCode,AccTaxCode);
                        }
                    }
                }
           }
           
           system.debug('RatesName>>>>>'+RatesName);
           system.debug('RatesCode>>>>>'+RatesCode);
           system.debug('RatesTax>>>>>'+RatesTax);
           
           for(String Rates:RatesCode.keyset()){
               if(TexRateUpdate.containskey(Rates)){
                   for(Xero_Account__c TaxRt:TexRateUpdate.get(Rates)){
                       TaxRt.Percentage__c=Decimal.valueof(RatesTax.get(RatesName.get(Rates)));
                       TaxRt.Name__c=RatesCode.get(Rates);
                       TaxRt.Tax_Type__c=RatesName.get(Rates);
                       TaxRt.Name=Rates;
                       InsXero.add(TaxRt);
                   }
               }else{
                   if(!Test.isRunningTest()){
                   InsXero.add(new Xero_Account__c(Name=Rates,Name__c=RatesCode.get(Rates),Percentage__c=Decimal.valueof(RatesTax.get(RatesName.get(Rates))),Tax_Type__c=RatesName.get(Rates)));
                   }
               }
           }
        
           if(InsXero.size()>0)
           upsert InsXero;
           
    }
}