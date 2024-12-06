public class DeliveryNoteHandler{
        
         public void AfterUpdate(Map<id,Delivery_Note__c > newMap,Map<id,Delivery_Note__c > oldMap){
            ShowDescUpdate(newMap,oldMap);
         }
         
             
/*==============================================================================
Method Name: ShowDescUpdate
Description: Update Show Description based on Parent Show Descripton Field
Created date: 14-07-2017
================================================================================*/


public void ShowDescUpdate(Map<id,Delivery_Note__c > newMap,Map<id,Delivery_Note__c > oldMap){
List<Id> DnIds=new List<Id>();
List<Delivery_Note_Line_Item__c> UpdateDli=new List<Delivery_Note_Line_Item__c>();
       
    for(Delivery_Note__c Dn:newMap.values()){
          if(Dn.Show_Description__c!=oldMap.get(Dn.id).Show_Description__c){
              DnIds.add(Dn.id);
          }
    }
    
    if(DnIds.size()>0){
        for(Delivery_Note_Line_Item__c Dli:[Select id,Show_Description__c,Delivery_Note__r.Show_Description__c,Delivery_Note__c from Delivery_Note_Line_Item__c  where Delivery_Note__c IN:DnIds]){
            Dli.Show_Description__c=Dli.Delivery_Note__r.Show_Description__c;
            UpdateDli.add(Dli);
        }
    }      
    
    if(UpdateDli.size()>0){
       update UpdateDli;
    }  
}
    }