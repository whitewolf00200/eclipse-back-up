/*============================================================================================================
*Class Name     : VisitTriggerHandler
*Description    : All the implementations related to Visit Object's Triggers should be handled here
*Company        : Merfantz Technologies Pvt. Ltd
*Date           : 12th Feb, 2021
*Version        : 2.0
*Change History : Initial Trigger Handler
                : changes date 04-03-2023 (#107229)
*Methods        : public void OnAfterUpdate(Map<id,Visits__c> VisitsNewMap)
                  Public void OnBeforeUpdate()
                  Private void updateOrderValue(List<Visits__c> newList)
                  Private void UpdateReactiveSheetNumber(List<Visits__c> newVList)
                  public void updatePreviousVisit(Set<Id> newVisitIds)
                  updateNotesFromPreviousService(Set<Id> newVisitIds)
                  
*============================================================================================================*/

public class VisitTriggerHandler{

    
    public void OnAfterUpdate(Map<id,Visits__c> VisitsNewMap,Map<id,Visits__c> VisitsoldMap){
        if(RecursiveHandler.runOnce1()){
            //Call UpdatePriceListdate Class
            updateOrderValue(VisitsNewMap.values()); 
            UpdateAssetDueDate(VisitsNewMap,VisitsoldMap);
            //updateContactName(VisitsNewMap.Values());
             //if(!Test.IsRunningTest())
             updatePreviousVisit(VisitsNewMap.keySet());
             updateNotesFromPreviousService(VisitsNewMap.keySet());

            
        } 
              
    
        if(RecursiveHandler.runVT_UOPPOnce()){
            updateOpportunity(VisitsNewMap);
            OpportynityCreatedAfterInsert(VisitsNewMap,VisitsoldMap);
            
        }
        
        UpdateFieldsInVisitandServiceSheet(VisitsNewMap,VisitsoldMap);
        
        
    }
    
    public void OnAfterInsert(Map<id,Visits__c> VisitsNewMap,Map<id,Visits__c> VisitsoldMap){
       
       
        InsertAssetDueDate(VisitsNewMap,VisitsoldMap);
        updatePreviousVisit(VisitsNewMap.keySet());
        updateNotesFromPreviousService(VisitsNewMap.keySet());
       
    }
    
    public void InsertAssetDueDate(Map<id,Visits__c> VisitsNewMap,Map<id,Visits__c> VisitsoldMap){
         List<String> assid=new List<String>();
         for(Visits__c vi:VisitsNewMap.values()){
              if( vi.Asset__c!=null && vi.Actual_Service_Date__c!=null && vi.Booked_with_Customers__c=='Yes' && vi.Visit_Type__c=='Service'){
                   assid.add(vi.Asset__c);
              }
         }
         
         if(assid.size()>0){
            List<Asset> AssetList=[select id,Booked_Date__c,Date_Of_Manufacture__c from Asset where ID IN:assid];         
            for(Visits__c vis:VisitsNewMap.values()){
               for(Asset ass:AssetList){
                  ass.Booked_Date__c =vis.Actual_Service_Date__c;
               }  
             }
            if(AssetList.size()>0){
               update AssetList;
            } 
            
         }
        
    }
    
     public void UpdateAssetDueDate(Map<id,Visits__c> VisitsNewMap,Map<id,Visits__c> VisitsoldMap){
         List<String> assid=new List<String>();
         for(Visits__c vi:VisitsNewMap.values()){
              if( (vi.Asset__c!=null && vi.Actual_Service_Date__c!=null && vi.Booked_with_Customers__c=='Yes' && vi.Visit_Type__c=='Service' && VisitsoldMap.get(vi.id).Actual_Service_Date__c!=vi.Actual_Service_Date__c ) ||
                  (vi.Asset__c!=null && vi.Actual_Service_Date__c!=null && vi.Booked_with_Customers__c=='Yes' &&  vi.Visit_Type__c=='Service' && VisitsoldMap.get(vi.id).Booked_with_Customers__c!=vi.Booked_with_Customers__c)
                 ){
                   assid.add(vi.Asset__c);
              }
         }
         
         if(assid.size()>0){
            List<Asset> AssetList=[select id,Booked_Date__c from Asset where ID IN:assid];
            for(Visits__c vis:VisitsNewMap.values()){
               for(Asset ass:AssetList){
                  ass.Booked_Date__c =vis.Actual_Service_Date__c;
               }
            }
            if(AssetList.size()>0){
               update AssetList;
            } 
            
         }
        
    }
    
