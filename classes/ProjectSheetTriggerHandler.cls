Public Class ProjectSheetTriggerHandler{

    public void OnBeforeInsert(Map<Id,Project_Sheet__c> newProMap){
        
    }
    public void OnAfterInsert(Map<Id,Project_Sheet__c> newProMap,Map<Id,Project_Sheet__c> oldProMap){        
       
    }
    public void OnAfterUpdate(Map<Id,Project_Sheet__c> newProMap,Map<Id,Project_Sheet__c> oldProMap){
        if(Limits.getQueries()>80 && Test.isRunningTest())
            return;
         if(RecursiveHandler.runPS_USVTOnce()){UpdateSiteVisitTimes(newProMap,oldProMap);}        //Updating the Site Visit Times on the opportunities  ERROR: Failure Message: "System.DmlException: Update failed. First exception on row 0 with id a0FD000000HD5FCMA1; first error: CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY, ReactiveSheetTriggers: execution of AfterUpdate caused by: System.DmlException: Update failed. First exception on row 0 with id 006D000000Us8A3IAJ; first error: FIELD_CUST
         if(RecursiveHandler.runPS_UVCOnce()){UpdateVisitComplete(newProMap);}    //Updating the Visit Complete on the Visit.
         if(RecursiveHandler.runPS_UPONOnce()){UpdatePurchaseOrderNumber(newProMap,oldProMap);}    // Update the Purchase Order Number Field on the Opportunity
         if(RecursiveHandler.runPS_UVOLTOnce()){UpdateVisitOppLayout(newProMap,oldProMap);}       // Update the Actual GP Margin, Actual Total Cost, Project Manager Fields on the Opportunity
    }
    public void OnBeforeUpdate(Map<Id,Project_Sheet__c> newProMap,Map<Id,Project_Sheet__c> oldProMap){
        
    }
    
    //Update Site Visit Times
    Private void UpdateSiteVisitTimes(Map<Id,Project_Sheet__c> newProMap,Map<Id,Project_Sheet__c> oldProMap){
        List<id> listPROIds=new List<id>();
        for(Project_Sheet__c PRO:newProMap.values()){
            if((PRO.Arrive__c!=oldProMap.get(PRO.id).Arrive__c) || (PRO.Depart__c!=oldProMap.get(PRO.id).Depart__c)){
                listPROIds.add(PRO.id);    
            }
        }
        List<Opportunity> listOpps=new List<Opportunity>();
        listOpps=[SELECT id, Site_Visit_Time__c,Project_Sheet__c from opportunity where Project_Sheet__c IN:listPROIds];    
        DateTime aDte;
        DateTime dDte;
        Long diffMS;
        for(Opportunity opp:listOpps){
            aDte=((newProMap.get(opp.Project_Sheet__c).Arrive__c!=NULL)?newProMap.get(opp.Project_Sheet__c).Arrive__c:system.now());
            dDte=((newProMap.get(opp.Project_Sheet__c).Depart__c!=NULL)?newProMap.get(opp.Project_Sheet__c).Depart__c:system.now());
            diffMS=dDte.getTime()-aDte.getTime();            
            
            opp.Site_Visit_Time__c=aDte.Day()+'/'+aDte.Month()+'/'+aDte.Year()+' '+aDte.Hour()+':'+aDte.Minute()+'\r\n'+
                                   dDte.Day()+'/'+dDte.Month()+'/'+dDte.Year()+' '+dDte.Hour()+':'+dDte.Minute()+'\r\n'+
                                   aDte.Date().DaysBetween(dDte.Date())+' Day(s), ' + Math.FLOOR((Math.Mod(diffMS,86400000))/3600000) + ' Hour(s) and ' + math.ROUND(Math.Mod((Math.Mod(diffMS,86400000)),3600000)/60000) + ' Minute(s)';            
        }
        try{
            update listOpps;
        }Catch(Exception e){
            String msg=e.getMessage();
            for(Project_Sheet__c ps:newProMap.values()){
                ps.addError(msg);
            }
        }
        
    
    }
    
    //Update Visit Complete 
    Private void UpdateVisitComplete(Map<Id,Project_Sheet__c> newProMap){
        //Variable Declaration
        List<id> visitIds=new List<id>();
        for(Project_Sheet__c ps:newProMap.values()){
            if(ps.Visit__c!=NULL)
                visitIds.add(ps.visit__c);
        }
        System.debug('--------'+visitIds);
        //to get a list of Visits 
        List<Visits__c> visitList=[select id,Visit_Complete__c,Visit_Completed__c from Visits__c where ID IN:visitIds ];
        System.debug('--------'+visitList);
        for(Project_Sheet__c ps:newProMap.values()){
            for(Visits__c  vt :visitList){
                if(ps.Visit__c == vt.Id && ps.Close_Visit__c=='Yes' && ps.Fire_Extinguisher_Service_complete__c){
                    //assign  Visit Complete Field
                     vt.Visit_Complete__c =true;
                     vt.Visit_Completed__c=system.now();
               }
           }
        }
        try{
            update visitList;    //update the Visits
        }Catch(Exception e){
            String msg=e.getMessage();
            for(Project_Sheet__c ps:newProMap.values()){
                ps.addError(msg);
            }
        }
    
    }
    
/*====================================================
*Method Name     : UpdatePurchaseOrderNumber
*Description     : Update the Purchase Order Number Field.
*Arguments       : new Project Sheet list
====================================================*/        
    Private void UpdatePurchaseOrderNumber(Map<id,Project_Sheet__c> newProMap,Map<id,Project_Sheet__c> oldProMap){
        //Variable Declaration
        List<id> psIds=new List<id>();
        for( Project_Sheet__c ps:newProMap.values()){
            if(oldProMap.get(ps.id).Order_No__c!=ps.Order_No__c)
                psIds.add(ps.Id);
        }
        //to get a list of Opportunity
        List<Opportunity> oppList=[select id,Purchase_order_number2__c,Project_Sheet__c from Opportunity
                                            where Project_Sheet__c IN:psIds ];
        for(Opportunity opp :oppList){
            //assign Purchase Order Number Field
            if(opp.Project_Sheet__c!=NULL){
                opp.Purchase_order_number2__c =newProMap.get(opp.Project_Sheet__c).Order_No__c;
            }
        }
        update oppList;    //update the Opportunity
    }  
    
    /*====================================================
*Method Name     : UpdateVisitOppLayout
*Description     : Update the Actual GP Margin, Actual Total Cost, Project Manager Fields.
*Arguments       : new Project Sheet list
====================================================*/        
    Private void UpdateVisitOppLayout(Map<id,Project_Sheet__c> newProMap,Map<id,Project_Sheet__c> oldProMap){
        //Variable Declaration
        List<id> psIds=new List<id>();
        Map<id,Project_Sheet__c> NewPSMap = new Map<id,Project_Sheet__c>([select id,Visit__r.Actual_GP_Margin__c,
                                                                                       Visit__r.Actual_Cost__c, Visit__r.Project_Manager__c
                                                                                        from Project_Sheet__c
                                                                                        where id=:newProMap.keyset()]);
        for( Project_Sheet__c ps:NewPSMap.values()){
            
                psIds.add(ps.Id);
        }
        //to get a list of Opportunity
        List<Opportunity> oppList=[select id,Actual_GP_Margin__c,Actual_Total_Cost__c,Project_Manager__c,Project_Sheet__c from Opportunity
                                            where Project_Sheet__c IN:psIds ];
        for(Opportunity opp :oppList){
            //assign Purchase Order Number Field
            if(opp.Project_Sheet__c!=NULL){
                opp.Actual_GP_Margin__c =NewPSMap.get(opp.Project_Sheet__c).Visit__r.Actual_GP_Margin__c;
                opp.Actual_Total_Cost__c =NewPSMap.get(opp.Project_Sheet__c).Visit__r.Actual_Cost__c;
                opp.Project_Manager__c =NewPSMap.get(opp.Project_Sheet__c).Visit__r.Project_Manager__c;
            }
        }
        update oppList;    //update the Opportunity
    }  
}