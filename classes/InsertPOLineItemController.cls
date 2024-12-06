/*============================================================================================================
*Class Name     : InsertPOLineItemController
*Description    : All the implementations related to scan and Add the PO LineItem.
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 25th Jun, 2020
*Version        : 1.0
*Change History : Initial class
*Methods        : public static PurchaseOrderLineItem__c insertPart(string productCode,string qty,string purchaseId)
                  public pagereference pageRedirector(){         
*============================================================================================================*/
public class InsertPOLineItemController{
public List<SelectOption> options{get;set;}
public id currentSheet{get;set;}
   public InsertPOLineItemController(ApexPages.StandardController controller){
         currentSheet=ApexPages.currentPage().getParameters().get('id');
         options=new List<SelectOption>();
         List<Warehouse__C> whlist=new List<Warehouse__c>();
         whlist=[Select id,name from Warehouse__c];
         for(Warehouse__c wh:whlist){
           options.add(new Selectoption(wh.id,wh.name));
         }
  }
/*====================================================
*Method Name     : insertPart
*Description     : This method gets input from page and search products based on supplier code.
*Arguments       : string productCode,string qty,string purchaseId
*Ticket No       : 40744
====================================================*/
   @RemoteAction
     public static PurchaseOrderLineItem__c insertPart(string productCode,string qty,string purchaseId){
          id reportid=purchaseId;
          Schema.SObjectType sobjectName=reportid.getSObjectType();
          system.debug(sobjectName);

          Product2 prod=[Select id,name,Supplier_Product_Code__c from Product2 where product2.Supplier_Product_Code__c=:productCode limit 1];
          PurchaseOrderLineItem__c  parts;
          if(prod!=null){
           parts=new PurchaseOrderLineItem__c();
           
          parts.Purchase_Order__c=purchaseId;
          
          parts.Product__c=prod.id;
          parts.Quantity__c=Decimal.valueof(qty);          
          system.debug(parts);
          try{                            
              insert parts;                            
          }
          catch(Exception e){
            system.debug(e);
            return null;
          }
         
               
          }
          return parts;

  
  }//insertPart
/*====================================================
*Method Name     : pageRedirector
*Description     : This method redirects to the record page.
*Arguments       : No arguments
*Ticket No       : 40744
====================================================*/ 
  public pagereference pageRedirector(){    
    ApexPages.Pagereference  pg=new ApexPages.Pagereference('/'+currentSheet);
    pg.setRedirect(true);
    return pg;
  }
  
}