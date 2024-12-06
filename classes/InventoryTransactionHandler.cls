public class InventoryTransactionHandler{

    public void OnAfterInsert(Map<id,Inventory_Transaction__c> newInvMap){
        AvoidDulipcateSN(newInvMap);
    }
    
    public void OnBeforeUpdate(Map<id,Inventory_Transaction__c> newInvMap){
        AvoidDulipcateSN(newInvMap);
    }
    
    public void AvoidDulipcateSN(Map<id,Inventory_Transaction__c> newInvMap){
       Map<String,String> FindDuplicate=new Map<String,String>();
       List<String> InvId=new List<String>();
       Boolean Flag=false;
       
       for(Inventory_Transaction__c InvenTrans:newInvMap.values()){
          InvId.add(InvenTrans.Product__c);
       }
      
      if(InvId.size()>0){
          for(Inventory_Transaction__c InvTrans:[select id,Name,Product__c,Inventory__c,Warehouse__c from Inventory_Transaction__c where Product__c IN:InvId]){
          //system.debug(InvTrans.Name+'>>>>>>>'+InvTrans.Product__c);
          if(FindDuplicate.containskey(InvTrans.Name) && FindDuplicate.get(InvTrans.Name)==InvTrans.Product__c)
          Flag=true;
          else
          FindDuplicate.put(InvTrans.Name,InvTrans.Product__c);
          }
       }
       
       for(Inventory_Transaction__c InvenTrans:newInvMap.values()){
           IF(Test.isRunningTest())
           if(Flag && ControlFetch__c.getInstance('Avoid Duplicate').Serial_Number_Check__c)
           InvenTrans.addError(ControlFetch__c.getInstance('Avoid Duplicate').Error_Message__c!=null?ControlFetch__c.getInstance('Avoid Duplicate').Error_Message__c:'Duplicate Serial Number found');
       }
    }
    
}