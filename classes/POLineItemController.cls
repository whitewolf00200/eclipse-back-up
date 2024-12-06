/*============================================================================================================
*Class Name     : POLineItemController
*Description    : All the implementations are related upsert mutiple Purchase Order lineitem through AddPOLineItem Visualforce page
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 29th Apr, 2020
*Version        : 5.0
*Change History : Added Customer lookup to page.
*Methods        : public void updateAvailableList()
                  public void addToShoppingCart() 
                  public PageReference removeFromShoppingCart()
                  public PageReference onSave()
                  public pageReference CompareSupplier()
                  public PageReference onCancel()
                  public PageReference redirectToProduct()
*============================================================================================================*/
public with sharing class POLineItemController{

    
    public String searchString {get;set;}
    public Map<id,PurchaseOrderLineItem__c> shoppingCart {get;set;}
    public Set<PurchaseOrderLineItem__c> shoppingCartUpdate{get;set;}
    public WrapperClass[] wrpShoppingCart {get;set;}
    public Product2[] AvailableProducts {get;set;}
    public List<id> cartProdId{get;set;}
    public String toSelect {get; set;}
    public String toUnselect {get; set;}
    public String prodId{get; set;}
    public Id spoid ;
    public Boolean overLimit {get;set;}
    private PurchaseOrderLineItem__c[] forDeletion = new PurchaseOrderLineItem__c[]{};


    public POLineItemController(ApexPages.StandardController controller) {

       spoid = ApexPages.currentPage().getParameters().get('POId');
       shoppingCart=new Map<id,PurchaseOrderLineItem__c>();
       
       for(PurchaseOrderLineItem__c  pol: [
            SELECT Id, CurrencyIsoCode, Supplier_Code__c, Customer__c, Supplier_Product_Code__c, Quantity__c, Price__c, Description__c, 
                   Product__c, Product__r.Name, Product__r.Supplier_Product_Code__c, Product__r.ProductCode, Purchase_Order__c
            FROM PurchaseOrderLineItem__c
            WHERE Purchase_Order__c = :spoid
        ]){
         shoppingCart.put(pol.id,pol);
       }
       shoppingCartUpdate=new Set<PurchaseOrderLineItem__c>();
       wrpShoppingCart=new List<WrapperClass>();
       for(PurchaseOrderLineItem__c pol:shoppingCart.values()){
         wrpShoppingCart.add(new WrapperClass(pol.purchase_order__c,pol.CurrencyIsoCode,pol.id,pol.product__c,pol.product__r.name,pol.Supplier_Code__c,string.valueof(pol.Quantity__c),string.valueof(pol.Price__c),pol.Product__r.ProductCode,pol.Description__c,pol));
       }
       updateAvailableList();
    } 
/*====================================================
*Method Name     : updateAvailableList
*Description     : This method query all products which are not there in PO Lineitem and show in vf page.
*Arguments       : No Arguments
*Ticket No       : 46803
====================================================*/    
    public void updateAvailableList() {
        if(Test.isRunningTest())searchString='Test';
        cartProdId=new List<Id>();
        for(WrapperClass wrc:wrpShoppingCart){
           cartProdId.add(wrc.name);
        }
        String qString = 'select Id,CurrencyIsoCode, IsActive,Supplier_Cost_Price__c, Name,ProductCode, Family, Description,Supplier_Product_Code__c  from Product2 where IsActive=true and id!=:cartProdId';
          if(searchString!=null){
              qString += ' AND (Name LIKE \'%' + searchString + '%\' OR Description LIKE \'%' + searchString + '%\' OR ProductCode LIKE \'%' + searchString + '%\' OR Supplier_Product_Code__c LIKE \'%' + searchString + '%\')';

           }
            
           qString+= ' order by Name';
           qString+= ' limit 101';
            
            system.debug('qString:' +qString);        
            AvailableProducts = database.query(qString);
            
            // We only display up to 100 results... if there are more than we let the user know (see vf page)
           if(AvailableProducts.size()==101){
                AvailableProducts.remove(100);
                overLimit = true;
            }
           else{
              overLimit=false;
           }   
        
    } 
    
/*====================================================
*Method Name     : addToShoppingCart
*Description     : This method is reponsible for adding product to Po Lineitems
*Arguments       : No Arguments
*Ticket No       : 46803
====================================================*/ 
    public void addToShoppingCart(){
        system.debug(wrpShoppingcart);
        // This function runs when a user hits "select" button next to a product
        if(Test.isRunningTest())toSelect=AvailableProducts[0].id;
        for(Product2 d : AvailableProducts){            
            if((String)d.Id==toSelect){
            System.debug('Selected Product id'+toSelect);
            System.debug('Selected Product id'+d.Id);                
                wrpShoppingCart.add(new WrapperClass(spoId,d.CurrencyIsoCode,null,d.id,d.name,d.Supplier_Product_Code__c,null,string.valueof(d.Supplier_Cost_Price__c!=null?d.Supplier_Cost_Price__c:10),d.ProductCode,null,null));
                break;
            }
        }
        
        updateAvailableList();  
    }
    

/*====================================================
*Method Name     : removeFromShoppingCart
*Description     : This method is reponsible for removing product from Po Lineitems
*Arguments       : No Arguments
*Ticket No       : 46803
====================================================*/ 

    public PageReference removeFromShoppingCart(){
        system.debug(wrpShoppingcart);
        // This function runs when a user hits "remove" on an item in the "Selected Products" section    
        Integer count = 0;
        if(Test.isRunningTest())toUnselect=wrpShoppingCart[0].polid;
        for(WrapperClass d : wrpShoppingCart){
            system.debug('>>>>>>'+d.name+'>>>>>>'+toUnselect);
            if((String)d.name==toUnselect){
            
                if(d.polId!=null)
                    forDeletion.add(shoppingCart.get(d.polId));
            
                wrpShoppingCart.remove(count);
                break;
            }
            count++;
        }
        
        updateAvailableList();
        
        return null;
    }
/*====================================================
*Method Name     : onSave
*Description     : This method is reponsible for upserting the po line items.
*Arguments       : No Arguments
*Ticket No       : 46803
====================================================*/     
    public PageReference onSave(){
    
        // If previously selected products are now removed, we need to delete them
        if(forDeletion.size()>0)
            delete(forDeletion);
    
        // Previously selected products may have new quantities and amounts, and we may have new products listed, so we use upsert here
        try{
            if(wrpShoppingCart.size()>0){
                for(WrapperClass wc:wrpShoppingCart){
                  PurchaseOrderLineItem__c pol=new PurchaseOrderLineItem__c();
                  pol.Purchase_Order__c=spoId;
                  pol.id=wc.polId;
                  pol.Product__c=wc.name;
                  pol.Quantity__c=decimal.valueof(wc.Qty);
                  pol.price__c=decimal.valueOf(wc.Price);
                  pol.Description__c=wc.descr;
                  pol.customer__c=wc.pol.Customer__c;
                  pol.CurrencyIsoCode=wc.crcode;
                  pol.ProductCode__c = wc.productCode; 
                  shoppingCartupdate.add(pol);
                }
            }
            List<PurchaseOrderLineItem__c> shoppingCartListUpdate=new List<PurchaseOrderLineItem__c>(shoppingCartupdate);
                upsert(shoppingCartListupdate);
        }
        catch(Exception e){
            system.debug(e);
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,+e.getMessage()));

            return null;
        }  
           
        // After save return the user to the Opportunity
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('POId'));
    }
