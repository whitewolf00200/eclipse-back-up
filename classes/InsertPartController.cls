/*============================================================================================================
*Class Name     : InsertPartController
*Description    : All the implementations related to scan and Add the parts to sheet.
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 28th Nov, 2022
*Version        : 1.0
*Ticket         : 96456
*Change History : Initial class
*Methods        : public static Required_Parts__c insertPart(string productCode,string whid,string qty,string sheetId)
public pagereference pageRedirector()
*============================================================================================================*/
public class InsertPartController{
    public List<SelectOption> options{get;set;}
    public string selectedWH{get;set;}
    Public String prdcode {get;set;}
    Public Integer numb {get;set;}
    public id SheetId{get;set;}
    public Integer count{get;set;}
    public string code{get;set;} 
    
    public InsertPartController(ApexPages.StandardController controller){
        SheetId=ApexPages.currentPage().getParameters().get('id');
        options=new List<SelectOption>();
        List<Warehouse__C> whlist=new List<Warehouse__c>();
        count=0;
        whlist=[Select id,name from Warehouse__c];
         options.add(new Selectoption('','Please Select' ));
        for(Warehouse__c wh:whlist ){
            
            options.add(new Selectoption(wh.id,wh.name ));
        }
    }    
    /*====================================================
*Method Name     : getAvailableQty
*Description     : This method checks the product is exist or not based on given product code.
*Arguments       : string supCode,String srcWH.
*Ticket No       : 96456
====================================================*/
    
    @RemoteAction
    public static boolean checkAvailibility(string productcode){
        
        system.debug(productcode);
        try{
            Product2 prod=[Select id,name,Supplier_Product_Code__c,productcode from Product2 where product2.productcode=:productCode limit 1];
            
            return true;
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'The product code not matching'));
            return null;
        }
    }
    
    
    /*====================================================
*Method Name     : insertPart
*Description     : This method gets Product from page and search products based on product code.
*Arguments       : string productCode,string whid,string qty,string sheetId
*Ticket No       : 96456
====================================================*/
    public PageReference onSave(){
        code=Apexpages.currentPage().getParameters().get('myParam');
        
        id reportid=sheetId; 
        System.debug(numb);
        System.debug('Product Code===> '+code);
        system.debug(reportid);
        Required_Parts__c parts;
        Schema.SObjectType sobjectName=reportid.getSObjectType();
        system.debug(sobjectName);
        try{ 
            Product2 prod=[Select id,name,Supplier_Product_Code__c,productcode from Product2 where ProductCode=:code limit 1];
            
            if(prod!=null){
                parts=new Required_Parts__c();
                if(sobjectName.getDescribe().getName()=='Service_Sheet_STD__c')
                    parts.Maintenance_Reactive_Sheet__c=sheetId;
                if(sobjectName.getDescribe().getName()=='Engineer_Checklist__c')
                    parts.Service_Sheet__c=sheetId;
                
                parts.Product_Name__c=prod.id;
                parts.Quantity__c=numb;
                parts.Warehouse__c=SelectedWH;
                if(code!=Null){
                insert parts;
                }
            }
            
        }
        catch(Exception e){
            system.debug(e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
        }
        
        
        
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
        
        
    }
    
    /*====================================================
*Method Name     : verifyCode
*Description     : This method verify the product code is valid or not.
*Arguments       : No argument
*Ticket No       : 96456
==================================================== */    
    
    public void verifyCode(){
        code=Apexpages.currentPage().getParameters().get('myParam');
        count=0;
        system.debug(code);
        if(code!=null){
            AggregateResult[] ag=[Select count(id)cnt from product2 where productcode=:code group by productcode];
            if(ag.size()>0)
                count=(Integer)ag[0].get('cnt'); 
        }
        
        
    }
    
    /*====================================================
*Method Name     : pageRedirector
*Description     : This method redirects to the record page.
*Arguments       : No arguments
*Ticket No       : 96456
====================================================*/ 
    public pagereference pageRedirector(){
        system.debug(count); 
        
        if(count!=0){
            ApexPages.Pagereference  pg=new ApexPages.Pagereference('/'+SheetId);
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