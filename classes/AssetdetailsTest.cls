@isTest(seeAlldata=true)
Public Class AssetdetailsTest{
     @isTest Public static void Method1() { 

     List <Asset> lstAsset = new List<Asset>();
     
     Account testAccount = new Account();
     testAccount.Name='Test Account' ;
     insert  testAccount;
     
     Product2 prod = new Product2(Name = 'Laptop X200',Family = 'Hardware');
     insert prod;

     Asset Ass1=new Asset();
     Ass1.AccountId=testAccount.id;
     Ass1.Product2Id=prod.id;
     lstAsset.add(Ass1);
     
     Asset Ass2=new Asset();
     Ass2.AccountId=testAccount.id;
     Ass2.Product2Id=prod.id;
     lstAsset.add(Ass2);
     
    Test.startTest();
      Test.setCurrentPage(Page.Export_Asset);
      ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(lstAsset);
      stdSetController.setSelected(lstAsset);
      Assetdetails AssetDetails = new Assetdetails(stdSetController);
     Test.stopTest();
   }
}