    public void OnBeforeInsert(List<Visits__c> VisitsNewMap){  
     
       system.debug('VisitsNewMap=='+VisitsNewMap);
        UpdateNextVisitEndDate(VisitsNewMap);
        updateContactName(VisitsNewMap);
        updatebookedwithcustmerBeforeinsert(VisitsNewMap);
        updateVisitFields(VisitsNewMap);
        UpdateManufacturedate(VisitsNewMap);

                       
    }
    
    Public void OnBeforeUpdate(Map<id,Visits__c> VisitsNewMap,Map<id,Visits__c> VisitsOldMap){
        If(Limits.getQueries() >50 && Test.isRunningTest())
            return;
        if(RecursiveHandler.runonce()){
            this.UpdateReactiveSheetNumber(VisitsNewMap); 
            
              
        }
        if(RecursiveHandler.runVT_USSNOnce()){
            UpdateServiceSheetNumber(VisitsNewMap,VisitsOldMap);        //Update the latest Service Sheet number
            
        }
     
        updateContactName(VisitsNewMap.Values());
        updatebookedwithcust(VisitsNewMap,VisitsOldMap);
    }
    
    public void updateContactName(List<Visits__c> VisitsNewMap){
        List<Id> visitIds=new List<Id>();
        List<Visits__c> vlist=new List<Visits__c>();
        for(Visits__c visit :VisitsNewMap){
            visitIds.add(visit.id);
        }  
        try{      
            list<Visits__c> visitsval = new list<Visits__c>([select id,Site_Contract__r.Contact_Name__c,Customer_Contact__c from Visits__c where id IN:visitIds]);
            
        for(Visits__c visit1:visitsval){
            for(Visits__c visit :VisitsNewMap){
                if(visit.id==visit1.id){                              
                    visit.Contact_2__c=visit1.Site_Contract__r.Contact_Name__c;
                    //update visit;
                    system.debug('VisitsNewMap==>'+VisitsNewMap);
                    vlist.add(visit);
                }
            }     
        }    
        system.debug('VisitsNewMap==>'+VisitsNewMap);
        //update vlist;
        }catch(Exception e){}
    }

