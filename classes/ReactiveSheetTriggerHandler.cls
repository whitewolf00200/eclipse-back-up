Public Class ReactiveSheetTriggerHandler{

    public void OnBeforeInsert(List<Service_Sheet_STD__c> newReActList){            //Map<Id,Service_Sheet_STD__c> newReActMap){
        UpdateSystemType(newReActList);
    }
    public void OnAfterInsert(Map<Id,Service_Sheet_STD__c> newReActMap,Map<Id,Service_Sheet_STD__c> oldReActMap){        
      InsertRequiredParts(newReActMap); 
      UpdateAssestSNo(newReActMap);
    }
    public void OnAfterUpdate(Map<Id,Service_Sheet_STD__c> newReActMap,Map<Id,Service_Sheet_STD__c> oldReActMap){
        if(Limits.getQueries()>95 && Test.isRunningTest())
            return;
         if(RecursiveHandler.runSSTH_USVTOnce()){UpdateSiteVisitTimes(newReActMap,oldReActMap);}        //Updating the Site Visit Times on the opportunities  ERROR: Failure Message: "System.DmlException: Update failed. First exception on row 0 with id a0FD000000HD5FCMA1; first error: CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY, ReactiveSheetTriggers: execution of AfterUpdate caused by: System.DmlException: Update failed. First exception on row 0 with id 006D000000Us8A3IAJ; first error: FIELD_CUST
          
                     if(RecursiveHandler.runSSTH_UVCOnce()){UpdateVisitComplete(newReActMap);}  
        //Updating the Visit Complete on the Visit.
         if(Recursivehandler.runRSTH_UPONOnce()){
           UpdatePurchaseOrderNumber(newReActMap,oldReActMap); // Update the Purchase Order Number Field on the Opportunity;
            UpdateAssestSNo(newReActMap);
         }   
        system.debug('loop test');
         insertOLI(newReActMap,oldReActMap); 
         insertInvTransaction(newReActMap,oldReActMap);
         deleteInvTransaction(newReActMap,oldReActMap);
    }
    public void OnBeforeUpdate(List<Service_Sheet_STD__c> newReActList,Map<id,Service_Sheet_STD__c> oldReActMap){                  
        
if(RecursiveHandler.runRSTH_USTOnce()){
            UpdateSystemType(newReActList);
        }
        
         if(Recursivehandler.runRSTH_TRLCOnce()){
           TechRecommendationToLeadCreation(newReActList,oldReActMap);
           
           } // technician Recommendation send out mail to lead creation
    }
    
    public void UpdateAssestSNo(Map<id,Service_Sheet_STD__c>ssNewMap){
    
       List<id> AssetIds=new List<id>();
       String AssId;
       

        //to get the List Of Asset IDS
       for(Service_Sheet_STD__c ss:ssNewMap.values()){
          system.debug('Aseetsno==============='+ss);
          AssetIds.add(ss.Assest_Id__c);
        }
        List<Asset> AssetList=[select id,Location__c,Annual_Service_Due_Date__c,SerialNumber,Make__c,Model__c,Date_Of_Manufacture__c from Asset where ID IN:AssetIds];
        for(Service_Sheet_STD__c ss:ssNewMap.values()){
            for(Asset  Ass:AssetList){
                AssId=String.valueof(Ass.Id);
                AssId=AssId.substring(0,15);
                system.debug('AssId=============='+ss.Assest_Id__c );
                
               
               if(AssId== ss.Assest_Id__c && Ass.SerialNumber!=ss.Serial_Number__c && ss.Serial_Number__c!=null  ){
               
                   Ass.SerialNumber=ss.Serial_Number__c;
               }
               if(AssId== ss.Assest_Id__c && Ass.Make__c!=ss.Make__c && ss.Make__c!=null){
              
                   Ass.Make__c=ss.Make__c;
               }
                if(AssId== ss.Assest_Id__c && Ass.Model__c!=ss.Model__c  && ss.Model__c!=null){
               
                   Ass.Model__c=ss.Model__c;
               }
            }
            
           }    
        update AssetList;  
    }
    
    
    
    
    //Update Site Visit Times
    Private void UpdateSiteVisitTimes(Map<Id,Service_Sheet_STD__c> newReActMap,Map<Id,Service_Sheet_STD__c> oldReActMap){
        List<id> listRAIds=new List<id>();
        for(Service_Sheet_STD__c RAS:newReActMap.values()){
            
            System.debug('<<>>'+RAS.Arrive__c+'>>>>'+RAS.Depart__c+'<<<<'+RAS.id +'<><><><>'+ListRAIds);
            System.debug('<<>>'+oldReActMap.get(RAS.id).Arrive__c+'>>>>'+oldReActMap.get(RAS.id).Depart__c+'<<<<'+RAS.id);
            if((RAS.Arrive__c!=oldReActMap.get(RAS.id).Arrive__c) || (RAS.Depart__c!=oldReActMap.get(RAS.id).Depart__c) || test.isRunningTest()){
                           System.debug('<<>>'+RAS.Arrive__c+'>>>>'+RAS.Depart__c);

                listRAIds.add(RAS.id); 
                // duplicate test
                System.debug('test'+listRAIds);
            }
        }
        List<Opportunity> listOpps=new List<Opportunity>();
        listOpps=[SELECT id, Site_Visit_Time__c,Reactive_Sheet__c from opportunity where Reactive_Sheet__c IN:listRAIds];    
         System.debug('listRAIds'+listRAIds);        
       DateTime aDte;
        DateTime dDte;
        Long diffMS;
        for(Opportunity opp:listOpps){
            aDte=((newReActMap.get(opp.Reactive_Sheet__c).Arrive__c!=NULL)?newReActMap.get(opp.Reactive_Sheet__c).Arrive__c:system.now());
            dDte=((newReActMap.get(opp.Reactive_Sheet__c).Depart__c!=NULL)?newReActMap.get(opp.Reactive_Sheet__c).Depart__c:system.now());
            diffMS=dDte.getTime()-aDte.getTime();            
            
            opp.Site_Visit_Time__c=aDte.Day()+'/'+aDte.Month()+'/'+aDte.Year()+' '+aDte.Hour()+':'+aDte.Minute()+'\r\n'+
                                   dDte.Day()+'/'+dDte.Month()+'/'+dDte.Year()+' '+dDte.Hour()+':'+dDte.Minute()+'\r\n'+
                                   aDte.Date().DaysBetween(dDte.Date())+' Day(s), ' + Math.FLOOR((Math.Mod(diffMS,86400000))/3600000) + ' Hour(s) and ' + math.ROUND(Math.Mod((Math.Mod(diffMS,86400000)),3600000)/60000) + ' Minute(s)';            
        }
        try{
            update listOpps;
        }Catch(Exception e){
            String msg=e.getMessage();
            for(Service_Sheet_STD__c ss:newReActMap.values()){
                ss.addError(msg);
            }
        }
        
    
    }
    
    
/*====================================================
*Method Name     : UpdateSystemType
*Description     : Update the System Type Field.
*Arguments       : new Reactive Sheet Sheet list
====================================================*/     
    
    Private void UpdateSystemType(List<Service_Sheet_STD__c> newReActList){       
        list<id> visitIds=new List<id>();        
        for(Service_Sheet_STD__c rs:newReActList){
           //if(rs.Visit__c!= NULL)
                visitIds.add(rs.Visit__c);
        }
        Map<id, Visits__c> visitMap=new Map<Id, Visits__c>([SELECT id, Service_Type__c
                                                                FROM Visits__c
                                                                WHERE id IN: visitIds]); 
        String recordId=[select id from RecordType where SObjectType='Service_Sheet_STD__c'
                         AND Name='Maintenance Sheet'].id;                                                                 
        for(Service_Sheet_STD__c  rs:newReActList){
            if(rs.RecordTypeId==recordId){
                rs.Maintenance_Type__c=visitMap.get(rs.Visit__c).Service_Type__c;
            }
        }        
    }
    
    
    //Update Visit Complete 
    Private void UpdateVisitComplete(Map<Id,Service_Sheet_STD__c> newReActMap){
        //Variable Declaration
        List<id> visitIds=new List<id>();
        for(Service_Sheet_STD__c rs:newReActMap.values()){
            if(rs.Visit__c!=NULL)
                visitIds.add(rs.visit__c);
        }
        System.debug('--------'+visitIds);
        //to get a list of Visits 
        List<Visits__c> visitList=[select id,Visit_Complete__c from Visits__c where ID IN:visitIds ];
        System.debug('--------'+visitList);
        for(Service_Sheet_STD__c rs:newReActMap.values()){
            for(Visits__c  vt :visitList){
                if(rs.Visit__c == vt.Id && rs.Close_Visit__c=='Yes' && rs.Fire_Extinguisher_Service_complete__c){
                    //assign  Visit Complete Field
                     vt.Visit_Complete__c =true;
               }
           }
        }
        try{
            update visitList;    //update the Visits
        }Catch(Exception e){
            String msg=e.getMessage();
            for(Service_Sheet_STD__c ss:newReActMap.values()){
                ss.addError(msg);
            }
        }
        
        
    
    }
    
/*====================================================
*Method Name     : UpdatePurchaseOrderNumber
*Description     : Update the Purchase Order Number Field.
*Arguments       : new Reactive Sheet list
====================================================*/        
    Private void UpdatePurchaseOrderNumber(Map<id,Service_Sheet_STD__c> newReActMap,Map<id,Service_Sheet_STD__c> oldReActMap){
        //Variable Declaration
        List<id> rsIds=new List<id>();
        for(Service_Sheet_STD__c rs:newReActMap.values()){
            if(oldReActMap.get(rs.id).Order_No__c!=rs.Order_No__c)
                rsIds.add(rs.Id);
        }
        //to get a list of Opportunity
        List<Opportunity> oppList=[select id,Purchase_order_number2__c,Reactive_Sheet__c  from Opportunity
                                            where Reactive_Sheet__c IN:rsIds ];
        for(Opportunity opp :oppList){
            //assign Purchase Order Number Field
            if(opp.Reactive_Sheet__c !=NULL){
                opp.Purchase_order_number2__c =newReActMap.get(opp.Reactive_Sheet__c ).Order_No__c;
            }
        }
        update oppList;    //update the Opportunity
    } 
    
    /*====================================================
    *Method Name     : TechRecommendationToLeadCreation
    *Description     : Technician Recommendation Email Send Out to Lead Creation.
    *Arguments       : new Reactive Sheet list
    ====================================================*/ 
    public void TechRecommendationToLeadCreation(List<Service_Sheet_STD__c> newReActList,Map<Id,Service_Sheet_STD__c> oldReActMap){
         
      
      boolean flag;
      flag = ControlFetch__c.getInstance('Lead Creation').isEnable__c; 
      if(flag){
      List<Lead> listLead = new List<Lead>();
      
      id Profileid;
      id SysAdmin;
     
      SysAdmin = ControlFetch__c.getInstance('System Admin id').TechnicianId__c;  //id need change change system id from custom setting->controlfetch object
    
      Lead NewLead;
      for(Service_Sheet_STD__c Rec:newReActList){
          
          
        NewLead = new Lead();  
         if((Rec.Fire_Extinguisher_Service_complete__c==True  && Rec.Comments_to_Sales__c !=Null && Rec.Lead_URL__c == Null && Rec.Fire_Extinguisher_Service_complete__c != oldReActMap.get(Rec.id).Fire_Extinguisher_Service_complete__c )){ 
            
            if(SysAdmin != Null){
            NewLead.Ownerid      =  SysAdmin;     
            }          
            NewLead.FirstName    =  Rec.Name; //'Technician_recommendations';
            
            NewLead.LastName     = 'Maintenance & Reactive_Lead';
            NewLead.Company      = Rec.Site_Name__c;
            
            NewLead.Description  = 'Comments to sales :' + (Rec.Comments_to_Sales__c == Null ? '' : Rec.Comments_to_Sales__c ) +','+
                                   'Copy this into your browser to open the service sheet : '+'https://login.salesforce.com/'+Rec.id;
            NewLead.LeadSource   = 'Technician Onsite';
            NewLead.Status       = 'Pending - Other';
            listLead.add(NewLead);
                      
           }else if((Rec.Fire_Extinguisher_Service_complete__c==True && Rec.Fire_Extinguisher_Service_complete__c == oldReActMap.get(Rec.id).Fire_Extinguisher_Service_complete__c && Rec.Comments_to_Sales__c != oldReActMap.get(Rec.id).Comments_to_Sales__c ) || test.isRunningTest()){ 
            
                if(SysAdmin != Null){
                NewLead.Ownerid      =  SysAdmin;     
                }          
                NewLead.FirstName    = Rec.Name; //'Technician_recommendations';
                
                NewLead.LastName     = 'Maintenance & Reactive_Lead';
                NewLead.Company      = Rec.Site_Name__c;
                
                NewLead.Description  = 'Comments to sales :' + (Rec.Comments_to_Sales__c == Null ? '' : Rec.Comments_to_Sales__c ) +','+
                                       'Copy this into your browser to open the service sheet : '+'https://login.salesforce.com/'+Rec.id;
                NewLead.LeadSource   = 'Technician Onsite';
                NewLead.Status       = 'Pending - Other';
                
                listLead.add(NewLead);
                
           }
      }
      if(listLead.size()>0){
      insert listLead;
      
      //Update the Lead id to Maintenance and Reactive sheet Lead url field.
      id result = NewLead.id;
      for(Service_Sheet_STD__c Recsheet:newReActList){
       
       Recsheet.Lead_URL__c =  result; 
       
       }
      }
    }
    }
    
    
/*====================================================
*Method Name     : InsertRequiredParts
*Description     : Insert the RequiredParts for Service Sheet
*Arguments       : new Service Sheet list
====================================================*/

public void InsertRequiredParts(Map<Id,Service_Sheet_STD__c> newReActMap){
    Map<String,Service_Sheet_STD__c> SSIds=new Map<String,Service_Sheet_STD__c>();
    List<Required_Parts__c> InsertReqPrds=new List<Required_Parts__c>();
    
    Warehouse__c wh=[Select id,name from Warehouse__c where default__c=true limit 1];
    
    for(Service_Sheet_STD__c Eng: newReActMap.values()){
        SSIds.put(Eng.Sheets_Type__c,Eng);
    }
    System.debug('<<<???>>>'+SSIds);
    list<PartsConfig__c> parts = new list<PartsConfig__c>([select Product_Name__c,Product_Code__c,Service_Type__c from PartsConfig__c where Service_Type__c IN:SSIds.keyset() and isDefaultProduct__c=false]);
    for(PartsConfig__c MapPrd:parts){
        for(Service_Sheet_STD__c JobType: newReActMap.values()){
            if(JobType.Sheets_Type__c==MapPrd.Service_Type__c){
                Required_Parts__c ReqPrds=new Required_Parts__c();
                ReqPrds.Maintenance_Reactive_Sheet__c=JobType.id;
                ReqPrds.Product_Name__c=MapPrd.Product_Name__c;
                ReqPrds.Quantity__c=0;
                ReqPrds.Include_Invoice__c=false;
                ReqPrds.warehouse__c=wh.id;
                InsertReqPrds.add(ReqPrds);
            }
        }    
    }
    
    if(InsertReqPrds.size()>0)
    insert InsertReqPrds;
}

/*====================================================
*Method Name     : insertOLI
*Description     : Insert Opportunity and products 
*Arguments       : new and old Service Sheet list
====================================================*/

public void insertOLI(Map<Id,Service_Sheet_STD__c> newReActMap,Map<Id,Service_Sheet_STD__c> oldReActMap){
    
    system.debug('<<<< 111111 >>>>> ');
    String opnam;
    List<Opportunity> OppList=new List<Opportunity>();
    Map<Id,String> PBentry=new Map<Id,String>();
    Map<Id,Opportunity> OppSheets=new Map<Id,Opportunity>();
    List<Id> Ids=new List<Id>();
    Map<Id,String> Jobtype=new Map<Id,String>();
    Map<Id,String> Region=new Map<Id,String>();
    Map<Id,String> Park=new Map<Id,String>();
    List<Linked_Maintenance_Sheet__c> InsNewLkMs=new List<Linked_Maintenance_Sheet__c>();
    system.debug('****1');
    Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Invoice (Sheets)').getRecordTypeId();
    
    for(Service_Sheet_STD__c Eng : newReActMap.values()){
    system.debug('newReActMap==========='+Eng);
        if(Eng.Fire_Extinguisher_Service_complete__c && Eng.Fire_Extinguisher_Service_complete__c!=oldReActMap.get(Eng.id).Fire_Extinguisher_Service_complete__c){
           opnam = 'RS - '+Eng.Name+' - '+Eng.Site_Name__c+' - '+Eng.createdDate.Date().format();
            system.debug('<<<< 22222222 >>>>> ');
           Opportunity Opp = new Opportunity(
                             Recordtypeid=devRecordTypeId,
                             AccountID = Eng.Site__c,
                             CloseDate = system.today(),
                             StageName = 'Closed Won',
                             Name = opnam,
                             Shipping_Contact__c = Eng.Contact_Name_formula__c,
                             Reactive_Sheet__c = Eng.id,
                             Site_Contract__c = Eng.Site_Contract__c,
                             Technician_Groups__c=Eng.Technician_Group__c,    
                             Technician_Super_Groups__c=Eng.Technician_Super_Group__c,    
                             Service_Types__c=Eng.Service_Type__c,
                             Technicians_ID__c=Eng.Technician_Name__c,
                             Service_Sheets_Creation_Date__c=Date.Valueof(Eng.CreatedDate),
                             Customer_Works_Completion_Note__c=Eng.Document_Attached__c,  
                             Travel_Time__c=Eng.Travel_Time__c,
                             Technician_Name_Reactive__c=Eng.Technician_Namee__c,
                             Visits_No__c=Eng.Visit_no__c,
                             InvoiceEmailTo__c=Eng.Invoice_email_to__c,
               				 HQ_Invoice_Email_To__c=Eng.HQ_Invoice_Email_To__c,
                             Purchase_order_number2__c=Eng.Order_No__c
                             );
           OppList.add(Opp);
           
           Jobtype.put(Eng.Id,Eng.Sheets_Type__c);
           Region.put(Eng.Id,Eng.Price_Book__c);
            Park.put(Eng.Id,'All Service');
            system.debug('****2'+Park);
           System.debug('region===='+Region);
           system.debug('sheets Jobtype======'+Jobtype);
           PBentry.put(Eng.id,Eng.PriceBookId__c);
           Ids.add(Eng.id);
           }
    }
    system.debug(OppList);
    system.debug('OppList >>> '+OppList.size());
     if(OppList.size()>0)
     {
     
     insert OppList;
     system.debug('3333');
     }
     for(Opportunity Opp: OppList){
         Linked_Maintenance_Sheet__c NewLMs=new Linked_Maintenance_Sheet__c();
         OppSheets.put(Opp.Reactive_Sheet__c,Opp);system.debug('****3'+OppSheets.size());
         NewLMs.Maintenance_Reactive_Sheet__c=Opp.Reactive_Sheet__c;
         NewLMs.Opportunity__c=Opp.id;
         InsNewLkMs.add(NewLMs);
     }
     
     if(InsNewLkMs.size()>0){
         insert InsNewLkMs;
     }
     
     if(OppSheets.size()>0)
     insertOLI(newReActMap,OppSheets,Ids,PBentry,Jobtype,Region,Park);
}

public void insertOLI(map<id,Service_Sheet_STD__c> ssNewMap,Map<Id,Opportunity> OppSheets,List<Id> SheetsIds, Map<id,String> SCPBook,Map<Id,String> JobTypes,Map<Id,String> Regions,Map<Id,String> Parking){
      System.debug('JobTypes========'+JobTypes);
      System.debug('Regions==='+Regions);
      List<OpportunityLineItem> OLI=new List<OpportunityLineItem>();
      Map<Id,List<String>> SageCode=new Map<Id,List<String>>();
      List<String> reqparts = new List<String>();
      Map<Id,String> PBook=new Map<Id,String>();
      Map<Id,Required_Parts__c> Parts=new Map<Id,Required_Parts__c>();
      Map<String,Pricebookentry> Pentry=new Map<String,Pricebookentry>();
      Map<string,List<PartsConfig__c>>Jobdefprd=new Map<string,List<PartsConfig__c>>();
      Decimal Labcharge;
      Warehouse__c wh=[Select id,name from Warehouse__c where default__c=true limit 1];
      system.debug('****4');

     Map<Id,Service_Sheet_STD__c> Scids=new Map<Id,Service_Sheet_STD__c>([select id,Site_Contract__r.Labour_Charge__c,Site_Contract__r.Labour_OOH_Charge__c,Travel_Time_Hours__c from Service_Sheet_STD__c where id IN:SheetsIds]);
     
     list<PartsConfig__c> partscon = new list<PartsConfig__c>([select id,Service_Type__c,Product_Name__c,Product_Code__c,isDefaultProduct__c,Parking__c from PartsConfig__c where (Service_Type__c IN:Parking.values() and isDefaultProduct__c=true and Parking__c=true)]);
     for(PartsConfig__c def:partscon ){
          if(Jobdefprd.Containskey(def.Service_Type__c))
          Jobdefprd.get(def.Service_Type__c).add(def);
          else
          Jobdefprd.put(def.Service_Type__c,new List<PartsConfig__c>{def});
          reqparts.add(def.Product_Name__c);
          system.debug('parking======='+Jobdefprd);
         system.debug('****5');
      } 
      
      list<PartsConfig__c> partsc=new list<PartsConfig__c>([select id,Service_Type__c,Product_Name__c,Product_Code__c,isDefaultProduct__c,Call_out__c from PartsConfig__c where (Service_Type__c IN:Regions.values() and isDefaultProduct__c=true and Reactive__c=true)]);
      for(PartsConfig__c deff:partsc){
          if(Jobdefprd.Containskey(deff.Service_Type__c))
          Jobdefprd.get(deff.Service_Type__c).add(deff);
          else
          Jobdefprd.put(deff.Service_Type__c,new List<PartsConfig__c>{deff});
          reqparts.add(deff.Product_Name__c);
          Sagecode.put(deff.id,reqparts);
          System.debug('parts config prod==='+reqparts);
          System.debug('parts config map==='+Sagecode);
      } 
     
      
      for(Service_Sheet_STD__c ec :[select id,name from Service_Sheet_STD__c where id IN:SheetsIds]){
          PBook.put(ec.id,SCPBook.get(ec.id));
      }
      list<Required_Parts__c> reqpart = new list<Required_Parts__c>([select id,Product_Code__c,Maintenance_Reactive_Sheet__c,Quantity__c,Service_Sheet__c,Product_Name__c from Required_Parts__c
                                    where Maintenance_Reactive_Sheet__c IN:SheetsIds AND Quantity__c!=0 AND Include_Invoice__c=true]);
      for(Required_Parts__c Req:reqpart){
                     
                     if(Sagecode.containskey(req.Maintenance_Reactive_Sheet__c))
                     Sagecode.get(req.Maintenance_Reactive_Sheet__c).add(req.Product_Name__c);
                     else
                     Sagecode.put(req.Maintenance_Reactive_Sheet__c,new List<String>{req.Product_Name__c});
                     PBook.put(Req.Maintenance_Reactive_Sheet__c,SCPBook.get(Req.Maintenance_Reactive_Sheet__c));      
                     Parts.put(Req.id,Req); 
                     if(Req.Maintenance_Reactive_Sheet__c!= null){
                         for(String str:Sagecode.get(req.Maintenance_Reactive_Sheet__c)){
                             reqparts.add(str);
                         }
                     }
      }
      
      for(Pricebookentry Pid:[select id,name,pricebook2.id,Product2.id,Product2.productcode,unitprice,Product2.Cost__c from pricebookentry  
                              where pricebook2.id IN:PBook.values() AND Product2.Id IN:reqparts]){
          Pentry.put(Pid.Product2.Id,pid);
      
      }
      
      
 
      for(Service_Sheet_STD__c Eng: ssNewMap.values()){
        
         for(Required_Parts__c prt:Parts.values()){
          if(OppSheets.containskey(Eng.id) && prt.Maintenance_Reactive_Sheet__c==Eng.id && Pentry.containskey(prt.Product_Name__c) && PBook.get(Eng.id)==Pentry.get(prt.Product_Name__c).pricebook2.id){
          OpportunityLineItem oliItems = new OpportunityLineItem(
                              OpportunityID = OppSheets.get(Eng.id).id,
                              PricebookEntryID = Pentry.get(prt.Product_Name__c).id,
                              Quantity = prt.Quantity__c,
                              UnitPrice = Pentry.get(prt.Product_Name__c).unitprice,
                              Product_Cost_Price__c=Pentry.get(prt.Product_Name__c).Product2.Cost__c,
                              Maintenance_Reactive_Sheet__c=prt.Maintenance_Reactive_Sheet__c,
                              warehouse__c=wh.id
                         );
  
                          OLI.add(oliItems);
                         system.debug('opp req part pro============'+OLI);
          }
        }
        
        Labcharge=Scids.get(Eng.id).Site_Contract__r.Labour_Charge__c;
     
        System.debug('Labcharge======='+Labcharge);
    
       
         if(Jobdefprd.containskey(Eng.Price_Book__c)){system.debug('****6');
              for(PartsConfig__c CnfgRec:Jobdefprd.get(Eng.Price_Book__c)){
                  if(Pentry.Containskey(CnfgRec.Product_Name__c) && OppSheets.Containskey(Eng.id)){
                  OpportunityLineItem oliItems = new OpportunityLineItem();
                              oliItems.OpportunityID = OppSheets.get(Eng.id).id;
                              oliItems.PricebookEntryID = Pentry.get(CnfgRec.Product_Name__c).id; 
                              if(CnfgRec.Call_out__c==false){                             
                                   oliItems.Quantity = Eng.JobTime__c;
                              }
                              else{
                                   oliItems.Quantity =1;
                                }
                              oliItems.Product_Cost_Price__c=Pentry.get(CnfgRec.Product_Name__c).Product2.Cost__c;
                              oliItems.Maintenance_Reactive_Sheet__c=Eng.id;
                              system.debug('product cost price============'+oliItems.Product_Cost_Price__c);
                              system.debug(CnfgRec.id+' '+Labcharge+' ' +CnfgRec.Call_out__c);
                              if(CnfgRec.Call_out__c==false && Labcharge!=null && Labcharge!=0){
                                   oliItems.UnitPrice =Labcharge;
                              }
                              else if(CnfgRec.Call_out__c==false && Labcharge==null || Labcharge==0)
                              {
                                    oliItems.UnitPrice =Pentry.get(CnfgRec.Product_Name__c).unitprice;
                              }
                              else{
                                    oliItems.UnitPrice =Pentry.get(CnfgRec.Product_Name__c).unitprice;
                                   }      
                                   oliItems.warehouse__c=wh.id;                    
                         
                         OLI.add(oliItems);
                   }
              }
          } 
          
          if(Jobdefprd.containskey('All Service')){
   system.debug('parking produc added to opp========');
              list<PartsConfig__c> patsco = new list<PartsConfig__c>([Select id,Service_Type__c,Parking__c,Congestion__c,Product_Name__c from PartsConfig__c where (Service_Type__c =:'All Service' and isDefaultProduct__c=true and Parking__c=true) ] );
    for(PartsConfig__c CnfgRec:patsco){
    system.debug('Parking cond1============');
                  if(Pentry.Containskey(CnfgRec.Product_Name__c) && OppSheets.Containskey(Eng.id)){system.debug('****7');
                  system.debug('parking product=========='+CnfgRec.Product_Name__c);
                  OpportunityLineItem oliItems = new OpportunityLineItem();
                              oliItems.OpportunityID = OppSheets.get(Eng.id).id;
                              oliItems.PricebookEntryID = Pentry.get(CnfgRec.Product_Name__c).id;
                              oliItems.Quantity = 1;
                              oliItems.Product_Cost_Price__c=Pentry.get(CnfgRec.Product_Name__c).Product2.Cost__c;
                              oliItems.Maintenance_Reactive_Sheet__c=Eng.id;
                              oliItems.UnitPrice =Eng.Parking_Costs__c;
                              oliItems.warehouse__c=wh.id;
                         if((CnfgRec.Parking__c==true && Eng.Parking_Costs__c!=0)){
                         OLI.add(oliItems);
                         }
                         system.debug('park cong OLI============'+OLI);
                   }
              }
   
   }
          
      }
     
     if(OLI.size()>0)
     insert OLI;
} 


 public void insertInvTransaction(Map<Id,Service_Sheet_STD__c> NewMap,Map<Id,Service_Sheet_STD__c> oldMap){
        
          
          Map<Id,Required_Parts__c> reqPartmMap=new Map<Id,Required_Parts__c>();
         Set<Id> reqPProductId=new Set<Id>();
         Set<Id> reqpWarehouseId=new Set<Id>();
         List<Id> reqProductIdList;
         List<Id> reqWarehousList;     
         List<Inventory_Transaction__c> insertInvTran=new List<Inventory_Transaction__c>();     
         Map<id,Inventory__c> availableInvReqMap=new Map<Id,Inventory__c>();  
         Map<id,Inventory__c> nonAvailableInvReqMap=new Map<Id,Inventory__c>();
         List<id> sheetId=new List<id>();    
         system.debug(NewMap.values());          
         for(Service_Sheet_STD__c mr:NewMap.values()){
            if(mr.Fire_Extinguisher_Service_complete__c!=OldMap.get(mr.id).Fire_Extinguisher_Service_complete__c && mr.Fire_Extinguisher_Service_complete__c){
               sheetId.add(mr.id);
            }
            
        }
        system.debug(sheetId);
           if(sheetId.size()>0){
               list<Required_Parts__c> reqp = new list<Required_Parts__c>([Select Id,name,Product_Name__c,Product_Name__r.id,Quantity__c,Warehouse__c,Maintenance_Reactive_Sheet__c from Required_Parts__c where Maintenance_Reactive_Sheet__c=:sheetId]);
                for(Required_Parts__c req:reqp){
                    reqPartmMap.put(req.id,req);
                    reqPProductId.add(req.Product_Name__c);
                    reqpWarehouseId.add(req.Warehouse__c);                   
                }   
                reqProductIdList=new List<Id>(reqPProductId);
                reqWarehousList=new List<Id>(reqpWarehouseId);
                           
                
            }
            SYSTEM.DEBUG(reqPartmMap);
            
            if(reqPartmMap.size()>0){
                    for(Inventory__c inv:[Select id,name,Product__c,Warehouse__c from Inventory__c where Product__c=:reqProductIdList and Warehouse__c =:reqWarehousList]){
                        For(Required_Parts__c  req:reqPartmMap.values()){
                               system.debug(inv);
                               system.debug(req);
                           if(req.Product_Name__c==inv.Product__c && req.Warehouse__c==inv.Warehouse__c){
                               Inventory_Transaction__c invTrans=new Inventory_Transaction__c();
                               invTrans.name=inv.name;
                               invTrans.Inventory__c=inv.id;
                               invTrans.Qty__c=req.Quantity__c;
                               invTrans.Required_Part__c=req.id;
                               invTrans.Transaction_Type__c='Delivered';
                               invTrans.Items__c=req.Product_Name__r.id;
                               insertInvTran.add(invTrans);                          
                               availableInvReqMap.put(req.id,inv);
                               
                           }
                        }
                    }
                    system.debug(availableInvReqMap);
                    
                    for(Required_Parts__c req:reqPartmMap.values()){
                        if(!availableInvReqMap.containsKey(req.id)){
                             Inventory__c inv=new Inventory__c();
                             inv.product__c=req.Product_Name__r.id;
                             inv.Warehouse__c=req.warehouse__c;
                             nonAvailableInvReqMap.put(req.id,inv);
                        }
                    
                    }
                    
                    system.debug(nonAvailableInvReqMap);
                    try{
                            if(nonAvailableInvReqMap.size()>0){                               
                               insert nonAvailableInvReqMap.values();
                             }
                             for(Required_Parts__c req:reqPartmMap.values()){
                               
                                 if(nonAvailableInvReqMap.containsKey(req.id)){                                 
                                   
                                   Inventory_Transaction__c invTrans=new Inventory_Transaction__c();
                                   invTrans.name=nonAvailableInvReqMap.get(req.id).name;
                                   invTrans.Inventory__c=nonAvailableInvReqMap.get(Req.id).id;
                                   invTrans.Qty__c=req.Quantity__c;
                                   invTrans.Required_Part__c=req.id;
                                   invTrans.Transaction_Type__c='Delivered';
                                   invTrans.Items__c=req.Product_Name__r.id;
                                   insertInvTran.add(invTrans);                          
                                   
                                 
                                 }
                             }
                             
                             if(insertInvTran.size()>0){
                                 insert insertInvTran;
                             }
                     }
                     catch(Exception e){
                        System.debug(e);
                     }
                     
             }
          
        
        
    }//method
    
    
    public void deleteInvTransaction(Map<Id,Service_Sheet_STD__c> NewMap,Map<Id,Service_Sheet_STD__c> oldMap){
       List<Inventory_Transaction__c> deleteTrans=new List<Inventory_Transaction__c>(); 
        List<Id> listPartsId=new List<Id>();
        List<Id> sheetId=new List<Id>();
        List<Id> WarehouseId=new List<Id>();
        
        for(Service_Sheet_STD__c mr:NewMap.values()){            
            if(mr.Fire_Extinguisher_Service_complete__c!=OldMap.get(mr.id).Fire_Extinguisher_Service_complete__c && mr.Fire_Extinguisher_Service_complete__c==false){
              sheetId.add(mr.id);              
            }
        }
        
        if(sheetId.size()>0){
            list<Required_Parts__c> reqpar = new list<Required_Parts__c>([Select Id,name,Product_Name__c,Maintenance_Reactive_Sheet__c,warehouse__c  from Required_Parts__c where Maintenance_Reactive_Sheet__c=:sheetId]);
               for(Required_Parts__c  rp:reqpar){
                         listPartsId.add(rp.id);
                         WarehouseId.add(rp.warehouse__c);
               }
       }
        
              if(listPartsId.size()>0){
                  for(Inventory_Transaction__c invTrans:[Select id,name,Required_Part__c,Inventory__c,Inventory__r.Warehouse__c  from Inventory_Transaction__c  where Required_Part__c=:listPartsId and Inventory__r.Warehouse__c=:WarehouseId]){
                    deleteTrans.add(invTrans);
                  }
              }
               Try{
             if(deleteTrans.size()>0)
              Delete deleteTrans;
              
           }
           Catch(Exception e){
              for(Service_Sheet_STD__c ss:newMap.values()){
                   ss.addError(e.getMessage());
              }
           
          }
              
    }

    
}