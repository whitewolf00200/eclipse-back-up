public class OpportunityLineItemAddController{
public List<SelectOption> options{get;set;}
public Integer count{get;set;}

   public OpportunityLineItemAddController(ApexPages.StandardController controller){
        
        options=new List<SelectOption>();
        List<Warehouse__C> whlist=new List<Warehouse__c>();
        whlist=[Select id,name from Warehouse__c];
        for(Warehouse__c wh:whlist){
           options.add(new Selectoption(wh.id,wh.name));
        }
        
        id opid=ApexPages.currentPage().getParameters().get('id');
        count=[select count() from Opportunitylineitem where opportunityid=:opid];
        if(count==0){
            /* options=new List<SelectOption>();
             List<Warehouse__C> whlist=new List<Warehouse__c>();
              whlist=[Select id,name from Warehouse__c where id!=:currentWH];
               for(Warehouse__c wh:whlist){
                options.add(new Selectoption(wh.id,wh.name));
        }*/
        
        }
        
  }
   @RemoteAction
  public static Required_Parts__c insertPart(string productCode,string whid,string qty,string sheetId){
          id reportid=sheetId;
          Schema.SObjectType sobjectName=reportid.getSObjectType();
          system.debug(sobjectName);

          Product2 prod=[Select id,name,Supplier_Product_Code__c from Product2 where product2.Supplier_Product_Code__c=:productCode limit 1];
          Required_Parts__c parts;
          if(prod!=null){
           parts=new Required_Parts__c();
           if(sobjectName.getDescribe().getName()=='Service_Sheet_STD__c')
          parts.Maintenance_Reactive_Sheet__c=sheetId;
          if(sobjectName.getDescribe().getName()=='Engineer_Checklist__c')
          parts.Service_Sheet__c=sheetId;
          
          parts.Product_Name__c=prod.id;
          parts.Quantity__c=integer.valueof(qty);
          parts.Warehouse__c=whid;
          
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
  
}