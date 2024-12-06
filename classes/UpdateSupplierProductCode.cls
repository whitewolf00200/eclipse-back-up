public class UpdateSupplierProductCode{

public List<SupplierProduct__c> supline{get;set;}
public List<PurchaseOrderLineItem__c> polineitem;
public Set<String> polineset;
public List<String> polinelist;
public Id poid;
public PurchaseOrder__c po;

public Id getPoid(){return poid;}
public void setPoid(Id Poids){
    if(Poids != null)
        Poid=poids;
        getsupplierproducts();
}
    public void getsupplierproducts(){

        try{
            polineset = new Set<String>();
            polinelist = new List<String>();
            
            po = [select id,supplier__c from PurchaseOrder__c where id=:poid];
            polineitem = [select id,Product__c from PurchaseOrderLineItem__c where Purchase_Order__c=:po.id];
            system.debug('#####################'+polineitem);
            for(PurchaseOrderLineItem__c prli :polineitem){
                polinelist.add(prli.Product__c);    
            }
            polineset.addAll(polinelist);
            system.debug('@@@@@@@@@@@@@@@@@@@'+polineset);
            supline = [select name,Product__c,supplier__c,Supplier_Product_Code__c from SupplierProduct__c where supplier__c=:po.supplier__c AND Product__c IN :polineset];
            system.debug('&&&&&&&&&&&&&&&&&&&&&'+supline);
        }catch(Exception e){}
    }
}