@isTest
public class AcknowledgementCompContTest{
    
    static testMethod void myTest(){
    
    test.starttest();
    
    AcknowledgementComponentController AckCtrl=new AcknowledgementComponentController();
    AckCtrl.getpoNo();
    AckCtrl.setpoNo('Test');
    
    test.stoptest();
    }
}