 /*====================================================
*Method Name     : updateOpportunity
*Description     : Update the Opportunity Filed.
*Arguments       : new Visits list
====================================================*/        
    Private void updateOpportunity(Map<id,Visits__c> VisitsNewMap){
        //Variable Declaration
        List<id> visitIds=new List<id>();
        for(Visits__c v:VisitsNewMap.values()){
            visitIds.add(v.Id);
        }
        //to get a list of Mechanical Service Sheet 
        List<SFDC_Purchase_Order__c> POList=[select id,Opportunity__c,Visit__c from SFDC_Purchase_Order__c where visit__c IN:visitIds];
        for(SFDC_Purchase_Order__c po :POList){
            //assign Visit service Type Field to Mechanical Service sheet System Type Field
            po.Opportunity__c=VisitsNewMap.get(po.visit__c).Opportunity__c;
        }
        if(POList.size()>0){
            update POList; }   //update the Mechanical service Sheet
    }   
    
    
    
    
    /*Method Name    : UpdateNextVisitEndDate
    //Description    : Fetch the amount from Sales opportunity and Update the order value in the visit record 
    //Arguments      : newVList- Receiving all the Visit records which triggers this trigger.
    */
    Private void updateOrderValue(List<Visits__c> newList){
        string VisitId;
        for(Visits__c v : newList){
            VisitId = v.id;
        }        
        Visits__c VisitRecord =  [SELECT Id,Sales_Opportunity__c,Order_Value__c FROM Visits__c where id =:VisitId limit 1];    
        if(VisitRecord.Sales_Opportunity__c != NULL){
            Decimal amount =  [SELECT Amount FROM Opportunity WHERE Id = :VisitRecord.Sales_Opportunity__c limit 1].amount;
            VisitRecord.Order_Value__c = amount;
            update VisitRecord;        
        }
    }    
    

 
    /*Method Name    : UpdateReactiveSheetNumber
    //Description    : This method is to update the Reactive sheet number on the Visit record with the latest Reactive sheet number
    //Arguments      : newVList- Receiving all the Visit records which triggers this trigger.
    */
    Private void UpdateReactiveSheetNumber(Map<id,Visits__c> visitsNewMap){       
        Map<Id, DateTime> RAVisitMap=new Map<Id, DateTime>();
        Map<DateTime, Service_Sheet_STD__c> RADateMap=new Map<DateTime, Service_Sheet_STD__c>();
     List<AggregateResult> aggList = New List<AggregateResult> ([SELECT Visit__r.Id,MAX(CreatedDate)
                                 FROM Service_Sheet_STD__c
                                 WHERE visit__c IN:visitsNewMap.keyset()
                                 GROUP BY Visit__r.Id]);
system.debug('aggList>>>>>'+aggList);
       
        for(AggregateResult ar:aggList){                                 
            RAVisitMap.put(ar.Id,(DateTime)ar.get('expr0'));
        }
        
        list<Service_Sheet_STD__c> Mrsheets =new list<Service_Sheet_STD__c>([SELECT id,Name,CreatedDate
                                 FROM Service_Sheet_STD__c
                                 WHERE visit__c IN:visitsnewMap.keyset()]);
        system.debug('Mrsheets>>>>>>>'+Mrsheets);
        for(Service_Sheet_STD__c RAS: Mrsheets ){
            RADateMap.put(RAS.CreatedDate,RAS);                                     
          //  RADateMapid.put(RAS.CreatedDate,RAS.id);                      
            system.debug('Mapss===='+RADateMap);                            
        }
        system.debug('Mapss===='+RADateMap+'====='+RAVisitMap);
        for(Visits__c visit:visitsNewMap.values()){
            if(RAVisitMap.containsKey(visit.id)){
            visit.Reactive_Sheet_Number__c = RADateMap.get(RAVisitMap.get(visit.id)).Name; 
            visit.M_R_Sheet_Id__c =  RADateMap.get(RAVisitMap.get(visit.id)).id; 
            //Change the reactive sheet number with the calculated value            
            }
        }
    }
    
    /*Method Name    : UpdateServiceSheetNumber
    //Description    : This method is to update the Service sheet number on the Visit record with the latest Service sheet number
    //Arguments      : newVList- Receiving all the Visit records which triggers this trigger.
    */
    Private void UpdateServiceSheetNumber(Map<id,Visits__c> visitsNewMap,Map<id,Visits__c> visitsOldMap){       
        Map<Id, DateTime> SSVisitMap=new Map<Id, DateTime>();
        Map<DateTime, Engineer_Checklist__c> SSDateMap=new Map<DateTime, Engineer_Checklist__c>();
        system.debug('keyset==>>'+visitsNewMap.keyset());
         List<AggregateResult> aggList = New List<AggregateResult>([SELECT Visit__r.Id,MAX(CreatedDate)
                                FROM Engineer_Checklist__c
                                WHERE visit__c IN:visitsNewMap.keyset()
                                GROUP BY Visit__r.Id]);
      
        for(AggregateResult ar:aggList){                                 
                                    SSVisitMap.put(ar.Id,(DateTime)ar.get('expr0'));
                                }
        system.debug('SSVisitMap==>>'+SSVisitMap);
        list<Engineer_Checklist__c> servicesheets = new list<Engineer_Checklist__c>([SELECT id,Name,CreatedDate
                                      FROM Engineer_Checklist__c
                                      WHERE visit__c IN:visitsnewMap.keyset()]);
        
        for(Engineer_Checklist__c SS:servicesheets){
                                          SSDateMap.put(SS.CreatedDate,SS);
                                      }
        system.debug('Mapss===='+SSDateMap+'====='+SSVisitMap);
        for(Visits__c visit:visitsNewMap.values()){
            if(visit.Service_Sheet_Number__c==visitsOldMap.get(visit.id).Service_Sheet_Number__c)//To check whether the service sheet number is being updated by any other call
            {
                if(SSVisitMap.containsKey(visit.id)){
                    system.debug('SSDateMap.get(SSVisitMap.get(visit.id)).Name'+SSDateMap.get(SSVisitMap.get(visit.id)).Name);
                    visit.Service_Sheet_Number__c=SSDateMap.get(SSVisitMap.get(visit.id)).Name;
                    visit.Service_Sheet_id__c=SSDateMap.get(SSVisitMap.get(visit.id)).Id;
                }
            }
            
        }  
    }
    
