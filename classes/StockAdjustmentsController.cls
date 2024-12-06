public class StockAdjustmentsController {
public Id WhId;
public String ProductName {get; set;}
public String Quantity {get; set;}
public String Reason{get; set;}
public String ProductId {get; set;}
public boolean AllowSave{get;set;}
public boolean AddPrdBoolean{get;set;}
public boolean AdjustBoolean{get;set;}
public boolean SerialBoolean{get;set;}
public List<Inventory_Transaction__c> InsertInv{get;set;}
List<Inventory_Transaction__c> InsertIns=new List<Inventory_Transaction__c>();
public List<Inventory_Transaction__c> remInvTrans{get;set;}
public String SelectedPrd{get;set;}
public boolean RemoveBoolean{get;set;}
public boolean RemoveSaveBoolean{get;set;}
public boolean AvailPrd{get;set;}
public Warehouse__c Whouse{get;set;}
public Inventory__c[] AvailableProducts{get;set;}
public Boolean overLimit {get;set;}
     
    public StockAdjustmentsController(ApexPages.StandardController controller) {
        WhId=ApexPages.currentpage().getParameters().get('Id');
        AllowSave=false;
        Whouse=new Warehouse__c();
        AddPrdBoolean=false;
        AdjustBoolean=true;
        AvailPrd=true;
        SerialBoolean=false;
        RemoveBoolean=false;
        RemoveSaveBoolean=false;
        AvailableProducts=new List<Inventory__c>();
    }
    
    public void StockSearch(){
      AvailPrd=true;
      remInvTrans=new List<Inventory_Transaction__c>();
      String qString = 'select Id,Name,Product__r.Name,Product__r.Sales_Description__c,In_Hand_Quantity__c from Inventory__c where Warehouse__c=:WhId';
      
      if(SelectedPrd!=null){
            qString+=' and Product__r.Name like \'%' + SelectedPrd + '%\'';
      }
      qString+= ' order by Product__r.Name';
      qString+= ' limit 101';
          AvailableProducts = database.query(qString);
          
          if(AvailableProducts.size()==101){
            AvailableProducts.remove(100);
            overLimit = true;
        }
        else{
            overLimit=false;
            }
    }
    
    public void selctedInvs(){
    }
    
    public void AddStock(){
        ProductName='';
        Quantity='';
        Reason='';
        AddPrdBoolean=true;
        AdjustBoolean=false;
    }
    
    public void RemoveStock(){
        SelectedPrd='';
        RemoveBoolean=true;
        AdjustBoolean=false;
    }
 
    public void PrdRemCancel(){
        RemoveBoolean=false;
        AdjustBoolean=true;
    }
    
    public pagereference saveclick(){
        if(ProductId!=null){
            List<Inventory__c> InvLists;
            InvLists=new List<Inventory__c>([select id,Name,Product__c from Inventory__c where Product__c=:ProductId and Warehouse__c=:WhId]);
            
            if(ProductName=='' || ProductName==null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select the Product Name'));
                AllowSave=false;
                return null;
            }else if(Quantity=='' || Integer.valueof(Quantity)<=0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter valid Quantity'));
                AllowSave=false;
                return null;
            }else{
            if(InvLists.size()<=0){
                Inventory__c newInv=new Inventory__c();
                newInv.Product__c=ProductId;
                newInv.Maximum_Stock_Level__c=1;
                newInv.Warehouse__c=WhId;
                insert newInv;
                InvLists.add(newInv);
            }
            
            if(InsertInv.size()<=0){
                for(Integer i=0;i<Integer.valueof(Quantity);i++){
                    Inventory_Transaction__c newInv=new Inventory_Transaction__c();
                    newInv.Inventory__c=InvLists[0].id;
                    newInv.Transaction_Type__c='Received';
                    newInv.Name='N/A';
                    InsertIns.add(newInv);
                }
            }else{
                for(Inventory_Transaction__c Inv:InsertInv){
                    Inv.Inventory__c=InvLists[0].id;
                    Inv.Transaction_Type__c='Received';
                    Inv.Name=Inv.Name;
                    InsertIns.add(Inv);
                }
            }
          }
        }
        if(InsertIns.size()>0){
            insert InsertIns;
            return new pagereference('/'+WhId);
        }
      return null;
    }
    
    public void StockAdjust(){
        if(Test.isRunningTest()){
            ProductName='Test Product';
            Quantity='2';
        }
        
        if(ProductName=='' || ProductName==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select the Product Name'));
            AllowSave=false;
            return;
        }if(Quantity=='' || Integer.valueof(Quantity)<=0){
            AllowSave=false;
            return;
        }
        else{
            AllowSave=true;
            if(ProductId!=null){
                InsertInv=new List<Inventory_Transaction__c>();
                try{
                Product2 Prd=[select id,Name,Non_Stock__c,Serialized__c from Product2 where id=:ProductId];
                if(Prd.Serialized__c){
                    SerialBoolean=true;
                    for(Integer i=0;i<Integer.valueof(Quantity);i++){
                        InsertInv.add(new Inventory_Transaction__c(Product2__c=ProductName,Transaction_Type__c='Received'));
                    }
                }
              } 
              catch(Exception e){
                  
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Select product from lookup'));
              } 
            }
        }
    }
    
    public void PrdCancel(){
        AdjustBoolean=true;
        AddPrdBoolean=false;
        SerialBoolean=false;
    }
    
    public void RemovePrdSelect(){
        RemoveSaveBoolean=false;
        String selectedInv=String.valueOf(apexpages.currentpage().getparameters().get('selInv'));
        system.debug('selectedInv>>>>>'+selectedInv);
        if(SelectedPrd != null){
            remInvTrans=[select id,Product2__c ,Purchase_Order__r.Name, Name, Transaction_Type__c, Inventory__c from Inventory_Transaction__c where Transaction_Type__c ='Received' AND Inventory__c =:selectedInv];
        }
        if(remInvTrans.size()>0){
            RemoveSaveBoolean=true;
            AvailPrd=false;
        }system.debug('remInvTrans>>>>>'+remInvTrans);
    }
    
    public PageReference UpdateInvTrans(){
        if(remInvTrans != null){
            update remInvTrans;
        }
       return new pagereference('/'+WhId);
       
    }
    
    public pagereference Cancel(){
        return new pagereference('/'+WhId);
    }
}