/*Class Name : SpecialAccountProductPricePageTest
Purpose      : SpecialAccountProductPricePageController Test Class.
Author       : Sachin Chincholi
Created On   : 03/02/2014
Last Modified On : 06/02/2014
Reason for Modification : Added Functionality */


@isTest(seeAllData = true)
public class SpecialAccountProductPricePageTest{
    
    static testMethod void specialAccountProductTest() {
        test.startTest();
        List<Account_Product_Price__c> appList =  new List<Account_Product_Price__c>();
        ApexPages.StandardController controller;  
        
        //Create Test Data
        Account acc = new Account();
        acc.name = 'Test Account';
        insert acc;
        
        //Create Test Data for Product
        Pricebook2 pb2 = [select Id,name,isActive from Pricebook2 where isStandard=true];
        
        Product2 p2 = new Product2(Name='Test Product',isActive=true,UniqueSageCode__c='H8486_4888',Product_Name_Check__c='10 Person First Aid Kit Product');
        insert p2;
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pb2.id, Product2Id=p2.Id, UnitPrice=99, isActive=true);
        insert pbe;
        
        Account_Product_Price__c app = new Account_Product_Price__c(); 
        app.Account__c = acc.id;
        app.Product__c = p2.id;
        app.Price__c = 0.00;
        appList.add(app);
        insert appList;
        ApexPages.CurrentPage().getparameters().put('id', appList[0].id);
        SpecialAccountProductPricePageController  instance = new SpecialAccountProductPricePageController(controller);
        instance.addRow();
        instance.addRowAcc();
        instance.SaveData();
        system.assertEquals(app.Price__c,0.00);
        system.assertEquals(appList.size(),1);
        instance.SaveandExit();
        test.stopTest();
    }
}