@isTest(SeeAllData=true)
public class BarcodeControllerTest{
    
    static testMethod void myTest(){
    
    test.starttest();
     
     Account Acc=new Account();
     Acc.Name='Test';
     insert Acc;
     
     ApexPages.CurrentPage().getParameters().put('id',String.valueOf(Acc.id));
     BarcodeController Barcode=new BarcodeController();
     Barcode.imageBase='Test';
     Barcode.saveImage();
    
    test.stoptest();
    }
}