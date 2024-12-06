@isTest
public class XeroAccountingApiTest {

    @isTest
    static void getContactsSuccess () {

        Test.setMock(HttpCalloutMock.class, getStaticMock(200, 'XeroContactsMock'));
        Test.startTest();
        List<XeroContact> xeroContacts = XeroAccountingApi.getContacts();
        Test.stopTest();

        system.assertEquals(
            1,
            xeroContacts.size(),
            'There should be one contact returned from the callout'
        );
    }


    @isTest
    static void getContactsFail () {

        Test.setMock(HttpCalloutMock.class, getStaticMock(500, 'XeroContactsMock'));
        Test.startTest();

        try {

            List<XeroContact> xeroContacts = XeroAccountingApi.getContacts();
        } 
        catch (Exception ex) {

            system.assert(
                String.valueOf(ex).contains('500'),
                'The 500 error code should be contained in the string.'
            );
        }

        Test.stopTest();
    }

    @isTest
    static void createContactSuccess () {

        Test.setMock(HttpCalloutMock.class, getStaticMock(200, 'XeroContactsMock'));

        Test.startTest();

        XeroContact createdContact = XeroAccountingApi.createContact('<Contact><Name>Test Contact</Name></Contact>');

        Test.stopTest();

        system.assertNotEquals(
            null,
            createdContact,
            'The contact should be created and not null.'
        );
    }


    @isTest
    static void createContactsFail () {

        Test.setMock(HttpCalloutMock.class, getStaticMock(500, 'XeroContactsMock'));

        Test.startTest();

        try {

            XeroContact createdContact = XeroAccountingApi.createContact('<Contact><Name>Test Contact</Name></Contact>');
        } 
        catch (Exception ex) {

            system.assert(
                String.valueOf(ex).contains('500'),
                'The 500 error code should be contained in the string.'
            );
        }

        Test.stopTest();
    }

    
    @isTest
    static void getInvoicesSuccess() {

        Test.setMock(HttpCalloutMock.class, getStaticMock(200, 'XeroInvoicesMock'));

        Test.startTest();

        List<XeroInvoice> xeroInvoices = XeroAccountingApi.getInvoices();

        Test.stopTest();

        system.assertEquals(
            1,
            xeroInvoices.size(),
            'There should be one invoice returned from the callout'
        );
    }

    
    @isTest
    static void getInvoicesFail() {

        Test.setMock(HttpCalloutMock.class, getStaticMock(500, 'XeroInvoicesMock'));

        Test.startTest();

        try {

            List<XeroInvoice> xeroInvoices = XeroAccountingApi.getInvoices();
        } 
        catch (Exception ex) {

            system.assert(
                String.valueOf(ex).contains('500'),
                'The 500 error code should be contained in the string.'
            );
        }

        Test.stopTest();
    }

    @isTest
    static void getInvoicesForContactSuccess() {

        Test.setMock(HttpCalloutMock.class, getStaticMock(200, 'XeroInvoicesMock'));

        Test.startTest();

        List<XeroInvoice> xeroInvoices = XeroAccountingApi.getInvoicesForContact('ABC123');

        Test.stopTest();

        system.assertEquals(
            1,
            xeroInvoices.size(),
            'There should be one invoice returned from the callout'
        );
    }

    @isTest
    static void createInvoiceSuccess() {

        Test.setMock(HttpCalloutMock.class, getStaticMock(200, 'XeroInvoicesMock'));

        Test.startTest();

        XeroInvoice createdInvoice = XeroAccountingApi.createInvoice('<Invoice>BODY</Invoice>');

        Test.stopTest();

        system.assertNotEquals(
            null,
            createdInvoice,
            'There should be one invoice created from the callout'
        );
    }

    
    @isTest
    static void createInvoiceFail() {

        Test.setMock(HttpCalloutMock.class, getStaticMock(500, 'XeroInvoicesMock'));

        Test.startTest();

        try {

            XeroInvoice createdInvoice = XeroAccountingApi.createInvoice('<Invoice>BODY</Invoice>');
        } 
        catch (Exception ex) {

            system.assert(
                String.valueOf(ex).contains('500'),
                'The 500 error code should be contained in the string.'
            );
        }

        Test.stopTest();
    }

    @isTest
    static void getXeroSettingsError() {

        delete [Select Id From Xero_Settings__c];

        system.assertEquals(
            null,
            XeroCalloutUtility.xeroSettings.Id,
            'There should be no Xero Setting record found.'
        );

    }

    private static StaticResourceCalloutMock getStaticMock (Integer responseCode, String mockName) {

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource(mockName);
        mock.setStatusCode(responseCode);
        mock.setHeader('Content-Type', 'application/json');

        return mock;
    }


    @testSetup
    static void setupTestData () {

        insert new Xero_Settings__c(
            SetupOwnerId = Userinfo.getOrganizationId(),
            Consumer_Key__c = '123456789',
            Endpoint__c = 'https://api.xero-test.com?param1=value1&param2=value2/'
        );

    }
    
}