/*=========================================================================================================
    *Class Name     : ProductPBLControllerTest
    *Description    : Test class for ProductPBLController
    *Company        : Merfantz Technology
    *Date           : 23 Nov 2018  
 ============================================================================================================== */    



@istest
public class ProductPBLControllerTest
{

/*================================================================
Method Name: Mytest
Parameters : Null
Description: 
Date       : 23 Nov 2018  
================================================================*/


static testmethod void Mytest()
{
//Standard PriceBook
PriceBook2 pb1 = New PriceBook2(Id = test.getStandardPricebookId(), isActive = true);
update pb1;

//products
Product2 Prd=new Product2();
Prd.Name='Test Product';
Prd.isActive=true;
insert Prd;

//Standard PriceBook Id
id PriceBookID  = test.getStandardPricebookId();

//Standard priceBookEntry1
PricebookEntry standardPrice = new PricebookEntry(
Pricebook2Id = pricebookId, Product2Id = prd.Id,
UnitPrice = 0.0, IsActive = true,CurrencyIsoCode ='GBP');
insert standardPrice;

//Standard priceBookEntry2
PricebookEntry standardPrice2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prd.Id,UnitPrice = 0.0, IsActive = true,CurrencyIsoCode ='EUR');
insert standardPrice2 ;

//Custom PriceBook
pricebook2  customPB=new pricebook2();
customPB.name='custom pricebook';
customPB.isactive=true;
insert customPB;

//Custom PriceBook2
pricebook2  customPB1=new pricebook2();
customPB1.name='custom pricebook';
customPB1.isactive=true;
insert customPB1;

//Custom pricebookentry 
PricebookEntry pBe=new PricebookEntry();
pbe.product2id = prd.id;
pbe.pricebook2id =customPB.id;
pbe.UnitPrice =1000.00;  
pbe.isActive=true;
insert pbe;

//Apex PageReference
pageReference pageRef= Page.ProductPriceBookLineItemPage;
Test.setCurrentPage(pageRef);
pageRef.getParameters().put('id',Prd.id);
ProductPBLController MyControllerObj = new ProductPBLController();

//Wrapper class
ProductPBLController.InstallSysWrap wrapper1=new ProductPBLController.InstallSysWrap(true,customPB);
ProductPBLController.InstallSysWrap1 wrapper= new ProductPBLController.InstallSysWrap1(True,customPB1);

//PageReference Method
MyControllerObj.Selected();
MyControllerObj.CANCEL();
MyControllerObj.SaveMore();
MyControllerObj.SaveFun();

}
}