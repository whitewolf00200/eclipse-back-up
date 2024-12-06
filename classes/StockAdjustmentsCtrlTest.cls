@isTest(SeeAllData=true)
public class StockAdjustmentsCtrlTest{
    
    static testMethod void myTest(){
    
    test.starttest();
    
    Warehouse__c WH=new Warehouse__c();
    WH.Name='Test';
    insert WH;
    
    product2 prd=new product2();
    prd.Name='Test Product';
    prd.IsActive=true;
    prd.Serialized__c=true;
    prd.ProductCode='TES124';
    prd.Cost__c=12;
    insert prd;
    
    Inventory__c Inv=new Inventory__c();
    Inv.Warehouse__c=WH.id;
    Inv.Product__c=prd.id;
    insert Inv;
    
    ApexPages.StandardController sc = new ApexPages.standardController(WH);
    ApexPages.currentPage().getParameters().put('Id', WH.id);
    StockAdjustmentsController SCA=new StockAdjustmentsController(sc); 
    
    Apexpages.currentpage().getparameters().put('selInv',String.Valueof(prd.id));
    
    SCA.ProductId=prd.id;
    SCA.ProductName=prd.Name;
    SCA.Quantity='3';
    
    SCA.AddStock();
    SCA.RemoveStock();
    SCA.PrdRemCancel();
    SCA.PrdCancel();
    SCA.Cancel();
    SCA.selctedInvs();
    SCA.StockSearch();
    SCA.StockAdjust();
    SCA.saveclick();
    SCA.UpdateInvTrans();
    SCA.RemovePrdSelect();
    test.stoptest();
    }
    
    static testMethod void myTest1(){
        test.starttest();
    
        Warehouse__c WH1=new Warehouse__c();
        WH1.Name='Test';
        insert WH1;
    
        product2 prd1=new product2();
        prd1.Name='Test Product';
        prd1.IsActive=true;
        prd1.Serialized__c=true;
        prd1.ProductCode='TES124';
        prd1.Cost__c=12;
        insert prd1;
        
        ApexPages.StandardController sc1 = new ApexPages.standardController(WH1);
        ApexPages.currentPage().getParameters().put('Id', WH1.id);
        StockAdjustmentsController SCA1=new StockAdjustmentsController(sc1); 
        
        SCA1.ProductId=prd1.id;
        
        SCA1.saveclick();
        
        test.stoptest();
    }
}