    /*Method Name    : UpdateNextVisitEndDate
    //Description    : This method is to update End date for the next visit based on the previous visit
    //Arguments      : newVList- Receiving all the Visit records which triggers this trigger.
    */
    Private void UpdateNextVisitEndDate(List<Visits__c> newVisitList){       
        Map<Id, DateTime> SSVisitMap=new Map<Id, DateTime>();
        list<id> previousVisitIds=new List<id>();  
        list<id> dateIds=new List<id>();        
        for(Visits__c v:newVisitList){
            if(v.Previous_Visit__c!= NULL){
                previousVisitIds.add(v.Previous_Visit__c);
                dateIds.add(v.Date__c);
            }    
        }
        system.debug('previousVisitIds==='+previousVisitIds);
        Map<id, Visits__c> previousVisitMap=new Map<Id, Visits__c>([SELECT id, Actual_Service_Date__c,End_Date__c,Number_of_Days_on_this_Service__c
                                                                FROM Visits__c 
                                                                WHERE id IN: previousVisitIds AND Number_of_Days_on_this_Service__c!=NULL]);                                                             
        system.debug('previousVisitMap==='+previousVisitMap);
        Map<id, Date__c> dateMap=new Map<id, Date__c>([SELECT Date_Field__c
                                                       FROM Date__c 
                                                       WHERE id IN:dateids]);
       
        for(Visits__c visit:newVisitList){
        system.debug('visit==='+visit.Previous_Visit__c +'===='+visit.Date__c);
            if(visit.Previous_Visit__c !=NULL && visit.Date__c!=NULL){
                //calculate the end date based on the number of days spent onsite during the previous visit
                
                if(previousVisitMap.containsKey(visit.Previous_Visit__c ))
                {
                    visit.End_Date__c=(dateMap.get(visit.Date__c).Date_Field__c).addDays(Integer.valueOf(previousVisitMap.get(visit.Previous_Visit__c ).Number_of_Days_on_this_Service__c));                                      
                    system.debug('visit.End_Date__c==='+visit.End_Date__c);
                }
            }                           
        }        
    }
    
 
/*===========================================================
*Method Name     :UpdateFieldsInVisitandServiceSheet
*Description     :Update Fields in Visit  and Service sheet
*Arguments       :
==============================================================*/
Public void UpdateFieldsInVisitandServiceSheet(Map<id,Visits__c> VisitsNewMap,Map<id,Visits__c> VisitsoldMap){
    
    
    if(VisitsNewMap.values() != VisitsoldMap.values()){
        for(Visits__c v : VisitsNewMap.values()){
            if(v.Engineer2__c != VisitsoldMap.get(v.id).Engineer2__c){
                UpdateTechnicianInSS(string.valueof(v.name),string.valueof(v.Engineer2__c));
                    
            }
            
            if(v.End_Date_Time__c != VisitsoldMap.get(v.id).End_Date_Time__c){
                system.debug('v.End_Date_Time__c>>>'+v.End_Date_Time__c);
           
                UpdateEndDateTimeInSS(string.valueof(v.name),string.valueof(v.End_Date_Time__c));
                 system.debug('v.End_Date_Time__c>>>'+v.End_Date_Time__c);
           
            }
            
          
            
        }
    }
    
}

/*====================================================================================================================================
* Method Name   :   UpdateEndDateTimeInSS
* Description   :   This method updates the End_Date_Time__c in visit to End_Date_and_Time__c in Service Sheet
*
====================================================================================================================================*/
Public void UpdateEndDateTimeInSS(string visitno,String visitdatetime){
    List<Engineer_Checklist__c> ss = [select id, End_Date_and_Time__c from Engineer_Checklist__c where Visit__r.name =: visitno and Fire_Extinguisher_Service_complete__c = false];
        for(Engineer_Checklist__c e : ss){
            if(visitdatetime == null){
                e.End_Date_and_Time__c = null;
                system.debug('e.End_Date_and_Time__c>>>'+e.End_Date_and_Time__c);
                update e;
            }
            else
            {
                e.End_Date_and_Time__c = datetime.valueof(visitdatetime);
                system.debug('e.End_Date_and_Time__c>>>'+e.End_Date_and_Time__c);
                update e;
            }
            
        }
    
}

/*====================================================================================================================================
* Method Name   :   UpdateTechnicianInSS
* Description   :   This method updates the Technician in visit to Technician in Service Sheet
*
====================================================================================================================================*/
Public void UpdateTechnicianInSS(string visitno, string VisitTechnicianName){
    system.debug('visitno>>>'+visitno);
    List<Engineer_Checklist__c> ss = [select id, Engineer__c from Engineer_Checklist__c where Visit__r.name =: visitno and Fire_Extinguisher_Service_complete__c = false];
        for(Engineer_Checklist__c e : ss){
            e.Engineer__c = VisitTechnicianName;
            system.debug('e.Engineer__c>>>'+e.Engineer__c);
            update e;
        }
}

/*====================================================================================================================================
* Method Name   :   updatebookedwithcust
* Description   :   This method updates the bookedwithcustomer in visit
*
====================================================================================================================================*/
Public void updatebookedwithcust(Map<id,Visits__c> VisitsNewMap, Map<id,Visits__c> VisitsoldMap){
    if(VisitsNewMap.values() != VisitsoldMap.values()){
        for(Visits__c v : VisitsNewMap.values()){
            if(v.Engineer2__c != VisitsoldMap.get(v.id).Engineer2__c){
                if(v.Engineer2__c != null){
                    v.Booked_with_Customers__c = 'Yes';
                }
                else
                {
                    v.Booked_with_Customers__c = null;
                }
                    
            }        
         }    
     }    
}

/*====================================================================================================================================
* Method Name   :   updatebookedwithcustmerBeforeinsert
* Description   :   This method updates the bookedwithcustomer for new visit 
*
====================================================================================================================================*/
Public void updatebookedwithcustmerBeforeinsert(List<Visits__c> VisitsNewMap){
    for(Visits__c v : VisitsNewMap){
            if(v.Engineer2__c != null){
                    v.Booked_with_Customers__c = 'Yes';
                }
            }        
}




/*====================================================================================================================================
* Method Name   :   OpportynityCreatedAfterInsert
* Description   :   ServiceSheet And Visit Automaticaly close and Opportunity Created
*
====================================================================================================================================*/


