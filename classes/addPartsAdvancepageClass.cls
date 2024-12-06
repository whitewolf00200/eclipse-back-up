public with sharing class addPartsAdvancepageClass{
    
    public integer num{get;set;}
    Public Set<productwrapper> myset = new Set<productwrapper>();
    public String searchString {get;set;}
    public integer numb{get;set;}
    Public List<String> numbers{get;set;}
    public List<SelectOption> options{get;set;}
    Public list<id> Prid{get;set;}
    public list<productwrapper> recordlist { get; set;}
    Public List<productwrapper> rec{get;set;}
    //Public List<Product2> record {get;set;}
    public String selectedWH{get;set;} 
    pUBLIC string twareid {get;set;}
    Public list<Engineer_Checklist__c> Wrc {get;Set;}
    public List<Product2> shoppingCart {get;set;}
    public Product2 [] AvailableProducts {get;set;}
    public List<Required_Parts__c>Invt{get;set;}
    public List<Required_Parts__c>Inv{get;set;}
    public list <Id> prdid{get;set;}
    public String toSelect {get; set;}
    public String toUnselect {get; set;}
    public list <Id> Tnvid{get;set;}
    public List<Required_Parts__c> Tinv{get;set;}
    public List<Required_Parts__c> prd{get;set;}
    public List<Required_Parts__c> Tivts{get;set;}
    Public List<Required_Parts__c> updin {get;set;}
    Public map<id,id> nid {get;set;}
    public Id CurrentId;
    Public id currentWH;
    public Integer count{get;set;}
    public Boolean overLimit {get;set;}
    String Soql='';
    Public List<Required_Parts__c> prolist {get;set;}
    
    Schema.SObjectType sObjName;
    Public List<integer> recv{get;set;}
    private List<productwrapper> fordeletion = new List<productwrapper>();
    public string selectedstatus { get; set;}
     
    
        public addPartsAdvancepageClass(ApexPages.StandardController controller) {
        currentWH=ApexPages.currentPage().getParameters().get('id');
        prdid =new list <Id> ();
        prid =new list <Id> ();
        shoppingCart=new List<Product2>();
        sObjName = controller.getRecord().Id.getSObjectType();
        system.debug('sObjName ='+sObjName );
        CurrentId=controller.getRecord().Id;
        system.debug('CurrentId='+CurrentId);
        
        //Soql='select id,Name,Product__c,Product__r.IsActive,Product__r.Name,Product__r.Id,Engineer_Checklist__c,In_Hand_Quantity__c from Required_Parts__c where Engineer_Checklist__c =:CurrentId';
        system.debug('Soql===='+Soql);
        List<Product2> pro = [select id,Name,ProductCode,IsActive from Product2];
        if(pro.size()!=0){
            recordlist = new list<productwrapper>();
            
        }
        //for(Required_Parts__c p:pro){
           // recordlist.add(new productwrapper(p,numb=1,SelectedWH='None'));
        //}
       //S System.debug(tinv);

        system.debug('shoppingCart in controller ='+shoppingCart );
        AvailableProducts = [Select id,Name,ProductCode,IsActive From Product2 Limit 5 ];
        count=0;
        options=new List<SelectOption>();
        List<Warehouse__c> whlist=new List<Warehouse__c>();
       whlist=[Select id,name from Warehouse__c limit 10];
         //options.add(new Selectoption('','None'));

        for(Warehouse__c wh:whlist){
          options.add(new Selectoption(wh.id,wh.name));
       	 }
        System.debug(shoppingCart);
        System.debug(prdid);
        
      }
  public void updateAvailableList() {
   
        String qpName='';
        if(searchString!=null && searchString !=''){
            qpName= '%' + searchString + '%';
        }
        Set<Id> selectedEntries = new Set<Id>();
        for(Product2 d:shoppingCart){
            Prdid.add(d.Name);
        }
        System.debug(Prdid);
            AvailableProducts = [Select id,Name,ProductCode,IsActive,Description From Product2 Where (Name like:qpName or Description like:qpName) Order by Name LIMIT 10];
        if(AvailableProducts.size()==101){
            AvailableProducts.remove(100);
            overLimit = true;
        }
        else{
            overLimit=false;
        }
      
     }     
public void changestatus(){
    
    System.debug(AvailableProducts);
        	for(Product2 d : AvailableProducts){
                if((String)d.Id==toSelect){   
                    System.debug(d);
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
     if(Schema.sObjectType.Required_Parts__c.isAccessible() && Schema.sObjectType.Required_Parts__c.isDeletable() && Schema.sObjectType.Required_Parts__c.fields.Product_Name__c.isAccessible()){
        for(productwrapper d : recordlist){
            if((String)d.record.Id == toUnselect){
                if(d.record.Id!=null){
                    //fordeletion.add(d);
               recordlist.remove(count);
            break;
            }
            }
            
            count++;
        }
       
       }
        return null;
    }
    
public PageReference onSave(){
      list<Id> npro = new list<Id>();
      list<Id> prolist = new list<Id>();
      List<id> tid=new List<id>();
     List<id> tisnw =new List<id>();
    map<String,id> tis =new map<string,id>();
    map<String,id> tss =new map<string,id>();
    
      List<id> allinv = new List<id>();
    List<Required_Parts__c> dps = new List<Required_Parts__c>();
    map<id,id> newinvd =new map<id,id>();
     for(productwrapper pwd: recordlist){
              prolist.add(pwd.SelectedWH);  
              tid.add(pwd.record.id);
              npro.add(pwd.record.id);
              
       }
      System.debug(tid);
      System.debug(prolist);
     // prd=[Select id,name,Product__c,Engineer_Checklist__c,Product__r.id,Product__r.Name,Product__r.ProductCode from Required_Parts__c where Engineer_Checklist__c=:prolist];
           
         Invt=[Select id,name,Product_Name__c,Quantity__c,Service_Sheet__c,Warehouse__c from Required_Parts__c where Warehouse__c=:prolist];
         
         System.debug(npro);
    
    for(productwrapper It : recordlist){
      Tinv=[Select id,name,Product_Name__c,	Product_Name__r.id,Quantity__c,Service_Sheet__c,Warehouse__c from Required_Parts__c where Warehouse__c=:It.SelectedWH and Product_Name__r.id=:It.record.id];
        for(Required_Parts__c tst : Tinv){
          tis.put(tst.Product_Name__r.id,tst.Product_Name__r.id);
          tss.put(tst.Service_Sheet__c,tst.Service_Sheet__c);
         }
    }
 System.debug(tis);
 System.debug(tss);
    

       //System.debug(Tinv);
        /*for(Required_Parts__c its : Tinv ){
        tis.put(its.Engineer_Checklist__c,its.Product__r.id);
         System.debug('After Remove Dupluicate Values =====> '+tis);
         } */
        
         for(productwrapper Itv : recordlist ){
                 Required_Parts__c ts = new Required_Parts__c ();
                 ts.Service_Sheet__c = currentWH;
                 ts.Warehouse__c = itv.SelectedWH;
                 ts.Product_Name__c = itv.record.id;
                 ts.Quantity__c = itv.numb;
                 dps.add(ts);
             } 
            
     System.debug(dps);
     Insert dps;
    
   /* List<Required_Parts__c> TransList=new List<Required_Parts__c>();
        
    for(productwrapper a : recordlist ){
       Required_Parts__c invTrans2=new Required_Parts__c();
                 invTrans2.Warehouse__c = a.SelectedWH;
                 invTrans2.Service_Sheet__c = currentWH; 
                 invTrans2.Product_Name__c = a.record.id;
                 invTrans2.Quantity__c = a.numb;
                 TransList.add(invTrans2);
                 System.debug(TransList);
    }
    Upsert TransList;	
    for(productwrapper b : recordlist ){
updin=[Select id,name,Product__c,Product__r.ProductCode,Product__r.Supplier_Product_Code__c,Engineer_Checklist__c from Required_Parts__c where Engineer_Checklist__c=:b.SelectedWH and Product__r.id =: b.record.Product__r.id];
        for(Required_Parts__c ist : updin ){
    inventory_Transaction__c invTrans=new Inventory_Transaction__c();
              invTrans.name=b.record.name;
              invTrans.Required_Parts__c=ist.id;
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
*/
          
return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
}

public PageReference onCancel(){
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }
    public class productwrapper{
        public boolean selected { get; set;}
        Public string SelectedWH {get;set;}
        Public integer numb {get;set;}
        Public Product2 record { get;set;} 
        
 public productwrapper(Product2 record,integer numb,string SelectedWH){
            this.record = record;
            this.numb = numb;   
            this.SelectedWH = SelectedWH;
            selected = false;
        }
    }
}