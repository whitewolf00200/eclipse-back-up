@isTest(SeeAllData=true)
public class TrasferPartsControllerTest{
    
    
    
    static testMethod void myTest1(){
    
    Map<Id,List<Inventory__c>> CheckStatus=new Map<Id,List<Inventory__c>>();
    Map<String,Inventory_Transaction__c> UpdateVehMap;
    UpdateVehMap=new Map<String,Inventory_Transaction__c>();
    test.starttest();
    
    product2 prd=new product2();
    prd.Name='Test Product';
    prd.IsActive=true;
    prd.ProductCode='TES124';
    prd.Cost__c=12;
    insert prd;
    
    Warehouse__c WH=new Warehouse__c();
    WH.Name='Test';
    insert WH;
    
    Vehicle__c ve=new Vehicle__c(Name='vehicle',Warehouse__c=WH.id,Available__c=true);
    insert ve;
       
    Inventory__c Inv=new Inventory__c();
     Inv.Warehouse__c=WH.id;
    Inv.Product__c=prd.id;
    insert Inv;
    
     
   Inventory_Transaction__c IT=new Inventory_Transaction__c();
    It.Name='Test';
    IT.Transaction_Type__c='In Vehicle';
    IT.Inventory__c=Inv.id;
    IT.Vehicle__c=ve.id;
   // IT.Inventory__r.Product__r.Name;
    insert IT;
    system.debug('invT============='+Inv.id);
   
  
    ApexPages.currentPage().getParameters().put('Id',WH.id);
    ApexPages.currentPage().getParameters().put('selInv',String.valueOf(Inv.id));
    
     List<TrasferPartsController.SerialWrapper> SerialWrap=new List<TrasferPartsController.SerialWrapper>();
     list<TrasferPartsController.WrapInv> wrapInvList = new list<TrasferPartsController.WrapInv>();
     list<TrasferPartsController.wrapTran> wrapTranList = new list<TrasferPartsController.wrapTran>();
     TrasferPartsController.WrapInv wrapI = new TrasferPartsController.WrapInv('Test Product',wrapTranList ,2,4,prd.id,SerialWrap,Inv.id,Inv.Warehouse__c);
     wrapInvList.add(wrapI);
     
    
     PageReference pageRef = Page.TransferParts;
     Test.setCurrentPage(pageRef);

     pageRef.getParameters().put('Id', String.valueOf(WH.Id));
     ApexPages.StandardController sc = new ApexPages.StandardController(WH);
     TrasferPartsController TP=new TrasferPartsController(sc);
    TP.searchString ='';
    TP.wrapInvList=wrapInvList;
    apexpages.currentpage().getparameters().put('qtyPrd',prd.Name);
   // TrasferPartsController.wrapTran tr=new TrasferPartsController.wrapTran(prd.name, 'test',IT.id);
   // TrasferPartsController.WrapInv wrp=new TrasferPartsController.WrapInv(prd.Name,'',2,1);
   // TrasferPartsController.Vehctransfer vt=new TrasferPartsController.Vehctransfer (prd.name,IT.Name,true,IT.Vehicle__c,IT.id,null);
    // system.debug('prd name= '+prd.name+' S.no= '+IT.Name+' false= '+false+'vehicle = '+IT.Vehicle__c+'id=== '+IT.id);
   // TP.ChngReason='Test';
   // TP.transTypeWH=true;
   // TP.Invslists();
   // TP.cancel();
   // TP.selctedInvs();
   
    TP.selectedPicValue='Warehouse to Vehicle';
    TP.transTypeWH = false;
    TP.transTypeVH = true;
    TP.transTypeHV = false;
    TP.TransferTypeChange();
    
    
   TP.selectedPicValue='Vehicle to Warehouse';
   TP.transTypeWH = false;
    TP.transTypeVH = false;
    TP.transTypeHV = true;
    TP.TransferTypeChange();
    TP.InvQtyChange();
    
    list<TrasferPartsController.Vehctransfer> VehicleParts= new list<TrasferPartsController.Vehctransfer>();
    TrasferPartsController.Vehctransfer trans = new TrasferPartsController.Vehctransfer('Test Product','Test',true,'vehicle',IT.id,null,IT.Warehouse_id__c);
    VehicleParts.add(trans);
     TP.getVehicleParts();
      
    
    
    TP.SaveInv();
    }
    
