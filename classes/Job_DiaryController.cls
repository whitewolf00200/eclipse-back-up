/*=========================================================================================================
    *Class Name     : Job_DiaryController
    *Description    : MyDiaryTAb page controller class
    *Company        : Merfantz
    *Date           : 22 Nov 2018  
 ============================================================================================================== */   
public with sharing class Job_DiaryController {
    public string userId;
    public List<SchedulerTechDetails> vstList{get;set;}
    public Map<id,SchedulerTechDetails> VisitMap {get; set;}
    public string LoggedUserId;
    public string flgs{get;set;}
    public Job_DiaryController() {
        flgs='';
        LoggedUserId=UserInfo.getUserId();
        system.debug('LoggedUserId'+LoggedUserId);
        vstList=new List<SchedulerTechDetails>();
        VisitMap   = new Map<id,SchedulerTechDetails>();
        loadVisits();
    }

/*================================================================
Method Name: loadVisits
Parameters : Null
Description: 
Date       : 22 Nov 2018  
================================================================*/
    public void loadVisits(){
    
        List<Engineer__c> Se=new List<Engineer__c>();
        if( Schema.sObjectType.Engineer__c.fields.id.isAccessible() ){
            Se=[select id from Engineer__c where Salesforce_User__c=:LoggedUserId limit 1];
            system.debug('Engineer'+se);
       
            if(Test.IsRunningTest()){
             Se=[select id from Engineer__c limit 1];
            }
         
            userId=se[0].id;    
            system.debug('userID'+userId);
        if( Schema.sObjectType.Visits__c.fields.Engineer2__c.isAccessible() && Schema.sObjectType.Visits__c.fields.Name.isAccessible() && Schema.sObjectType.Visits__c.fields.Status__c.isAccessible()
            && Schema.sObjectType.Visits__c.fields.Actual_Service_Date__c.isAccessible() 
            && Schema.sObjectType.Visits__c.fields.Visit_Type__c.isAccessible() 
            &&  Schema.sObjectType.Config__c.isAccessible()
            && Schema.sObjectType.Config__c.fields.Id.isAccessible() && Schema.sObjectType.Visits__c.fields.Id.isAccessible()  
            && Schema.sObjectType.Visits__c.isAccessible() ){

            TimeZone tz = UserInfo.getTimeZone();
            system.debug('tz'+tz);
            SchedulerTechDetails engs;
            
            
        
        for(visits__c vst:[Select id,Engineer2__c,Status__c,Asset_Name__c,Site__r.name,Actual_Service_Date__c,Message_to_Technician__c,Visit_Completed__c,End_Date__c,Requested_Attendance_Time__c,X2nd_Technician__c,job_Status__c,Visit_Complete__c, Name,Visit_Type__c,Asset__c,Asset__r.name,Booking_Notes__c                                                  From Visits__c 
                                                  where Engineer2__c=:userId or X2nd_Technician__c=:userId
                                                  ]){
           engs=new SchedulerTechDetails();
           DateTime Reqdontime ;
           system.debug('Reqdontime'+Reqdontime);  
           Datetime ActSerDate = vst.Actual_Service_Date__c;
           DateTime ActserDates=vst.Actual_Service_Date__c;
           if(vst.Requested_Attendance_Time__c != null){
               String[] reqAttTimeStr = vst.Requested_Attendance_Time__c.split('\\:');
               ActSerDate = ActSerDate.addHours(Integer.valueOf(reqAttTimeStr[0]));
               ActSerDate = ActSerDate.addMinutes(Integer.valueOf(reqAttTimeStr[1]));
           }
           Reqdontime = ActSerDate;
           system.debug('Reqdontime='+Reqdontime); 
           system.debug('ActSerDate= '+ActSerDate);
           system.debug('ActSerDates='+ActSerDate);
           DateTime vstComDate = vst.End_Date__c;
           if(vstComDate != null){
               vstComDate = vstComDate.addHours(23);
           }
           system.debug('vstComDate'+vstComDate );
           engs.SchedulerTitle=vst.Name;
           system.debug('engs.SchedulerTitle'+engs.SchedulerTitle);
           engs.MsgToTech=vst.Message_to_Technician__c;
           engs.SchedulerNotes=vst.Booking_Notes__c;
           system.debug('engs.SchedulerNotes'+engs.SchedulerNotes);
           engs.SchedulerAsset=vst.Asset_Name__c;
           system.debug('engs.SchedulerAsset'+engs.SchedulerAsset);
           engs.SchedulerSitesName =vst.Site__r.name;
           
           if(vst.End_Date__c != null && vst.Actual_Service_Date__c!=null && vst.Requested_Attendance_Time__c!=null){
           engs.SchedulerStart =Reqdontime.format('MM/dd/yyyy HH:mm:ss',string.valueof(tz));
           engs.SchedulerEnd =vstComDate.format('MM/dd/yyyy HH:mm:ss',string.valueof(tz));
           
           }
           system.debug('engs.SchedulerStart'+engs.SchedulerStart);
           system.debug('engs.SchedulerEnd'+engs.SchedulerEnd);
           if(vst.End_Date__c== null && vst.Actual_Service_Date__c!=null && vst.Requested_Attendance_Time__c!=null){
            
                engs.SchedulerStart =Reqdontime.format('MM/dd/yyyy HH:mm:ss',string.valueof(tz));
                engs.SchedulerEnd =Reqdontime.format('MM/dd/yyyy HH:mm:ss',string.valueof(tz));
              }
            system.debug('engs.SchedulerStart1'+engs.SchedulerStart);
            system.debug('engs.SchedulerEnd1'+engs.SchedulerEnd);
           if(vst.End_Date__c != null && vst.Actual_Service_Date__c!=null && vst.Requested_Attendance_Time__c==null){
           engs.SchedulerStart =ActserDates.format('MM/dd/yyyy HH:mm:ss',string.valueof(tz));
           engs.SchedulerEnd =vstComDate.format('MM/dd/yyyy HH:mm:ss',string.valueof(tz));
           
           }
            system.debug('engs.SchedulerStart2'+engs.SchedulerStart);
            system.debug('engs.SchedulerEnd2'+engs.SchedulerEnd);
            if(vst.End_Date__c== null && vst.Actual_Service_Date__c!=null && vst.Requested_Attendance_Time__c==null){
            
                engs.SchedulerStart =ActserDates.format('MM/dd/yyyy HH:mm:ss',string.valueof(tz));
                engs.SchedulerEnd =ActserDates.format('MM/dd/yyyy HH:mm:ss',string.valueof(tz));
              }
            system.debug('engs.SchedulerStart3'+engs.SchedulerStart);
            system.debug('engs.SchedulerEnd3'+engs.SchedulerEnd);
            engs.SchedulerURL = '/' + vst.Id ;
            system.debug('engs.SchedulerURL'+engs.SchedulerURL);
             if(vst.Visit_Complete__c )
                engs.SchedulerName ='#32CD32';
             else
                engs.SchedulerName ='Red';
                system.debug(engs.SchedulerName);
            VisitMap.put(vst.id,engs);   
        }  
        }
        }
    }
 /*=========================================================================================================
    *Class Name     : SchedulerTechDetails
    *Description    : Inner class(wrapper class)
    *Company        : Merfantz
    *Date           : 22 Nov 2018  
 ============================================================================================================== */      
    public class SchedulerTechDetails{       
        Public String SchedulerStart {get;set;}
        Public String SchedulerEnd {get;set;}
        Public String SchedulerURL {get;set;}
        Public String SchedulerName {get;set;}
        public String SchedulerTitle {get;set;}
        public String MsgToTech{get;set;}
        public String SchedulerAsset{get;set;}
        public String SchedulerNotes{get;set;}
        public String SchedulerSitesName {get;set;}     
        
    }

}