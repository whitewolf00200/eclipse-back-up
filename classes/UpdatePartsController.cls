public with sharing class UpdatePartsController{
    
    public integer num{get;set;}
    Public Set<productwrapper> myset = new Set<productwrapper>();
    public String searchString {get;set;}
    public integer numb{get;set;}
    Public List<String> numbers{get;set;}
    public List<SelectOption> options{get;set;}
    Public list<id> Prid{get;set;}
    public list<productwrapper> recordlist { get; set;}
    Public List<productwrapper> rec{get;set;}
    Public List<Inventory__c> record {get;set;}
    public String selectedWH{get;set;}
    pUBLIC string twareid {get;set;}
    Public list<Warehouse__c> Wrc {get;Set;}
    public List<Inventory__c> shoppingCart {get;set;}
    public Inventory__c [] AvailableProducts {get;set;}
    public List<Inventory__c>Invt{get;set;}
    public List<Inventory__c>Inv{get;set;}
    public list <Id> prdid{get;set;}
    public String toSelect {get; set;}
    public String toUnselect {get; set;}
    public list <Id> Tnvid{get;set;}
    public List<Inventory__c> Tinv{get;set;}
    public List<Inventory__c> prd{get;set;}
    public List<Inventory__c> Tivts{get;set;}
    Public List<Inventory__c> updin {get;set;}
    Public map<id,id> nid {get;set;}
    public Id CurrentId;
    Public id currentWH;
    public Integer count{get;set;}
    public Boolean overLimit {get;set;}
    String Soql='';
    Public List<Inventory__c> prolist {get;set;}
    
    Schema.SObjectType sObjName;
    Public List<integer> recv{get;set;}
    private List<productwrapper> fordeletion = new List<productwrapper>();
    public string selectedstatus { get; set;}
     
    
        public UpdatePartsController(ApexPages.StandardController controller) {
        currentWH=ApexPages.currentPage().getParameters().get('id');
        prdid =new list <Id> ();
        prid =new list <Id> ();
        shoppingCart=new List<Inventory__c>();
        sObjName = controller.getRecord().Id.getSObjectType();
        system.debug('sObjName ='+sObjName );
        CurrentId=controller.getRecord().Id;
        system.debug('CurrentId='+CurrentId);
        if(Schema.sObjectType.Inventory__c.isAccessible() && Schema.sObjectType.Inventory__c.fields.id.isAccessible() && Schema.sObjectType.Inventory__c.fields.Name.isAccessible()
         && Schema.sObjectType.Inventory__c.fields.Warehouse__c.isAccessible() && Schema.sObjectType.Inventory__c.fields.Product__c.isAccessible()){
        Soql='select id,Name,Product__c,Product__r.IsActive,Product__r.Name,Product__r.Id,Warehouse__c,In_Hand_Quantity__c from Inventory__c where Warehouse__c =:CurrentId';
        system.debug('Soql===='+Soql);
        List<Inventory__c> pro = [select id, name, Product__c,Product__r.Name,In_Hand_Quantity__c, Warehouse__c from Inventory__c where Warehouse__c=:CurrentWH];
        if(pro.size()!=0){
            recordlist = new list<productwrapper>();
            
        }
        for(Inventory__c p:pro){
           // recordlist.add(new productwrapper(p,numb=1,SelectedWH='None'));
        }
        System.debug(tinv);

        system.debug('shoppingCart in controller ='+shoppingCart );
        AvailableProducts = [Select id,Name,Product__r.Name,Product__r.Id,Product__r.ProductCode,Product__r.IsActive,Warehouse__c,In_Hand_Quantity__c From Inventory__c Where Warehouse__c =:CurrentWH limit 5 ];
        count=0;
        options=new List<SelectOption>();
        List<Warehouse__C> whlist=new List<Warehouse__c>();
        whlist=[Select id,name from Warehouse__c where id!=:currentWH];
        

        for(Warehouse__c wh:whlist){
           options.add(new Selectoption(wh.id,wh.name));
        }
        System.debug(shoppingCart);
        System.debug(prdid);
        
      }
    }
  public void updateAvailableList() {
       if(Schema.sObjectType.Inventory__c.isAccessible() && Schema.sObjectType.Inventory__c.fields.Id.isAccessible() && Schema.sObjectType.Inventory__c.fields.Warehouse__c.isAccessible()
          && Schema.sObjectType.Inventory__c.fields.Product__c.isAccessible() && Schema.sObjectType.Product2.isAccessible() && Schema.sObjectType.Product2.fields.Name.isAccessible() && Schema.sObjectType.Product2.fields.Description.isAccessible()
          && Schema.sObjectType.Product2.fields.IsActive.isAccessible()){
        String qpName='';
        if(searchString!=null && searchString !=''){
            qpName= '%' + searchString + '%';
        }
        Set<Id> selectedEntries = new Set<Id>();
        for(Inventory__c d:shoppingCart){
            Prdid.add(d.Product__c);
        }
        System.debug(Prdid);
            AvailableProducts = [Select id,Name,Product__r.Name,Product__r.Id,Product__r.ProductCode,Product__r.IsActive,Warehouse__c,In_Hand_Quantity__c From Inventory__c Where Warehouse__c=:CurrentWH and (Product__r.Name like:qpName or Product__r.Description like:qpName) Order by Product__r.Name LIMIT 10];
        if(AvailableProducts.size()==101){
            AvailableProducts.remove(100);
            overLimit = true;
        }
        else{
            overLimit=false;
        }
      
     }
    }      
public void changestatus(){
    
    System.debug(AvailableProducts);
        	for(Inventory__c d : AvailableProducts){
                if((String)d.Id==toSelect){   
                 recordlist.add(new productwrapper(d,numb=1,SelectedWH));
                 break;
                }	
            }
    System.debug(recordlist);
} 
    /*Public void Savepro(){
      List<integer> Pro = new List<integer>();
      list<Id> prolis = new list<Id>();
        for(productwrapper pw: recordlist){
           
                prolis.add(pw.SelectedWH);
               Pro.add(pw.numb);
        }
        System.debug(' Selected Warehouse   ======>    '+prolis);
         System.debug('Given Quentity      ======>    '+Pro);    
    }*/
    
    public PageReference removeFromShoppingCart(){
        Integer count = 0;
     if(Schema.sObjectType.Inventory__c.isAccessible() && Schema.sObjectType.Inventory__c.isDeletable() && Schema.sObjectType.Inventory__c.fields.Product__c.isAccessible()){
        for(productwrapper d : recordlist){
            if((String)d.record.Product__c==toUnselect){
                if(d.record.Id!=null){
                    //fordeletion.add(d);
               recordlist.remove(count);
            break;
            }
            }
            
            count++;
        }
        updateAvailableList();
       }
        return null;
    }
    
public PageReference onSave(){
      list<Id> npro = new list<Id>();
      list<Id> prolist = new list<Id>();
      List<id> tid=new List<id>();
     List<id> tisnw =new List<id>();
    map<String,id> tis =new map<string,id>();
      List<id> allinv = new List<id>();
    List<Inventory__c> dps = new List<Inventory__c>();
    map<id,id> newinvd =new map<id,id>();
     for(productwrapper pwd: recordlist){
              prolist.add(pwd.SelectedWH);  
              tid.add(pwd.record.Product__r.id);
              npro.add(pwd.record.id);
              
       }
      System.debug(tid);
      System.debug(prolist);
     // prd=[Select id,name,Product__c,Warehouse__c,Product__r.id,Product__r.Name,Product__r.ProductCode from Inventory__c where Warehouse__c=:prolist];
           
         Invt=[Select id,name,Product__c,Product__r.ProductCode,Product__r.Supplier_Product_Code__c,Warehouse__c from Inventory__c where Warehouse__c=:CurrentWH];
         
         System.debug(npro);
    
    for(productwrapper It : recordlist){
      Tinv=[Select id,Product__r.Name,name,Product__c,Product__r.ProductCode,Product__r.Supplier_Product_Code__c,Warehouse__c from Inventory__c where Warehouse__c=:It.SelectedWH and Product__r.id =:It.record.Product__r.id];
        for(Inventory__c tst : Tinv){
          tis.put(tst.Product__r.id,tst.Product__r.id);
         }
    }
 System.debug(tis);

       //System.debug(Tinv);
        /*for(Inventory__c its : Tinv ){
        tis.put(its.Warehouse__c,its.Product__r.id);
         System.debug('After Remove Dupluicate Values =====> '+tis);
         } */
        
         for(productwrapper Itv : recordlist ){
             if(tis.containsKey(itv.record.Product__r.id) != true){
                 Inventory__c ts = new Inventory__c ();
                 ts.warehouse__c = itv.SelectedWH;
                 ts.Product__c= itv.record.Product__r.id;
                 dps.add(ts);
             } 
             
         } 
     System.debug(dps);
    Upsert dps;
    List<Inventory_Transaction__c> TransList=new List<Inventory_Transaction__c>();
        
    for(productwrapper a : recordlist ){
       inventory_Transaction__c invTrans2=new Inventory_Transaction__c();
              invTrans2.name=a.record.name;
              invTrans2.Inventory__c=a.record.id;
              invTrans2.qty__c=a.numb;
              invTrans2.Transaction_Type__c='Delivered';
              TransList.add(invTrans2);
    }
    
    for(productwrapper b : recordlist ){
updin=[Select id,name,Product__c,Product__r.ProductCode,Product__r.Supplier_Product_Code__c,Warehouse__c from Inventory__c where Warehouse__c=:b.SelectedWH and Product__r.id =: b.record.Product__r.id];
        for(Inventory__c ist : updin ){
    inventory_Transaction__c invTrans=new Inventory_Transaction__c();
              invTrans.name=b.record.name;
              invTrans.Inventory__c=ist.id;
              invTrans.qty__c=b.numb;
              invTrans.Transaction_Type__c='Received';
              TransList.add(invTrans);
        break;
}
       
    }
    System.debug(updin);
    System.debug(TransList);
    if(TransList != Null){
    Insert TransList;
    }
    
    System.debug(allinv);
          
return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
}

public PageReference onCancel(){
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }
    public class productwrapper{
        public boolean selected { get; set;}
        Public string SelectedWH {get;set;}
        Public integer numb {get;set;}
    Public Inventory__c record { get;set;} 
        
 public productwrapper(Inventory__c record,integer numb,string SelectedWH){
            this.record = record;
            this.numb = numb;   
            this.SelectedWH = SelectedWH;
            selected = false;
        }
    }
}