/*============================================================================================================
*Class Name     : PurchaseOrderTriggerHandler
*Description    : All the implementations related to Purchase Order Triggers should be handled here
*Company        : Puthuvannam Technology Solutions
*Date           : 17th June, 2014
*Version        : 1.0
*Change History : Initial Trigger Handler
*Methods        : public void OnAfterInsert(Map<Id,SFDC_Purchase_Order__c> newPOMap)
                 public void OnAfterUpdate(Map<Id,SFDC_Purchase_Order__c> newPOMap,Map<Id,SFDC_Purchase_Order__c> oldPOMap)
*================================================================================================================*/

 public class PurchaseOrderTriggerHandler{
/*    public void OnAfterInsert(Map<Id,SFDC_Purchase_Order__c> newPOMap) {

      
    }
    public void OnBeforeInsert(List<SFDC_Purchase_Order__c> newPOList) {
      this.UpdateOppName(newPOList);
      
    }
    
    public void OnBeforeUpdate(List<SFDC_Purchase_Order__c> newPOList) {
      this.UpdateOppName(newPOList);
      
    }
  
    public void OnAfterUpdate(Map<Id,SFDC_Purchase_Order__c> newPOMap,Map<Id,SFDC_Purchase_Order__c> oldPOMap){
  
     }
     private void UpdateOppName(List<SFDC_Purchase_Order__c> newPOList){
     // Variable Declaration
        List<id> visitIds = new List<id> ();
        for(SFDC_Purchase_Order__c po:newPOList){
            visitIds.add(po.Visit__c);
            system.debug('======'+po.Visit__c);
        }
      //to get a list of Visits      
      if(visitIds != null && visitIds.size() > 0){ 
        Map<id, Visits__c> visitMap=new Map<id, Visits__c>([select Id,Opportunity__c from Visits__c where ID IN:visitIds And Opportunity__c != null]);
        for(SFDC_Purchase_Order__c po:newPOList){
            if(visitMap.containsKey(po.visit__c)){
                po.Opportunity__c=visitMap.get(po.visit__c).Opportunity__c;    
            }else{
                po.Opportunity__c = null;
            }         
        }
      }
     } */
}