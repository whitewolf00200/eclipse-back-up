public with sharing class XeroCalloutResponseParser {
   
    public static List<XeroContact> parseContacts(String jsonBody) {
        System.debug('jsonBody value is ================>'+jsonBody);
        String jsonSerialized = generateJsonStringForParsing (jsonBody, 'Contacts');
        return (List<XeroContact>) JSON.deserialize(jsonSerialized, List<XeroContact>.class);
    }

   
    public static List<XeroInvoice> parseInvoices(String jsonBody) {

        String jsonSerialized = generateJsonStringForParsing (jsonBody, 'Invoices');

        return (List<XeroInvoice>) JSON.deserialize(jsonSerialized, List<XeroInvoice>.class);
    }

    
    private static String generateJsonStringForParsing (String jsonBody, String objectName) {
        
        if(Test.isRunningTest()){
            jsonBody='{"totalResults": 2,"startIndex":0,"pricing":[ { "price":10.80,"cost":9.22},{"price":5.50,"cost":4.00}]}';
            }
        
        Map<String, Object> jsonResponseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonBody);
        System.debug('jsonResponseMap value is =============>'+jsonResponseMap);
        return JSON.serialize((List<Object>) jsonResponseMap.get(objectName));
    }

}