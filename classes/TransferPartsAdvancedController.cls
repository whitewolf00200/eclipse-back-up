/*============================================================================================================
*Class Name     : TransferPartsAdvancedController
*Description    : All the implementations related to scan and transfer parts.
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 28th Nov, 2022
*Version        : 1.0
*Ticket         : 96456
*Change History : Added None to target warehouse picklist.
*Methods        : public static String getAvailableQty(string supCode,String srcWh)
public static string partsTransfer(string supCode,string whid,string num,String srcWh)
public pagereference pageRedirector()
*============================================================================================================*/
public class TransferPartsAdvancedController{
    
    public List<SelectOption> options{get;set;}
    public string selectedWH{get;set;}
    public Integer count{get;set;}
    Public id currentWH;
    public string code{get;set;}
    
    public TransferPartsAdvancedController(ApexPages.StandardController controller) {
        currentWH=ApexPages.currentPage().getParameters().get('id');
        
        count=0;
        options=new List<SelectOption>();
        List<Warehouse__C> whlist=new List<Warehouse__c>();
        whlist=[Select id,name from Warehouse__c where id!=:currentWH];
        
        options.add(new Selectoption('','Please Select'));
        
        for(Warehouse__c wh:whlist){
            options.add(new Selectoption(wh.id,wh.name));
        }
        
    }
    /*====================================================
*Method Name     : getAvailableQty
*Description     : This method checks the product is exist or not based on given product code.
*Arguments       : string supCode,String srcWH.
*Ticket No       : 96456
====================================================*/    
    @RemoteAction
    public static String getAvailableQty(string supCode,String selectedWH){
        Inventory__c srcinv;
        String availQty;
        
        system.debug(selectedWH);
        system.debug(supCode);
        
        try{
            srcinv=[Select id,name,Product__c,Total_Received__c,In_Hand_Quantity__c,Product__r.Supplier_Product_Code__c,Product__r.ProductCode,Warehouse__c from Inventory__c where Warehouse__c=:selectedWH and Product__r.ProductCode=:supCode limit 1];
            availQty=string.valueof(srcinv.In_Hand_Quantity__c);
            system.debug(srcinv);     
            return availQty;
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'The product code not matching'));
            return null;
        }
    }
    
    /*====================================================
*Method Name     : partsTransfer
*Description     : This method transfer the parts quantity.
*Arguments       : string supCode,string whid,string num,String srcWh
*Ticket No       : 96456
====================================================*/   
    @RemoteAction
    public static string partsTransfer(string supCode,string whid,string num,String selectedWH){
        Inventory__c srcinv;
        Inventory__c tgtinv;
        List<Inventory_Transaction__c> invTransList=new List<Inventory_Transaction__c>();
        
        system.debug(selectedWH);
        system.debug(supCode);
        if(selectedWh == '0'){
            system.debug(selectedWH);
        }
        try{
            srcinv=[Select id,name,Product__c,Product__r.ProductCode,Product__r.Supplier_Product_Code__c,Warehouse__c from Inventory__c where Warehouse__c=:selectedWH and Product__r.ProductCode=:supCode limit 1];
            
            system.debug(srcinv);
            
            tgtinv=[Select id,name,Product__c,Product__r.ProductCode,Product__r.Supplier_Product_Code__c,Warehouse__c from Inventory__c where Warehouse__c=:whid and Product__r.ProductCode=:supCode limit 1];    
            Inventory_Transaction__c invTrans=new Inventory_Transaction__c();
            invTrans.name=tgtinv.name;
            invTrans.qty__c=decimal.valueOf(num);
            invTrans.Inventory__c=tgtinv.id;
            invTrans.Transaction_Type__c='Received';
            
            system.debug(invTrans);
            invTransList.add(invTrans);
            inventory_Transaction__c invTrans2=new Inventory_Transaction__c();
            invTrans2.name=srcinv.name;
            invTrans2.Inventory__c=srcinv.id;
            invTrans2.qty__c=Decimal.valueOf(num);
            invTrans2.Transaction_Type__c='Delivered';
            system.debug(invTrans2);
            
            invTransList.add(invTrans2);
            system.debug(invTrans2);
            
            if(invTransList!=Null)
            insert invTransList;   
        }
        catch(QueryException qe){      
            system.debug(qe);
            List<Inventory_Transaction__c> TransList=new List<Inventory_Transaction__c>();
            
            product2 prod=[Select id,name,ProductCode,Supplier_Product_Code__c from Product2 where ProductCode=:supCode limit 1];
            Inventory__c newInv=new Inventory__c();
            newInv.warehouse__c=whid;
            newInv.Product__c=prod.id;
            insert newInv;
            Inventory_Transaction__c invTrans=new Inventory_Transaction__c();
            invTrans.name=newInv.name;
            invTrans.qty__c=Decimal.valueOf(num);
            invTrans.Transaction_Type__c='Received';
            invTrans.Inventory__c=newInv.id;
            insert invTrans;
            
            Inventory_Transaction__c invTrans2=new Inventory_Transaction__c();
            invTrans2.name=srcinv.name;
            invTrans2.Inventory__c=srcinv.id;
            invTrans2.qty__c=Decimal.valueOf(num);
            invTrans2.Transaction_Type__c='Delivered';
            insert invTrans2;
            
            
            
            
        }
        
        return selectedWH;
        
        
    }//insertPart
    /*====================================================
*Method Name     : verifyCode
*Description     : This method verify the product code is valid or not.
*Arguments       : No argument
*Ticket No       : 96456
====================================================*/     
    
    public void verifyCode(){
        code=Apexpages.currentPage().getParameters().get('myParam');
        count=0;
        system.debug(code);
        if(code!=null){
AggregateResult[] ag=[Select count(id)cnt from product2 where ProductCode=:code group by ProductCode];
if(ag.size()>0){
count=(Integer)ag[0].get('cnt');

} 

}
        
        
    }
    
    /*====================================================
*Method Name     : pageRedirector
*Description     : This method redirects to target warehouse.
*Arguments       : No argument
*Ticket No       : 96456
====================================================*/     
    public pagereference pageRedirector(){
        
        system.debug(count); 
        
        if(count!=0){
            ApexPages.Pagereference  pg = new ApexPages.Pagereference('/'+currentWH);
            pg.setRedirect(true);
            return pg;  
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Product Code Not Matched'));
            return null;
        }
        
    }
    public PageReference onCancel(){
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }
    
}