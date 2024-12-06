/*============================================================================================================
*Class Name     : InventoryTriggerHandler
*Description    : All the implementations related to Inventory Triggers should be handled here
*Company        : Merfantz Technology Solutions
*Date           : 18th Augest, 2014
*Version        : 1.0
*Change History : Initial Trigger Handler
*Methods        : public void OnAfterInsert(Map<id,Inventory__c> newInvMap,Map<id,Inventory__c> oldInvMap)

*============================================================================================================*/

public class InventoryTriggerHandler{
    
    
/*====================================================
    *Method Name     : OnAfterInsert
    *Description     : Handle the after Insert operation
    *Arguments       : new map list
====================================================*/

    public void OnBeforeInsert(List<Inventory__c> newInv){
     //DuplicInv(newInvMap);
    system.debug('before insert====='+newInv);
     if(ControlFetch__c.getInstance('Inventory check').Allow_Duplicate__c==false){
     DuplicInv(newInv);
     }
    }
    
    public void OnAfterInsert(Map<id,Inventory__c> newInvMap,Map<id,Inventory__c> oldInvMap){
        
         UpdateCapacity(newInvMap);
        if(!Test.isRunningTest())
         RollupSumOnInv(newInvMap);
       
        
    }
    public void OnAfterUpdate(Map<id,Inventory__c> newInvMap,Map<id,Inventory__c> oldInvMap){
        UpdateCapacity(newInvMap);
        RollupSumOnInv(newInvMap);
    }
    
    public void OnAfterDelete(Map<id,Inventory__c> oldMap){
        UpdateCapacity(oldMap);
        RollupSumOnInv(oldMap);
    }
    
    public void OnAfterUnDelete(Map<id,Inventory__c> newInvMap){
        UpdateCapacity(newInvMap);
        RollupSumOnInv(newInvMap);
    }
    
    public void RollupSumOnInv(Map<id,Inventory__c> newInvMap){
        system.debug('newInvMap RollupSumOnInv============'+newInvMap);
        List<Id> PrdIds=new List<Id>();
        Map<id,Product2> Products;
        for(Inventory__c Inv:newInvMap.values()){
            PrdIds.add(Inv.Product__c);
            System.debug('Product Id === '+PrdIds);
        }
        
        if(PrdIds.size()>0){
            Products=new Map<Id,Product2>([select id,Total_Inventory__c,Total_In_Vehicle__c,Total_Delivered__c from product2 where id In:PrdIds]);
            AggregateResult[] Result=[select Product__c,Count(Id)cnt,SUM(In_Hand_Quantity__c)tot,SUM(Total_in_Vehicle__c)veh,SUM(Total_Delivered__c)disp from Inventory__c where Product__c IN:PrdIds GROUP BY Product__c];
            system.debug('Result========'+Result.size());
            for(AggregateResult agg:Result){
                if(Products.containskey((Id)agg.get('Product__c'))){
                Products.get((Id)agg.get('Product__c')).Total_Inventory__c=(Decimal)agg.get('cnt');
                Products.get((Id)agg.get('Product__c')).Total_Stock_In_Hand__c=(Decimal)agg.get('tot');
                Products.get((Id)agg.get('Product__c')).Total_In_Vehicle__c=(Decimal)agg.get('veh');
                Products.get((Id)agg.get('Product__c')).Total_Delivered__c=(Decimal)agg.get('disp');
                }
            }
        }
        if(Products.size()>0){
            update Products.values();
        }
    }
    
    public void UpdateCapacity(Map<id,Inventory__c> newInvMap){
        List<String> loc=new List<String>();
        Map<Id,Integer> LocHand=new Map<Id,Integer>();
         List<Location__c> locList=new List<Location__c>();
        system.debug('newInvMap UpdateCapacity============'+newInvMap);
        for(Inventory__c inv:newInvMap.values()){
            if(inv.Location__c!=null){
                loc.add(inv.Location__c);
            }
        }
        
        if(loc.size()!=0){
            AggregateResult[] Results= [select Location__c,sum(In_Hand_Quantity__c)inHand from Inventory__c group by Location__c having Location__c IN:loc ];
           for(AggregateResult agr :Results){ 
               LocHand.put((Id)agr.get('Location__c'),integer.valueOf(agr.get('inHand')));
           } 
        }
        
        list<Location__c> loca =new list<Location__c>([select id,Occupied__c from Location__c where id IN:loc]);
        
        for(Location__c Locloop:loca){
            if(LocHand.containskey(Locloop.id)){
                Locloop.Occupied__c=LocHand.get(Locloop.id);
                locList.add(Locloop);
            }
        }
        
        if(locList.size()>0){
            update locList;
        }
       // System.debug('111111111111'+locList);
    }
    
  public void DuplicInv(List<Inventory__c> newInvMap){
  
  List<Id> Whid=new List<Id>();
  Map<Id,Inventory__c> dupinv=new Map<Id,Inventory__c>();  
  
   for(Inventory__c I:newInvMap){
     Whid.add(I.Warehouse__c);
     } 
     system.debug('whid========'+Whid);
    system.debug('newInvMap=============='+newInvMap);
    list<Inventory__c> inv = new list<Inventory__c>([Select id,Product__c,Warehouse__c from Inventory__c where Warehouse__c=:Whid]);
    for(Inventory__c Inve:inv){
    dupinv.put(Inve.Product__c,Inve);
    }
    system.debug('dupinv==========='+dupinv);
    
    for(Inventory__c dup:newInvMap){
    if(dupinv.ContainsKey(dup.Product__c))
    {
     dup.addError('Product you choose is already exist for this warehouse. Duplicate products are not allowed in Inventory');
    }
    } 
    
    }  
}