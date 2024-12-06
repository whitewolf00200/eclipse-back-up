@isTest
/*============================================================================================================
*Class Name     : MockHttpErrResponseGenerator 
*Description    : All the implementations are related to Get fake response for Xero classes.
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 29th Apr, 2020
*Version        : 1.0
*Change History : Xero Migration to 2.0
*Methods        : respond(HTTPRequest req)
*============================================================================================================*/
global class MockHttpErrResponseGenerator implements HttpCalloutMock {
/*====================================================
*Method Name     : respond
*Description     : Return fake failure response.
*Arguments       : HTTPRequest req
*Ticket No       : 
====================================================*/
    global HTTPResponse respond(HTTPRequest req) {
       // Optionally, only send a mock response for a specific endpoint                
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type','application/json'); 
        res.SetBody('[{"Message":"Error Occured"},{"tenantId":"1A2B3CDEFG"}]');
        res.setStatusCode(500);
        res.setstatus('Failed');
        return res;
    }
}