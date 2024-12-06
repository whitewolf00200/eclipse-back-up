/*============================================================================================================
*Class Name     : FormQRCodeController 
*Description    : All the implementations related Generate Label For Product.
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 25th Jun, 2020
*Version        : 1.0
*Change History : Initial class
*Methods        : No Methods
*============================================================================================================*/
public with sharing class FormQRCodeController {

Public id ProdId;
public Product2 prod{get;set;}
Public String URLString{get;set;}


Public FormQRCodeController (){
ProdId=ApexPages.currentPage().getparameters().get('id');
prod=new Product2();
System.debug('id=='+ProdId);

prod=[Select id,Name,ProductCode,Supplier_Product_Code__c,Min_Stock__c,Maximum_stock_level__c from Product2 where id=:ProdId];

if(prod.Supplier_Product_Code__c!=null)

URLString ='https://chart.googleapis.com/chart?chs=250x250&cht=qr&chl='+prod.Supplier_Product_Code__c;

else
URLString='No Supplier Code';


}

}