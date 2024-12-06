@isTest(seeAlldata=true)
Public Class ProductDetailsTest{
     @isTest Public static void Method1() { 

     List <Product2> lstProduct = new List<Product2>();
     
     product2 prd=new Product2(Name='Test Prd');
     lstProduct.add(prd);
     
     product2 prd1=new Product2(Name='Test Prd');
     lstProduct.add(prd1);
     
     insert  lstProduct;
     
    Test.startTest();
      Test.setCurrentPage(Page.Export_Opportunity);
      ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(lstProduct);
      stdSetController.setSelected(lstProduct);
      ProductDetails PrdList = new ProductDetails(stdSetController);
     Test.stopTest();
   }
}