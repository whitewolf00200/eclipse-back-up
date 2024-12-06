/*Class Name: CreateOppandOliOnReactiveSheetsHandler
Purpose: Opportunity Pricing Ticket
Author:Sachin Chincholi
Last Modified Date : 20/Jan/2014 Version:1.5
23/Jan/2014 Version:1.6
Reason:Additional Requirements to consider Split Hours of Inside and Outside Office Hours.
Additional Requirements for Scenario-3.
Modified Requirement to consider different Arrive and Depart Dates. - Test Update
*/
public class createOppandOliOnReactiveSheetsHandler{
    //Declare Variables
    Map<Id,SiteContracts__c> mapServiceSheetIdSiteContractRecord = new Map<Id,SiteContracts__c>();
    Map<Id,Visits__c> mapServiceSheetIdVisitRecord = new Map<Id,Visits__c>();
    Map<Id,Id> mapSiteContractIdServiceSheetId = new Map<Id,Id>();
    Map<Id,Id> mapVisitIdServiceSheetId = new Map<Id,Id>();
    List<SiteContracts__c> listofAllSiteContracts= new List<SiteContracts__c>();
    List<Visits__c> listofAllVisits = new List<Visits__c>();
    Decimal stdReacCallOutCharge =0.0;
    Decimal callOutCharge4HourResponse = 0.0;
    Decimal stdReacCallOutChargeOOH = 0.0;
    Decimal callOutChargePerHourThereafter = 0.0;
    Integer noOfHoursSpentOnsite = 0;
    Boolean isOutOfMonFri830AMto5PM = false;
    Decimal callOutOOHChargePerHourThereafter =0.0;
    Decimal salePrice = 0.0;
    Decimal labourChargePerHour = 0.0;
    Decimal labourOutOfHourCharge = 0.0;
    Decimal callOutOOHChargeInclude15min = 0.0;
    Decimal callOutChargeInclude15min = 0.0;
    Decimal callOutChargeIncludeFirsthour = 0.0;
    Decimal callOutOOHChargeIncludeFirsthour = 0.0;
    Map<ID,Service_Sheet_STD__c> mp = new Map<ID,Service_Sheet_STD__c>();
    List<Integer> listOfSplitHoursSpent = new List<Integer>();
    Integer noOfHoursInOfficeTime = 0;
    Integer noOfHoursOutOfficeTime=0;
    Integer noOfHoursInOfficeTimeAgain=0;
    //Added
    Decimal callOutCharge2HrResponse =0.0;
    Decimal callOutCharge2HrResponseOOH = 0.0;
    Decimal callOutCharge8HourResponse =0.0;
    Decimal callOutCharge8HourResponseOOH =0.0;
    Decimal callOutCharge5DayResponse = 0.0;
    
    //SINGLETON Pattern
    private static createOppandOliOnReactiveSheetsHandler instance = null;
    