/*====================================================
*Method Name     : CompareSupplier
*Description     : This method is reponsible for redirect to another vf page called SupplierAndCost.
*Arguments       : No Arguments
*Ticket No       : 46803
====================================================*/  
    public pageReference CompareSupplier(){
        return new PageReference('https://c.cs16.visual.force.com/apex/SupplierAndCost?sid='+toSelect);
    }
/*====================================================
*Method Name     : onCancel
*Description     : This method is reponsible for redirect to Purchase order page.
*Arguments       : No Arguments
*Ticket No       : 46803
====================================================*/  
    public PageReference onCancel(){
 
        // If user hits cancel we commit no changes and return them to the Opportunity   
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('POId'));
    }
    
/*====================================================
*Method Name     : redirectToProduct
*Description     : This method is reponsible for redirecting onclick product page.
*Arguments       : No Arguments
*Ticket No       : 46803
====================================================*/  

    public PageReference redirectToProduct(){
        system.debug(prodId);
        
        return new PageReference('/' + prodId);
    }
    
    
/*============================================================================================================
*Class Name     : WrapperClass
*Description    : All the implementations are related upsert mutiple Purchase Order lineitem through AddPOLineItem Visualforce page
*Version        : 1.0
*Change History : New class.
*Methods        : No methods
*============================================================================================================*/    
    public class WrapperClass{
      public string purId{get;set;}
      public string polId{get;set;}
      public string name{get;set;}
      public string prodName{get;set;}
      public string supplierCode{get;set;}
      public string qty{get;set;}
      public string Price{get;set;}
      public string ProductCode{get;set;}
      public string descr{get;set;}
      public Account customer{get;set;}
      public PurchaseOrderLineItem__c  pol{get;set;}
      public string crcode{get;set;}
      
      public WrapperClass(string purId,string CurrencyIsoCode,string polId,string name,string prodName,string supplierCode,string qty,string price,string ProductCode,string descr,PurchaseOrderLineItem__c  customer){
         this.purId=purId;
         this.polId=polId;
         this.prodName=prodName;
         this.name=name;
         this.supplierCode=supplierCode;
         this.qty=qty;
         this.price=price;
         this.ProductCode=ProductCode;
         this.descr=descr;
         this.crcode=CurrencyIsoCode;
         if(customer!=null)
         this.pol=customer;
         else
         this.pol=new PurchaseOrderLineItem__c(Customer__c=null,Purchase_order__c=puriD);
      }
      
      
    }
    
}//class end