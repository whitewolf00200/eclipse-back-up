@isTest
public class OppListInvoiceHandlerTest{
    
    static testMethod void myTest(){
    
    test.starttest();
    
    Opportunity Opps=new Opportunity();
    Opps.Name='Test';
    Opps.CloseDate=system.today();
    Opps.StageName='Closed Won';
    insert Opps;
    
    OppListInvoiceHandler Opp=new OppListInvoiceHandler();
    Opp.updateFun();
    
    test.stoptest();
    }
}