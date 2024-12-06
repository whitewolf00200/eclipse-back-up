Public Class SmallWorksTriggerHandler{

    public void OnBeforeInsert(Map<Id,Small_Works__c> newReActMap){
        
    }
    public void OnAfterInsert(Map<Id,Small_Works__c> newSmallWorksMap,Map<Id,Small_Works__c> oldSmallWorksMap){       
       
    }
    public void OnAfterUpdate(Map<Id,Small_Works__c> newSmallWorksMap,Map<Id,Small_Works__c> oldSmallWorksMap){
         if(RecursiveHandler.runSW_USVTOnce()){
            //this.UpdateSiteVisitTimes(newSmallWorksMap);        //Updating the Site Visit Times on the opportunities                     
            UpdateSiteVisitTimes(newSmallWorksMap);        //Updating the Site Visit Times on the opportunities                     
        }
        if(RecursiveHandler.runSW_UVCOnce()){
            //this.UpdateVisitComplete(newSmallworksMap);        //Updating the Visit Complete on the Visits 
            UpdateVisitComplete(newSmallworksMap);        //Updating the Visit Complete on the Visits 
        }
        
         if(RecursiveHandler.runSW_UPONOnce()){
            UpdatePurchaseOrderNumber(newSmallworksMap,oldSmallWorksMap);         // Update the Purchase Order Number Field on the Opportunity
        }
        
    }
    public void OnBeforeUpdate(Map<Id,Small_Works__c> newSmallWorksMap,Map<Id,Small_Works__c> oldSmallWorksMap){
        
    }
    
    //Update Site Visit Times
    Private void UpdateSiteVisitTimes(Map<Id,Small_Works__c> newSWMap){
        List<Opportunity> listOpps=new List<Opportunity>();
        listOpps=[SELECT id, Site_Visit_Time__c,Small_Works__c from opportunity where Small_Works__c IN:newSWMap.keyset()];    
        DateTime aDte;
        DateTime dDte;
        Long diffMS;
        for(Opportunity opp:listOpps){
            aDte=((newSWMap.get(opp.Small_Works__c ).Arrive__c!=NULL)?newSWMap.get(opp.Small_Works__c ).Arrive__c:system.now());
            dDte=((newSWMap.get(opp.Small_Works__c ).Depart__c!=NULL)?newSWMap.get(opp.Small_Works__c ).Depart__c:system.now());
            diffMS=dDte.getTime()-aDte.getTime();            
            
            opp.Site_Visit_Time__c=aDte.Day()+'/'+aDte.Month()+'/'+aDte.Year()+' '+aDte.Hour()+':'+aDte.Minute()+'\r\n'+
                                   dDte.Day()+'/'+dDte.Month()+'/'+dDte.Year()+' '+dDte.Hour()+':'+dDte.Minute()+'\r\n'+
                                   aDte.Date().DaysBetween(dDte.Date())+' Day(s), ' + Math.FLOOR((Math.Mod(diffMS,86400000))/3600000) + ' Hour(s) and ' + math.ROUND(Math.Mod((Math.Mod(diffMS,86400000)),3600000)/60000) + ' Minute(s)';            
        }
        
        update listOpps;
        
    }
    
       // Update Visit Complete
       Private void UpdateVisitComplete(Map<Id,Small_Works__c> newSWMap){
       // Variable Declaration
       List<id> visitIds = new List<id> ();
       for(Small_Works__c  sw:newSWMap.values()){
          visitIds.add(sw.visit__c);   
       }
        //to get a list of Visits 
         List<Visits__c> visitList=[select id,Visit_Complete__c from Visits__c where ID IN:visitIds ];
         for(Small_Works__c  sw:newSWMap.values()){ 
            for(Visits__c  vt :visitList){
               if(sw.Visit__c == vt.Id && sw.Close_Visit__c=='Yes'){ 
                  //assign  Visit Complete Field
                   vt.Visit_Complete__c =true; 
                }    
             }
          }
            update visitList;    //update the Visits
        }
        
/*====================================================
*Method Name     : UpdatePurchaseOrderNumber
*Description     : Update the Purchase Order Number Field.
*Arguments       : new Small Works list
====================================================*/        
    Private void UpdatePurchaseOrderNumber(Map<id,Small_Works__c> newSWMap,Map<id,Small_Works__c> oldSWMap){
        //Variable Declaration
        List<id> swIds=new List<id>();
        for(Small_Works__c sw:newSWMap.values()){
            if(oldSWMap.get(sw.id).Order_No__c!=sw.Order_No__c)
                swIds.add(sw.Id);
        }
        //to get a list of Opportunity
        List<Opportunity> oppList=[select id,Purchase_order_number2__c,Small_Works__c from Opportunity
                                            where Small_Works__c IN:swIds ];
        for(Opportunity opp :oppList){
            //assign Purchase Order Number Field
            if(opp.Small_Works__c!=NULL){
                opp.Purchase_order_number2__c =newSWMap.get(opp.Small_Works__c).Order_No__c;
            }
        }
        update oppList;    //update the Opportunity
    }        
        
}