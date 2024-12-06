public class CreditHandler{
     
    public void AfterUpdate(Map<id,Credit_Notes__c> newMap,Map<id,Credit_Notes__c> oldMap){
    
        showdesc(newMap,oldMap);
    }
    
    public void AfterInsert(Map<Id,Credit_Notes__c> newMap){
       
        UpdateCreditNo(newMap);
    }
    
     public void showdesc(Map<id,Credit_Notes__c> newMap,Map<id,Credit_Notes__c> oldMap){
        Set<id> crdid=new Set<id>();
        List<Credit_Note_Line_Item__c> cli=new List<Credit_Note_Line_Item__c>();
       
       for(Credit_Notes__c cn:newMap.values()){
          if(cn.Show_Description__c!=oldMap.get(cn.id).Show_Description__c){
              crdid.add(cn.id);
          }
       }
          
         
       if(crdid.size()>0){ 
         for(Credit_Note_Line_Item__c cl:[Select id,Show_Description__c,Credit_Notes__r.Show_Description__c,Credit_Notes__c from Credit_Note_Line_Item__c where Credit_Notes__c IN:crdid]){
           cl.Show_Description__c=cl.Credit_Notes__r.Show_Description__c;
           cli.add(cl);
         } 
       }
       if(cli.size()>0){
           update cli;
       }  

    }
    
/* =======================================

Method Name: UpdateCreditNo
Created Date: 31.10.17
Purpose: To link credit note number in opportunity.This is used in reports and dashboard for credit note number reference
Argument: NewMap

============================================= */    
     
    public void UpdateCreditNo(Map<Id,Credit_Notes__c> newMap){
      List<Id> oppid=new List<Id>();
      Map<Id,String> creno=new Map<Id,string>();
      List<Opportunity> opplist=new List<Opportunity>();
       
       for(Credit_Notes__c cn:newMap.values()){
          if(cn.Opportunity__c!=null){
              oppid.add(cn.Opportunity__c);
              if(!creno.containskey(cn.Opportunity__c)){
                  creno.put(cn.Opportunity__c,cn.Name);
                  system.debug('creno=========='+creno);
               }
          }
       }
       if(oppid.size()>0){
         for(Opportunity opp:[Select id,name,Credit_Note_Number__c from opportunity where id IN:oppid]){
            if(creno.containskey(opp.id)){
                opp.Credit_Note_Number__c=creno.get(opp.id);
                opplist.add(opp);
                system.debug('opplist=========='+opplist);
            }
         }
       }
       if(opplist.size()>0){
          update opplist;
       }
     
     }
     
     
}