  Public void OpportynityCreatedAfterInsert(Map<id,Visits__c> VisitsNewMap,Map<id,Visits__c> VisitsOldMap){
    
    List<id> serviceIds=new List<id>();
   
        for(Visits__c vt:VisitsNewMap.values()){
            serviceIds.add(vt.id);
        }
        system.debug('completed>>>');
        Map<String,Engineer_Checklist__c> eachSS=new Map<String,Engineer_Checklist__c>();
        List<Engineer_Checklist__c> udss=new List<Engineer_Checklist__c>();
        List<Engineer_Checklist__c> ssht=new List<Engineer_Checklist__c>();
        ssht = [SELECT id,visit__c,Start_Date_and_Time__c,End_Date_and_Time__c,Fire_Extinguisher_Service_complete__c ,Close_Visit__c FROM Engineer_Checklist__c  where visit__c IN:serviceIds ];
        for(Engineer_Checklist__c ec:ssht){
            if(!eachSS.containskey(String.valueOf(ec.visit__c)))               
                eachSS.put(String.valueOf(ec.visit__c),ec);
        }
        if(ssht.size()>0)
        for(Visits__c vt:VisitsNewMap.values()){
           if(vt.Job_Status__c=='Completed' && VisitsOldMap.get(vt.id).Job_Status__c!='Completed' && eachSS.containskey(vt.id)){
                system.debug('completed111>>>');
                 eachSS.get(vt.id).Fire_Extinguisher_Service_complete__c=true;
                 eachSS.get(vt.id).Close_Visit__c='Yes';
                 eachSS.get(vt.id).Start_Date_and_Time__c=(eachSS.get(vt.id).Start_Date_and_Time__c==null?System.now():eachSS.get(vt.id).Start_Date_and_Time__c);
                 eachSS.get(vt.id).End_Date_and_Time__c=(eachSS.get(vt.id).End_Date_and_Time__c==null?System.now().addhours(1):eachSS.get(vt.id).End_Date_and_Time__c);
               udss.add(eachSS.get(vt.id));
           }
        }
        try{
        if(udss.size()>0)
            update udss;   
        }
        catch(exception e){
           for(Visits__c vt:VisitsNewMap.values()){
               vt.addError(e.getMessage());
           }
        }
    
    }
    
    
public void updateVisitFields(List<Visits__c> VisitsNewMap){ 
      for(Visits__c vis:VisitsNewMap){
          vis.Original_Actual_Service_Date__c=vis.Actual_Service_Date__c;
          vis.Overdue_Visit_Check_Date__c=vis.Actual_Service_Date__c;
      }
  } 
/*====================================================
*Method Name     : updateNotesFromPreviousService
*Description     : Update the Notes from Previous Service field in new visit insert/update time from previous visit latest service sheet's Notes for next service
*Arguments       : Set<Id> newVisitIds
*Ticket No       : 53499
====================================================*/     
  public void updateNotesFromPreviousService(Set<Id> newVisitIds){
      Map<Id,Visits__c> currentVisistsWithPrev=new Map<Id,Visits__c>();
      Set<Id> previousVisitId=new Set<Id>();
      Map<Id,Engineer_Checklist__c > visitServiceMap=new Map<Id,Engineer_Checklist__c >();
      List<Engineer_Checklist__c> listService=new List<Engineer_Checklist__c>();
      
      if(newVisitIds.size()>0){
          list <Visits__c> previousvisits =new list<Visits__c>([Select Id,name,Previous_Visit__c,Notes_from_Previous_Service__c from Visits__c where Previous_Visit__c!=null and id=:newVisitIds]);
          for(Visits__c visit:previousvisits){
               currentVisistsWithPrev.put(visit.Previous_Visit__c,visit);
               previousVisitId.add(visit.Previous_Visit__c);    
          }
      }
      system.debug(previousVisitId);
      if(previousVisitId.size()>0){
        listService=[Select id,name,Notes_for_next_service__c,Visit__c,createddate from Engineer_Checklist__c where Visit__c=:previousVisitId order by createddate desc limit 1];
        
      }
       system.debug(listService);
      
      if(listService.size()>0){
          for(Engineer_Checklist__c service:listService){
           visitServiceMap.put(service.Visit__c,service);
        }
      }
      system.debug('visitServiceMap>>>>>>'+visitServiceMap);
      
      if(visitServiceMap.size()>0){
         for(Engineer_Checklist__c  serv:visitServiceMap.values()){
           if(currentVisistsWithPrev.containsKey(serv.Visit__c)){
              system.debug('if block');
              currentVisistsWithPrev.get(serv.Visit__c).Notes_from_Previous_Service__c=serv.Notes_for_next_service__c;
              system.debug(currentVisistsWithPrev.get(serv.Visit__c).Notes_from_Previous_Service__c);
           }
         }
      }
      system.debug(currentVisistsWithPrev.size());

      
      if(currentVisistsWithPrev.size()>0){
        try{
           update currentVisistsWithPrev.values();
           system.debug(currentVisistsWithPrev.values());
        }
        catch(Exception e){
          System.debug(e.getMessage());
        }
      }
  }
  
/*====================================================
*Method Name     : updatePreviousVisit
*Description     : Update Previous Visit
*Arguments       : Set<Id> newVisitIds
*Ticket No       : 53499
====================================================*/       
  public void updatePreviousVisit(Set<Id> newVisitIds){
     Map<Id,Visits__c> currentVisitMap=new Map<Id,Visits__c>();
     Map<Id,List<Visits__c>> siteContractWithPrevVisit=new Map<Id,List<Visits__c>>();
     list<Visits__c> previsits = new list<Visits__c>([Select id,name,Site_Contract__c,Previous_Visit__c,Visit_Type__c,Asset__c  from Visits__c where id=:newVisitIds and previous_visit__c=null and Visit_Type__c='Service']);
     for(Visits__c vis: previsits){
         currentVisitMap.put(vis.Site_Contract__c,vis);
     }
     system.debug('previsits>>>>>>>'+previsits);
     if(currentVisitMap.size()>0){
         system.debug(currentVisitMap);
         list<Visits__c> visits = new list<Visits__c>([Select id,name,Site_Contract__c,Visit_Type__c,Asset__c from Visits__c  where Site_Contract__c=:currentVisitMap.keySet() and id!=:newVisitIds and Visit_Type__c='Service' order by createddate desc]);
         system.debug('visits>>>>>>>>>>>'+visits);
         for(Visits__c vis: visits){
            if(!siteContractWithPrevVisit.containsKey(vis.Site_Contract__c)){               
               
               siteContractWithPrevVisit.put(vis.Site_Contract__c,new List<Visits__c>{vis});
            }
            else{
               siteContractWithPrevVisit.get(vis.Site_Contract__c).add(vis);
            }
            
         }
     }
     if(siteContractWithPrevVisit.size()>0){
        system.debug(siteContractWithPrevVisit);
        for(id i:siteContractWithPrevVisit.keyset()){
           for(Visits__c vis:siteContractWithPrevVisit.get(i)){
              if(currentVisitMap.containsKey(vis.Site_Contract__c)){
                 if(currentVisitMap.get(vis.Site_Contract__c).Asset__c==vis.Asset__c){
                       currentVisitMap.get(vis.Site_Contract__c).Previous_Visit__c =vis.id;
                       break;
                 }
              }
           }
        }
     }
     
     try{
       if(currentVisitMap.size()>0)
       update currentVisitMap.values();
     }
     catch(Exception e){
        System.debug(e.getMessage());
     }
  }
  
  
  
   public void UpdateManufacturedate(List<Visits__c> VisitsNewMap){

    Set<String> assid = new Set<String>();
    List<Visits__c> visi = new List<Visits__c>();
    
    for(Visits__c vi : VisitsNewMap){
        assid.add(vi.Asset__c);
    }
    
    if(assid.size() > 0){
        Map<String, Asset> assetMap = new Map<String, Asset>([
            SELECT Id, Booked_Date__c, Date_Of_Manufacture__c 
            FROM Asset 
            WHERE Id IN :assid
        ]);
        
        for(Visits__c vis : VisitsNewMap){
            String assetId = vis.Asset__c;
            if(assetMap.containsKey(assetId)){
                Asset relatedAsset = assetMap.get(assetId);
                vis.Manufacture_Date__c = relatedAsset.Date_Of_Manufacture__c;
                
            }
        }
        
        
    }
}

  
  
  
  
  
  
  
  
  
  
  
  
  
  }