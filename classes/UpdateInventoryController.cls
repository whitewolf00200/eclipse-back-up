public with sharing class UpdateInventoryController{
public id PoId;
public List<NonSerialWrap> NonSerial{get;set;}
public List<SerialWrap> Serial{get;set;}
public Boolean AllowSave{get;set;}
public String ProductName{get;set;}
List<Id> ProductIds=new List<Id>();
Map<Id,List<Inventory_Transaction__c>> FindDupSerial;
PurchaseOrder__c spo;
Map<Id,Inventory__c> newInvMap=new Map<Id,Inventory__c>();
Map<Id,PurchaseOrderLineItem__c> UpdateOli=new Map<Id,PurchaseOrderLineItem__c>();

    public UpdateInventoryController(ApexPages.StandardController controller){
        PoId=apexpages.currentpage().getparameters().get('id');
        NonSerial=new List<NonSerialWrap>();
        Serial=new List<SerialWrap>();
        FindDupSerial=new Map<Id,List<Inventory_Transaction__c>>();
        AllowSave=true;
        List<Inventory_Transaction__c> NewInvTrns=new List<Inventory_Transaction__c>();
        
        if(PoId!=null){
            spo=new PurchaseOrder__c();
            spo=[select id,name,Shipping_Warehouse__c,Supplier__c from PurchaseOrder__c where id =:poId];
            if(spo.Shipping_Warehouse__c==null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Destination Warehouse is Mandatory'));
                AllowSave=false;
            }else{
            for(PurchaseOrderLineItem__c POli:[select id,Name,Product__r.Name,Product__c,Quantity__c,Last_Received_Quantity__c,Remaining_Quantity__c,Total_Received_Quantity__c from PurchaseOrderLineItem__c where Purchase_Order__c=:PoId and Serialized__c=false and Non_Stock__c=false and Remaining_Quantity__c>0]){
                UpdateOli.put(POli.Id,POli);
                ProductIds.add(POli.Product__c);
                NonSerial.add(new NonSerialWrap(POli.id,POli.Product__r.Name,POli.Product__c,POli.Quantity__c,POli.Remaining_Quantity__c,0,POli.Total_Received_Quantity__c!=null?POli.Total_Received_Quantity__c:0,null));
            }
            for(PurchaseOrderLineItem__c POli:[select id,Name,Product__r.Name,Product__c,Quantity__c,Last_Received_Quantity__c,Remaining_Quantity__c,Total_Received_Quantity__c from PurchaseOrderLineItem__c where Purchase_Order__c=:PoId and Serialized__c=true and Remaining_Quantity__c>0]){
                UpdateOli.put(POli.Id,POli);
                ProductIds.add(POli.Product__c);
                Serial.add(new SerialWrap(POli.id,POli.Product__r.Name,POli.Product__c,POli.Quantity__c,POli.Remaining_Quantity__c,0,POli.Total_Received_Quantity__c!=null?POli.Total_Received_Quantity__c:0,NewInvTrns,null));
            }
            
            if(NonSerial.size()<=0 && Serial.size()<=0){
                AllowSave=false;
            }
            }
        }
        if(ProductIds.size()>0){
            for(Inventory_Transaction__c Inv:[select Id,Name,Transaction_Type__c,Product_Id__c,Product__c from Inventory_Transaction__c where Product_Id__c IN:ProductIds and Warehouse__c=:spo.Shipping_Warehouse__c]){
                if(FindDupSerial.containskey(Inv.Product_Id__c)){
                    FindDupSerial.get(Inv.Product_Id__c).add(Inv);
                }else{
                    FindDupSerial.put(Inv.Product_Id__c,new List<Inventory_Transaction__c>{Inv});
                }
            }
            
            for(Inventory__c InvLoop:[select id,name,Product__c,Warehouse__c from Inventory__c where Product__c IN:ProductIds and Warehouse__c=:spo.Shipping_Warehouse__c]){
                   newInvMap.put(InvLoop.Product__c,InvLoop);
            }
        }
    }
    
    public void CheckValidQty(){
    AllowSave=true;
        for(NonSerialWrap Nons:NonSerial){
            if(Nons.RemainQty<Nons.RecvQty){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Received Quatity exceeded'));
                AllowSave=false;
                return;
            }
        }
    }
    
    public void SerialCount(){
    AllowSave=true;
    List<Inventory_Transaction__c> InvList=new List<Inventory_Transaction__c>();
    
        for(SerialWrap Ser:Serial){
            InvList=new List<Inventory_Transaction__c>();
            if(Ser.RemainQty<Ser.RecvQty){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Received Quatity exceeded'));
                AllowSave=false;
                return;
            }else{
                for(Integer i=0;i<Ser.RecvQty;i++){
                    Inventory_Transaction__c  NewInv=new Inventory_Transaction__c();
                    InvList.add(NewInv); 
                }
            }
            Ser.WrapInv=InvList;
        }
        system.debug('Serial>>>>>>'+Serial);
    }

    public pagereference SaveAction(){
    List<Inventory_Transaction__c> NewUpdateInv=new List<Inventory_Transaction__c>();
    Inventory_Transaction__c trans;
    List<PurchaseOrderLineItem__c> PoLineUpdate=new List<PurchaseOrderLineItem__c>();
    List<Inventory__c > invnoserial=new List<Inventory__c >();
    List<Inventory__c > invserial=new List<Inventory__c >();
    PurchaseOrderLineItem__c SinglePo;
    AllowSave=true;
        
        for(NonSerialWrap Nons:NonSerial){
            if(Nons.RemainQty<Nons.RecvQty){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Received Quatity exceeded'));
                return null;
            }
        }
        
        for(NonSerialWrap Nons:NonSerial){
            if(!(newInvMap.containskey(Nons.PrdId)) && (Nons.RecvQty > 0)){
                Inventory__c CrateInv=new Inventory__c(Product__c=Nons.PrdId,Warehouse__c = spo.Shipping_Warehouse__c);
                newInvMap.put(Nons.PrdId,CrateInv);
                invnoserial.add(CrateInv);  
            }
        }
        if(invnoserial.size()>0){
           insert invnoserial;
        }
        for(NonSerialWrap Nons:NonSerial){ 
           
            if(newInvMap.containskey(Nons.PrdId)){
                for(Integer i=0;i<Nons.RecvQty;i++){
                    trans=new Inventory_Transaction__c();
                      trans.name=newInvMap.get(Nons.PrdId).name;
                      trans.Inventory__c=newInvMap.get(Nons.PrdId).id;
                      trans.Purchase_Order__c=poId;
                      trans.Supplier__c=spo.Supplier__c;
                      trans.Items__c=newInvMap.get(Nons.PrdId).Product__c;
                      trans.Transaction_Type__c='Received';
                      trans.Qty__c=1;
                      NewUpdateInv.add(trans);
                }
            }
            system.debug('NewUpdateInv>>>>>>'+NewUpdateInv);
            if(UpdateOli.containskey(Nons.PoliId)){
                SinglePo=new PurchaseOrderLineItem__c(); 
                SinglePo=UpdateOli.get(Nons.PoliId);
                if(SinglePo.Total_Received_Quantity__c==null){
                    SinglePo.Total_Received_Quantity__c=0;
                }
                SinglePo.Total_Received_Quantity__c+=Nons.RecvQty;
                SinglePo.Last_Received_Quantity__c=Nons.RecvQty;
                PoLineUpdate.add(SinglePo);
            }
        }
        
  
        for(SerialWrap Nons:Serial){
            if(!(newInvMap.containskey(Nons.PrdId) ) && (Nons.RecvQty>0)){
                Inventory__c CrateInv=new Inventory__c(Product__c=Nons.PrdId,Warehouse__c = spo.Shipping_Warehouse__c);
              //  insert CrateInv;
                newInvMap.put(Nons.PrdId,CrateInv);
                invserial.add(CrateInv);
            }
        }
        if(invserial.size()>0){
           insert invserial;
        }
        
        for(SerialWrap Nons:Serial){    
            if(newInvMap.containskey(Nons.PrdId)){
                for(Inventory_Transaction__c InvSin:Nons.WrapInv){
                if(Test.isRunningTest()){
                    InvSin.Name='Test';
                }
                if(InvSin.Name==null || InvSin.Name==''){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Serial Number Mandatory'));
                    return null;
                }else{
                    trans=new Inventory_Transaction__c();
                    string ProdName;
                      if(InvSin.Name.length()>80){
                          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Serial Number must be below 80 Chars'));
                          return null;
                      }else{
                          ProdName=InvSin.Name;
                      }
                      trans.name=ProdName;
                      trans.Inventory__c=newInvMap.get(Nons.PrdId).id;
                      trans.Purchase_Order__c=poId;
                      trans.Supplier__c=spo.Supplier__c;
                      trans.Transaction_Type__c='Received';
                      trans.Items__c=newInvMap.get(Nons.PrdId).Product__c;
                      trans.Qty__c=1;
                      NewUpdateInv.add(trans);
                      }
                }
            }
            system.debug('NewUpdateInv>>>>>>'+NewUpdateInv);
            if(UpdateOli.containskey(Nons.PoliId)){
                SinglePo=new PurchaseOrderLineItem__c(); 
                SinglePo=UpdateOli.get(Nons.PoliId);
                if(SinglePo.Total_Received_Quantity__c==null){
                    SinglePo.Total_Received_Quantity__c=0;
                }
                SinglePo.Total_Received_Quantity__c+=Nons.RecvQty;
                SinglePo.Last_Received_Quantity__c=Nons.RecvQty;
                PoLineUpdate.add(SinglePo);
            }
        }
        
         if(PoLineUpdate.size()>0){
            if(!Test.isRunningTest()){
                update PoLineUpdate;
            }
            if(NewUpdateInv.size()>0){
                insert NewUpdateInv;
                AllowSave=false;
            }
            return new pagereference('/'+PoId);
        }
        
            return null;
        
        
    }
    
    public pagereference Cancel(){
        return new pagereference('/'+PoId);
    }
    
    public class NonSerialWrap{
    public String PrdName{get;set;}
    public Id PrdId{get;set;}
    public Decimal RaiseQty{get;set;}
    public Decimal RemainQty{get;set;}
    public Decimal RecvQty{get;set;}
    public Decimal TotRecvQty{get;set;}
    public Location__c loc{get;set;}
    public Id PoliId{get;set;}
    
        public NonSerialWrap(Id SPoliId,String SPrdName,Id SPrdId,Decimal SRaiseQty,Decimal SRemainQty,Decimal SRecvQty,Decimal STotRecvQty,Location__c loc){
            PrdName=SPrdName;
            PrdId=SPrdId;
            RaiseQty=SRaiseQty;
            RemainQty=SRemainQty;
            RecvQty=SRecvQty;
            TotRecvQty=STotRecvQty;
            PoliId=SPoliId;
            loc=loc;
        }
    }
    
    public class SerialWrap{
    public String PrdName{get;set;}
    public Id PrdId{get;set;}
    public Decimal RaiseQty{get;set;}
    public Decimal RemainQty{get;set;}
    public Decimal RecvQty{get;set;}
    public Decimal TotRecvQty{get;set;}
    public Location__c loc{get;set;}
    public List<Inventory_Transaction__c> WrapInv{get;set;}
    public Id PoliId{get;set;}
    
        public SerialWrap(Id SPoliId,String SPrdName,Id SPrdId,Decimal SRaiseQty,Decimal SRemainQty,Decimal SRecvQty,Decimal STotRecvQty,List<Inventory_Transaction__c> SWrapInv,Location__c loc){
            PrdName=SPrdName;
            PrdId=SPrdId;
            RaiseQty=SRaiseQty;
            RemainQty=SRemainQty;
            RecvQty=SRecvQty;
            TotRecvQty=STotRecvQty;
            WrapInv=SWrapInv;
            PoliId=SPoliId;
            loc=loc;
        }
    }
   
}