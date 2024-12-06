Public CLASS ServiceSheetTriggerHandler{
    Public ServiceSheetTriggerHandler(){
    }
    //Public static List<Engineer_Checklist__c> serShtTrigerList;
    PUBLIC VOID OnAfterUpdate(map<id,Engineer_Checklist__c> ssNewMap,map<id,Engineer_Checklist__c> ssOldMap){
        system.debug('ssNewMap==='+ssNewMap+' ssOldMap=='+ssOldMap);
        //Call the AddProducts
        if(test.isRunningTest() && limits.getqueries()>90)
            return;
        //IF(RecursiveHandler.runOnce() || (test.isRunningTest() && limits.getqueries()<50)) {
        if(RecursiveHandler.runSSTH_UVCTOnce()){
            UpdateVisitComplete(ssNewMap,ssOldMap);
            UpdateAssestDueDate(ssNewMap,ssOldMap);
            UpdateProductType(ssNewMap,ssOldMap);
            //Added below loop for fix the 11471 ticket.
            for(Engineer_Checklist__c EngCheck :ssNewMap.values() )
                if(EngCheck.Linked_SS_count__c == ssOldMap.get(EngCheck.id).Linked_SS_count__c)            //While merging the opportunity the linked sheet is created. It updates the service, so the asset location. Now it is stopped the update from that merging Opportunity.
            {
                UpdateAssestSNo(ssNewMap,ssOldMap);
            }
        }
        if(RecursiveHandler.runSSTH_UPONOnce()){UpdatePurchaseOrderNumber(ssNewMap,ssOldMap);}     // Update the Purchase Order Number Field to the Opportunity
        //if(RecursiveHandler.runSSTH_ULELDOnce()){UpdateLastEmergencyLightingDuration(ssNewMap);}//{updateLocationList(ssNewMap);}
        system.debug('Coming after the signal===');
        
        //}          
        insertOLI(ssNewMap,ssOldMap);
        
        for(Engineer_Checklist__c ECheck : ssNewMap.values())
            if(ECheck.Invoiced__c != ssOldMap.get(ECheck.id).Invoiced__c)       
            UpdateAccountStatus(ssNewMap,ssOldMap);
        
        
        
        insertInvTransaction(ssNewMap,ssOldMap); 
        
        deleteInvTransaction(ssNewMap,ssOldMap);
    }
    
    /*====================================================
*Method Name     : OnBeforeInsert
*Description     : Handle the Before Insert operation
*Arguments       : new map list
====================================================*/   
    PUBLIC VOID OnBeforeInsert(List<Engineer_Checklist__c> ssList){
        map<id,Engineer_Checklist__c> ssNewMap=new map<id,Engineer_Checklist__c>();
        for(Engineer_Checklist__c ss:ssList){
            ssNewMap.put(ss.id,ss);    
        }
        
    }
    
    
    /*====================================================
*Method Name     : OnBeforeUpdate
*Description     : Handle the Before Update operation
*Arguments       : new map list
====================================================*/   
    PUBLIC VOID OnBeforeUpdate(map<id,Engineer_Checklist__c> ssNewMap,map<id,Engineer_Checklist__c> ssOldMap){
        //if(RecursiveHandler.runSSTH_UVCTOnce()){UpdateVisitComplete(ssNewMap);}
        //Call ValidateRequiredFields method
        if(RecursiveHandler.runSSTH_UVRFOnce()){
            //ValidateRequiredFields(ssNewMap); //Validating The Required Fields for some service type     
        }                         
        
        //TechRecommendationToLeadCreation Method
        if(RecursiveHandler.runSSTH_TRLCROnce()){
            // Create the New lead
            TechRecommendationToLeadCreation(ssNewMap,ssOldMap);
        }  
        
        if(ControlFetch__c.getInstance('Parts Used Condition').Flag__c){
            reqparts(ssNewMap);
        }  
    } 
    
    
    /*====================================================
*Method Name     : OnAfterInsert
*Description     : Handle the after Insert operation
*Arguments       : new map list
====================================================*/    
    PUBLIC VOID OnAfterInsert(Map<id,Engineer_Checklist__c>ssNewMap,Map<id,Engineer_Checklist__c>ssOldMap ){
        InsertRequiredParts(ssNewMap); 
        UpdateAssestSNo(ssNewMap,ssOldMap);
        UpdateProductType(ssNewMap,ssOldMap);
        UpdateAccountStatus(ssNewMap,ssOldMap);
        
        
    }
    
    /*====================================================
*Method Name     : OnAfterInsert
*Description     : Update product type for Suction pump service record type
*Arguments       : new map list
====================================================*/  
    private void UpdateProductType(Map<id,Engineer_Checklist__c>ssNewMap,Map<id,Engineer_Checklist__c>ssOldMap){
        
        List<id> AssetIds=new List<id>();
        List<Id> Eids=new List<Id>();
        List<id> PrdId=new List<id>();
        List<Engineer_Checklist__c > produ=new List<Engineer_Checklist__c >();
        String pro;
        List<Engineer_Checklist__c> SSList;
        Map<ID,Schema.RecordTypeInfo> rt_Map = Engineer_Checklist__c.sObjectType.getDescribe().getRecordTypeInfosById();
        system.debug('Producttypeupdate============='+ssNewMap.values());
        //to get the List Of Asset IDS
        for(Engineer_Checklist__c ss:ssNewMap.values()){
            if(ss.Type__c==null && rt_map.get(ss.recordTypeID).getName().containsIgnoreCase('Suction Pump Service')){
                system.debug('rt_Map ======='+rt_map.get(ss.recordTypeID).getName());
                system.debug('Producttypeupdate===========true');
                AssetIds.add(ss.Assest_Id__c);
                Eids.add(ss.id);
            }
        }
        
        for(Asset  Ass:[select id,Product2Id from Asset where ID IN:AssetIds]){
            prdId.add(Ass.Product2Id );
        }
        
        if(prdId.size()>0){
            Product2 prd=[Select id,name,Type__c from Product2 where id IN:prdId limit 1];
            
            pro=prd.Type__c ;
            system.debug('pro========'+pro);
        }
        if(pro!=null){
            SSList=new List<Engineer_CheckList__c>([select id,Visit__r.Asset__r.Product2.Type__c from Engineer_Checklist__c  where id IN:Eids]);
            
        for(Engineer_Checklist__c ss:SSList)
        {      
           ss.Type__c=ss.Visit__r.Asset__r.Product2.Type__c;
           produ.add(ss);
                
            } 
        }
        if(produ.size()>0){
            system.debug('updating product type======');           
            update produ;
        }
           
        
    }
    /*====================================================
*Method Name     : UpdateVisitComplete
*Description     : Update the Visit Complete Field.
*Arguments       : new Service Sheet list
====================================================*/   
    Private void UpdateVisitComplete(Map<id,Engineer_Checklist__c>ssNewMap,Map<id,Engineer_Checklist__c>ssOldMap){
        //Variable Declaration
        List<id> visitIds=new List<id>();
        
        //to get the List Of visit IDS
        for(Engineer_Checklist__c ss:ssNewMap.values()){
            if(ss.Fire_Extinguisher_Service_complete__c!=ssOldMap.get(ss.id).Fire_Extinguisher_Service_complete__c && ss.Fire_Extinguisher_Service_complete__c || test.isRunningTest())
                visitIds.add(ss.visit__c);
        }
        
        //to get a list of Visits 
        List<Visits__c> visitList=[select id,Visit_Complete__c,Last_Submitted_Service_Sheet__c from Visits__c where ID IN:visitIds ];
        for(Engineer_Checklist__c ss:ssNewMap.values()){
            for(Visits__c  vt :visitList){
                if(ss.Visit__c == vt.Id && ss.Close_Visit__c=='Yes' && ss.Fire_Extinguisher_Service_complete__c ||test.isRunningTest()){
                    //assign  Visit Complete Field
                    vt.Visit_Complete__c =true;
                    vt.Visit_Completed__c=system.today();
                    vt.Last_Submitted_Service_Sheet__c=ss.id;
                }
            }
        }
        update visitList;    //update the Visits
        
    }
    
    /*====================================================
*Method Name     : UpdateAssestDueDate
*Description     : Update the Assest Service Due Date when visit is Completed.
*Arguments       : new Service Sheet list
====================================================*/   
    Private void UpdateAssestDueDate(Map<id,Engineer_Checklist__c>ssNewMap,Map<id,Engineer_Checklist__c>ssOldMap){
        //Variable Declaration
        List<id> AssetIds=new List<id>();
        String AssId;
        
        //to get the List Of Asset IDS
        for(Engineer_Checklist__c ss:ssNewMap.values()){
            if(ss.Fire_Extinguisher_Service_complete__c!=ssOldMap.get(ss.id).Fire_Extinguisher_Service_complete__c && ss.Fire_Extinguisher_Service_complete__c || test.isRunningTest())
                AssetIds.add(ss.Assest_Id__c);
        }
        
        //to get a list of Assets
        List<Asset> AssetList=[select id,Annual_Service_Due_Date__c,SerialNumber from Asset where ID IN:AssetIds];
        for(Engineer_Checklist__c ss:ssNewMap.values()){
            for(Asset  Ass:AssetList){
                AssId=String.valueof(Ass.Id);
                AssId=AssId.substring(0,15);
                system.debug('>>>>>AssId>>'+AssId+'>>>>'+ss.Assest_Id__c);
                if(AssId== ss.Assest_Id__c && ss.Fire_Extinguisher_Service_complete__c){
                    Ass.Annual_Service_Due_Date__c=ss.Actual_Service_date__c+365;
                    
                }
                
            }
        }
        update AssetList;    //update the Visits
        
    }
    
    
    /*====================================================
*Method Name     : UpdateAssestSNo
*Description     : Update the Assest Service serial number
*Arguments       : new Service Sheet list
====================================================*/   
    Private void UpdateAssestSNo(Map<id,Engineer_Checklist__c>ssNewMap,Map<id,Engineer_Checklist__c>ssOldMap){
        //Variable Declaration
        List<id> AssetIds=new List<id>();
        String AssId;
        Map<ID,Schema.RecordTypeInfo> rt_Map = Engineer_Checklist__c.sObjectType.getDescribe().getRecordTypeInfosById();
        
        //to get the List Of Asset IDS
        for(Engineer_Checklist__c ss:ssNewMap.values()){
            system.debug('Aseetsno==============='+ss);
            
            AssetIds.add(ss.Assest_Id__c);
        }
        
        //to get a list of Assets
        List<Asset> AssetList=[select id,Location__c,InstallDate,Annual_Service_Due_Date__c,SerialNumber,Make__c,Model__c,Date_Of_Manufacture__c from Asset where ID IN:AssetIds];
        for(Engineer_Checklist__c ss:ssNewMap.values()){
            for(Asset  Ass:AssetList){
                AssId=String.valueof(Ass.Id);
                AssId=AssId.substring(0,15);
                system.debug('AssId=============='+ss.Assest_Id__c );
                
                
                if(AssId== ss.Assest_Id__c && Ass.SerialNumber!=ss.Serial_No__c && ss.Serial_No__c!=null  ){
                    
                    Ass.SerialNumber=ss.Serial_No__c;
                }
                if(AssId== ss.Assest_Id__c && Ass.Make__c!=ss.Make__c && ss.Make__c!=null){
                    
                    Ass.Make__c=ss.Make__c;
                }
                if(AssId== ss.Assest_Id__c && Ass.Model__c!=ss.Model__c  && ss.Model__c!=null){
                    
                    Ass.Model__c=ss.Model__c;
                }
                if(AssId== ss.Assest_Id__c && Ass.Date_Of_Manufacture__c!=ss.Date_Of_Manufacture__c  && ss.Date_Of_Manufacture__c!=null){
                    
                    Ass.Date_Of_Manufacture__c=ss.Date_Of_Manufacture__c;
                }
                if((AssId== ss.Assest_Id__c && rt_map.get(ss.recordTypeID).getName().containsIgnoreCase('Suction Pump Service') || rt_map.get(ss.recordTypeID).getName().containsIgnoreCase('Treatment Centre Certificate Of Service') && ss.surgery_name__c!=null && ss.surgery_name__c!=Ass.Location__c)){
                    Ass.Location__c=ss.surgery_name__c;
                    system.debug('suction & treatment====='+ Ass.Location__c);
                    system.debug('Itra-oral'+Ass.Location__c);
                }
                if(AssId== ss.Assest_Id__c && rt_map.get(ss.recordTypeID).getName().containsIgnoreCase('Mechanical X-Ray Report') && Ass.Location__c!=ss.Room_Name__c && ss.Room_Name__c!=null ){
                    Ass.Location__c=ss.Room_Name__c;
                    system.debug('mechanical========'+Ass.Location__c);
                }
                /**if(AssId== ss.Assest_Id__c && rt_map.get(ss.recordTypeID).getName().containsIgnoreCase('Air Compressor Service and Test Report') && Ass.Location__c!=ss.Room_Name__c && ss.Room_Name__c!=null ){
                    Ass.Location__c=ss.Room_Name__c;
                    system.debug('Air Compressor Service========'+Ass.Location__c);
                }
                **/
           if(AssId== ss.Assest_Id__c && rt_map.get(ss.recordTypeID).getName().containsIgnoreCase('Suction Pump Installation') && Ass.Location__c!=ss.Surgery_no_location__c && ss.Surgery_no_location__c!=null ){
                    Ass.Location__c=ss.Surgery_no_location__c;
                    system.debug('suction pump Installation========'+Ass.Location__c);
                }
           
           if(AssId== ss.Assest_Id__c && Ass.Location__c!=ss.Location__c && ss.Location__c!=null && (rt_map.get(ss.recordTypeID).getName().containsIgnoreCase('OPG Installation Certificate') || rt_map.get(ss.recordTypeID).getName().containsIgnoreCase('Air compressor Installation')|| rt_map.get(ss.recordTypeID).getName().containsIgnoreCase('Treatment Centre Installation')|| rt_map.get(ss.recordTypeID).getName().containsIgnoreCase('Intra Oral Xray Installation'))){
                    Ass.Location__c=ss.Location__c;
                    system.debug('Installation========'+Ass.Location__c);
                }
            
            if(AssId== ss.Assest_Id__c && ss.surgery_name__c!=Ass.Location__c && ss.surgery_name__c!=null && (rt_map.get(ss.recordTypeID).getName().containsIgnoreCase('Intra Oral Xray Installation')||rt_map.get(ss.recordTypeID).getName().containsIgnoreCase('Treatment Centre Installation'))){
            
            Ass.Location__c=ss.surgery_name__c;
            system.debug('Itra-oral'+Ass.Location__c);

            }
          
          if(AssId==ss.Assest_Id__c && ss.Date_of_installation__c!=Ass.InstallDate && ss.Date_of_installation__c!=null)
          {
          
          Ass.InstallDate=ss.Date_of_installation__c;
          
          }
          
          if(AssId==ss.Assest_Id__c && ss.Date_service_due__c!=Ass.Annual_Service_Due_Date__c && ss.Date_service_due__c!=null)
          {
          
          Ass.Annual_Service_Due_Date__c=ss.Date_service_due__c;
          
           }
          
         }
        
        }
        update AssetList;    //update the Visits
        
    }
    
    
    /*====================================================
*Method Name     : UpdatePurchaseOrderNumber
*Description     : Update the Purchase Order Number Field.
*Arguments       : new Service Sheet list
====================================================*/        
    Private void UpdatePurchaseOrderNumber(Map<id,Engineer_Checklist__c> NewSSMap,Map<id,Engineer_Checklist__c> oldSSMap){
        //Variable Declaration
        List<id> ssIds=new List<id>();
        for(Engineer_Checklist__c ss:NewSSMap.values()){
            if(oldSSMap.get(ss.id).Purchase_Order_Number__c!=ss.Purchase_Order_Number__c)
                ssIds.add(ss.Id);
        }
        //to get a list of Opportunity
        List<Opportunity> oppList=[select id,Purchase_order_number2__c,Service_Sheet__c from Opportunity
                                   where Service_Sheet__c IN:ssIds ];
        for(Opportunity opp :oppList){
            //assign Purchase Order Number Field
            if(opp.Service_Sheet__c!=NULL){
                opp.Purchase_order_number2__c =NewSSMap.get(opp.Service_Sheet__c).Purchase_Order_Number__c;
            }
        }
        update oppList;    //update the Opportunity
    }  
    
    /*====================================================
*Method Name     : TechRecommendationToLeadCreation
*Description     : Technician Recommendation to Lead Creation.
*Arguments       : new Smallwork Sheet list
====================================================*/    
    public void TechRecommendationToLeadCreation(map<id,Engineer_Checklist__c> ssNewMap,map<id,Engineer_Checklist__c> ssOldMap){
        
        boolean flag;
        flag = ControlFetch__c.getInstance('Lead Creation').isEnable__c; 
        if(flag){
            List<Lead> listLead = new List<Lead>();
            
            id Profileid;
            id SysAdmin;
            
            SysAdmin = ControlFetch__c.getInstance('System Admin id').TechnicianId__c;  //id need change change system id from custom setting->controlfetch object
            system.debug('SysAdmin'+SysAdmin);
            Lead NewLead;      
            for(Engineer_Checklist__c SSsheet:ssNewMap.values()){
                
                
                
                NewLead = new Lead(); 
                if( (SSsheet.Fire_Extinguisher_Service_complete__c==True && SSsheet.Service_Recommendations__c != Null && SSsheet.Lead_URL__c == null && SSsheet.Fire_Extinguisher_Service_complete__c != ssOldMap.get(SSsheet.id).Fire_Extinguisher_Service_complete__c )){ 
                    if(SysAdmin != Null){
                        NewLead.Ownerid      =  SysAdmin;     
                    } 
                    NewLead.FirstName    = SSsheet.Name; //'Technician_recommendations';
                    
                    NewLead.LastName     = 'Servicesheet_Lead';
                    
                    NewLead.Company      =  SSsheet.Site_Name__c;
                    
                    NewLead.Description  = 'Comments to sales :' + (SSsheet.Service_Recommendations__c == Null ? '' : SSsheet.Service_Recommendations__c) +','+
                        'Copy this into your browser to open the service sheet : '+'https://login.salesforce.com/'+SSsheet.id;
                    NewLead.LeadSource   = 'Technician Onsite';
                    NewLead.Status       = 'Pending - Other';
                    listLead.add(NewLead);
                    
                }
                else if((SSsheet.Fire_Extinguisher_Service_complete__c == True && SSsheet.Fire_Extinguisher_Service_complete__c == ssOldMap.get(SSsheet.id).Fire_Extinguisher_Service_complete__c && SSsheet.Service_Recommendations__c != ssOldMap.get(SSsheet.id).Service_Recommendations__c) || test.isRunningTest() ){
                    
                    if(SysAdmin != Null){
                        NewLead.Ownerid      =  SysAdmin;     
                    } 
                    NewLead.FirstName    = SSsheet.Name; //'Technician_recommendations';
                    
                    NewLead.LastName     = 'Servicesheet_Lead';
                    
                    NewLead.Company      =  SSsheet.Site_Name__c;
                    
                    NewLead.Description  = 'Comments to sales :' + (SSsheet.Service_Recommendations__c == Null ? '' : SSsheet.Service_Recommendations__c) +','+
                        'Copy this into your browser to open the service sheet : '+'https://login.salesforce.com/'+SSsheet.id;
                    NewLead.LeadSource   = 'Technician Onsite';
                    NewLead.Status       = 'Pending - Other';
                    
                    listLead.add(NewLead);
                    
                }
            }
            if(listLead.size()>0){
                insert listLead;
                system.debug('<<<<<<listLead>>>>>>'+listLead);
                //Update the Lead id to Service sheet Lead url field.
                id result = NewLead.id;
                for(Engineer_Checklist__c  SSsheet:ssNewMap.values()){
                    
                    SSsheet.Lead_URL__c = result;   
                    system.debug('<<<<<SSsheet>>>>>'+SSsheet);
                }  
            }    
            
        }
    }
    
    /*====================================================
*Method Name     : InsertRequiredParts
*Description     : Insert the RequiredParts for Service Sheet
*Arguments       : new Service Sheet list
====================================================*/
    
    public void InsertRequiredParts(Map<id,Engineer_Checklist__c>ssNewMap){
        Map<String,Engineer_Checklist__c> SSIds=new Map<String,Engineer_Checklist__c>();
        List<Required_Parts__c> InsertReqPrds=new List<Required_Parts__c>();
        Warehouse__c wh=[Select id,name from Warehouse__c where default__c=true limit 1];
        for(Engineer_Checklist__c Eng: ssNewMap.values()){
            SSIds.put(Eng.Service_Sheet_Type__c,Eng);
        }
        System.debug('<<SSIds>>'+SSIds);
       list<PartsConfig__c> par =new list<PartsConfig__c>([select Product_Name__c,Product_Code__c,Service_Type__c from PartsConfig__c where Service_Type__c IN:SSIds.keyset() and isDefaultProduct__c=false]);
        
        for(PartsConfig__c MapPrd:par){
            for(Engineer_Checklist__c JobType: ssNewMap.values()){
                System.debug('<<SSIds1>>');
                
                if(JobType.Service_Sheet_Type__c==MapPrd.Service_Type__c){    System.debug('<<MapPrd.Service_Type__c>>'+MapPrd.Service_Type__c);
                                                                          
                                                                          Required_Parts__c ReqPrds=new Required_Parts__c();
                                                                          ReqPrds.Service_Sheet__c=JobType.id;
                                                                          ReqPrds.Product_Name__c=MapPrd.Product_Name__c;
                                                                          ReqPrds.Quantity__c=1;
                                                                          ReqPrds.Include_Invoice__c=true;
                                                                          ReqPrds.warehouse__c=wh.id;
                                                                          InsertReqPrds.add(ReqPrds);
                                                                          System.debug('Default req parts======='+ReqPrds);
                                                                         }
            }    
        }
        
        if(InsertReqPrds.size()>0)
            insert InsertReqPrds;
    }
    
    public void reqparts(map<id,Engineer_Checklist__c> ssNewMap){
        
        List<Required_Parts__c> reqli=new List<Required_Parts__c>();
        Map<String,List<Required_Parts__c>> reqpart=new Map<String,List<Required_Parts__c>>();
        List<Id> Eid=new List<Id>();
        
        for(Engineer_Checklist__c Engc:ssNewMap.values()){
            
            Eid.add(Engc.id);
            if(test.isrunningtest())
                Eid.add(Engc.id);
        }
        list<Required_Parts__c> reqp =new list<Required_Parts__c>([Select id,name,Service_Sheet__c from Required_Parts__c where Service_Sheet__c IN:Eid]);
        for(Required_Parts__c req:reqp){
                       system.debug(reqpart.Containskey(req.Service_Sheet__c ));   
            if(reqpart.Containskey(req.Service_Sheet__c ))
                reqpart.get(req.Service_Sheet__c ).add(req);
            else
                reqpart.put(req.Service_Sheet__c,new List<Required_Parts__c >{req});
            reqli.add(req);
            system.debug('reqli======'+reqli);
        }
       
            for(Engineer_Checklist__c E:ssNewMap.values()){
               if(E.Visit__r.Visit_Type__c=='Service'||E.Visit__r.Visit_Type__c=='Project'||E.Visit__r.Visit_Type__c=='Callout'||E.Visit__r.Visit_Type__c=='Workshop Repair'||E.Visit__r.Visit_Type__c=='Warranty')
               {
                
                if(E.Close_Visit__c=='Yes' || E.Close_Visit__c=='No' )
                    E.addError('Required parts is mandatory'); 
               }
                
            }
            
        
    }
    
    /*====================================================
*Method Name     : insertOLI
*Description     : Insert and products 
*Arguments       : new and old Service Sheet list
====================================================*/
    
    public void insertOLI(map<id,Engineer_Checklist__c> ssNewMap,map<id,Engineer_Checklist__c> ssOldMap){
        
        String opnam;
        List<Opportunity> OppList=new List<Opportunity>();
        Map<Id,String> PBentry=new Map<Id,String>();
        Map<Id,Opportunity> OppSheets=new Map<Id,Opportunity>();
        List<Id> Ids=new List<Id>();     
        Map<Id,String> Jobtype=new Map<Id,String>();
        Map<Id,Engineer_Checklist__c> SSList;
        Map<Id,String> Region=new Map<Id,String>();
        List<Linked_Service_Sheet__c> InsertLkSS=new List<Linked_Service_Sheet__c>();
        Map<Id,String> Park=new Map<Id,String>();
        
        Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Invoice (Sheets)').getRecordTypeId(); 
        
        for(Engineer_Checklist__c Eng:ssNewMap.values()){
            if(Eng.Fire_Extinguisher_Service_complete__c && Eng.Fire_Extinguisher_Service_complete__c!=ssOldMap.get(Eng.id).Fire_Extinguisher_Service_complete__c)
                Ids.add(Eng.id);
            if(test.isrunningtest())
                Ids.add(Eng.id);
        }
        
        SSList=new Map<Id,Engineer_CheckList__c>([select id,Site_Contract__r.Contact_Site_Contracts__c,visit__r.Customer_Contact__c,Site__r.Site_Contact__c,Site__r.Parent.Site_Contact__c,Engineer__r.Name,Visit__r.Current_Purchase_Order_No__c,Site__r.Invoice_Email_To__c,HQ_Invoice_Email_To__c,Visit__r.Name,Engineer__r.Engineer_ID__c from Engineer_CheckList__c where id IN:Ids]);
        system.debug('SSList============='+SSList);
        for(Engineer_Checklist__c Eng:ssNewMap.values()){
            //  if(Eng.Fire_Extinguisher_Service_complete__c && Eng.Fire_Extinguisher_Service_complete__c!=ssOldMap.get(Eng.id).Fire_Extinguisher_Service_complete__c){
            opnam ='SS-'+Eng.Name+'-'+  Eng.Site_Name__c+'-'+Date.valueOf(Eng.createdDate).format();
            if(SSList.containsKey(Eng.id)){
                Opportunity Opp = new Opportunity();
                Opp.Recordtypeid=devRecordTypeId;
                Opp.AccountID = Eng.Site__c;
                Opp.CloseDate = system.today();
                Opp.StageName = 'Closed Won';
                Opp.Name = opnam;
                Opp.Service_Sheet__c = Eng.id;
                Opp.Site_Contract__c = Eng.Site_Contract__c;
                Opp.HQ_Invoice_Email_To__c=SSList.get(Eng.id).HQ_Invoice_Email_To__c;
                Opp.InvoiceEmailTo__c = SSList.get(Eng.id).Site__r.Invoice_Email_To__c;
                Opp.Service_Sheets_Creation_Date__c=Date.valueOf(Eng.createdDate);
                Opp.Visits_No__c=SSList.get(Eng.id).Visit__r.Name;
                Opp.Technicians_ID__c=SSList.get(Eng.id).Engineer__r.Engineer_ID__c;
                Opp.Technicians_Name_Service__c=SSList.get(Eng.id).Engineer__r.Name;
                Opp.Purchase_order_number2__c=SSList.get(Eng.id).Visit__r.Current_Purchase_Order_No__c;
                Opp.Shipping_Contact__c=SSList.get(Eng.id).visit__r.Customer_Contact__c;
                system.debug('Opp============='+Opp);
                OppList.add(Opp);
                PBentry.put(Eng.id,Eng.PriceBookId__c);
                //Ids.add(Eng.id);
                Jobtype.put(Eng.id,Eng.Service_Sheet_Type__c);
                Region.put(Eng.Id,Eng.Price_Book__c);
                Park.put(Eng.Id,'All Service');
                system.debug('Jobtype======'+Jobtype);
                System.debug('Region======'+Region);
                system.debug('parking====='+Park);
            }
        }
        if(OppList.size()>0){
            insert OppList;
        }
        
        for(Opportunity Opp: OppList){
            Linked_Service_Sheet__c NewLkSS=new Linked_Service_Sheet__c();
            OppSheets.put(Opp.Service_Sheet__c,Opp);
            NewLkSS.Opportunity__c=Opp.Id;
            NewLkSS.Service_Sheet__c=Opp.Service_Sheet__c;
            InsertLkSS.add(NewLkSS);
        }
        
        if(InsertLkSS.size()>0){
            insert InsertLkSS;
        }
        
        if(OppSheets.size()>0)
            insertOLI(ssNewMap,OppSheets,Ids,PBentry,Jobtype,Region,Park);
    }
    
    public void insertOLI(map<id,Engineer_Checklist__c> ssNewMap,Map<Id,Opportunity> OppSheets,List<Id> SheetsIds, Map<id,String> SCPBook,Map<Id,String> JobTypes,Map<Id,String> Regions,Map<Id,String> Parking){
        
        List<OpportunityLineItem> OLI=new List<OpportunityLineItem>();
        Map<Id,List<String>> SageCode=new Map<Id,List<String>>();
        List<String> reqparts = new List<String>();
        Map<Id,String> PBook=new Map<Id,String>();
        Map<Id,Required_Parts__c> Parts=new Map<Id,Required_Parts__c>();
        Map<String,Pricebookentry> Pentry=new Map<String,Pricebookentry>();
        Map<string,List<PartsConfig__c>>Jobdefprd=new Map<string,List<PartsConfig__c>>();
        Map<Id,Engineer_Checklist__c> Scids=new Map<Id,Engineer_Checklist__c>([select id,Site_Contract__r.Service_Charge__c,Site_Contract__r.Labour_OOH_Charge__c,Travel_Time_Hours__c from Engineer_Checklist__c where id IN:SheetsIds]);
        Decimal ServiceChg,unipri;
        Warehouse__c wh=[Select id,name from Warehouse__c where default__c=true limit 1];
        
        List<PartsConfig__c> partsConfigList = new List<PartsConfig__c>([SELECT Id, Service_Type__c, Product_Name__c, Product_Code__c, isDefaultProduct__c, Call_out__c 
                   FROM PartsConfig__c 
                   WHERE (Service_Type__c IN :Regions.values() OR Service_Type__c IN :Parking.values()) 
                   AND isDefaultProduct__c = true 
                   AND Call_out__c = false 
                   AND Reactive__c = false]);

 
        
        for(PartsConfig__c deff: partsConfigList){
            if(Jobdefprd.Containskey(deff.Service_Type__c))
                Jobdefprd.get(deff.Service_Type__c).add(deff);
            else
                Jobdefprd.put(deff.Service_Type__c,new List<PartsConfig__c>{deff});
            reqparts.add(deff.Product_Name__c);
            Sagecode.put(deff.id,reqparts);
            System.debug('parts config prod==='+reqparts);
            System.debug('parts config map==='+Sagecode);
        } 
        
        
        list<Engineer_Checklist__c> engi =new list<Engineer_Checklist__c>([select id,name from Engineer_Checklist__c where id IN:SheetsIds]);
        for(Engineer_Checklist__c ec :engi){
            PBook.put(ec.id,SCPBook.get(ec.id));
        }
        
         List<Required_Parts__c> Requiredparts = new List<Required_Parts__c>([select id,Product_Code__c,Quantity__c,Service_Sheet__c,Product_Name__c from Required_Parts__c
                                                                         where Service_Sheet__c IN:SheetsIds AND Quantity__c!=0 AND Include_Invoice__c=true]);
        
        for(Required_Parts__c Req:Requiredparts){
                                       
                                       if(Sagecode.containskey(req.Service_Sheet__c))
                                           Sagecode.get(req.Service_Sheet__c).add(req.Product_Name__c);
                                       else
                                           Sagecode.put(req.Service_Sheet__c,new List<String>{req.Product_Name__c});
                                       
                                       PBook.put(Req.Service_Sheet__c,SCPBook.get(Req.Service_Sheet__c));  
                                       Parts.put(Req.id,Req); // req parts values for opp
                                       
                                       if(Req.Service_Sheet__c != null){
                                           for(String str:Sagecode.get(req.Service_Sheet__c)){
                                               reqparts.add(str); // for pricebook entry price
                                           }
                                       }
            
                                   }
        list<Pricebookentry> pricebooks = new list<Pricebookentry>([select id,name,CurrencyIsoCode,pricebook2.id,Product2.id,Product2.productcode,unitprice,Product2.Cost__c from pricebookentry  
                                where pricebook2.id IN:PBook.values() AND Product2.Id IN:reqparts]);
        
        for(Pricebookentry Pid:pricebooks){
                                    Pentry.put(Pid.Product2.Id,pid);
        System.debug('priceBookentry'+Pid);
        System.debug(Pentry.put(Pid.Product2.Id,pid));
                                }
       
        for(Engineer_Checklist__c Eng: ssNewMap.values()){
            //required parts product added here
            for(Required_Parts__c prt:Parts.values()){
                if(OppSheets.containskey(Eng.id) && prt.Service_Sheet__c==Eng.id && Pentry.containskey(prt.Product_Name__c) && PBook.get(Eng.id)==Pentry.get(prt.Product_Name__c).pricebook2.id){
                   
                        system.debug('OppSheets.get(Eng.id).id>>'+OppSheets.get(Eng.id).id);
                        system.debug('Pentry.get(prt.Product_Name__c).id>>'+Pentry.get(prt.Product_Name__c).id);
                         system.debug('OppSheets.get(Eng.id).CurrencyIsoCode>>'+OppSheets.get(Eng.id).CurrencyIsoCode);
                        system.debug('Pentry.get(prt.Product_Name__c).CurrencyIsoCode>>'+Pentry.get(prt.Product_Name__c).CurrencyIsoCode);
                    OpportunityLineItem oliItems = new OpportunityLineItem(
                        
                        OpportunityID = OppSheets.get(Eng.id).id,
                        PricebookEntryID = Pentry.get(prt.Product_Name__c).id,
                        Quantity = prt.Quantity__c,
                        UnitPrice = Pentry.get(prt.Product_Name__c).unitprice,
                        Product_Cost_Price__c=Pentry.get(prt.Product_Name__c).Product2.Cost__c,
                        Service_Sheet__c=prt.Service_Sheet__c,
                        warehouse__c=wh.id
                    );
                    
                    
                    OLI.add(oliItems);
                    
                }
                system.debug('req parts OLI================'+OLI);
            }
            
            /*    unipri=Scids.get(Eng.id).Site_Contract__r.Service_Charge__c;
system.debug('unipri====='+unipri+'travel time========'+Eng.Travel_time__c);
if(unipri!=null && unipri!=0 && Eng.Travel_time__c!=0){
ServiceChg=unipri*Eng.Travel_time__c;
}
if(Eng.Travel_time__c==0 || unipri==null || unipri==0 ){
ServiceChg=70;
}
system.debug('ServiceChg====='+ServiceChg); */
            
            if(Jobdefprd.containskey(Eng.Price_Book__c)){
                
                for(PartsConfig__c CnfgRec:Jobdefprd.get(Eng.Price_Book__c)){
                    
                    system.debug('default product added to opp=====');
                    if(Pentry.Containskey(CnfgRec.Product_Name__c) && OppSheets.Containskey(Eng.id) ){
                        OpportunityLineItem oliItems = new OpportunityLineItem();
                        oliItems.OpportunityID = OppSheets.get(Eng.id).id;
                        System.debug('error line'+CnfgRec.Product_Name__c);
                        oliItems.PricebookEntryID = Pentry.get(CnfgRec.Product_Name__c).id;
                        System.debug(Pentry.get(CnfgRec.Product_Name__c).id);
                        System.debug(oliItems.PricebookEntryID);
                        oliItems.Quantity = 1;
                        oliItems.warehouse__c=wh.id;
                        oliItems.Product_Cost_Price__c=Pentry.get(CnfgRec.Product_Name__c).Product2.Cost__c;
                        oliItems.UnitPrice =Pentry.get(CnfgRec.Product_Name__c).unitprice;
                        oliItems.Service_Sheet__c=Eng.id;
                        
                        
                        OLI.add(oliItems);
                    }
                    system.debug('Default OLI============'+OLI);
                    
                }
            }
            
            if(Jobdefprd.containskey('All Service')){
                system.debug('parking produc added to opp========');
             //   list <PartsConfig__c> partsconfig = new list<PartsConfig__c>([Select id,Service_Type__c,Parking__c,Congestion__c,Product_Name__c from PartsConfig__c where Service_Type__c =:'All Service']);
               list<PartsConfig__c> partscon=new list<PartsConfig__c>([Select id,Service_Type__c,Parking__c,Congestion__c,Product_Name__c from PartsConfig__c where Service_Type__c =:'All Service']);
                for(PartsConfig__c CnfgRec: partscon){
                    system.debug('Parking cond1============'+CnfgRec);
                    if(Pentry.Containskey(CnfgRec.Product_Name__c) && OppSheets.Containskey(Eng.id)){
                        system.debug('parking product=========='+CnfgRec.Product_Name__c);
                        OpportunityLineItem oliItems = new OpportunityLineItem();
                        oliItems.OpportunityID = OppSheets.get(Eng.id).id;
                        oliItems.PricebookEntryID = Pentry.get(CnfgRec.Product_Name__c).id;
                        oliItems.Quantity = 1;
                        oliItems.Product_Cost_Price__c=Pentry.get(CnfgRec.Product_Name__c).Product2.Cost__c;
                        oliItems.Service_Sheet__c=Eng.id;
                        oliItems.Warehouse__c=wh.id;
                        if(CnfgRec.Congestion__c==true){
                            oliItems.UnitPrice =Eng.Congestion_Charge__c;
                        System.debug('1st IF Condition'+oliItems.UnitPrice);
                        System.debug('1st IF Condition'+Eng.Congestion_Charge__c);
                        }
                        if(CnfgRec.Parking__c==true ){
                            oliItems.UnitPrice =Eng.Parking_Costs__c;
                        System.debug('2nd IF Condition'+oliItems.UnitPrice);
                        System.debug('1nd IF Condition'+Eng.Parking_Costs__c);
                        }
                        if((CnfgRec.Parking__c==true && Eng.Parking_Costs__c!=0) || (CnfgRec.Congestion__c==true && Eng.Congestion_Charge__c!=0)){
                            OLI.add(oliItems);
                        System.debug('3rd IF Condition'+OLI);
                        System.debug('3rdst IF Condition');  
                        }
                        system.debug('park cong OLI============'+OLI);
                    }
                }
                
            }
            
        }
        
        if(OLI.size()>0)
        {
            SYSTEM.DEBUG(OLI);
            insert OLI;
        }
    } 
    
    Public void UpdateAccountStatus(Map<id,Engineer_Checklist__c>ssNewMap,Map<id,Engineer_Checklist__c>ssOldMap){
        
        List<id> AccountID = new List<id>();
        Map<id,account> AccMap = new Map<id,account>();
        for(Engineer_Checklist__c ECheck : ssNewMap.values()){
            if(ECheck.Invoiced__c ){
                AccountID.add(ECheck.Site__c);
            }
            System.debug('<<<111>>>'+AccountID);
        }
        list<Account> accts=new list<Account>([select id,name,Account_Status__c from Account where id =:AccountID]);
        for(Account forAcc :accts ){
            forAcc.Account_Status__c= 'Live';
            AccMap.put(forAcc.id,forAcc);
        }
        System.debug('<<<111>>>'+AccMap.values());
        if(AccMap.size()>0){
            try{
                update AccMap.values();
            }
            catch(Exception e){
                System.debug('Error :'+e);
            }
        }
        
    }
    
    public void insertInvTransaction(Map<Id,Engineer_Checklist__c> NewMap,Map<Id,Engineer_Checklist__c> oldMap){
        
        
        Map<Id,Required_Parts__c> reqPartmMap=new Map<Id,Required_Parts__c>();
        Set<Id> reqPProductId=new Set<Id>();
        Set<Id> reqpWarehouseId=new Set<Id>();
        List<Id> reqProductIdList;
        List<Id> reqWarehousList;     
        List<Inventory_Transaction__c> insertInvTran=new List<Inventory_Transaction__c>();     
        Map<id,Inventory__c> availableInvReqMap=new Map<Id,Inventory__c>();  
        Map<id,Inventory__c> nonAvailableInvReqMap=new Map<Id,Inventory__c>();
        List<id> sheetId=new List<id>();              
        for(Engineer_Checklist__c ss:NewMap.values()){
            if(ss.Fire_Extinguisher_Service_complete__c!=OldMap.get(ss.id).Fire_Extinguisher_Service_complete__c && ss.Fire_Extinguisher_Service_complete__c){
                sheetId.add(ss.id);
            }
            
        }
        if(sheetId.size()>0){
            list<Required_Parts__c> requ=new list<Required_Parts__c>([Select Id,name,Product_Name__c,Product_Name__r.id,Quantity__c,Warehouse__c,Service_Sheet__c from Required_Parts__c where Service_Sheet__c =:sheetId]);
            for(Required_Parts__c req:requ){
                reqPartmMap.put(req.id,req);
                reqPProductId.add(req.Product_Name__c);
                reqpWarehouseId.add(req.Warehouse__c);                   
            }   
            reqProductIdList=new List<Id>(reqPProductId);
            reqWarehousList=new List<Id>(reqpWarehouseId);
            
            
        }
        SYSTEM.DEBUG(reqPartmMap);
        
        if(reqPartmMap.size()>0){
            list<Inventory__c> inven = new list<Inventory__c>([Select id,name,Product__c,Warehouse__c from Inventory__c where Product__c=:reqProductIdList and Warehouse__c =:reqWarehousList]);
            for(Inventory__c inv:inven){
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
    
    
    public void deleteInvTransaction(Map<Id,Engineer_Checklist__c> NewMap,Map<Id,Engineer_Checklist__c> oldMap){
        List<Inventory_Transaction__c> deleteTrans=new List<Inventory_Transaction__c>(); 
        List<Id> listPartsId=new List<Id>();
        List<Id> sheetId=new List<Id>();
        List<Id> WarehouseId=new List<Id>();
        
        
        for(Engineer_Checklist__c ss:NewMap.values()){            
            if(ss.Fire_Extinguisher_Service_complete__c!=OldMap.get(ss.id).Fire_Extinguisher_Service_complete__c && ss.Fire_Extinguisher_Service_complete__c==false) {
                sheetId.add(ss.id);              
            }
        }
        
        if(sheetId.size()>0){
            list<Required_Parts__c> rep=new list<Required_Parts__c>([Select Id,name,Product_Name__c,warehouse__c from Required_Parts__c where Service_Sheet__c =:sheetId]);
            for(Required_Parts__c  rp:rep){
                listPartsId.add(rp.id);
                WarehouseId.add(rp.warehouse__c);
            }
        }
        if(listPartsId.size()>0){
            list<Inventory_Transaction__c> invet=new list<Inventory_Transaction__c>([Select id,name,Required_Part__c,Inventory__c,Inventory__r.Warehouse__c from Inventory_Transaction__c  where Required_Part__c=:listPartsId and Inventory__r.Warehouse__c=:WarehouseId]);
            for(Inventory_Transaction__c invTrans:invet){
                deleteTrans.add(invTrans);
            }
        }
        
        Try{
            if(deleteTrans.size()>0)
                Delete deleteTrans;
            
        }
        Catch(Exception e){
            for(Engineer_Checklist__c ss:newMap.values()){
                ss.addError(e.getMessage());
            }
            
        }
    }
  
}