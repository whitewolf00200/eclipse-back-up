/*============================================================================================================
*Class Name     : MSS_ServSheetTriggerHandler
*Description    : All the implementations related to MSS_ServSheet Triggers should be handled here
*Company        : Puthuvannam Technology Solutions
*Date           : 19th May, 2014
*Version        : 1.0
*Change History : Initial Trigger Handler
*Methods        : public void OnAfterUpdate(Map<Id,Mechanical_Service_Sheet__c> newMssMap,Map<Id,Mechanical_Service_Sheet__c> oldMssMap)
                  public void OnAfterInsert(Map<Id,Mechanical_Service_Sheet__c> newMssMap)
                  Private void UpdateVisitComplete(Map<Id,Mechanical_Service_Sheet__c> newMssMap)
                  Private void UpdateVisitMSSNumber(Map<Id,Mechanical_Service_Sheet__c> newMssMap)            
*============================================================================================================*/
public class MSS_ServSheetTriggerHandler{
    
   public void OnAfterUpdate(Map<Id,Mechanical_Service_Sheet__c> newMssMap,Map<Id,Mechanical_Service_Sheet__c> oldMssMap){
         if(RecursiveHandler.runMSSSSTH_UVCOnce()){ 
             this.UpdateVisitComplete(newMssMap);    //Updating the Visit Complete on the Visit.
             //this.UpdateVisitMSSNumber(newMssMap);    //Updating the Visit mechanical Service Number Filed on the Visit.
              
        }
        if(RecursiveHandler.runMSSTH_ULMSSDOnce() || (test.isRunningTest() && limits.getqueries()<90)){UpdateLastServiceSheetDetails(newMssMap);}
        if(RecursiveHandler.runMSSSSTH_UPONOnce()){ 
             this.UpdatePurchaseOrderNumber(newMssMap,oldMssMap);     // Update the Purchase Order Number Field on the Opportunity
        }
        if(RecursiveHandler.runMSSSSTH_UVOLTOnce()){ 
             this.UpdateVisitOppLayout(newMssMap,oldMssMap);     // Update the Actual GP Margin, Actual Total Cost, Project Manager Fields on the Opportunity
        }
    }
    public void OnAfterInsert(Map<Id,Mechanical_Service_Sheet__c> newMssMap){
        //if(RecursiveHandler.RunOnce()){
            this.UpdateVisitMSSNumber(newMssMap);    //Updating the Visit mechanical Service Number Filed on the Visit.
            this.UpdatePreviousServiceField(newMssMap);
       // }
    }
    
    public void OnBeforeUpdate(List<Mechanical_Service_Sheet__c> newMssList,List<Mechanical_Service_Sheet__c> oldMssList){
        if(RecursiveHandler.runMSSSSTH_USTOnce()){
            UpdateSystemType(newMssList);
        }
    }
    public void OnBeforeInsert(List<Mechanical_Service_Sheet__c> newMssList){
        UpdateSystemType(newMssList);
    }
    
/*====================================================
*Method Name     : UpdateSystemType
*Description     : Update the System Type Field.
*Arguments       : new Mechanical Service Sheet list
====================================================*/     
    
