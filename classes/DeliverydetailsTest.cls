@isTest(seeAlldata=true)
Public Class DeliverydetailsTest{
     @isTest Public static void Method1(){ 

     List <Delivery_Note__c> lstDelivery = new List<Delivery_Note__c>();
     
     Account Acc=new Account();
     Acc.Name='Test Account';
     insert Acc;
     
     Delivery_Note__c testDel = new Delivery_Note__c();
     testDel.Date__c=system.today();
     testDel.Site__c=Acc.id;
     lstDelivery.add(testDel);
     
     Delivery_Note__c testDel1 = new Delivery_Note__c();
     testDel1.Date__c=system.today();
     testDel.Site__c=Acc.id;
     lstDelivery.add(testDel1);
     
     insert lstDelivery;
     
     product2 p=new Product2(Name='Test',isActive=true);
     insert p;
     
     Delivery_Note_Line_Item__c Deloli=new Delivery_Note_Line_Item__c();
     Deloli.Product__c=p.id;
     Deloli.Delivery_Note__c=lstDelivery[0].id;
     insert Deloli;
     
    Test.startTest();
      Test.setCurrentPage(Page.Export_Contact);
      ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(lstDelivery);
      stdSetController.setSelected(lstDelivery);
      Deliverydetails DelDetails = new Deliverydetails(stdSetController);
     Test.stopTest();
   }
}