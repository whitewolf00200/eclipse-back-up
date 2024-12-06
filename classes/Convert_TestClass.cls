@isTest(seeAllData=true)
public class Convert_TestClass 
{
    private static Lead testLead;
    private static Account testAccount;
    private static void init()
    {
        testLead = new Lead();
        testLead.LastName = 'testLead';
        testLead.Company = 'testCompany';
        testLead.Status = 'Converted-Qualified';
        database.insert(testLead);
        testAccount = new Account();
        testAccount.Name = 'Amsec';
        database.insert(testAccount);
        
    }
    static testmethod void testConv()
    {
        init();
        Test.starttest();
        String passString = ConvertLeadToOpp.Convert(testLead.Id);
        Test.stoptest();
        System.assertEquals(passString,'Success');
      
    }  
}