    Private void UpdateSystemType(List<Mechanical_Service_Sheet__c> newMssList){       
        list<id> visitIds=new List<id>();        
        for(Mechanical_Service_Sheet__c ms:newMssList){
           if(ms.Visit__c!= NULL)
                visitIds.add(ms.Visit__c);
        }
        Map<id, Visits__c> visitMap=new Map<Id, Visits__c>([SELECT id, Service_Type__c
                                                                FROM Visits__c
                                                                WHERE id IN: visitIds]);  
        for(Mechanical_Service_Sheet__c ms:newMssList){
                ms.System_type__c=visitMap.get(ms.Visit__c).Service_Type__c;
        }        
    }

/*====================================================
*Method Name     : UpdateVisitComplete
*Description     : Update the Visit Complete Field.
*Arguments       : new Mechanical Service Sheet list
====================================================*/   
    Private void UpdateVisitComplete(Map<Id,Mechanical_Service_Sheet__c> newMssMap){
        //Variable Declaration
        List<id> visitIds=new List<id>();

        //to get the List Of visit IDS
        for(Mechanical_Service_Sheet__c ms:newMssMap.values()){
            visitIds.add(ms.visit__c);
        }

        //to get a list of Visits 
        List<Visits__c> visitList=[select id,Visit_Complete__c from Visits__c where ID IN:visitIds ];
        for(Mechanical_Service_Sheet__c ms:newMssMap.values()){
            for(Visits__c  vt :visitList){
                if(ms.Visit__c == vt.Id && ms.Close_Visit__c=='Yes' && ms.Fire_Extinguisher_Service_complete__c ){
                    //assign  Visit Complete Field
                     vt.Visit_Complete__c =true;
                     vt.Actual_Service_Date__c=system.today();
               }
           }
        }
        update visitList;    //update the Visits
    
    }
/*====================================================
*Method Name     : UpdateVisitMSSNumber
*Description     : Update the Visit Service Sheet Number Field.
*Arguments       : new Mechanical Service Sheet list
====================================================*/      
    
    Private void UpdateVisitMSSNumber(Map<Id,Mechanical_Service_Sheet__c> newMssMap){
        //Variable Declaration
        List<id> visitIds=new List<id>();

        //to get the List Of visit IDS
        for(Mechanical_Service_Sheet__c ms:newMssMap.values()){
            visitIds.add(ms.visit__c);
        }

        //to get a list of Visits 
        
        List<Visits__c> visitList=[select id,Mechanical_Service_Sheet_Numbers__c,Service_Type__c from Visits__c where ID IN:visitIds ];
        List<Mechanical_Service_Sheet__c> mechList=new List<Mechanical_Service_Sheet__c>();
        
        system.debug('======='+visitList);
        for(Mechanical_Service_Sheet__c ms:newMssMap.values()){
            for(Visits__c  vt :visitList){
                if(ms.Visit__c == vt.Id  ){
                    //assign  Service Sheet Number Field
                     vt.Mechanical_Service_Sheet_Numbers__c=ms.Name;
                     //vt.Service_Type__c=ms.System_Type__c;
                     System.debug('======='+vt.Service_Sheet_Number__c);
               }
           }
        }
        
        update visitList;    //update the Visits
        System.debug('======='+visitList);
    
    }

/*====================================================
*Method Name     : UpdatePreviousServiceField
*Description     : Update the Notes From Previous Service Field.
*Arguments       : new Service Sheet list
====================================================*/    
    PRIVATE VOID UpdatePreviousServiceField(map<id,Mechanical_Service_Sheet__c> NewMSSMap){
        //Variable Declaration
        List<id> visitIds=new List<id>();
        for(Mechanical_Service_Sheet__c ms:NewMSSMap.values()){
            visitIds.add(ms.visit__c);
        }
        System.debug('--------'+visitIds);
        //to get a list of Visits 
        List<Visits__c> visitList=[select id,Notes_from_Previous_Service__c from Visits__c where ID IN:visitIds ];
        
        System.debug('--------'+visitList);
        for(Mechanical_Service_Sheet__c ms:NewMSSMap.values()){
            for(Visits__c  vt :visitList){
                if(ms.Visit__c == vt.Id){
                    //assign  Previous Service Field
                     vt.Notes_from_Previous_Service__c=ms.Comments_to_service__c;
               }
           }
        }
        update visitList;    //update the Visits
    }
    
//Name           : UpdateLastMechanicalServiceSheetDetails
//Description    : Whenever the 'Dry Riser' Service sheet gets submitted, reset the Last Service Sheet Details-Mechanical in the Site Contract record.
//Arguments      :
//Date           : 23rd May, 2014
 

