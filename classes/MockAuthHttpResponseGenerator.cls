@isTest
/*============================================================================================================
*Class Name     : MockAuthHttpResponseGenerator 
*Description    : All the implementations are related to Get fake response for XeroOAuthUtilityTest.
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 29th Apr, 2020
*Version        : 1.0
*Change History : Xero Migration to 2.0
*Methods        : respond(HTTPRequest req)
*============================================================================================================*/


global class MockAuthHttpResponseGenerator implements HttpCalloutMock {
/*====================================================
*Method Name     : respond
*Description     : Return fake response.
*Arguments       : HTTPRequest req
*Ticket No       : 36814
====================================================*/
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint                
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type','application/json'); 
        res.SetBody('[{"tenantId":"1A2B3CDEFG"},{"BrandingThemes":[{"BrandingThemeID":"123ADCV","Name":"Test"}]},{"Invoices":[{"InvoiceID":"123456INV","AmountPaid":200,"DateString":"2020-04-21T00:00:00","DueDateString":"2020-04-21T00:00:00","PlannedPaymentDateString":"2020-04-21T00:00:00","AmountDue":70,"ExpectedPaymentDateString":"2020-04-21T00:00:00","FullyPaidOnDate":"(1587945600000+000)","AmountCredited":20,"SentToContact":"true","Payments":[{"PaymentID": "4dd1408f-34da-4a00-bf9b-ba5c4e605a84","Date": "Date(1645747200000+0000)","Amount": 100.00,"CurrencyRate": 1.0000000000,"HasAccount": false,"HasValidationErrors": false}],"CreditNotes": [],"Prepayments": [],"Overpayments": [],"AmountDue": 0.00,"AmountPaid": 242.00,"AmountCredited": 0.00,"SentToContact": true,"CurrencyRate": 1.0000000000,"IsDiscounted": true,"HasAttachments": false,"HasErrors": false,"Contact": {"ContactID": "b96454b5-174d-4b13-818c-ced8c192e541","ContactNumber": "","Name": "Eclipse Limited test","Addresses": [],"Phones": [],"ContactGroups": [],"ContactPersons": [],"HasValidationErrors": false},"DateString": "2022-02-23T00:00:00","Date": "Date(1645574400000+0000)","DueDateString": "2022-02-23T00:00:00","DueDate": "Date(1645574400000+0000)","ExpectedPaymentDateString": "2022-02-26T00:00:00","ExpectedPaymentDate": "Date(1645833600000+0000)","BrandingThemeID": "d2ad3964-4fe2-4551-b053-0f2637dcb7ab","Status": "PAID","LineAmountTypes": "Exclusive","LineItems": [{"ItemCode": "test","Description": "Travel to site address","UnitAmount": 70.00,"TaxType": "TAX003","TaxAmount": 0.00,"LineAmount": 70.00,"AccountCode": "200","Item": {"ItemID": "4c6f1363-b75a-4db6-9fb5-85702f9c52ae","Code": "test"},"Tracking": [],"Quantity": 1.0000,"DiscountRate": 0.00,"LineItemID": "fbb8d6ba-e422-471a-b87b-110753782844"}],"Type":"Test"}]}]');
        res.setStatusCode(200);
        res.setstatus('OK');   

        return res;
    }
}