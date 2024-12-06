public class TrasferPartsControllerNew {
Id Whid;
public String selectedPicValue{get;set;} 
public Boolean transTypeWH{get;set;}
public Boolean transTypeVH{get;set;}
public Boolean transTypeHV{get;set;}
public Inventory__c inv{get;set;}
public String ChngReason{get;set;}
public Boolean overLimit {get;set;}
public date transferDate{get;set;}
public List<Inventory__c> Invslist{get;set;}
public String searchString{get;set;}
public List<WrapInv> wrapInvList{get;set;}
public List<Id> ProductIds;
public List<String> selectList{get;set;}
public List<SerialWrapper> SerialWrap{get;set;}

    public TrasferPartsControllerNew(ApexPages.StandardController controller) {
        ProductIds=new List<Id>();
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
        String qString = 'select id,Name,Product__c,Product__r.Name,Warehouse__c,In_Hand_Quantity__c,Product__r.Description,Warehouse_Location__c from Inventory__c where In_Hand_Quantity__c>0 and Warehouse__c=:Whid and (Product__r.Non_Stock__c=false or Product__r.Serialized__c=true)';
        
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
            ProductIds=new List<Id>();
            for(Inventory__c invl:[select id,Name,Product__c,Product__r.name,Total_Received__c,Warehouse__c,Warehouse_Location__c from Inventory__c where id=:selectedInv and Warehouse__c=:Whid]){
                wrapInvList.add(new WrapInv(String.valueOf(invl.Product__r.name),0,Integer.valueOf(invl.Total_Received__c),invl.Product__c,SerialWrap,invl.id));
            }
            for(WrapInv wrp:wrapInvList){
                ProductIds.add(wrp.PrdId);
            } 
            
            String qString = 'select id,Name,Product__c,Product__r.Name,Warehouse__c,In_Hand_Quantity__c,Product__r.Description,Warehouse_Location__c from Inventory__c where Warehouse__c=:Whid and (Product__r.Non_Stock__c=false or Product__r.Serialized__c=true) and Product__c NOT IN:ProductIds and In_Hand_Quantity__c>0';
        
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
    
    public void InvQtyChange(){
        Map<Id,List<String>> SerialColec=new Map<Id,List<String>>();
        selectList=new List<String>();
        List<SerialWrapper> Temp=new List<SerialWrapper>();
        List<Id> SelPrdIds=new List<Id>();
        
        for(WrapInv serW : wrapInvList){
            SelPrdIds.add(serW.Invid);
        }
        
        for(Inventory_Transaction__c Inv:[select Id,Name,Transaction_Type__c,Inventory__c,Product_Id__c,Product__c from Inventory_Transaction__c where Inventory__c IN:SelPrdIds and Transaction_Type__c='Received']){
            if(SerialColec.containskey(Inv.Id)){
                SerialColec.get(Inv.Inventory__c).add(Inv.Name);
            }else{
                SerialColec.put(Inv.Inventory__c,new List<String>{Inv.Name});
            }
        }
        
   
        for(WrapInv serW : wrapInvList){  
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
                } 
                else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Quantity to Transfer exceeded from Recived Quantity'));
                }                                    
             serW.Swrp=Temp;
        }
    }
    
    public void SaveInv(){
    List<Id> ProductIds=new List<Id>();
    List<Id> InvIds=new List<Id>();
    Map<Id,Inventory__c> InvMap=new Map<Id,Inventory__c>();
    Map<id,Inventory_Transaction__c> UpdateInv=new Map<id,Inventory_Transaction__c>();
    Map<string,List<Inventory_Transaction__c>> TransferPrds=new Map<string,List<Inventory_Transaction__c>>();
    Id DesWareId;
    Boolean Flag;
        
        if(selectedPicValue == 'Warehouse to Warehouse'){
            DesWareId=inv.Warehouse__c;    
            for(WrapInv serW : wrapInvList){
                ProductIds.add(serW.PrdId);
                InvIds.add(serW.Invid);
            }
        
        for(Inventory_Transaction__c Inv:[select Id,Name,Inventory__r.Product__c,Transaction_Type__c,Inventory__c,Product_Id__c,Product__c from Inventory_Transaction__c where Inventory__c IN:InvIds and Transaction_Type__c='Received']){
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
        }
      }
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
    
    public class WrapInv{
       public Integer Qty{get;set;}
       public String PrdName{get;set;}
       public Integer AvailQty{get;set;}
       public Id PrdId{get;set;}
       public List<SerialWrapper> Swrp{get;set;}
       public id Invid{get;set;}
       
       public WrapInv(String pname,Integer sn,Integer avail,Id SPrdId,List<SerialWrapper> SSwrp,Id Invids){
           AvailQty=avail;
           PrdName=pname;
           Qty=sn;
           PrdId=SPrdId;
           Swrp=SSwrp;
           Invid=Invids;
       }
   }
}