    public static createOppandOliOnReactiveSheetsHandler getInstance(){
        if(instance == null) instance = new createOppandOliOnReactiveSheetsHandler();
        return instance;
    }
    //After Update Method Begins here
    public Decimal createOpp(List<Service_Sheet_STD__c> SSList){
      
        Set<ID> siteContractIds = new Set<ID>();
        Set<ID> visitIds = new Set<ID>();
        for(Service_Sheet_STD__c servSheetInst:SSList){
            siteContractIds.add(servSheetInst.Site_Contract__c);
            visitIds.add(servSheetInst.Visit__c);
        }
        try{
        if(Limits.getQueries()<95){
            listofAllSiteContracts = [SELECT id,name,Standard_Reactive_Call_Out_Charge__c,Labour_Out_of_Hour_Charge__c,
                                      Call_Out_Charge_Incl_First_15_Minutes__c,Call_Out_OOH_Charge_Incl_First_15_Mins__c,
                                      Call_Out_Charge_Incl_First_Hour__c,Call_Out_OOH_Charge_Incl_First_Hour__c,
                                      Call_Out_OOH_Charge_Per_Hour_Thereafter__c,X4_Hour_Reactive_Call_Out_Charge__c,
                                      Standard_Reactive_Call_Out_Charge_OOH__c,Call_Out_Charge_Per_Hour_Thereafter__c,
                                      Labour_Charge__c,Call_Out_Charge_2_Hour_Response__c,Call_Out_Charge_2_Hour_Response_OOH__c ,Call_Out_Charge_8_Hour_Response__c,Call_Out_Charge_8_Hour_Response_OOH__c,Call_Out_Charge_5_Day_Response__c
                                      /*, (SELECT id,name,priority__c from Visits__r) */ 
                                      from SiteContracts__c WHERE ID IN:siteContractIds];
            listofAllVisits = [SELECT id,name,priority__c from Visits__c WHERE ID IN:visitIds];
        }
        System.Debug('#Limits.getQueries(): ' + Limits.getQueries());
        }catch(Exception e){
            System.Debug('### EXCEPTION CREEPED IN ####'+e.getMessage());
        }
        
        //Populating the maps, Keep required data ready
        for(Service_Sheet_STD__c ssVar:SSList){ 
            mapSiteContractIdServiceSheetId.put(ssVar.Site_Contract__c,ssVar.id); 
            mapVisitIdServiceSheetId.put(ssVar.Visit__c,ssVar.id);
            mp.put(ssVar.id,ssVar);
        }   
        for(SiteContracts__c sc :listofAllSiteContracts){
            if(mapSiteContractIdServiceSheetId.containsKey(sc.id)){
                mapServiceSheetIdSiteContractRecord.put(mapSiteContractIdServiceSheetId.get(sc.id),sc);
            }   
        }
        for(Visits__c v :listofAllVisits){
            if(mapVisitIdServiceSheetId.containsKey(v.id)){
                mapServiceSheetIdVisitRecord.put(mapVisitIdServiceSheetId.get(v.id),v);   
            }  
        }
        
        //Scenarios Begin Here
        for(Service_Sheet_STD__c ssVar1:SSList){
            noOfHoursSpentOnsite = getNoOfHoursSpentOnsite(ssVar1.Arrive__c,ssVar1.Depart__c);
            isOutOfMonFri830AMto5PM = getIsOutOfMonFri830AMto5PM((Datetime)ssVar1.Arrive__c,(Datetime)ssVar1.Depart__c);
            
            //[0]=Hours inside Office Time,[1]=Hours Outside Office Time,[2] Hours inside Office Time Again
            listOfSplitHoursSpent = getSplitHoursSpentInsideAndOutSideOfficeHours(ssVar1.Arrive__c,ssVar1.Depart__c);
            System.Debug('####Final Split Hours are: '+listOfSplitHoursSpent);
            
            //Call Scenario 1
            if(mapServiceSheetIdVisitRecord.get(ssVar1.Id).Priority__c == '4 Hour Corrective' || mapServiceSheetIdVisitRecord.get(ssVar1.Id).Priority__c == '3 Day'  || mapServiceSheetIdVisitRecord.get(ssVar1.Id).Priority__c == '10 Day'|| mapServiceSheetIdVisitRecord.get(ssVar1.Id).Priority__c == 'Date Specific' ){
            if((mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Labour_Charge__c == null && (mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Labour_Out_of_Hour_Charge__c == null 
               && (
                   ((mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).X4_Hour_Reactive_Call_Out_Charge__c !=null && (mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Call_Out_Charge_Per_Hour_Thereafter__c !=null ) ||
                   ((mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Standard_Reactive_Call_Out_Charge__c !=null && (mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Call_Out_Charge_Per_Hour_Thereafter__c !=null ) ||
                   ((mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Standard_Reactive_Call_Out_Charge_OOH__c !=null && (mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Call_Out_Charge_Per_Hour_Thereafter__c !=null  && (mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Call_Out_OOH_Charge_Per_Hour_Thereafter__c !=null)
               )
              ){
                  System.debug('####'+' Inside SCENARIO:1');
                  salePrice = scenario1(ssVar1.Id);
              }
            }
            //Call Scenario 4,
             if(mapServiceSheetIdVisitRecord.get(ssVar1.Id).Priority__c == '4 Hour Corrective' || mapServiceSheetIdVisitRecord.get(ssVar1.Id).Priority__c == '3 Day'  || mapServiceSheetIdVisitRecord.get(ssVar1.Id).Priority__c == '10 Day'|| mapServiceSheetIdVisitRecord.get(ssVar1.Id).Priority__c == 'Date Specific' ){
            if((mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Labour_Charge__c != null || (mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Labour_Out_of_Hour_Charge__c != null
               && (
                   ((mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).X4_Hour_Reactive_Call_Out_Charge__c !=null && (mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Labour_Charge__c !=null ) ||
                   ((mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Standard_Reactive_Call_Out_Charge__c !=null && (mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Labour_Charge__c !=null ) ||
                   ((mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Standard_Reactive_Call_Out_Charge_OOH__c !=null && (mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Labour_Charge__c !=null  && (mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Labour_Out_of_Hour_Charge__c !=null)  
               )
              ){
                  System.debug('####'+'Inside SCENARIO-4');
                  salePrice = scenario4(ssVar1.Id);
              }
             }
            //Call Scenario 2
           
            if(
                ((mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Call_Out_Charge_Incl_First_Hour__c == null && 
                 (mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Call_Out_OOH_Charge_Incl_First_Hour__c == null &&
                 ((mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).X4_Hour_Reactive_Call_Out_Charge__c == null &&
                  (mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Standard_Reactive_Call_Out_Charge__c == null &&
                  (mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Standard_Reactive_Call_Out_Charge_OOH__c == null &&
                  (mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Labour_Charge__c == null &&
                  (mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Labour_Out_of_Hour_Charge__c == null
                 )
                ) &&
                (
                    ((mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Call_Out_Charge_Incl_First_15_Minutes__c != null &&  (mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Call_Out_Charge_Per_Hour_Thereafter__c != null) ||
                    ((mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Call_Out_OOH_Charge_Incl_First_15_Mins__c != null &&  (mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Call_Out_Charge_Per_Hour_Thereafter__c != null && (mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Call_Out_OOH_Charge_Per_Hour_Thereafter__c != null)
                )
            ){
                System.debug('####'+'Inside SCENARIO-2');
                salePrice = scenario2(ssVar1.Id); 
                return salePrice;               
            }  
            //Call Scenario 3       
 if(
                ((mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Call_Out_Charge_Incl_First_15_Minutes__c == null && 
                 (mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Call_Out_OOH_Charge_Incl_First_15_Mins__c == null &&
                 ((mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).X4_Hour_Reactive_Call_Out_Charge__c == null &&
                  (mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Standard_Reactive_Call_Out_Charge__c == null &&
                  (mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Standard_Reactive_Call_Out_Charge_OOH__c == null &&
                  (mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Labour_Charge__c == null &&
                  (mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Labour_Out_of_Hour_Charge__c == null
                 )
                ) &&
                (
                    ((mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Call_Out_Charge_Incl_First_Hour__c != null &&  (mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Call_Out_Charge_Per_Hour_Thereafter__c != null) ||
                    ((mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Call_Out_OOH_Charge_Incl_First_Hour__c != null &&  (mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Call_Out_Charge_Per_Hour_Thereafter__c != null && (mapServiceSheetIdSiteContractRecord.get(ssVar1.id)).Call_Out_OOH_Charge_Per_Hour_Thereafter__c != null)
                )
            ){
                System.debug('####'+'Inside SCENARIO-3');
                salePrice = scenario3(ssVar1.Id);  
            }
            //Entry condition for Scenario 5
           if(mapServiceSheetIdVisitRecord.get(ssVar1.Id).Priority__c == '2 Hour')
            {
                System.debug('####'+'Inside SCENARIO-5');
                salePrice = scenario5(ssVar1.Id);  
            }
            
            //Entry condition for Scenario 7
           if(mapServiceSheetIdVisitRecord.get(ssVar1.Id).Priority__c == '8 Hour')
           {
                System.debug('####'+'Inside SCENARIO-7');
                salePrice = scenario7(ssVar1.Id);  
            }
            
            //Entry condition for Scenario 8
          if(mapServiceSheetIdVisitRecord.get(ssVar1.Id).Priority__c == '24 Hour'){
                System.debug('####'+'Inside SCENARIO-8');
                salePrice = scenario8(ssVar1.Id);  
            }
            
             //Entry condition for Scenario 9
           if(mapServiceSheetIdVisitRecord.get(ssVar1.Id).Priority__c == '5 Day'){
                System.debug('####'+'Inside SCENARIO-9');
                salePrice = scenario9(ssVar1.Id);  
            }
            System.Debug('CHECK OF SCENARIOS'); 
        }
        System.Debug('####Final Sale Price going out: '+salePrice+'####');
        return salePrice;
    }
    //End of Scenario Evaluation
    //This Covers Scenario 1
    private Decimal scenario1(Id ssVar1Id){
        if(mapServiceSheetIdVisitRecord.get(ssVar1Id).Priority__c == '4 Hour Corrective'){
            if(!isOutOfMonFri830AMto5PM){
                System.debug('####'+'Sce 1: Pri=4C,Dep Time : Inside Office Hours');
                salePrice = insideOfficeHoursPri4CSce1(ssVar1Id);
            }
            else if(isOutOfMonFri830AMto5PM){
                System.debug('####'+'Sce 1: Pri=4C,Dep Time : Outside Office Hours');
                salePrice = outsideOfficeHoursSce1(ssVar1Id);
            }
        }
        else if(mapServiceSheetIdVisitRecord.get(ssVar1Id).Priority__c != '4 Hour Corrective'){
            if(!isOutOfMonFri830AMto5PM){
                System.debug('####'+'Sce 1: Pri=NOT4C,Dep Time : Inside Office Hours');
                salePrice=insideOfficeHoursPriNot4CSce1(ssVar1Id);
            }
            else if(isOutOfMonFri830AMto5PM){
                System.debug('####'+'Sce 1: Pri=NOT4C,Dep Time : Outside Office Hours');
                salePrice = outsideOfficeHoursSce1(ssVar1Id);
            }  
        }
        return salePrice;
    }
    //This Covers Scenario 4
    public Decimal scenario4(Id ssVar1Id){
        if(mapServiceSheetIdVisitRecord.get(ssVar1Id).Priority__c == '4 Hour Corrective'){
            if(!isOutOfMonFri830AMto5PM){
                System.debug('####'+'Sce 4: Pri=4C,Dep Time : Inside Office Hours');
                salePrice = insideOfficeHoursPri4CSce4(ssVar1Id);
            }
            else if(isOutOfMonFri830AMto5PM){
                System.debug('####'+'Sce 4: Pri=4C,Dep Time : Outside Office Hours');
                salePrice = outsideOfficeHoursSce4(ssVar1Id);
            }
        }
        else if(mapServiceSheetIdVisitRecord.get(ssVar1Id).Priority__c != '4 Hour Corrective'){
            if(!isOutOfMonFri830AMto5PM){
                System.debug('####'+'Sce 4: Pri=NOT4C,Dep Time : Inside Office Hours');
                salePrice=insideOfficeHoursPriNot4CSce4(ssVar1Id);
            }
            else if(isOutOfMonFri830AMto5PM){
                System.debug('####'+'Sce 4: Pri=NOT4C,Dep Time : Outside Office Hours');
                salePrice = outsideOfficeHoursSce4(ssVar1Id);
            }  
        }
        return salePrice;
    }
    //This Covers Scenario 2
    private Decimal scenario2(Id ssVar1Id){
        if(!isOutOfMonFri830AMto5PM){
            System.debug('####'+'Sce 2: Dep Time : Inside Office Hours');
            salePrice=insideOfficeHoursSce2(ssVar1Id);
        }
        else if(isOutOfMonFri830AMto5PM){
            System.debug('####'+'Sce 2: Dep Time : Outside Office Hours');
            salePrice = outsideOfficeHoursSce2(ssVar1Id);
        }
        return salePrice;
    }
    //This Covers Scenario 3
    private Decimal scenario3(Id ssVar1Id){
        if(!isOutOfMonFri830AMto5PM){
            System.debug('####'+'Sce 3: Dep Time : Inside Office Hours');
            salePrice=insideOfficeHoursSce3(ssVar1Id);
        }
        else if(isOutOfMonFri830AMto5PM){
            System.debug('####'+'Sce 3: Dep Time : Outside Office Hours');
            salePrice = outsideOfficeHoursSce3(ssVar1Id);
        }
        return salePrice;
    }
    //This Covers Scenario 5
    private Decimal scenario5(Id ssVar1Id){
        if(mapServiceSheetIdVisitRecord.get(ssVar1Id).Priority__c == '2 Hour'){
            if(!isOutOfMonFri830AMto5PM){
                System.debug('####'+'Sce 5: Pri=2H,Dep Time : Inside Office Hours');
                salePrice = insideOfficeHoursPri2HSce5(ssVar1Id);
            }
            else if(isOutOfMonFri830AMto5PM){
                System.debug('####'+'Sce 5: Pri=2H,Dep Time : Outside Office Hours');
                salePrice = outsideOfficeHoursSce5(ssVar1Id);
            }
        }
        return salePrice;
    }
    
    private Decimal insideOfficeHoursPri2HSce5(Id ssVar1Id){
        System.debug('####'+'Sce 5: Dep Time : Inside Office Hours:BEGIN');
        System.Debug('####List Of Split Hours is'+listOfSplitHoursSpent);
        noOfHoursInOfficeTime=listOfSplitHoursSpent.get(0);
        noOfHoursOutOfficeTime = listOfSplitHoursSpent.get(1);
        noOfHoursInOfficeTimeAgain = listOfSplitHoursSpent.get(2);
        callOutCharge2HrResponse = (mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Call_Out_Charge_2_Hour_Response__c;
        callOutChargePerHourThereafter=(mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Call_Out_Charge_Per_Hour_Thereafter__c;
        if(callOutCharge2HrResponse==null){
             System.debug('####callOutCharge2HrResponse is Null, Hence Substituted by 0');
             callOutCharge2HrResponse=0.0;
        }
        if(callOutChargePerHourThereafter==null){
            System.debug('####callOutChargePerHourThereafter is Null, Hence Substituted by 0');
            callOutChargePerHourThereafter=0.0;
        }
        salePrice = callOutCharge2HrResponse +(callOutChargePerHourThereafter*noOfHoursInOfficeTime);
        System.debug('####'+'Sce 5: Dep Time : Inside Office Hours:END');
        System.debug('####'+'Sce 5:  Dep Time : Inside Office Hours:SALEPRICE'+salePrice);
        return salePrice;
    }
   
    private Decimal outsideOfficeHoursSce5(Id ssVar1Id){
        System.debug('####'+'Sce 5: Dep Time : Outside Office Hours:BEGIN');
        System.Debug('####List Of Split Hours is'+listOfSplitHoursSpent);
        noOfHoursInOfficeTime=listOfSplitHoursSpent.get(0);
        noOfHoursOutOfficeTime = listOfSplitHoursSpent.get(1);
        noOfHoursInOfficeTimeAgain = listOfSplitHoursSpent.get(2);
        callOutCharge2HrResponseOOH = (mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Call_Out_Charge_2_Hour_Response_OOH__c;
        callOutChargePerHourThereafter=(mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Call_Out_Charge_Per_Hour_Thereafter__c;
        callOutOOHChargePerHourThereafter = (mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Call_Out_OOH_Charge_Per_Hour_Thereafter__c;
        if(callOutCharge2HrResponseOOH==null){
             System.debug('####callOutCharge2HrResponseOOH is Null, Hence Substituted by 0');
             callOutCharge2HrResponseOOH=0.0;
        }
        if(callOutChargePerHourThereafter==null){
            System.debug('####callOutChargePerHourThereafter is Null, Hence Substituted by 0');
            callOutChargePerHourThereafter=0.0;
        }
        if(callOutOOHChargePerHourThereafter==null){
            System.debug('####callOutOOHChargePerHourThereafter is Null, Hence Substituted by 0');
            callOutOOHChargePerHourThereafter=0.0;
        }
         salePrice = callOutCharge2HrResponseOOH + ((callOutChargePerHourThereafter* noOfHoursInOfficeTime)+(callOutOOHChargePerHourThereafter * noOfHoursOutOfficeTime)+(callOutChargePerHourThereafter*noOfHoursInOfficeTimeAgain));
                  System.debug('####'+'Sce 5: Dep Time : Outside Office Hours:END');
                 System.debug('####'+'Sce 5:  Dep Time : Outside Office Hours:SALEPRICE'+salePrice);
        return salePrice;
    }
    
    //This Covers Scenario 7
    private Decimal scenario7(Id ssVar1Id){
        if(mapServiceSheetIdVisitRecord.get(ssVar1Id).Priority__c == '8 Hour'){
            if(!isOutOfMonFri830AMto5PM){
                System.debug('####'+'Sce 7: Pri=8H,Dep Time : Inside Office Hours');
                salePrice = insideOfficeHoursPri8HSce7(ssVar1Id);
            }
            else if(isOutOfMonFri830AMto5PM){
                System.debug('####'+'Sce 7: Pri=8H,Dep Time : Outside Office Hours');
                salePrice = outsideOfficeHoursSce7(ssVar1Id);
            }
        }
        return salePrice;
    }
    
    private Decimal insideOfficeHoursPri8HSce7(Id ssVar1Id){
        System.debug('####'+'Sce 7: Dep Time : Inside Office Hours:BEGIN');
        System.Debug('####List Of Split Hours is'+listOfSplitHoursSpent);
        noOfHoursInOfficeTime=listOfSplitHoursSpent.get(0);
        noOfHoursOutOfficeTime = listOfSplitHoursSpent.get(1);
        noOfHoursInOfficeTimeAgain = listOfSplitHoursSpent.get(2);
        callOutCharge8HourResponse = (mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Call_Out_Charge_8_Hour_Response__c;
        callOutChargePerHourThereafter=(mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Call_Out_Charge_Per_Hour_Thereafter__c;
        if(callOutCharge8HourResponse==null){
             System.debug('####callOutCharge8HourResponse is Null, Hence Substituted by 0');
             callOutCharge8HourResponse=0.0;
        }
        if(callOutChargePerHourThereafter==null){
             System.debug('####callOutChargePerHourThereafter is Null, Hence Substituted by 0');
             callOutChargePerHourThereafter=0.0;
        }
        salePrice = callOutCharge8HourResponse +(callOutChargePerHourThereafter*noOfHoursInOfficeTime);
        return salePrice;
    }
    
    private Decimal outsideOfficeHoursSce7(Id ssVar1Id){
        System.debug('####'+'Sce 7: Dep Time : Outside Office Hours:BEGIN');
        System.Debug('####List Of Split Hours is'+listOfSplitHoursSpent);
        noOfHoursInOfficeTime=listOfSplitHoursSpent.get(0);
        noOfHoursOutOfficeTime = listOfSplitHoursSpent.get(1);
        noOfHoursInOfficeTimeAgain = listOfSplitHoursSpent.get(2);
         callOutCharge8HourResponseOOH= (mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Call_Out_Charge_8_Hour_Response_OOH__c;
        callOutChargePerHourThereafter=(mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Call_Out_Charge_Per_Hour_Thereafter__c;
        callOutOOHChargePerHourThereafter = (mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Call_Out_OOH_Charge_Per_Hour_Thereafter__c;
        if(callOutCharge8HourResponseOOH==null){
            System.debug('####callOutCharge8HourResponseOOH is Null, Hence Substituted by 0');
            callOutCharge8HourResponseOOH=0.0;
        }
        if(callOutChargePerHourThereafter==null){
            System.debug('####callOutChargePerHourThereafter is Null, Hence Substituted by 0');
            callOutChargePerHourThereafter=0.0;
        }
        if(callOutOOHChargePerHourThereafter==null){
            System.debug('####callOutOOHChargePerHourThereafter is Null, Hence Substituted by 0');
            callOutOOHChargePerHourThereafter=0.0;
        }
        salePrice =callOutCharge8HourResponseOOH +((callOutChargePerHourThereafter*noOfHoursInOfficeTime)+(callOutOOHChargePerHourThereafter*noOfHoursOutOfficeTime)+(callOutChargePerHourThereafter*noOfHoursInOfficeTimeAgain));
        return salePrice;
    }
    
    //This Covers Scenario 8
    private Decimal scenario8(Id ssVar1Id){
        if(mapServiceSheetIdVisitRecord.get(ssVar1Id).Priority__c == '24 Hour'){
            if(!isOutOfMonFri830AMto5PM){
                System.debug('####'+'Sce 8: Pri=24H,Dep Time : Inside Office Hours');
                salePrice = insideOfficeHoursPri24HSce8(ssVar1Id);
            }
            else if(isOutOfMonFri830AMto5PM){
                System.debug('####'+'Sce 7: Pri=8H,Dep Time : Outside Office Hours');
                salePrice = outsideOfficeHoursSce8(ssVar1Id);
            }
        }
        return salePrice;
    }
    
    private Decimal insideOfficeHoursPri24HSce8(Id ssVar1Id){
        System.debug('####'+'Sce 8: Dep Time : Inside Office Hours:BEGIN');
        System.Debug('####List Of Split Hours is'+listOfSplitHoursSpent);
        noOfHoursInOfficeTime=listOfSplitHoursSpent.get(0);
        noOfHoursOutOfficeTime = listOfSplitHoursSpent.get(1);
        noOfHoursInOfficeTimeAgain = listOfSplitHoursSpent.get(2);
        stdReacCallOutCharge = (mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Standard_Reactive_Call_Out_Charge__c;
        callOutChargePerHourThereafter=(mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Call_Out_Charge_Per_Hour_Thereafter__c;
        if(stdReacCallOutCharge == null){
            System.debug('####stdReacCallOutCharge is Null, Hence Substituted by 0');
            stdReacCallOutCharge = 0.0;
        }
        if(callOutChargePerHourThereafter == null){
            System.debug('####callOutChargePerHourThereafter is Null, Hence Substituted by 0');
            callOutChargePerHourThereafter = 0.0;
        }
        salePrice = stdReacCallOutCharge +(callOutChargePerHourThereafter*noOfHoursInOfficeTime);   
        return salePrice;
    } 
    
    private Decimal outsideOfficeHoursSce8(Id ssVar1Id){
        System.debug('####'+'Sce 8: Dep Time : Outside Office Hours:BEGIN');
        System.Debug('####List Of Split Hours is'+listOfSplitHoursSpent);
        noOfHoursInOfficeTime=listOfSplitHoursSpent.get(0);
        noOfHoursOutOfficeTime = listOfSplitHoursSpent.get(1);
        noOfHoursInOfficeTimeAgain = listOfSplitHoursSpent.get(2);
        stdReacCallOutChargeOOH = (mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Standard_Reactive_Call_Out_Charge_OOH__c;
        callOutChargePerHourThereafter=(mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Call_Out_Charge_Per_Hour_Thereafter__c;
        callOutOOHChargePerHourThereafter = (mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Call_Out_OOH_Charge_Per_Hour_Thereafter__c;
        if(stdReacCallOutChargeOOH==null){
            System.debug('####stdReacCallOutChargeOOH is Null, Hence Substituted by 0');
            stdReacCallOutChargeOOH=0.0;    
        }
        if(callOutOOHChargePerHourThereafter==null){
            System.debug('####callOutOOHChargePerHourThereafter is Null, Hence Substituted by 0');
            callOutOOHChargePerHourThereafter=0.0;  
        }
        if(callOutChargePerHourThereafter==null){
            System.debug('####callOutChargePerHourThereafter is Null, Hence Substituted by 0');
            callOutChargePerHourThereafter=0.0;    
        }
        salePrice = stdReacCallOutChargeOOH +((callOutChargePerHourThereafter*noOfHoursInOfficeTime)+(callOutOOHChargePerHourThereafter*noOfHoursOutOfficeTime)+(callOutChargePerHourThereafter*noOfHoursInOfficeTimeAgain));
        return salePrice;
    } 
    
    //This Covers Scenario 9
    private Decimal scenario9(Id ssVar1Id){
        if(mapServiceSheetIdVisitRecord.get(ssVar1Id).Priority__c == '5 Day'){
            if(!isOutOfMonFri830AMto5PM){
                System.debug('####'+'Sce 9: Pri=5D,Dep Time : Inside Office Hours');
                salePrice = insideOfficeHoursPri5DSce9(ssVar1Id);
            }
            else if(isOutOfMonFri830AMto5PM){
                System.debug('####'+'Sce 9: Pri=5D,Dep Time : Outside Office Hours');
                salePrice = insideOfficeHoursPri5DSce9(ssVar1Id);
            }
        }
        return salePrice;
    }
    
    private Decimal insideOfficeHoursPri5DSce9(Id ssVar1Id){
        System.debug('####'+'Sce 9: Dep Time : Inside Office Hours:BEGIN');
        System.Debug('####List Of Split Hours is'+listOfSplitHoursSpent);
        noOfHoursInOfficeTime=listOfSplitHoursSpent.get(0);
        noOfHoursOutOfficeTime = listOfSplitHoursSpent.get(1);
        noOfHoursInOfficeTimeAgain = listOfSplitHoursSpent.get(2);
        callOutCharge5DayResponse = (mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Call_Out_Charge_5_Day_Response__c;
        callOutChargePerHourThereafter=(mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Call_Out_Charge_Per_Hour_Thereafter__c;
         if(callOutCharge5DayResponse==null){
            System.debug('####callOutCharge5DayResponse is Null, Hence Substituted by 0');
            callOutCharge5DayResponse=0.0;
        }
        if(callOutChargePerHourThereafter==null){
            System.debug('####callOutChargePerHourThereafter is Null, Hence Substituted by 0');
            callOutChargePerHourThereafter=0.0;
        }
        salePrice = callOutCharge5DayResponse +((callOutChargePerHourThereafter*noOfHoursInOfficeTime)+(callOutChargePerHourThereafter*noOfHoursOutOfficeTime)+(callOutChargePerHourThereafter*noOfHoursInOfficeTimeAgain));
        return salePrice;
    }
    
    //Helper Methods Begin
    private Decimal insideOfficeHoursSce3(Id ssVar1Id){
        System.debug('####'+'Sce 3: Dep Time : Inside Office Hours:BEGIN');
        System.Debug('####List Of Split Hours is'+listOfSplitHoursSpent);
        noOfHoursInOfficeTime=listOfSplitHoursSpent.get(0);
        noOfHoursOutOfficeTime = listOfSplitHoursSpent.get(1);
        noOfHoursInOfficeTimeAgain = listOfSplitHoursSpent.get(2);
        callOutChargeIncludeFirsthour= (mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Call_Out_Charge_Incl_First_Hour__c;
        callOutChargePerHourThereafter=(mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Call_Out_Charge_Per_Hour_Thereafter__c;
        if(callOutChargeIncludeFirsthour==null){
            System.debug('####callOutChargeIncludeFirsthour is Null, Hence Substituted by 0');
            callOutChargeIncludeFirsthour=0.0;
        }
        if(callOutChargePerHourThereafter==null){
            System.debug('####callOutChargePerHourThereafter is Null, Hence Substituted by 0');
            callOutChargePerHourThereafter=0.0;
        }
        if(noOfHoursInOfficeTime>=1){
            salePrice = callOutChargeIncludeFirsthour +(callOutChargePerHourThereafter*(noOfHoursInOfficeTime-1));
        }
        else{
            salePrice = 0.0; 
        }
        System.debug('####'+'Sce 3: Dep Time : Inside Office Hours:END');
        System.debug('####'+'Sce 3:  Dep Time : Inside Office Hours:SALEPRICE'+salePrice);
        return salePrice;
    }
    private Decimal outsideOfficeHoursSce3(Id ssVar1Id){
        System.debug('####'+'Sce 3: Dep Time : Outside Office Hours:BEGIN');
        System.Debug('####List Of Split Hours is'+listOfSplitHoursSpent);
        noOfHoursInOfficeTime=listOfSplitHoursSpent.get(0);
        noOfHoursOutOfficeTime = listOfSplitHoursSpent.get(1);
        noOfHoursInOfficeTimeAgain = listOfSplitHoursSpent.get(2);
        callOutOOHChargeIncludeFirsthour = (mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Call_Out_OOH_Charge_Incl_First_Hour__c;
        callOutChargePerHourThereafter=(mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Call_Out_Charge_Per_Hour_Thereafter__c;
        callOutOOHChargePerHourThereafter = (mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Call_Out_OOH_Charge_Per_Hour_Thereafter__c;
        if(callOutOOHChargeIncludeFirsthour==null){
            System.debug('####callOutOOHChargeIncludeFirsthour is Null, Hence Substituted by 0');
            callOutOOHChargeIncludeFirsthour=0.0;
        }
        if(callOutChargePerHourThereafter==null){
            System.debug('####callOutChargePerHourThereafter is Null, Hence Substituted by 0');
            callOutChargePerHourThereafter=0.0;
        }
        if(callOutOOHChargePerHourThereafter==null){
            System.debug('####callOutOOHChargePerHourThereafter is Null, Hence Substituted by 0');
            callOutOOHChargePerHourThereafter=0.0;
        }
        if(noOfHoursInOfficeTime>=1){
            salePrice = callOutOOHChargeIncludeFirsthour + ((callOutChargePerHourThereafter*(noOfHoursInOfficeTime-1))+(callOutOOHChargePerHourThereafter * noOfHoursOutOfficeTime)+(callOutChargePerHourThereafter*noOfHoursInOfficeTimeAgain));
        }
        if(noOfHoursInOfficeTime<=0 && noOfHoursOutOfficeTime>=1){
            salePrice = callOutOOHChargeIncludeFirsthour + ((callOutChargePerHourThereafter* noOfHoursInOfficeTime)+(callOutOOHChargePerHourThereafter * (noOfHoursOutOfficeTime-1))+(callOutChargePerHourThereafter*noOfHoursInOfficeTimeAgain));
        }
        System.debug('####'+'Sce 3: Dep Time : Outside Office Hours:END');
        System.debug('####'+'Sce 3:  Dep Time : Outside Office Hours:SALEPRICE'+salePrice);
        return salePrice;      
    }
    
    private Decimal insideOfficeHoursSce2(Id ssVar1Id){
        System.debug('####'+'Sce 2: Dep Time : Inside Office Hours:BEGIN');
        System.Debug('####List Of Split Hours is'+listOfSplitHoursSpent);
        noOfHoursInOfficeTime=listOfSplitHoursSpent.get(0);
        noOfHoursOutOfficeTime = listOfSplitHoursSpent.get(1);
        noOfHoursInOfficeTimeAgain = listOfSplitHoursSpent.get(2);
        callOutChargeInclude15min = (mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Call_Out_Charge_Incl_First_15_Minutes__c;
        callOutChargePerHourThereafter=(mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Call_Out_Charge_Per_Hour_Thereafter__c;
        if(callOutChargeInclude15min==null){
            System.debug('####callOutChargeInclude15min is Null, Hence Substituted by 0');
            callOutChargeInclude15min = 0.0;
        }
        if(callOutChargePerHourThereafter==null){
            System.debug('####callOutChargePerHourThereafter is Null, Hence Substituted by 0');
            callOutChargePerHourThereafter = 0.0;
        }
        salePrice = callOutChargeInclude15min +(callOutChargePerHourThereafter*noOfHoursInOfficeTime);
        System.debug('####'+'Sce 2: Dep Time : Inside Office Hours:END');
        System.debug('####'+'Sce 2:  Dep Time : Inside Office Hours:SALEPRICE'+salePrice);
        return salePrice;
    }
    private Decimal outsideOfficeHoursSce2(Id ssVar1Id){
        System.debug('####'+'Sce 2: Dep Time : Outside Office Hours:BEGIN');
        System.Debug('####List Of Split Hours is'+listOfSplitHoursSpent);
        noOfHoursInOfficeTime=listOfSplitHoursSpent.get(0);
        noOfHoursOutOfficeTime = listOfSplitHoursSpent.get(1);
        noOfHoursInOfficeTimeAgain = listOfSplitHoursSpent.get(2);
        callOutOOHChargeInclude15min = (mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Call_Out_OOH_Charge_Incl_First_15_Mins__c;
        callOutChargePerHourThereafter=(mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Call_Out_Charge_Per_Hour_Thereafter__c;
        callOutOOHChargePerHourThereafter = (mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Call_Out_OOH_Charge_Per_Hour_Thereafter__c;
        if(callOutOOHChargeInclude15min==null){
            System.debug('####callOutOOHChargeInclude15min is Null, Hence Substituted by 0');
            callOutOOHChargeInclude15min=0.0;
        }
        if(callOutChargePerHourThereafter==null){
            System.debug('####callOutChargePerHourThereafter is Null, Hence Substituted by 0');
            callOutChargePerHourThereafter=0.0;
        }
        if(callOutOOHChargePerHourThereafter==null){
            System.debug('####callOutOOHChargePerHourThereafter is Null, Hence Substituted by 0');
            callOutOOHChargePerHourThereafter=0.0;
        }
        salePrice = callOutOOHChargeInclude15min + ((callOutChargePerHourThereafter*noOfHoursInOfficeTime)+(callOutOOHChargePerHourThereafter*noOfHoursOutOfficeTime)+(callOutChargePerHourThereafter*noOfHoursInOfficeTimeAgain));
        System.debug('####'+'Sce 2: Dep Time : Outside Office Hours:END');
        System.debug('####'+'Sce 2:  Dep Time : Outside Office Hours:SALEPRICE'+salePrice);
        return salePrice;      
    }
    
    private Decimal insideOfficeHoursPri4CSce1(Id ssVar1id){
        System.debug('####'+'Sce 1: Pri=4C,Dep Time : Inside Office Hours');
        noOfHoursInOfficeTime=listOfSplitHoursSpent.get(0);
        System.debug('####'+noOfHoursInOfficeTime);
        callOutCharge4HourResponse = (mapServiceSheetIdSiteContractRecord.get(ssVar1id)).X4_Hour_Reactive_Call_Out_Charge__c;
        callOutChargePerHourThereafter=(mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Call_Out_Charge_Per_Hour_Thereafter__c;
        if(callOutCharge4HourResponse == null){
            callOutCharge4HourResponse = 0.0;
        }
        if(callOutChargePerHourThereafter == null){
            callOutChargePerHourThereafter = 0.0;
        }
        salePrice = callOutCharge4HourResponse +(callOutChargePerHourThereafter*noOfHoursInOfficeTime);
        System.Debug('####'+salePrice);
        return salePrice;
    }
    private Decimal insideOfficeHoursPri4CSce4(Id ssVar1id){
        System.debug('####'+'Sce 4: Pri=4C,Dep Time : Inside Office Hours:BEGIN');
        System.Debug('####List Of Split Hours is'+listOfSplitHoursSpent);
        noOfHoursInOfficeTime=listOfSplitHoursSpent.get(0);
        noOfHoursOutOfficeTime = listOfSplitHoursSpent.get(1);
        noOfHoursInOfficeTimeAgain = listOfSplitHoursSpent.get(2);
        callOutCharge4HourResponse = (mapServiceSheetIdSiteContractRecord.get(ssVar1id)).X4_Hour_Reactive_Call_Out_Charge__c;
        labourChargePerHour=(mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Labour_Charge__c;
        if(callOutCharge4HourResponse==null){
            System.debug('####callOutCharge4HourResponse is Null, Hence Substituted by 0');
            callOutCharge4HourResponse=0.0;
        }
        if(labourChargePerHour==null){
            System.debug('####labourChargePerHour is Null, Hence Substituted by 0');
            labourChargePerHour=0.0;
        }
        salePrice = callOutCharge4HourResponse +(labourChargePerHour*noOfHoursInOfficeTime);
        System.debug('####'+'Sce 4: Pri=4C,Dep Time : Inside Office Hours:END');
        System.debug('####'+'Sce 4: Pri=4C,Dep Time : Inside Office Hours:SALEPRICE'+salePrice);
        return salePrice;
    }
    private Decimal insideOfficeHoursPriNot4CSce1(Id ssVar1id){
        System.debug('####'+'Sce 1: Pri=NOT4C,Dep Time : Inside Office Hours:BEGIN');
        System.Debug('####List Of Split Hours is'+listOfSplitHoursSpent);
        noOfHoursInOfficeTime=listOfSplitHoursSpent.get(0);
        noOfHoursOutOfficeTime = listOfSplitHoursSpent.get(1);
        noOfHoursInOfficeTimeAgain = listOfSplitHoursSpent.get(2);
        stdReacCallOutCharge = (mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Standard_Reactive_Call_Out_Charge__c;
        callOutChargePerHourThereafter=(mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Call_Out_Charge_Per_Hour_Thereafter__c;
        if(stdReacCallOutCharge == null){
            System.debug('####stdReacCallOutCharge is Null, Hence Substituted by 0');
            stdReacCallOutCharge = 0.0;
        }
        if(callOutChargePerHourThereafter == null){
            System.debug('####callOutChargePerHourThereafter is Null, Hence Substituted by 0');
            callOutChargePerHourThereafter = 0.0;
        }
        salePrice = stdReacCallOutCharge +(callOutChargePerHourThereafter*noOfHoursInOfficeTime);
        System.debug('####'+'Sce 1: Pri=NOT4C,Dep Time : Inside Office Hours:END');
        System.debug('####'+'Sce 1: Pri=NOT4C,Dep Time : Inside Office Hours:SALEPRICE'+salePrice);
        return salePrice;
    } 
    private Decimal insideOfficeHoursPriNot4CSce4(Id ssVar1id){
        System.debug('####'+'Sce 4: Pri=NOT4C,Dep Time : Inside Office Hours:BEGIN');
        System.Debug('####List Of Split Hours is'+listOfSplitHoursSpent);
        noOfHoursInOfficeTime=listOfSplitHoursSpent.get(0);
        noOfHoursOutOfficeTime = listOfSplitHoursSpent.get(1);
        noOfHoursInOfficeTimeAgain = listOfSplitHoursSpent.get(2);
        stdReacCallOutCharge = (mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Standard_Reactive_Call_Out_Charge__c;
        labourChargePerHour=(mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Labour_Charge__c;
        if(stdReacCallOutCharge==null){
            System.debug('####stdReacCallOutCharge is Null, Hence Substituted by 0');
            stdReacCallOutCharge =0.0;
        }
        if(labourChargePerHour==null){
            System.debug('####labourChargePerHour is Null, Hence Substituted by 0');
            labourChargePerHour =0.0;
        }
        salePrice = stdReacCallOutCharge +(labourChargePerHour*noOfHoursInOfficeTime);
        System.debug('####'+'Sce 4: Pri=NOT4C,Dep Time : Inside Office Hours:END');
        System.debug('####'+'Sce 4: Pri=NOT4C,Dep Time : Inside Office Hours:SALEPRICE'+salePrice);
        return salePrice;
    } 
    private Decimal outsideOfficeHoursSce1(Id ssVar1id){
        System.debug('####'+'Sce 1: Pri=4C/NOT4C,Dep Time : Outside Office Hours:BEGIN ');
        System.Debug('####List Of Split Hours is'+listOfSplitHoursSpent);
        noOfHoursInOfficeTime=listOfSplitHoursSpent.get(0);
        noOfHoursOutOfficeTime = listOfSplitHoursSpent.get(1);
        noOfHoursInOfficeTimeAgain = listOfSplitHoursSpent.get(2);
        stdReacCallOutChargeOOH = (mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Standard_Reactive_Call_Out_Charge_OOH__c;
        callOutChargePerHourThereafter=(mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Call_Out_Charge_Per_Hour_Thereafter__c;
        callOutOOHChargePerHourThereafter = (mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Call_Out_OOH_Charge_Per_Hour_Thereafter__c;
        if(stdReacCallOutChargeOOH==null){
            System.debug('####stdReacCallOutChargeOOH is Null, Hence Substituted by 0');
            stdReacCallOutChargeOOH=0.0;    
        }
        if(callOutOOHChargePerHourThereafter==null){
            System.debug('####callOutOOHChargePerHourThereafter is Null, Hence Substituted by 0');
            callOutOOHChargePerHourThereafter=0.0;  
        }
        if(callOutChargePerHourThereafter==null){
            System.debug('####callOutChargePerHourThereafter is Null, Hence Substituted by 0');
            callOutChargePerHourThereafter=0.0;    
        }
        salePrice = stdReacCallOutChargeOOH +((callOutChargePerHourThereafter*noOfHoursInOfficeTime)+(callOutOOHChargePerHourThereafter*noOfHoursOutOfficeTime)+(callOutChargePerHourThereafter*noOfHoursInOfficeTimeAgain));
        System.debug('####'+'Sce 1: Pri=4C/NOT4C,Dep Time : Outside Office Hours:END');
        System.debug('####'+'Sce 1: Pri=4C/NOT4C,Dep Time : Outside Office Hours:SALEPRICE:'+salePrice);
        return salePrice;
    }
    private Decimal outsideOfficeHoursSce4(Id ssVar1id){
        System.debug('####'+'Sce 4: Pri=4C/NOT4C,Dep Time : Outside Office Hours:BEGIN ');
        System.Debug('####List Of Split Hours is'+listOfSplitHoursSpent);
        noOfHoursInOfficeTime=listOfSplitHoursSpent.get(0);
        noOfHoursOutOfficeTime = listOfSplitHoursSpent.get(1);
        noOfHoursInOfficeTimeAgain = listOfSplitHoursSpent.get(2);
        stdReacCallOutChargeOOH = (mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Standard_Reactive_Call_Out_Charge_OOH__c;
        labourChargePerHour=(mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Labour_Charge__c;
        labourOutOfHourCharge = (mapServiceSheetIdSiteContractRecord.get(ssVar1id)).Labour_Out_of_Hour_Charge__c;
        if(stdReacCallOutChargeOOH==null){
            System.debug('####stdReacCallOutChargeOOH is Null, Hence Substituted by 0');
            stdReacCallOutChargeOOH=0.0;
        }
        if(labourChargePerHour==null){
            System.debug('####labourChargePerHour is Null, Hence Substituted by 0');
            labourChargePerHour=0.0;
        }
        if(labourOutOfHourCharge==null){
            System.debug('####labourOutOfHourCharge is Null, Hence Substituted by 0');
            labourOutOfHourCharge=0.0;
        }
        salePrice = stdReacCallOutChargeOOH + ((labourChargePerHour * noOfHoursInOfficeTime)+(labourOutOfHourCharge*noOfHoursOutOfficeTime +(labourChargePerHour*noOfHoursInOfficeTimeAgain)));
        System.debug('####'+'Sce 4: Pri=4C/NOT4C,Dep Time : Outside Office Hours:END');
        System.debug('####'+'Sce 4: Pri=4C/NOT4C,Dep Time : Outside Office Hours:SALEPRICE:'+salePrice);
        return salePrice;
    }
    private Integer getNoOfHoursSpentOnsite(DateTime arrDate,DateTime depDate){ 
        Integer totalHours;
        Decimal decHours = ((depDate.getTime()-arrDate.getTime())/1000/60/60);
        Long decMinsTest = ((depDate.getTime()-arrDate.getTime())/1000/60);
        //if(Math.mod(decMinsTest,60) > 0){
        if(Math.mod(decMinsTest,60) > 15){        //Modified by Puthuvannam for Ticket #SFD000017
            totalHours = Integer.valueOf(decHours+1);
        }
        else{
            totalHours =  Integer.valueOf(decHours);
        }
        System.Debug('#####totalHours'+totalHours);
        return totalHours;
    }
    
    private Boolean getIsOutOfMonFri830AMto5PM(DateTime arrTime,DateTime depTime){
        String arrDateStr = String.valueOf(arrTime.date());
        String depDateStr = String.valueOf(depTime.date());
        DateTime arrDate830oClock = Datetime.ValueOf(arrDateStr+' '+'08:30:00');
        DateTime arrDate5oClock = Datetime.ValueOf(arrDateStr+' '+'17:00:00');
        DateTime depDate830Clock = Datetime.ValueOf(depDateStr+' '+'08:30:00');
        DateTime depDate5oClock = Datetime.ValueOf(depDateStr+' '+'17:00:00');
        String dayOfWeek = depTime.format('E');
        String myTime = String.valueOf(depTime);
        if(arrTime.date()==depTime.date()){
            if(dayofWeek !='Sat' && dayofWeek != 'Sun'){
                if(depTime.getTime() < depDate830Clock.getTime() || depTime.getTime() >depDate5oClock.getTime() ){
                    System.Debug('####'+'Yes, Depart Time is Out of Mon - Fri 8.30 Am to 5.30 Pm'+dayofWeek+'  '+depTime);
                    return true;
                }
            }
        }
        if(arrTime.getTime() < arrDate830oClock.getTime()){
            return true;    
        }
        else if( dayofWeek =='Sat' || dayofWeek == 'Sun' ||(arrTime.date()!=depTime.date())){ // Logic added to check, if depart date is different from arrive date.
            System.Debug('####'+'Yes, Depart Time is Out of Mon - Fri 8.30 Am to 5.30 Pm:Different Arr/Dep Date Logic'+dayofWeek+'  '+depTime);
            return true;   
        }
        System.debug('######:Depart Time is Inside Mon - Fri 8.30 Am to 5.30 Pm '+dayofWeek+'  '+depTime);
        return false;
    }
    
    //This has got into continuous changes-As per requirements
    //
    //Change History: 
    //Modified by Puthuvannam On 13th May, 2014::::: Setting the Access specifier as 'Public' from 'Private' as we need to access this from OpportunityTriggerHandler to calculate the out of hours
    Public List<Integer> getSplitHoursSpentInsideAndOutSideOfficeHours(DateTime arrDate,DateTime depDate){  
        String arrDateStr = String.valueOf(arrDate.date());
        String depDateStr = String.valueOf(depDate.date());
        DateTime arrDate830oClock = Datetime.ValueOf(arrDateStr+' '+'08:30:00');
        DateTime arrDate5oClock = Datetime.ValueOf(arrDateStr+' '+'17:00:00');
        DateTime depDate830Clock = Datetime.ValueOf(depDateStr+' '+'08:30:00');
        DateTime depDate5oClock = Datetime.ValueOf(depDateStr+' '+'17:00:00');
        Integer noOfHoursOnsite = getNoOfHoursSpentOnsite(arrDate,depDate);
        Integer noOfHoursInOfficeTime = 0;
        Integer noOfHoursOutOfficeTime=0;
        Integer noOfHoursInOfficeTimeAgain=0;
        List<Integer> listSplitHours = new List<Integer>();
        String dayOfArr = arrDate.format('E');
        String dayOfDep = depDate.format('E');
        
        if(arrDate.getTime()>= arrDate830oClock.getTime() && arrDate.getTime() <= arrDate5oClock.getTime() && depDate.getTime()<= arrDate5oClock.getTime() && (dayOfDep !='Sat' && dayOfDep != 'Sun')){
            System.debug('####:Arr Time & Dep Time are inside 8.30AM to 5PM,Same Day');
            noOfHoursInOfficeTime = noOfHoursOnsite;
            listSplitHours = splitHoursHelper(noOfHoursInOfficeTime,noOfHoursOutOfficeTime,noOfHoursInOfficeTimeAgain);
        }
        else if(arrDate.getTime()>= arrDate5oClock.getTime() && depDate.getTime()>= arrDate5oClock.getTime()){
            System.debug('####:Arr Time after 5PM and Dep Time after 5Pm...');
            if((depDate.getTime()<depDate830Clock.getTime())|| (dayOfDep=='Sat' || dayOfDep=='Sun')){
                System.debug('####:Arr Time after 5PM and Dep Time after 5Pm...&& Dep Time before 8.30 AM next day ');
                noOfHoursOutOfficeTime = getNoOfHoursSpentOnsite(arrDate,depDate);   
            }else if((depDate.getTime()>=depDate830Clock.getTime())&& (depDate.date()> arrDate.date())){
                System.debug('####:Arr Time after 5PM and Dep Time after 5Pm...&& Dep Time after 8.30 AM next day ');
                noOfHoursOutOfficeTime = getNoOfHoursSpentOnsite(arrDate,depDate830Clock);   
                noOfHoursInOfficeTimeAgain = getNoOfHoursSpentOnsite(depDate830Clock,depDate);
            }else if(arrDate.getTime()> =arrDate5oClock.getTime() && depDate.getTime()>= arrDate5oClock.getTime() && (depDate.date() == arrDate.date()) ){
                System.debug('####:Arr Time after 5PM and Dep Time after 5Pm...&& Same Day ');
                noOfHoursOutOfficeTime = getNoOfHoursSpentOnsite(arrDate,depDate);  
            }
            listSplitHours = splitHoursHelper(noOfHoursInOfficeTime,noOfHoursOutOfficeTime,noOfHoursInOfficeTimeAgain);
        }
        else if(arrDate.getTime()< arrDate5oClock.getTime() && depDate.getTime()>= arrDate5oClock.getTime()){
            noOfHoursInOfficeTime = getNoOfHoursSpentOnsite(arrDate,arrDate5oClock);
            noOfHoursOutOfficeTime = getNoOfHoursSpentOnsite(arrDate5oClock,depDate); 
            if((depDate.getTime()>=depDate830Clock.getTime())&& (depDate.date()> arrDate.date()) && (dayOfDep !='Sat' && dayOfDep != 'Sun')){
                System.Debug('#### Depart Next Day after 8.30 AM');
                noOfHoursOutOfficeTime = getNoOfHoursSpentOnsite(arrDate5oClock,depDate830Clock);   
                noOfHoursInOfficeTimeAgain = getNoOfHoursSpentOnsite(depDate830Clock,depDate);
            }
            if(arrDate.getTime()<=arrDate830oClock.getTime() && depDate.getTime()>= arrDate5oClock.getTime() ){
                noOfHoursInOfficeTime = getNoOfHoursSpentOnsite(arrDate830oClock,arrDate5oClock);
                noOfHoursOutOfficeTime = getNoOfHoursSpentOnsite(arrDate,arrDate830oClock);
                noOfHoursOutOfficeTime = noOfHoursOutOfficeTime+getNoOfHoursSpentOnsite(arrDate5oClock,depDate);
                if(depDate.Date()>arrDate.Date() && depDate.getTime() < depDate830Clock.getTime() ){
                    noOfHoursOutOfficeTime = getNoOfHoursSpentOnsite(arrDate5oClock,depDate);
                }
                if(depDate.Date()>arrDate.Date() && depDate.getTime() > depDate830Clock.getTime() ){
                    noOfHoursOutOfficeTime = getNoOfHoursSpentOnsite(arrDate5oClock,depDate830Clock);
                    noOfHoursInOfficeTimeAgain = getNoOfHoursSpentOnsite(depDate830Clock,depDate);
                }
            }
            listSplitHours = splitHoursHelper(noOfHoursInOfficeTime,noOfHoursOutOfficeTime,noOfHoursInOfficeTimeAgain);
        }
        else if(arrDate.getTime()<arrDate830oClock.getTime()&&depDate.getTime()<arrDate5oClock.getTime() ){
            if(dayOfDep !='Sat' && dayOfDep != 'Sun'){
                noOfHoursInOfficeTime = getNoOfHoursSpentOnsite(arrDate830oClock,depDate);
                noOfHoursOutOfficeTime = getNoOfHoursSpentOnsite(arrDate,arrDate830oClock);
            }
            else if(dayOfDep=='Sat' || dayOfDep=='Sun'){
                noOfHoursOutOfficeTime = getNoOfHoursSpentOnsite(arrDate,depDate);  
            }
            listSplitHours = splitHoursHelper(noOfHoursInOfficeTime,noOfHoursOutOfficeTime,noOfHoursInOfficeTimeAgain);
        }
        System.debug('#########'+listSplitHours);
        return listSplitHours;   
    }
    private List<Integer> splitHoursHelper(Integer noOfHoursInOfficeTime,Integer noOfHoursOutOfficeTime, Integer noOfHoursInOfficeTimeAgain ){
        List<Integer> listInOutOfficeHours = new List<Integer>();
        listInOutOfficeHours.add(noOfHoursInOfficeTime);
        listInOutOfficeHours.add(noOfHoursOutOfficeTime);
        listInOutOfficeHours.add(noOfHoursInOfficeTimeAgain);
        return listInOutOfficeHours;
    }
}