    static testMethod void myTest2(){
    List<TrasferPartsController.SerialWrapper> SerialWrap=new List<TrasferPartsController.SerialWrapper>();
     Map<Id,List<Inventory__c>> CheckStatus=new Map<Id,List<Inventory__c>>();
    test.starttest();
    
    product2 prd=new product2();
    prd.Name='Test Product';
    prd.IsActive=true;
    prd.ProductCode='TES124';
    prd.Cost__c=12;
    insert prd;
    
    Warehouse__c WH=new Warehouse__c();
    WH.Name='Test';
    insert WH;
    
    Vehicle__c ve=new Vehicle__c(Name='vehicle',Warehouse__c=WH.id,Available__c=true);
    insert ve;
    
    Inventory__c Inv=new Inventory__c();
     Inv.Warehouse__c=WH.id;
    Inv.Product__c=prd.id;
    insert Inv;
    
   Inventory_Transaction__c IT=new Inventory_Transaction__c();
    It.Name='Test';
    IT.Transaction_Type__c='Received';
    IT.Inventory__c=Inv.id;
    
    insert IT;
    
    system.debug('invT============='+Inv.id);
    ApexPages.currentPage().getParameters().put('Id',WH.id);
    ApexPages.currentPage().getParameters().put('selInv',String.valueOf(Inv.id));
    apexpages.currentpage().getparameters().put('qtyPrd',prd.Name);
    PageReference pageRef = Page.TransferParts;
     Test.setCurrentPage(pageRef);

     pageRef.getParameters().put('Id', String.valueOf(WH.Id));
     ApexPages.StandardController sc = new ApexPages.StandardController(WH);
     TrasferPartsController TP=new TrasferPartsController(sc);
    TP.searchString ='';
    
    
   //TrasferPartsController.WrapInv wrp=new TrasferPartsController.WrapInv(prd.Name,inv,0,1);
    // TrasferPartsController.Vehctransfer vt=new TrasferPartsController.Vehctransfer (prd.name,IT.Name,false,IT.Vehicle__c,IT.id,null);
    // system.debug('prd name= '+prd.name+' S.no= '+IT.Name+' false= '+false+'vehicle = '+IT.Vehicle__c+'id=== '+IT.id);
    TP.ChngReason='Test';
    TP.transTypeWH=true;
    TP.Invslists();
    TP.cancel();
    TP.selctedInvs();
    //TP.InvQtyChange();
     TP.getVehicleParts();
    
   
   // TP.updateinvs();
   TP.selectedPicValue='Warehouse to Warehouse';
    TP.transTypeWH = true;
    TP.transTypeVH = false;
    TP.transTypeHV = false;
    TP.TransferTypeChange();
    
    TrasferPartsController.wrapTran tr=new TrasferPartsController.wrapTran(prd.name,'Test',IT.id);
    list<TrasferPartsController.wrapTran> wraptranList =new list<TrasferPartsController.wrapTran>();
    wraptranList.add(tr);
    system.debug('wraptranList<<<<<<<<====='+wraptranList);
    list<TrasferPartsController.WrapInv> wrapInvList = new list<TrasferPartsController.WrapInv>();
    TrasferPartsController.WrapInv wrapI = new TrasferPartsController.WrapInv('Test Product',wraptranList ,2,4,prd.id,SerialWrap,Inv.id,Inv.Warehouse__c);
    wrapInvList.add(wrapI );
     system.debug('wrapInvList<<<<<<<<====='+wrapInvList);
   
     TP.SaveInv();
    //TP.Transaction_Type__c='In Vehicle';
   
    test.stoptest();
    }
    
}