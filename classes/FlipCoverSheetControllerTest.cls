@istest(SeeAllData=true)
class FlipCoverSheetControllerTest{
static testMethod void mymethod (){

    test.starttest();
    Account a=new Account();
    a.Name='test';
    insert a;
    
    //Contact c=new Conact();
    ApexPages.StandardController sco = new ApexPages.StandardController(a);
    FlipCoverSheetController fl=new FlipCoverSheetController(sco);
    test.stoptest();

}

}