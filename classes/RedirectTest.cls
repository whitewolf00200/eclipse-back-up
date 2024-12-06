@isTest(SeeAllData=true)
public class RedirectTest{
    
    static testMethod void myTest(){
    
    test.starttest();
    
    Account Acc=new Account();
    Acc.Name='Test';
    insert Acc;
    
    ApexPages.StandardController sc = new ApexPages.standardController(Acc);
    ApexPages.currentPage().getParameters().put('Id', Acc.id);
    Redirect Redrts=new Redirect(sc);
    
    test.stoptest();
    }
}