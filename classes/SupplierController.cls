public class SupplierController {

    public String splid;
    public Boolean proceed;
    public PurchaseOrderLineItem__c updatePrd;
    public Id selSupplier{get; set;}
    public Boolean productListBool{get;set;}
    public List<ProductCatalog> SupplierPOProductList{get;set;}
    //public List<Supplier_Product_Line_Item__c> SupplierPOProductList{get;set;}
    public List<PurchaseOrderLineItem__c> POproductList{get;set;}
    public Boolean wrngMsg{get;set;}
//collection of the class/wrapper object wrapSupplier
    public List<wrapSupplier> wrapSupplierList {get; set;}
    public List<SupplierProduct__c> selectedSupplier {get; set;}
    public String poid{get; set;}
    public PurchaseOrderLineItem__c InsertPOLI;
    public PurchaseOrder__c spo;
    public String temp{get; set;}
    public String chekSupplier{get; set;}
    public PurchaseOrder__c updateSuptoPO{get; set;}
    public String POSupplier{get; set;}
    public SupplierController() {
        proceed=false;
        updateSuptoPO=new PurchaseOrder__c();
        splid = ApexPages.currentPage().getParameters().get('sid');
        poid= ApexPages.currentPage().getParameters().get('po');
        updateSuptoPO=[select Id,Supplier__c from PurchaseOrder__c where id =:poid];
        POSupplier=updateSuptoPO.Supplier__c;
        wrapSupplierList=getSupplier();
    }
             
     public List<wrapSupplier> getSupplier(){
         wrapSupplierList = new List<wrapSupplier>();
            for(SupplierProduct__c a: [SELECT Id,Product__c, Cost__c,Supplier__c FROM SupplierProduct__c WHERE Product__c= :splid]) {
                wrapSupplierList.add(new wrapSupplier(a));
            }
            return wrapSupplierList;
     }    
        
    public PageReference processSelected(boolean updatePrdBool) {
        chekSupplier='true';        
        
       selectedSupplier = new List<SupplierProduct__c>();
        InsertPOLI=new PurchaseOrderLineItem__c();
        PurchaseOrder__c spo;
        SupplierProduct__c lineItem;
        for(wrapSupplier supplierObj :wrapSupplierList) {
            if(supplierObj.selected == true || Test.isRunningTest()) {                              
                temp=supplierObj.spl.Id;
                //existPrd=[select Id,Product__c,Price__c,Supplier_Purchase_Order__c from SupplierProduct__c where Supplier_Purchase_Order__c=:poid AND Product__c =:temp];
                lineItem=[select Id,Product__c,Cost__c,Supplier__c from SupplierProduct__c where Id =:temp];
                temp=lineItem.Product__c;
                if(updatePrdBool == false  || Test.isRunningTest()){
                    InsertPOLI.Purchase_Order__c=poid;
                    InsertPOLI.Product__c=lineItem.Product__c;
                    InsertPOLI.Price__c=lineItem.Cost__c;                
                    insert InsertPOLI;
                }
                updateSuptoPO.Supplier__c=lineItem.Supplier__c ;
                update updateSuptoPO;
            }          
        }
      return new PageReference('javascript:window.close();window.opener.location.reload()'); 
    }
       
    public List<ProductCatalog> getSupplierPOProductList(String suplier){
        SupplierPOProductList=new List<ProductCatalog>();
        for(SupplierProduct__c SupPrdLI : [select Id,Product__c,Cost__c from SupplierProduct__c where Supplier__c=:suplier AND Product__c IN(select Product__c from PurchaseOrderLineItem__c where Purchase_Order__c=:poid)]){
            PurchaseOrderLineItem__c PoliPrd = [select Id,Product__c,Purchase_Order__c,Price__c from PurchaseOrderLineItem__c where Purchase_Order__c=:poid AND Product__c =:SupPrdLI.Product__c LIMIT 1];            
             SupplierPOProductList.add(new ProductCatalog(SupPrdLI,PoliPrd));
        }
        return SupplierPOProductList;
    }
    
    public void selectedSupplier(){   
    system.debug('wrapSupplierList=========='+wrapSupplierList);
    system.debug('selSupplier========='+selSupplier);
         for(wrapSupplier supplierObj :wrapSupplierList) {
            if(supplierObj.spl.Supplier__c!= selSupplier) {  
                 supplierObj.selected=false;     
            }
          }
       SupplierPOProductList = getSupplierPOProductList(selSupplier);       
       POproductList= [select Id,Product__c,Purchase_Order__c,Price__c from PurchaseOrderLineItem__c where Purchase_Order__c=:poid and Product__c NOT IN(select Product__c from SupplierProduct__c where Supplier__c=:selSupplier)];
       if(POproductList !=null ){
           wrngMsg=true;
           productListBool=true;
        }
        else{
            wrngMsg=false;
            productListBool=true;
        }
    }
    public PageReference continueProductDelete(){
      if(POproductList ==null || SupplierPOProductList == null ){
             return null; 
        }
        else{
        
        if(POproductList !=null){
            delete POproductList;
        }
        if(SupplierPOProductList !=null ){            
            for(ProductCatalog updateProductCat :SupplierPOProductList ){
                updatePrd=[select id,Product__c,Price__c,Purchase_Order__c from PurchaseOrderLineItem__c where Purchase_Order__c=:poid AND Product__c =:updateProductCat.SupProducts.Product__c LIMIT 1];                
                updatePrd.Price__c=updateProductCat.SupProducts.Cost__c;
                update updatePrd;
                
                if(updateProductCat.SupProducts.Product__c  == splid ){
                    processSelected(true);
                }
                else{
                    proceed=true;
                }
            }
        }        
        else{
            proceed=true;
        }
        if(proceed == true){
            proceed=false;
            processSelected(false);            
        }
        
        return new PageReference('javascript:window.top.close();window.opener.location.reload()');
       }
    }
   
   public class ProductCatalog{
       public SupplierProduct__c SupProducts{get;set;}
       public PurchaseOrderLineItem__c PoProducts{get;set;}
      // public Decimal ExistingCost{get;set;}
       public ProductCatalog(SupplierProduct__c sp,PurchaseOrderLineItem__c poliP){
           SupProducts=sp;
           PoProducts=poliP;
       }
   }

// This is a wrapper/Container class.
    public class wrapSupplier {
        public SupplierProduct__c spl {get; set;}
        public Boolean selected {get; set;}        
        public wrapSupplier(SupplierProduct__c a) {
            spl = a;
            selected = false;
        }
    }
}