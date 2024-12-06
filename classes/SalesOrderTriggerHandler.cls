public class SalesOrderTriggerHandler{

    public void OnAfterInsert(Map<Id,SalesOrder__c> NewMap,Map<Id,SalesOrder__c> OldMap){
      InsertOLIPrds(NewMap,OldMap);
      system.debug('NewMap.values========='+NewMap.values());
      UpdateStage(NewMap,OldMap);
      
    }
    
     public void AfterUpdate(Map<id,SalesOrder__c> newMap,Map<id,SalesOrder__c> oldMap){
    
        showdesc(newMap,oldMap);
        
    }
    
    public void InsertOLIPrds(Map<Id,SalesOrder__c> NewMap,Map<Id,SalesOrder__c> OldMap){
    Map<Id,Id> Ids=new Map<Id,Id>();
    List<SalesOrderLineItems__c> SalesOLiList=new List<SalesOrderLineItems__c>();
    SalesOrderLineItems__c SalesOLI;
   
    
        for(SalesOrder__c NewVal: NewMap.values()){
            Ids.put(NewVal.Opportunity__c,NewVal.Id);
            
        }
        
       
        
        for(OpportunityLineItem OppItem:[Select id,product2Id,quantity,SortOrder,OpportunityID,UnitPrice from OpportunityLineItem where OpportunityID=:Ids.keyset() order by SortOrder,Pricebookentry.product2.Name ]){
            if(Ids.containskey(OppItem.OpportunityID)){
            SalesOLI=new SalesOrderLineItems__c();
            SalesOLI.Sales_Order__c=Ids.get(OppItem.OpportunityID);
            SalesOLI.Product__c=OppItem.product2Id;
            SalesOLI.Quantity__c=OppItem.quantity;
            SalesOLI.Price__c=OppItem.UnitPrice;
            SalesOLiList.add(SalesOLI);
            }
        }
        if(SalesOLiList.size()>0)
        insert SalesOLiList;
    }
    
    public void UpdateStage(Map<Id,SalesOrder__c> NewMap,Map<Id,SalesOrder__c> OldMap){
        
        Set<Id> opid=new Set<Id>();
        List<Opportunity> OpList=new List<Opportunity>();
         
         
        for(SalesOrder__c NewVal: NewMap.values()){
            opid.add(NewVal.Opportunity__c);
        }
      if(opid.size()>0){
        for(Opportunity opp:[Select id,StageName from Opportunity where id IN:opid]) {
                        if(opp.StageName !='Order (Order Book)'){
                opp.StageName ='Order (Order Book)';
                OpList.add(opp);
                        }
        }
        }
        if(OpList.size()>0){
             update OpList;
        }
      
    }
   
    public void showdesc(Map<id,SalesOrder__c> newMap,Map<id,SalesOrder__c> oldMap){
        Set<id> soid=new Set<id>();
        List<SalesOrderLineItems__c> soliList=new List<SalesOrderLineItems__c>();
        List<SalesOrderLineItems__c> sli=new List<SalesOrderLineItems__c>();
      for(SalesOrder__c so:newMap.values()){
        if(so.Show_Description__c!=oldMap.get(so.id).Show_Description__c){
          soid.add(so.id);
          }
       }   
     if(soid.size()>0){
      for(SalesOrderLineItems__c ol:[Select id,Show_Description__c,Sales_Order__r.Show_Description__c,Sales_Order__c from SalesOrderLineItems__c where Sales_Order__c IN:soid]){
          ol.Show_Description__c=ol.Sales_Order__r.Show_Description__c;
          sli.add(ol);
       } 
       if(sli.size()>0){
           update sli;
       } 
       } 

    } public void updatelon(list<SalesOrder__c> newMap){
      Terms_on_SalesOrder__mdt[] termRecords = [SELECT Id, Term_In_Salesorder__c, Label FROM Terms_on_SalesOrder__mdt];
       string vas;
        for(Terms_on_SalesOrder__mdt va :termRecords){
            vas=va.Term_In_Salesorder__c;
        }            
        for(SalesOrder__c sales: newMap){
            
            string sd=sales.Terms__c;
 
            
                system.debug('Test11');
            List<String> splitValues;
            String customLabelValue =vas;
            splitValues = customLabelValue.split(';');
                        if(sales.Terms__c ==null){
                             sales.Terms__c= String.join(splitValues, '\n')+'\n';
                 }else
            sales.Terms__c= String.join(splitValues, '\n')+'\n'+sd;
            
            system.debug('sales.Terms__c>>>>>>>'+sales.Terms__c);
        }
    }

}