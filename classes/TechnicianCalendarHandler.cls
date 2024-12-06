/*============================================================================================================
*Class Name     : TechnicianCalendarHandler 
*Description    : All the Technician Visit Details handled here.
*Company        : Puthuvannam Technology Solutions Pvt Ltd.
*Date           : 17th Sep, 2014
*Version        : 1.0
*Change History : Initial Trigger Handler
*============================================================================================================*/


global  class TechnicianCalendarHandler {
    
    public transient list<calEvent> BookingLists {get;set;}
    transient Engineer__c technicianId;
    //The calendar plugin is expecting dates is a certain format. We can use this string to get it formated correctly
    String dtFormat = 'EEE, d MMM yyyy HH:mm:ss z';
    
    transient Map<id,Visits__c > visitMap;
    Map<id,Holiday> HolidayMap; 
    
    transient  List<Service_Sheet_STD__c> RSRecord;
    transient List<Engineer_Checklist__c> SSRecord ;
    transient List<Mechanical_Service_Sheet__c> MSSRecord ;
    transient List<Small_Works__c> SWRecord ;
    transient List<Project_Sheet__c> PSRecord;
    
    transient Map<string,siteContractValues> rsMap =  new Map<string,siteContractValues>();
    transient Map<string,siteContractValues> ssMap =  new Map<string,siteContractValues>();
    transient Map<string,siteContractValues> mssMap =  new Map<string,siteContractValues>();
    transient Map<string,siteContractValues> swMap =  new Map<string,siteContractValues>();
    transient Map<string,siteContractValues> psMap =  new Map<string,siteContractValues>();

    public TechnicianCalendarHandler(ApexPages.StandardController controller) {
        this.technicianId = (Engineer__c)controller.getRecord();
        visitMap = new Map<id,Visits__c >([Select id,Engineer2__c,TechnicianCaladerStartDateTime__c,TechnicianCaladerEndDateTime__c,Requested_Attendance_Time__c,Visit_Postcode__c,FE_Total_Formula__c,Visit_Complete__c,Booked_with_Customers__c,Site_Contract__r.Type_of_Panel_DVR__c,Site_Contract__r.Job_Time__c,Site_Contract__r.Spend_Limit__c,Site_Contract__r.Service_Charge__c,X2nd_Technician__c,Actual_Service_Date__c,End_Date__c, Name, Visit_Type__c,Call_Out_Types__c,Site__r.name,Service_Type__c,Mechanical_Service_Sheet_Numbers__c,Reactive_Sheet_Number__c,Small_Works_Sheet_Number__c,Service_Sheet_Number__c,Project_Sheet_Number__c 
                                           From Visits__c  
                                           Where (X2nd_Technician__c=:technicianId.id or Engineer2__c=:technicianId.id) and Actual_Service_Date__c!=null ORDER BY createddate desc LIMIT 900]);  
        
        
        HolidayMap  = new Map<id,Holiday>([Select Name, Id, ActivityDate From Holiday limit 1000]);  
        
  
        siteContractValues scValues;
        try{
            RSRecord  = [SELECT id,name,Visit__c, createddate,Site_Contract__r.Job_Time__c,Site_Contract__r.Job_time_value__c  
                         FROM Service_Sheet_STD__c 
                         WHERE Visit__c 
                         IN :visitMap.keyset() and (Site_Contract__r.Job_Time__c != null) ORDER BY createddate desc LIMIT 700];
            if(RSRecord != null)
            {
            for(Service_Sheet_STD__c rs:RSRecord){
             scValues = new siteContractValues();
              scValues.scpaneldvr =rs.Site_Contract__r.Type_of_Panel_DVR__c;
              scValues.scjobtime = rs.Site_Contract__r.Job_Time__c;
              rsMap.put(rs.name,scValues);
             }
            }             
        }
        catch(exception e){
            
        }  

         
        try{                                
            SSRecord  = [SELECT id,name,Visit__c, createddate,Site_Contract__r.Type_of_Panel_DVR__c,Site_Contract__r.Job_Time__c,Site_Contract__r.Job_time_value__c  
                         FROM Engineer_Checklist__c 
                         WHERE Visit__c 
                         IN :visitMap.keyset() and (Site_Contract__r.Job_Time__c != null) ORDER BY createddate desc LIMIT 700];
        
         if(SSRecord != null)
            {
            for(Engineer_Checklist__c ss: SSRecord){
            scValues = new siteContractValues();
              scValues.scpaneldvr = ss.Site_Contract__r.Type_of_Panel_DVR__c;
              scValues.scjobtime = ss.Site_Contract__r.Job_Time__c;
              ssMap.put(ss.name,scValues);
             }
            }    
        
        }
        catch(exception e){
            
        } 
        
       
        try{                                 
            MSSRecord  = [SELECT id,name,Visit__c, createddate,Site_Contract__r.Type_of_Panel_DVR__c,Site_Contract__r.Job_Time__c,Site_Contract__r.Job_time_value__c  
                          FROM Mechanical_Service_Sheet__c
                          WHERE Visit__c 
                          IN :visitMap.keyset() and (Site_Contract__r.Job_Time__c != null) ORDER BY createddate desc LIMIT 700];
         if(MSSRecord != null)
            {
            for(Mechanical_Service_Sheet__c mss: MSSRecord){
            scValues = new siteContractValues();
              scValues.scpaneldvr = mss.Site_Contract__r.Type_of_Panel_DVR__c;
              scValues.scjobtime = mss.Site_Contract__r.Job_Time__c;
              mssMap.put(mss.name,scValues);
             }
            }
        
        
        }
        catch(exception e){
            
        }                                  
        
      
        try{                                
            SWRecord  = [SELECT id,name,Visit__c, createddate,Site_Contract__r.Type_of_Panel_DVR__c,Site_Contract__r.Job_Time__c,Site_Contract__r.Job_time_value__c  
                         FROM Small_Works__c 
                         WHERE Visit__c 
                         IN :visitMap.keyset() and (Site_Contract__r.Job_Time__c != null) ORDER BY createddate desc LIMIT 700];
        
         if(SWRecord  != null)
            {
            for(Small_Works__c sw: SWRecord  ){
            scValues = new siteContractValues();
              scValues.scpaneldvr = sw.Site_Contract__r.Type_of_Panel_DVR__c;
              scValues.scjobtime = sw.Site_Contract__r.Job_Time__c;
              swMap.put(sw.name,scValues);
             }
            }
         
        }
        catch(exception e){
            
        }
        
        try{                                 
            PSRecord  = [SELECT id,name,Visit__c, createddate,Site_Contract__r.Type_of_Panel_DVR__c,Site_Contract__r.Job_Time__c,Site_Contract__r.Job_time_value__c  
                         FROM Project_Sheet__c 
                         WHERE Visit__c 
                         IN :visitMap.keyset() and (Site_Contract__r.Job_Time__c != null) ORDER BY createddate desc LIMIT 700];                                                                                                                                          
        
        
         if(PSRecord  != null)
            {
            for(Project_Sheet__c ps: PSRecord  ){
            scValues = new siteContractValues();
              scValues.scpaneldvr = ps.Site_Contract__r.Type_of_Panel_DVR__c;
              scValues.scjobtime = ps.Site_Contract__r.Job_Time__c;
              psMap.put(ps.name,scValues);
             }
            }
            
        
        }
        catch(exception e){
            
        }
        
     
    }
    
    
    public PageReference pageLoad() {
        BookingLists = new list<calEvent>();
        
        
         transient String LeastSSName = 'NA';
         transient String SSName = 'NA';
        //Get my BookingLists if we have selected the correct option
        for(Visits__c v : visitMap.values()){
           
            DateTime startDT = v.Actual_Service_Date__c;
            string startdate = v.TechnicianCaladerStartDateTime__c;
            string enddate = v.TechnicianCaladerEndDateTime__c;
            DateTime endDT = v.End_Date__c;
            calEvent myEvent = new calEvent();
            myEvent.title ='Visit : '+ v.name;
           
            if(v.Service_Sheet_Number__c != Null){LeastSSName = v.Service_Sheet_Number__c; SSName = 'SS';
           
            }else if(v.Mechanical_Service_Sheet_Numbers__c != Null){LeastSSName = v.Mechanical_Service_Sheet_Numbers__c;SSName = 'MSS';
            
            }else if(v.Reactive_Sheet_Number__c!= Null){LeastSSName = v.Reactive_Sheet_Number__c;SSName = 'RS';
            
            }else if(v.Small_Works_Sheet_Number__c!= Null){LeastSSName = v.Small_Works_Sheet_Number__c;SSName = 'SW';

            }else if(v.Project_Sheet_Number__c!= Null){LeastSSName = v.Project_Sheet_Number__c;SSName = 'PS';
            
            }else{
             LeastSSName  = 'NA';
            }
            
           
            myEvent.serviceType =(v.Service_Type__c != null ? 'Service Type: '+ v.Service_Type__c :'Service Type: ') ;   
            myEvent.visitType =(v.Visit_Type__c != null ? 'Visit Type: '+ v.Visit_Type__c :'Visit Type: ') ;   
                      
            myEvent.siteName =(v.Site__r.name != null ? 'Site Name: '+ v.Site__r.name :'Site Name: ') ;
            myEvent.servicecharge =(v.Site_Contract__r.Service_Charge__c != null ? 'Service Charge: '+ v.Site_Contract__r.Service_Charge__c :'Service Charge: 0.0') ;
            myEvent.postCode =(v.Visit_Postcode__c != null ? 'PostCode: '+ v.Visit_Postcode__c :'PostCode: ') ;
            myEvent.feTotal=(v.FE_Total_Formula__c!= null ? 'FE Total: '+ v.FE_Total_Formula__c:'FE Total: ') ;
            myEvent.attendanceTime=(v.Requested_Attendance_Time__c!= null ? 'Requested Attendance Time: '+ v.Requested_Attendance_Time__c:'Requested Attendance Time:') ;
            
            myEvent.spendLimit=(v.Site_Contract__r.Spend_Limit__c != null ? 'Spend Limit: '+ v.Site_Contract__r.Spend_Limit__c:'Spend Limit: ') ;
            
            myEvent.spend  = (v.Site_Contract__r.Spend_Limit__c != null ? v.Site_Contract__r.Spend_Limit__c  :'0.0') ;
            myEvent.scharge  = (v.Site_Contract__r.Service_Charge__c != null ? v.Site_Contract__r.Service_Charge__c :0.0) ;
            
            //myEvent.scpaneldvr = (v.Site_Contract__r.Type_of_Panel_DVR__c!= null ? 'Type of Panel DVR: '+ v.Site_Contract__r.Type_of_Panel_DVR__c:'Type of Panel DVR: ') ;
            //myEvent.scjobtime = (v.Site_Contract__r.Job_Time__c != null ? 'Job Time: '+ v.Site_Contract__r.Job_Time__c:'Job Time: ') ;
             
             
            if(LeastSSName != 'NA'  && rsMap.get(LeastSSName) != null && SSName == 'RS'){
            myEvent.scpaneldvr = (rsMap.get(LeastSSName).scpaneldvr != null ? 'Type of Panel DVR: '+rsMap.get(LeastSSName).scpaneldvr:'Type of Panel DVR: ');
            myEvent.scjobtime = (string.valueOf(rsMap.get(LeastSSName).scjobtime) != null ? 'Job Time: '+ string.valueOf(rsMap.get(LeastSSName).scjobtime) :'Job Time: '); 
            }
            else{
            myEvent.scpaneldvr = 'Type of Panel DVR: ';
            myEvent.scjobtime = 'Job Time: ';
            }
            
            if(LeastSSName != 'NA'  && ssMap.get(LeastSSName) != null  && SSName == 'SS'){
            myEvent.scpaneldvr = (ssMap.get(LeastSSName).scpaneldvr != null ? 'Type of Panel DVR: '+ssMap.get(LeastSSName).scpaneldvr:'Type of Panel DVR: ');
            myEvent.scjobtime = (string.valueOf(ssMap.get(LeastSSName).scjobtime) != null ? 'Job Time: '+ string.valueOf(ssMap.get(LeastSSName).scjobtime) :'Job Time: '); 
            }
            else{
            myEvent.scpaneldvr = 'Type of Panel DVR: ';
            myEvent.scjobtime = 'Job Time: ';
            }
            
            if(LeastSSName != 'NA'  &&  mssMap.get(LeastSSName) != null  && SSName == 'MSS'){
            myEvent.scpaneldvr = (mssMap.get(LeastSSName).scpaneldvr != null ? 'Type of Panel DVR: '+mssMap.get(LeastSSName).scpaneldvr:'Type of Panel DVR: ');
            myEvent.scjobtime = (string.valueOf(mssMap.get(LeastSSName).scjobtime) != null ? 'Job Time: '+ string.valueOf(mssMap.get(LeastSSName).scjobtime) :'Job Time: '); 
            }
            else{
            myEvent.scpaneldvr = 'Type of Panel DVR: ';
            myEvent.scjobtime = 'Job Time: ';
            }
            
            if(LeastSSName != 'NA'  && swMap.get(LeastSSName) != null && SSName == 'SW'){
            myEvent.scpaneldvr = (swMap.get(LeastSSName).scpaneldvr != null ? 'Type of Panel DVR: '+swMap.get(LeastSSName).scpaneldvr:'Type of Panel DVR: ');
            myEvent.scjobtime = (string.valueOf(swMap.get(LeastSSName).scjobtime) != null ? 'Job Time: '+ string.valueOf(swMap.get(LeastSSName).scjobtime) :'Job Time: '); 
            }
            else{
            myEvent.scpaneldvr = 'Type of Panel DVR: ';
            myEvent.scjobtime = 'Job Time: ';
            }
            
            if(LeastSSName != 'NA'  && psMap.get(LeastSSName) != null && SSName == 'PS'){
            myEvent.scpaneldvr = (psMap.get(LeastSSName).scpaneldvr != null ? 'Type of Panel DVR: '+psMap.get(LeastSSName).scpaneldvr:'Type of Panel DVR: ');
            myEvent.scjobtime = (string.valueOf(psMap.get(LeastSSName).scjobtime) != null ? 'Job Time: '+ string.valueOf(psMap.get(LeastSSName).scjobtime) :'Job Time: '); 
            }
            else{
            myEvent.scpaneldvr = 'Type of Panel DVR: ';
            myEvent.scjobtime = 'Job Time: ';
            }
            
            myEvent.url = '/' + v.Id ;
            
             if(v.End_Date__c != null){
             myEvent.startString =startdate ;
             myEvent.endString = enddate;
            }
            if(v.End_Date__c == null){
             myEvent.startString =startdate ;
             myEvent.endString = startdate ;
            }
           
            if(v.Visit_Complete__c == true){
                myEvent.className = 'complete';
                BookingLists.add(myEvent);
            }
            else if(v.Booked_with_Customers__c=='Yes' && v.Actual_Service_Date__c == date.today()){
                myEvent.className = 'bookedtoday';
                BookingLists.add(myEvent);
            }
            else if(v.Booked_with_Customers__c=='Yes'){
                myEvent.className = 'bookedwithcustomers';
                BookingLists.add(myEvent);
            }
            else if(v.Booked_with_Customers__c=='Waiting P/O' || v.Booked_with_Customers__c=='Waiting Permit' || v.Booked_with_Customers__c=='Waiting Confirmation'){
                myEvent.className = 'bookedwithcustomersothers';
                BookingLists.add(myEvent);
            }
            else if(v.Booked_with_Customers__c=='Booked Via Schedule'){
                myEvent.className = 'scheduled-work';
                BookingLists.add(myEvent);
            }
            else if(v.Visit_Type__c =='Holiday'){
                myEvent.className = 'holiday';
                BookingLists.add(myEvent);
            }
            else if(v.Visit_Type__c =='Projects'){
                myEvent.className = 'projects';
                BookingLists.add(myEvent);
            }
            else if(v.Call_Out_Types__c =='Call Out'){
                myEvent.className = 'call-out-day';
                BookingLists.add(myEvent);
            }
            else if(v.Call_Out_Types__c =='Small Works'){
                myEvent.className = 'small-works';
                BookingLists.add(myEvent);
            }
            
            else{
                myEvent.className = 'no-work';
                BookingLists.add(myEvent);
            }
            
        }
        
        for(Holiday h:HolidayMap.values()){
            DateTime startDT = h.ActivityDate;
            DateTime endDT = h.ActivityDate;
            calEvent myEvent = new calEvent();
            
            myEvent.title = h.name;
            myEvent.startString = startDT.format(dtFormat,'America/Los_Angeles');
            myEvent.endString = startDT.format(dtFormat,'America/Los_Angeles');
            myEvent.className = 'holiday';
            BookingLists.add(myEvent);
        }
        return null;
    }
     public class siteContractValues{
         public transient String scpaneldvr{get;set;}
         public transient decimal  scjobtime{get;set;}
     }
    //Class to hold calendar event data
    public class calEvent{
        public transient String title {get;set;}
        public transient String serviceType {get;set;}
        public transient String visitType {get;set;}
        public transient String siteName {get;set;}
        
        public transient String spend {get;set;}
        Public transient decimal scharge{get;set;}
        
        Public transient String startString {get;set;}
        Public transient String endString {get;set;}
        Public transient String url {get;set;}
        Public transient String className {get;set;}
        Public transient String servicecharge {get;set;}
        Public transient String postCode {get;set;}
        Public transient String feTotal{get;set;}
        Public transient String attendanceTime{get;set;}
        Public transient String holidayName{get;set;}
        Public transient String spendLimit{get;set;}
        
        
        
        Public transient String scpaneldvr{get;set;}
        Public transient String scjobtime{get;set;}
        

        
    }
    
    @RemoteAction
    global static Visits__c UpdateVisit(string actualServiceDate, string endDate, string visitURL) {
        Visits__c updateVisit = new Visits__c();
        Map<id,Holiday> HolidayMap = new Map<id,Holiday>([Select Name, Id, ActivityDate From Holiday limit 50000]);  
        DateTime dragStartDate ;
        DateTime dragEndDate ;
        String dtFormat = 'EEE, d MMM yyyy HH:mm:ss z';
        
        
        
        List <String> stringParts1 = actualServiceDate.split('T');
        List <String> stringParts = stringParts1[0].split('-');
        List <String> timeParts = stringParts1[1].split(':');
        dragStartDate = DateTime.newInstanceGmt(Integer.valueOf(stringParts[0]), Integer.valueOf(stringParts[1]), Integer.valueOf(stringParts[2]), Integer.valueOf(timeParts[0]), Integer.valueOf(timeParts[1]), Integer.valueOf(timeParts[2]));
        
        if(endDate!=null){
            List <String> stringEndParts1 = endDate.split('T');
            List <String> stringEndParts = stringEndParts1[0].split('-');
            List <String> timeEndParts = stringEndParts1[1].split(':');
            dragEndDate = DateTime.newInstanceGmt(Integer.valueOf(stringEndParts[0]), Integer.valueOf(stringEndParts[1]), Integer.valueOf(stringEndParts[2]), Integer.valueOf(timeEndParts[0]), Integer.valueOf(timeEndParts[1]), Integer.valueOf(timeEndParts[2]));
            
            list<string> IdList=visitURL.split('/');
            updateVisit =[Select id,Engineer2__c,X2nd_Technician__c,Actual_Service_Date__c,End_Date__c, Name, Visit_Type__c,Call_Out_Types__c 
                          From Visits__c  where id =:IdList[1]];
            
            
            for(Holiday h:HolidayMap.values()){
                if(h.ActivityDate ==dragStartDate.date() || h.ActivityDate == dragEndDate.date() || (h.ActivityDate >= dragStartDate.date() && h.ActivityDate <= dragEndDate.date() )  ){
                    throw new RecordNotFoundException('Visit date is Holiday');
                }
            }
            
            updateVisit.Actual_Service_Date__c=dragStartDate.date();
            updateVisit.End_Date__c = dragEndDate.date();
            
            
            
        }else{    dragEndDate  = dragStartDate;  }    
        if(!Test.isRunningTest()){
            if(updateVisit != null) {  update updateVisit; }
        }
        return updateVisit;
    }
    
    
    public class RecordNotFoundException extends Exception { }
    
}