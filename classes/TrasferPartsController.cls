public class TrasferPartsController{
Id Whid;
public String selectedPicValue{get;set;} 
public Boolean transTypeWH{get;set;}
public Boolean transTypeVH{get;set;}
public Boolean transTypeHV{get;set;}
public Inventory__c inv{get;set;}
public String ChngReason{get;set;}
public List<Vehctransfer> VehicleParts;
public Boolean overLimit {get;set;}
List<Inventory_Transaction__c> InsertInv;
public date transferDate{get;set;}
public List<Inventory__c> Invslist{get;set;}
public String searchString{get;set;}
Map<Id,Inventory_Transaction__c> DelInv;
public List<WrapInv> wrapInvList{get;set;}
public List<Id> ProductIds;
public List<String> selectList{get;set;}
public List<SerialWrapper> SerialWrap{get;set;}
List<Inventory_Transaction__c> UpdateInvl;
public boolean chk{get;set;}
Map<String,Inventory_Transaction__c> UpdateVehMap;
public string ChkPrdid{get;set;}
Public List<Id> prdidsel;

    public TrasferPartsController(ApexPages.StandardController controller) {
        ProductIds=new List<Id>();
        prdidsel=new List<Id> ();
        inv=new Inventory__c();
        wrapInvList=new List<WrapInv>();
        SerialWrap=new List<SerialWrapper>();
        Whid=apexpages.currentpage().getparameters().get('id');
        transferDate=system.today();
        
    }
    
    public void TransferTypeChange(){
    
        if(selectedPicValue != null && selectedPicValue == 'Warehouse to Warehouse'){
            transTypeWH = true;
            transTypeVH = false;
            transTypeHV = false;
            Invslists();
        }    
        else if(selectedPicValue != null && selectedPicValue == 'Warehouse to Vehicle'){
            transTypeVH = true;
            transTypeWH = false;
            transTypeHV = false;
             Invslists();
        }else if(selectedPicValue != null && selectedPicValue == 'Vehicle to Warehouse'){
            transTypeHV = true;
            transTypeWH = false;
            transTypeVH = false;
        }
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Select Warehouse/Vehicle first');
            ApexPages.addMessage(myMsg);
        }
    }
    
    public void Invslists(){
    
        Invslist = new List<Inventory__c>();
        
        String qString = 'select id,Name,Product__c,Product__r.Name,Warehouse__c,In_Hand_Quantity__c,Product__r.Description,Warehouse_Location__c from Inventory__c where In_Hand_Quantity__c>0 and id!=:prdidsel and Warehouse__c=:Whid and (Product__r.Non_Stock__c=false or Product__r.Serialized__c=true)';
        
        if(searchString != null){
        
            qString+= ' and (Product__r.Name like \'%' + searchString + '%\' or Product__r.Description like \'%' + searchString + '%\')';
        
            qString+= ' order by Product__r.Name';
            qString+= ' limit 101';
        }
        else{
            qString+= ' order by Product__r.Name';
            qString+= ' limit 101';
        }
        Invslist = database.query(qString);
        if(Invslist.size()==101){
            Invslist.remove(100);
            overLimit = true;
        }
        else{
           overLimit=false;
        } 
    } 
    
    public void selctedInvs(){
        if(transTypeWH || transTypeVH){
            String selectedInv=String.valueOf(apexpages.currentpage().getparameters().get('selInv'));
            system.debug('selectedInv after select=============='+selectedInv);
            ProductIds=new List<Id>();
            list<wrapTran> wraptranList =new list<wrapTran>();
            for(Inventory__c invl:[select id,Name,Product__c,Product__r.name,Total_Received__c,Warehouse__c,Warehouse_id__c,Warehouse_Location__c from Inventory__c where id=:selectedInv and Warehouse__c=:Whid]){
                wrapInvList.add(new WrapInv(String.valueOf(invl.Product__r.name),wraptranList,0,Integer.valueOf(invl.Total_Received__c),invl.Product__c,SerialWrap,invl.id,invl.Warehouse_id__c));
                prdidsel.add(invl.id);
            }
            system.debug('wrapInvList after select========'+wrapInvList);
            for(WrapInv wrp:wrapInvList){
                ProductIds.add(wrp.PrdId);
            } 
            system.debug('ProductIds after select========='+ProductIds);
            String qString = 'select id,Name,Product__c,Product__r.Name,Warehouse__c,In_Hand_Quantity__c,Product__r.Description,Warehouse_Location__c from Inventory__c where Warehouse__c=:Whid and (Product__r.Non_Stock__c=false or Product__r.Serialized__c=true) and Product__c NOT IN:ProductIds and In_Hand_Quantity__c>0 ';
        
        if(searchString != null){
        
            qString+= ' and (Product__r.Name like \'%' + searchString + '%\' or Product__r.Description like \'%' + searchString + '%\')';
        
            qString+= ' order by Product__r.Name';
            qString+= ' limit 101';
        }
        else{
            qString+= ' order by Product__r.Name';
            qString+= ' limit 101';
        }
        Invslist = database.query(qString);
        if(Invslist.size()==101){
            Invslist.remove(100);
            overLimit = true;
        }
        else{
           overLimit=false;
        } 
        
        }
    }
    
    
    public void unselect(){
        system.debug('Invslist: '+Invslist);
    system.debug('Invslist: '+Invslist);
    }
    
    public void InvQtyChange(){
  
  
    String selectedInv=String.valueOf(apexpages.currentpage().getparameters().get('qtyPrd'));
        system.debug('selectedInv in qty =========='+selectedInv );
        wrapTran tempt;
        for(WrapInv serW : wrapInvList){  
        system.debug('ChkPrdid======='+ChkPrdid);
        system.debug('serW.PrdId======='+serW.PrdId);
            if(serW.PrdName == selectedInv && ChkPrdid==serW.PrdId){
                if(serW.Qty <= serW.AvailQty){
                  serW.tranList.clear();
                 
                 system.debug('serW.tranList size========'+serW.Swrp.size());
                 
                    for(integer m=0;m<serW.Qty;m++){
                         tempt=new wrapTran(serW.PrdName,'',null);
                         serW.tranList.add(tempt);
                    }
                  
                } 
                else{
                 serW.tranList.clear();
                    serW.Qty=0;
                }                                    
             }
        }
        system.debug('tranList after qty change========'+wrapInvList);
        Map<Id,List<String>> SerialColec=new Map<Id,List<String>>();
        selectList=new List<String>();
        List<SerialWrapper> Temp=new List<SerialWrapper>();
        List<Id> SelPrdIds=new List<Id>();
        
        for(WrapInv serW : wrapInvList){
            SelPrdIds.add(serW.Invid);
        }
        system.debug('SelPrdIds after qty========='+SelPrdIds);
   
        for(Inventory_Transaction__c Inv:[select Id,Name,Transaction_Type__c,Inventory__c,Inventory__r.Product__c,Product__c from Inventory_Transaction__c where Inventory__c IN:SelPrdIds and Transaction_Type__c='Received']){
            List<String> Snum =  SerialColec.get(Inv.Inventory__c);  
             if(Snum ==null){
               Snum = new List<String>();
               SerialColec.put(Inv.Inventory__c,Snum );
                system.debug('inv in put====='+SerialColec);
             }
             Snum .add(Inv.Name);
        }        
        system.debug('inv in last====='+SerialColec);
        
   system.debug('SerialColec after qty======='+SerialColec);
        for(WrapInv serW : wrapInvList){  
          if(serW.PrdName == selectedInv && ChkPrdid==serW.PrdId){
                if(serW.Qty <= serW.AvailQty){
                     Temp=new List<SerialWrapper>();
                     for(integer m=0;m<serW.Qty;m++){
                        if(SerialColec.containskey(serW.Invid)){
                            selectList=new List<String>();
                            selectList=SerialColec.get(serW.Invid);
                             
                            SerialWrap.add(new SerialWrapper(serW.PrdName,selectList,'',serW.PrdId));
                            
                            Temp.add(new SerialWrapper(serW.PrdName,selectList,'',serW.PrdId));
                           
                        }
                    }
                    system.debug('SerialWrap in qty====='+SerialWrap);
                    system.debug('Temp========='+Temp);
                } 
                else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Quantity to Transfer exceeded from Recived Quantity'));
                }                                    
             serW.Swrp=Temp;
             }
        }
        
    }
    
    public pagereference warehouse()
    {
    system.debug('Warehouse');
    if(Whid==inv.Warehouse__c)
    {
    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Choose different Warehouse');
            ApexPages.addMessage(myMsg);
            return null;
    }
    return null;
    }
    
    
     public List<Vehctransfer> getVehicleParts(){
        VehicleParts=new List<Vehctransfer>();
        UpdateVehMap=new Map<String,Inventory_Transaction__c>();
        for(Inventory_Transaction__c tranInvs:[select id,Name,Vehicle__c,Vehicle__r.Name,Inventory__c,Warehouse_id__c,Transaction_Type__c,Product__c from Inventory_Transaction__c where Transaction_Type__c='In Vehicle' AND Inventory__c IN(select id from Inventory__c where Warehouse__c=:Whid)]){
        VehicleParts.add(new Vehctransfer(tranInvs.Product__c,tranInvs.Name,false,tranInvs.Vehicle__r.Name,tranInvs.id,null,tranInvs.Warehouse_id__c));
        UpdateVehMap.put(tranInvs.id,tranInvs);
        }
        return VehicleParts;
    }
    
    
    public pagereference SaveInv(){
    InsertInv=new List<Inventory_Transaction__c>();
    Map<Id,List<Inventory__c>> CheckStatus=new Map<Id,List<Inventory__c>>();
    List<Id> ProductIds=new List<Id>();
    List<Id> InvIds=new List<Id>();
    Map<Id,Inventory__c> InvMap=new Map<Id,Inventory__c>();
    Map<String,Id> MapProduct=new Map<String,Id>();
    List<String> Product=new List<String>();
    Map<String,String> DupProduct=new Map<String,String>();
    DelInv=new Map<Id,Inventory_Transaction__c>();
    String VehTransInveId;
    Id InveId;

    Map<id,Inventory_Transaction__c> UpdateInv=new Map<id,Inventory_Transaction__c>();
    Map<string,List<Inventory_Transaction__c>> TransferPrds=new Map<string,List<Inventory_Transaction__c>>();
    Id DesWareId;
    Boolean Flag;
        
         for(Inventory__c Invs:[select id,Product__c,Warehouse__c,Product__r.Name from Inventory__c where Warehouse__c=:Whid]){
            MapProduct.Put(Invs.Product__r.Name,Invs.Product__c);
            Product.add(Invs.Product__c);
        }
        
   
        
      if(selectedPicValue == 'Warehouse to Vehicle'){
         
         List<Inventory_Transaction__c > invt=new List<Inventory_Transaction__c >();
         List<Id> serId=new List<Id>();
         
          for(integer i=0; i<wrapInvList.size();i++){
             
            for(integer j=0; j<wrapInvList[i].tranList.size();j++){
               if(wrapInvList[i].Swrp[j].SelVals=='' || wrapInvList[i].tranList[j].VehicleNo.Vehicle__c==null){
                   system.debug('wrapInvList[i].Swrp[j].Vehicle: '+wrapInvList[i].tranList[j].VehicleNo.Vehicle__c );
                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Vehicle and Serial number is mandatory');
                  ApexPages.addMessage(myMsg);
                  return null; 
                  }
            }
            
          }  
         
         for(integer i=0; i<wrapInvList.size();i++){
             
           for(integer j=0; j<wrapInvList[i].tranList.size();j++){
              
               Vehicle__c  vh = [Select id, Name, Warehouse__r.id from  Vehicle__c where id=:wrapInvList[i].tranList[j].VehicleNo.Vehicle__c];
               system.debug('vh.Warehouse__c: '+vh.Warehouse__r.id);
               system.debug('wrapInvList[i].Swrp[j].PrdName: '+wrapInvList[i].Swrp[j].PrdName);
               system.debug('wrapInvList[i].Swrp[j].SelVals : '+wrapInvList[i].Swrp[j].SelVals );
              
        
       
                for(Inventory_Transaction__c IT: [Select id, Name, Vehicle__c,Transaction_Type__c,Warehouse_id__c  from Inventory_Transaction__c where Name=:wrapInvList[i].Swrp[j].SelVals and Product__c=:wrapInvList[i].Swrp[j].PrdName and Warehouse_id__c=:wrapInvList[i].wid and id!=:serId and Transaction_Type__c=:'Received']){
                         serId.add(IT.id);
                         IT.Vehicle__c=wrapInvList[i].tranList[j].VehicleNo.Vehicle__c;
                         IT.Transaction_Type__c='In Vehicle';
                         invt.add(IT);
                         break;
                 
                      system.debug('serId after N/A============'+serId);
                 }
            }
        }
      
          if(invt.size()>0){
              update invt;
          }   
    }
        
        
      else if(selectedPicValue == 'Vehicle to Warehouse')
      {
     
         List<Inventory_Transaction__c > invtvw=new List<Inventory_Transaction__c >();
         List<Id> serIdvw=new List<Id>();
         list<Inventory_Transaction__c > insertserial=new list<Inventory_Transaction__c >();
         list<Inventory_Transaction__c > deleteserial=new list<Inventory_Transaction__c >();
      
        for(Vehctransfer veh:VehicleParts){
        Flag=true;
       
           if(veh.prdStatus  && veh.DestinationWh.Warehouse__c!=null) {
            
         
                 
                 Inventory__c addinv=new Inventory__c();
                  list<Inventory__c> destin=[select id,name,Warehouse__c from Inventory__c where Warehouse__c=: veh.DestinationWh.Warehouse__c AND Product__r.name=: veh.prdName];
                  if(destin.size()==0 )
                  {
                      product2 p=[select id from product2 where name=: veh.prdname];
                      addinv.product__c=p.id;
                      addinv.warehouse__c=veh.DestinationWh.warehouse__c;
                      insert addinv;
                  }
                  VehTransInveId=Veh.TransInveId;
                  InveId=Id.valueOf(VehTransInveId);
                     
                     Inventory_Transaction__c  sern=[select id from Inventory_Transaction__c where id=:InveId];
                     system.debug('sern>>>'+sern);
                     
                      deleteserial.add(sern);
                      
                      Inventory_Transaction__c NewInv=new Inventory_Transaction__c();
                      NewInv.Name=Veh.serialName;
                      NewInv.Transaction_Type__c='Received';
                      if(destin.size()==0)
                      NewInv.inventory__c=addinv.id;
                      else NewInv.inventory__c=destin[0].id;
                      NewInv.TransferDate__c=transferDate;
                      insertserial.add(NewInv);
     
           }
        }
        if(deleteserial.size()>0)
            delete deleteserial;
            system.debug('>>>>>>DelInv'+DelInv);
            if(insertserial.size()>0)
               insert insertserial;
               system.debug('inserted serial========'+insertserial);
      
     }
        
      else  if(selectedPicValue == 'Warehouse to Warehouse'){
         if(inv.Warehouse__c==null ){
    
         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Choose Destination Warehouse');
            ApexPages.addMessage(myMsg);
            return null; 
      
         }
          for(WrapInv serW : wrapInvList){
             for(SerialWrapper ser :serW.Swrp){
                 if(ser.SelVals==''){
                     ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Serial Number is mandatory');
                    ApexPages.addMessage(myMsg);
                    return null; 
                 }
             }
          }
            DesWareId=inv.Warehouse__c;
            system.debug('DesWareId: '+DesWareId);    
            for(WrapInv serW : wrapInvList){
                ProductIds.add(serW.PrdId);
                InvIds.add(serW.Invid);
            }
        
        for(Inventory_Transaction__c Inv:[select Id,Name,Inventory__r.Product__c,Transaction_Type__c,Inventory__c,Product__c from Inventory_Transaction__c where Inventory__c IN:InvIds and Transaction_Type__c='Received']){
            if(TransferPrds.containskey(Inv.Inventory__r.Product__c)){
                TransferPrds.get(Inv.Inventory__r.Product__c).add(Inv);
            }else{
                TransferPrds.put(Inv.Inventory__r.Product__c,new List<Inventory_Transaction__c>{Inv});
            }
        }
        
        for(Inventory__c Inv:[select id,Name,Product__c,Product__r.Name,Warehouse__c,In_Hand_Quantity__c,Product__r.Description,Warehouse_Location__c from Inventory__c where Warehouse__c=:DesWareId and Product__c IN:ProductIds]){
            InvMap.put(Inv.Product__c,Inv);
        }
        
 
        
        for(WrapInv serW : wrapInvList){
           system.debug('serw============'+serw);
           if(InvMap.containskey(serW.PrdId) && TransferPrds.containskey(serW.PrdId)){
                for(SerialWrapper ser :serW.Swrp){
                    Flag=true;
                    for(Inventory_Transaction__c Trn:TransferPrds.get(serW.PrdId)){
                        if(!UpdateInv.containskey(Trn.id) && Flag){
                            Trn.Inventory__c=InvMap.get(serW.PrdId).id;
                            UpdateInv.put(Trn.id,Trn);
                            Flag=false;
                        }
                    }
                }
            }else{
                Inventory__c NewInv=new Inventory__c();
                NewInv.Warehouse__c=DesWareId;
                NewInv.Product__c=serW.PrdId;
                NewInv.Minimum_Stock_Level__c=1;
                insert NewInv;
                InvMap.put(NewInv.Product__c,NewInv);
                for(SerialWrapper ser :serW.Swrp){
                    Flag=true;
                    for(Inventory_Transaction__c Trn:TransferPrds.get(serW.PrdId)){
                        if(!UpdateInv.containskey(Trn.id) && Flag){
                            Trn.Inventory__c=InvMap.get(serW.PrdId).id;
                            UpdateInv.put(Trn.id,Trn);
                            Flag=false;
                        }
                    }
                }
            }
        }
        if(UpdateInv.size()>0){
            update UpdateInv.values();
            system.debug('UpdateInv: '+UpdateInv);
        }
      }
      return new PageReference('/' +Whid);
    }
    
    public PageReference cancel(){
        return new PageReference('/' +Whid);
    }
    

    public class SerialWrapper{
        public Id InvId{get;set;}
        public String PrdName{get;set;}
        public List<String> Items{get;set;}
        public string SelVals{get;set;}
        public string PrdId{get;set;}
        public Boolean AssLog{get;set;}
        public Decimal PrPrice{get;set;}
        public String SaDesc;
        public String ExSDesc;
        
        public SerialWrapper(String SPrdName,List<String> SItems,String SSelVals,string SPrdId){
            PrdName=SPrdName;
            Items=SItems;
            SelVals=SSelVals;
            PrdId=SPrdId;
           
        }
    }
    
    
    public class wrapTran{
        public String pname{get;set;}
        public String serial{get;set;}
        public Inventory_Transaction__c VehicleNo{get;set;}
        
        public wrapTran(String pname,String serial,Id Vehicle){
            this.pname=pname;
            this.serial=serial;
            this.VehicleNo=new Inventory_Transaction__c();
        }
    }    
    
    public class WrapInv{
       public list<wrapTran> tranList{get;set;}
       public Integer Qty{get;set;}
       public String PrdName{get;set;}
       public Integer AvailQty{get;set;}
       public Id PrdId{get;set;}
       public List<SerialWrapper> Swrp{get;set;}
       public id Invid{get;set;}
       public String Wid{get;set;}
       
       public WrapInv(String pname,List<wrapTran> LI,Integer sn,Integer avail,Id SPrdId,List<SerialWrapper> SSwrp,Id Invids,String Wid){
           AvailQty=avail;
           PrdName=pname;
           tranList=LI;
           Qty=sn;
           PrdId=SPrdId;
           Swrp=SSwrp;
           Invid=Invids;
           this.Wid=Wid;
       }
   }
   
   
   public class Vehctransfer{
       public String VehSid{get;set;}
       public string PrdName{get;set;}
       public string serialName{get;set;}
       public boolean prdStatus{get;set;}
       public string TransInveId{get;set;}
       public Vehicle__c DestinationWh{get;set;}
       public string Wid{get;set;}
       
       public Vehctransfer(String Name,String Serial,Boolean Status,String VehIds,String TransInveIds,Vehicle__c DesWh,String Wid){
           this.PrdName=Name;
           this.serialName=Serial;
           this.prdStatus=Status;
           this.VehSid=VehIds;
           this.TransInveId=TransInveIds;
           this.DestinationWh=new Vehicle__c();
           this.Wid=Wid;
       }
   }
   
}