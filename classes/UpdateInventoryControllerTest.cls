@isTest(SeeAllData=true)
public class UpdateInventoryControllerTest{
    
    static testMethod void myTest(){
    
    test.starttest();
    
    Warehouse__c WH=new Warehouse__c();
    WH.Name='Test';
    insert WH;
    
    PurchaseOrder__c PO=new PurchaseOrder__c();
    PO.Shipping_Warehouse__c=WH.id;
    PO.Create_Date__c=system.today();
    PO.Created_By__c='Tim Boyt';
    PO.Document_Creator__c='test@gmail.com';
    insert PO;
    
    List<Product2> PrdList=new List<Product2>();
    Product2 prd;
    
    prd=new product2();
    prd.Name='Test Product';
    prd.IsActive=true;
    prd.ProductCode='TES124';
    prd.Cost__c=12;
    PrdList.add(prd);
    
    prd=new product2();
    prd.Name='Test Serial';
    prd.IsActive=true;
    prd.ProductCode='TESer';
    prd.Cost__c=12;
    prd.Serialized__c=true;
    PrdList.add(prd);
    
    insert PrdList;
  
    List<PurchaseOrderLineItem__c> POLis=new List<PurchaseOrderLineItem__c>();
    PurchaseOrderLineItem__c POLine;
    
    for(Product2 Prds:PrdList){
        POLine=new PurchaseOrderLineItem__c();
        POLine.Purchase_Order__c=PO.id;
        POLine.Product__c=Prds.id;
        POLine.Quantity__c=3;
        POLine.Price__c=10;
        POLis.add(POLine);
    }
    
    insert POLis;
    
    Inventory__c Inv=new Inventory__c();
        Inv.Warehouse__c=WH.id;
        Inv.Product__c=PrdList[0].id;
    insert Inv;
        
    apexpages.standardcontroller sc=new apexpages.standardcontroller(PO);
    apexpages.currentpage().getparameters().put('id',String.valueof(PO.id));
    
    UpdateInventoryController InvCtrl=new UpdateInventoryController(sc);
    
    for(PurchaseOrderLineItem__c POli:[select id,Name,Product__r.Name,Product__c,Quantity__c,Last_Received_Quantity__c,Remaining_Quantity__c,Total_Received_Quantity__c from PurchaseOrderLineItem__c where Purchase_Order__c=:PO.id and Serialized__c=false and Non_Stock__c=false and Remaining_Quantity__c>0]){
        UpdateInventoryController.NonSerialWrap wrap=new UpdateInventoryController.NonSerialWrap(POli.id,POli.Product__r.Name,POli.Product__c,POli.Quantity__c,POli.Remaining_Quantity__c,1,POli.Total_Received_Quantity__c!=null?POli.Total_Received_Quantity__c:0,null);
        InvCtrl.NonSerial.add(wrap);
    }
    
    for(PurchaseOrderLineItem__c POli:[select id,Name,Product__r.Name,Product__c,Quantity__c,Last_Received_Quantity__c,Remaining_Quantity__c,Total_Received_Quantity__c from PurchaseOrderLineItem__c where Purchase_Order__c=:PO.id and Serialized__c=true and Remaining_Quantity__c>0]){
        List<Inventory_Transaction__c> NewInvTrns=new List<Inventory_Transaction__c>();
        UpdateInventoryController.SerialWrap wrap1=new UpdateInventoryController.SerialWrap(POli.id,POli.Product__r.Name,POli.Product__c,POli.Quantity__c,POli.Remaining_Quantity__c,1,POli.Total_Received_Quantity__c!=null?POli.Total_Received_Quantity__c:0,NewInvTrns,null);
        InvCtrl.Serial.add(wrap1);
    }
    
    InvCtrl.CheckValidQty();
    InvCtrl.SerialCount();
    InvCtrl.Cancel();
    InvCtrl.SaveAction();
    
    test.stoptest();
    }
}