  PRIVATE VOID UpdateLastServiceSheetDetails(Map<id,Mechanical_Service_Sheet__c> NewMSSMap){        
        List<id> visitIds=new List<id>();
        for(Mechanical_Service_Sheet__c ms:NewMSSMap.values()){
            visitIds.add(ms.visit__c);
        }
   String recordRiserId =[select id,name from RecordType
                 where SObjectType='Mechanical_Service_Sheet__c' 
                 AND name='Riser Service Sheet'].id;
   String recordSprinklerId =[select id,name from RecordType
                 where SObjectType='Mechanical_Service_Sheet__c' 
                 AND name='Sprinkler Service Sheet'].id;
    Map<id, Visits__c> visitMap=new Map<id, Visits__c>([SELECT id, Visit_Type__c from Visits__c where id IN:visitIds]);
        system.debug('Coming To visit print==='+visitMap);
        List<id> MRsiteContractIds=new List<Id>();
        List<id> MSsiteContractIds=new List<Id>();
        Map<id, Mechanical_Service_Sheet__c> MRMSSMap=new Map<Id, Mechanical_Service_Sheet__c>();
        Map<id, Mechanical_Service_Sheet__c> MSMSSMap=new Map<Id, Mechanical_Service_Sheet__c>(); 

    for(Mechanical_Service_Sheet__c ms:NewMSSMap.values()){

            if(visitMap.get(ms.Visit__c).Visit_Type__c=='Service' && ms.RecordTypeId==recordRiserId && ms.Fire_Extinguisher_Service_complete__c){                
                MRsiteContractIds.add(ms.Site_Contract__c);
                MRMSSMap.put(ms.id, ms);
 
            }else if(visitMap.get(ms.Visit__c).Visit_Type__c=='Service' && ms.RecordTypeID==recordSprinklerId  && ms.Fire_Extinguisher_Service_complete__c){
                MSsiteContractIds.add(ms.Site_Contract__c);
                MSMSSMap.put(ms.id, ms);
            }
        }
     Map<id,SiteContracts__c> MRSCMap=new Map<id, SiteContracts__c>([SELECT id,Service_Type__c FROM SiteContracts__c
                          WHERE Id IN: MRsiteContractIds]);
    Map<id,SiteContracts__c> MSSCMap=new Map<id, SiteContracts__c>([SELECT id, Change_Over_Done__c FROM SiteContracts__c
                          WHERE Id IN: MSsiteContractIds]);
    system.debug('Coming after the signal point 1===');
                  
        if(!MRSCMap.isEmpty()){            
            system.debug('Coming after the signal Point 2===');
            UPDATE UpdateMRSheetDetails(MRSCMap,MRMSSMap);    
        }

        if(!MSSCMap.isEmpty()){            
            UPDATE UpdateMSSheetDetails(MSSCMap,MSMSSMap);    
        }
    }
    
    //Name           : UpdateFESheetDetails
    //Description    : Set default value from the custom setting for the Site Contract's Last Service Sheet Details
    //Arguments      :
    //Date           : 23rd May, 2014
    Private SiteContracts__c[] UpdateMRSheetDetails(Map<id,SiteContracts__c> siteContractsMap,Map<id,Mechanical_Service_Sheet__c> NewMSSMap){ 
        Map<id,SiteContracts__c> scsNeedUpdate=new Map<id,SiteContracts__c>();
        SiteContracts__c siteContract;
        for(Mechanical_Service_Sheet__c mss:NewMSSMap.values()){
            siteContract=siteContractsMap.get(mss.Site_Contract__c);
            siteContract.Service_Type__c =mss.Service_Type__c ;
            if(!scsNeedUpdate.containsKey(siteContract.id)){    //Avoiding Duplicates
                scsNeedUpdate.put(siteContract.id, siteContract);                                  
            }
        }   
        system.debug('Coming after the signal Point 3===');     
        return scsNeedUpdate.values();
    }
    
