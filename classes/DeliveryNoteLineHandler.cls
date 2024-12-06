public class DeliveryNoteLineHandler{
    
    public void OnAfterInsert(Map<Id,Delivery_Note_Line_Item__c> newMap){
        InsertInvoice(newMap);
    }
    
    public void InsertInvoice(Map<Id,Delivery_Note_Line_Item__c> newMap){
     /* List<Id> OppId=new List<Id>();
      List<Id> ProductIds=new List<Id>();
      List<Id> PricebookIds=new List<Id>();
      Map<Id,Opportunity> OppMap=new Map<Id,Opportunity>();
      Map<Id,Map<Id,Pricebookentry>> PeEntry=new Map<Id,Map<Id,Pricebookentry>>();
      Map<String,OpportunityLineItem> newOli=new Map<String,OpportunityLineItem>();
      Map<Id,Pricebookentry> InnerMap=new Map<Id,Pricebookentry>();
      Map<String,Decimal> SoPrdCost=new Map<String,Decimal>();
      String CombineKey,SoPriceKey;
      
          for(Delivery_Note_Line_Item__c Deoli:newMap.values()){
              if(Deoli.Opportunity_Id__c!=null){
                  OppId.add(Deoli.Opportunity_Id__c);
                  ProductIds.add(Deoli.Product__c);
              }
          }   
          
          
          if(OppId.size()>0){
              for(Opportunity Opp:[select id,Pricebook2Id from Opportunity where id IN:OppId]){
                  if(!OppMap.containskey(Opp.Id)){
                      OppMap.put(Opp.Id,Opp);
                      PricebookIds.add(Opp.Pricebook2id);
                  }
              }
          }
         
          if(ProductIds.size()>0 && PricebookIds.size()>0){
              for(Pricebookentry Pe:[select id,Unitprice,Product2id,pricebook2id from pricebookentry where product2id IN:ProductIds and Pricebook2Id IN:PricebookIds]){
                  if(PeEntry.containskey(Pe.pricebook2Id)){
                      PeEntry.get(Pe.pricebook2Id).put(Pe.product2id,pe);
                  }else{
                      PeEntry.put(Pe.pricebook2Id, new Map<Id,Pricebookentry>{Pe.product2id =>pe});
                  }
              }
          }
           
           
          for(Delivery_Note_Line_Item__c Deoli:newMap.values()){
              if(Deoli.Opportunity_Id__c!=null){
                  if(OppMap.containskey(Deoli.Opportunity_Id__c) && PeEntry.containskey(OppMap.get(Deoli.Opportunity_Id__c).Pricebook2Id)){
                      InnerMap=new Map<Id,Pricebookentry>();
                      InnerMap=PeEntry.get(OppMap.get(Deoli.Opportunity_Id__c).Pricebook2Id);
                      OpportunityLineItem OppnewOli=new OpportunityLineItem();
                      if(InnerMap.containskey(Deoli.Product__c)){
                          CombineKey=Deoli.Opportunity_Id__c+Deoli.Product__c;
                          system.debug('newOli>>>>>>'+newOli);
                          if(!newOli.containskey(CombineKey)){
                          OppnewOli.pricebookentryid=InnerMap.get(Deoli.Product__c).Id;
                          OppnewOli.Quantity=Deoli.Qty__c!=null?Deoli.Qty__c:1;
                          OppnewOli.unitprice=Deoli.Price__c!=null?Deoli.Price__c:0;
                          OppnewOli.OpportunityId=Deoli.Opportunity_Id__c;
                          newOli.put(CombineKey,OppnewOli);
                          }else{
                              newOli.get(CombineKey).Quantity+=1;
                          }
                      
                      }
                  }
              }
          }
          system.debug('newOliouter>>>>>>'+newOli);
          if(newOli.size()>0){
              insert newOli.values();
          }*/
    }
}