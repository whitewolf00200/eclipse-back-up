@isTest
public class SettingsTest{
    
    static testMethod void myTest(){
    
    test.starttest();
    
    Settings Testset=new Settings();
    
    Testset.ptc='test';
    Testset.bg='test';
    Testset.foot2='test';
    Testset.foot='test';
    Testset.head='test';
    
    Testset.save();
    
    test.stoptest();
    }
}