    //Name           : UpdateFAESheetDetails
    //Description    : Set default value from the custom setting for the Site Contract's Last Service Sheet Details
    //Arguments      :
    //Date           : 23rd May, 2014
    Private SiteContracts__c[] UpdateMSSheetDetails(Map<id,SiteContracts__c> siteContractsMap,Map<id,Mechanical_Service_Sheet__c> NewMSSMap){ 
        Map<id,SiteContracts__c> scsNeedUpdate=new Map<id,SiteContracts__c>();
        SiteContracts__c siteContract;
        for(Mechanical_Service_Sheet__c mss:NewMSSMap.values()){
            siteContract=siteContractsMap.get(mss.Site_Contract__c);
            siteContract.Change_Over_Done__c =mss.Change_Over_Done__c ;
            if(!scsNeedUpdate.containsKey(siteContract.id)){    //Avoiding Duplicates
                scsNeedUpdate.put(siteContract.id, siteContract);                                  
            }
        }        
        return scsNeedUpdate.values();
             
    }
    
/*====================================================
*Method Name     : UpdatePurchaseOrderNumber
*Description     : Update the Purchase Order Number Field.
*Arguments       : new Mechanical Service Sheet list
====================================================*/        
    Private void UpdatePurchaseOrderNumber(Map<id,Mechanical_Service_Sheet__c> NewMSSMap,Map<id,Mechanical_Service_Sheet__c> oldMSSMap){
        //Variable Declaration
        List<id> mssIds=new List<id>();
        for(Mechanical_Service_Sheet__c ms:NewMSSMap.values()){
            if(oldMSSMap.get(ms.id).Order_No__c!=ms.Order_No__c)
                mssIds.add(ms.Id);
        }
        //to get a list of Opportunity
        List<Opportunity> oppList=[select id,Purchase_order_number2__c,Mechanical_Service_Sheet__c from Opportunity
                                            where Mechanical_Service_Sheet__c IN:mssIds ];
        for(Opportunity opp :oppList){
            //assign Purchase Order Number Field
            if(opp.Mechanical_Service_Sheet__c!=NULL){
                opp.Purchase_order_number2__c =NewMSSMap.get(opp.Mechanical_Service_Sheet__c).Order_No__c;
            }
        }
        update oppList;    //update the Opportunity
    }  
    
    /*====================================================
*Method Name     : UpdateVisitOppLayout
*Description     : Update the Actual GP Margin, Actual Total Cost, Project Manager Fields.
*Arguments       : new Mechanical Service Sheet list
====================================================*/        
    Private void UpdateVisitOppLayout(Map<id,Mechanical_Service_Sheet__c> NewMSSMap,Map<id,Mechanical_Service_Sheet__c> oldMSSMap){
        //Variable Declaration
        List<id> mssIds=new List<id>();
        Map<id,Mechanical_Service_Sheet__c> NewMSMap = new Map<id,Mechanical_Service_Sheet__c>([select id,Visit__r.Actual_GP_Margin__c,
                                                                                       Visit__r.Actual_Cost__c, Visit__r.Project_Manager__c
                                                                                        from Mechanical_Service_Sheet__c
                                                                                        where id=:NewMSSMap.keyset()]);
        for(Mechanical_Service_Sheet__c ms:NewMSMap.values()){
            
                mssIds.add(ms.Id);
        }
        //to get a list of Opportunity
        List<Opportunity> oppList=[select id,Actual_GP_Margin__c,Actual_Total_Cost__c,Project_Manager__c,Mechanical_Service_Sheet__c from Opportunity
                                            where Mechanical_Service_Sheet__c IN:mssIds ];
        for(Opportunity opp :oppList){
            //assign Purchase Order Number Field
            if(opp.Mechanical_Service_Sheet__c!=NULL){
                opp.Actual_GP_Margin__c =NewMSMap.get(opp.Mechanical_Service_Sheet__c).Visit__r.Actual_GP_Margin__c;
                opp.Actual_Total_Cost__c =NewMSMap.get(opp.Mechanical_Service_Sheet__c).Visit__r.Actual_Cost__c;
                opp.Project_Manager__c =NewMSMap.get(opp.Mechanical_Service_Sheet__c).Visit__r.Project_Manager__c;
            }
        }
        update oppList;    //update the Opportunity
    }  

    
}