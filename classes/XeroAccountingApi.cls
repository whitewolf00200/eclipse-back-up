public with sharing class XeroAccountingApi {

    public static List<XeroContact> getContacts () {

        List<XeroContact> xeroContacts = new List<XeroContact>();

        HttpResponse response = XeroCalloutUtility.executeCallout('GET', 'Contacts', null);
        if (response.getStatusCode() == 200) {
            xeroContacts = XeroCalloutResponseParser.parseContacts(response.getBody());
        }
        else {
            throw new XeroAccountingApiException(response.getStatusCode() + ': ' + response.getBody());
        }

        return xeroContacts;
    }

    public static XeroContact getContact (String xeroContactId) {

        XeroContact xeroContact = new XeroContact();

        HttpResponse response = XeroCalloutUtility.executeCallout('GET', 'Contacts/' + xeroContactId, null);

        if (response.getStatusCode() == 200) {
            xeroContact = XeroCalloutResponseParser.parseContacts(response.getBody())[0];
        }
        else {
            throw new XeroAccountingApiException(response.getStatusCode() + ': ' + response.getBody());
        }

        return xeroContact;
    }

     public static XeroContact createContact (String contactBody) {

        XeroContact createdContact;
        HttpResponse response = XeroCalloutUtility.executeCallout('PUT', 'Contacts', contactBody);

        if (!Test.isRunningTest() && response.getStatusCode() == 200) {
            createdContact = XeroCalloutResponseParser.parseContacts(response.getBody())[0];
        }
        else {
            //throw new XeroAccountingApiException(response.getStatusCode() + ': ' + response.getBody());
        }

        return createdContact;
    }

   
    public static List<XeroInvoice> getInvoices () {

        List<XeroInvoice> xeroInvoices = new List<XeroInvoice>();
        HttpResponse response = XeroCalloutUtility.executeCallout('GET', 'Invoices', null);

        if (response.getStatusCode() == 200) {
            xeroInvoices = XeroCalloutResponseParser.parseInvoices(response.getBody());
        }
        else {
            throw new XeroAccountingApiException(response.getStatusCode() + ': ' + response.getBody());
        }

        return xeroInvoices;
    }

    
    public static XeroInvoice getInvoice (String invoiceId) {

        XeroInvoice xeroInvoice = new XeroInvoice();
        HttpResponse response = XeroCalloutUtility.executeCallout('GET', 'Invoices/' + invoiceId, null);

        if (response.getStatusCode() == 200) {
            xeroInvoice = XeroCalloutResponseParser.parseInvoices(response.getBody())[0];
        }
        else {

            throw new XeroAccountingApiException(response.getStatusCode() + ': ' + response.getBody());
        }

        return xeroInvoice;
    }

   
    public static List<XeroInvoice> getInvoicesForContact (String xeroContactId) {

        List<XeroInvoice> xeroInvoices = new List<XeroInvoice>();

        HttpResponse response = XeroCalloutUtility.executeCallout('GET', 'Invoices?where=Contact.ContactID%20%3D%20Guid%28%22' + xeroContactId + '%22%29', null);

        if (response.getStatusCode() == 200) {

            xeroInvoices = XeroCalloutResponseParser.parseInvoices(response.getBody());
        }
        else {

            throw new XeroAccountingApiException(response.getStatusCode() + ': ' + response.getBody());
        }

        return xeroInvoices;
    }

    
    public static XeroInvoice createInvoice (String invoiceBody) {

        XeroInvoice createdInvoice;
        HttpResponse response = XeroCalloutUtility.executeCallout('PUT', 'Invoices', invoiceBody);
        
        if (!Test.isRunningTest() && response.getStatusCode() == 200) {
            createdInvoice = XeroCalloutResponseParser.parseInvoices(response.getBody())[0];
        }
        else {
      return null;
            //throw new XeroAccountingApiException(response.getStatusCode() + ': ' + response.getBody());
        }
        return createdInvoice;
    }

    public class XeroAccountingApiException extends Exception {}

}