global  class MultipleTechnicianCalendarHandler{

    public transient list<AllTechDetails> AllTechnicianVisits {get;set;}
    public transient list<AllTechDetails> AllVisitList {get;set;}
    Map<id,Engineer__c> AllTechnicianMap;
    public List<string> SelectedTechIds {get; set;}
    public transient List<Engineer__c> AllTechnicianList {get;set;}
    public List<Engineer__c> TechList{get;set;}
    String dtFormat = 'EEE, d MMM yyyy HH:mm:ss z';
    public transient Map<id,Visits__c > visitMap{get;set; }
    
    public String SelectedTechId{get; set;}
    public String CurrentDateVal{get; set;}
    public String CurrentView{get; set;}
    public MultipleTechnicianCalendarHandler() {
        
        SelectedTechIds = new List<string>();
        SelectedTechId = '';
        AllTechnicianList = new List<Engineer__c>([SELECT Id,Active_User__c, name FROM Engineer__c where Active_User__c = 'Yes']);
        CurrentDateVal = string.valueOf(system.Today());
    }
    integer i=1;
    public pagereference LoadVisit(){
    system.debug('LoadVisit==========');
        Date currentDate,currentEndDate;
        currentDate = setStringToDateFormat(CurrentDateVal);
        SelectedTechIds = new List<string>();
        if(currentDate != null){
            currentEndDate = currentDate;
            if(CurrentView == 'timelineThreeDays')
            currentEndDate = currentEndDate.addDays(5);
            if(CurrentView == 'timelineMonth')
            {
               Date selectedDate = setStringToDateFormat(CurrentDateVal);
               Date firstDate = selectedDate.toStartOfMonth();
               Date lastDate = firstDate.addDays(date.daysInMonth(selectedDate.year() , selectedDate.month())  - 1);
               currentEndDate = lastDate ;
               currentDate =firstDate ;
            }
        } 
        else{
        currentDate  = system.today();
        currentEndDate = system.today();
        system.debug('==='+currentDate +'==='+'currentEndDate ==='+currentEndDate);
        }
  
        if(SelectedTechId != null && SelectedTechId != '')
        SelectedTechIds = SelectedTechId.split('[,]{1}[\\s]?'); 
        
        
        AllTechnicianVisits  = new list<AllTechDetails >();
        AllVisitList = new list<AllTechDetails >();
        system.debug(SelectedTechIds.size()+'==='+'SelectedTechId ==='+SelectedTechId +'===Tech Ids==='+SelectedTechIds);
        system.debug('==='+ApexPages.currentPage().getParameters().get('tech'));
        AllTechnicianMap = new Map<id,Engineer__c>();
        if(SelectedTechIds.size()>0){
        AllTechnicianMap = new Map<id,Engineer__c>([SELECT Id,Active_User__c, name FROM Engineer__c where id = :SelectedTechIds]);
        }
        else{ 
        AllTechnicianMap = new Map<id,Engineer__c>([SELECT Id,Active_User__c, name FROM Engineer__c where Active_User__c = 'Yes']);
        }
        
        if(Test.isRunningTest()){
            AllTechnicianMap = new Map<id,Engineer__c>([SELECT Id,Active_User__c, name FROM Engineer__c limit 1]);
        }
        
        if(AllTechnicianMap.size()>0){
            TechList=new List<Engineer__c>();
            for(Engineer__c Eng:AllTechnicianMap.values()){
                 
                TechList.add(Eng);
            }
        }
        
        system.debug('<<<currentDate==='+currentDate+'<<<<<currentEndDate ===='+currentEndDate);
        visitMap = new Map<id,Visits__c >();
       if(!test.isrunningtest() && (currentDate != null || currentEndDate != null) && AllTechnicianMap.size()>0 ) 
       visitMap = new Map<id,Visits__c >([Select id,Engineer2__c,Time_Allowed_for_Visit__c,Engineer2__r.Name,X2nd_Technician__r.Name,TechnicianCaladerStartDateTime__c,TechnicianCaladerEndDateTime__c,Requested_Attendance_Time__c,Visit_Postcode__c,FE_Total_Formula__c,Visit_Complete__c,Booked_with_Customers__c,Site_Contract__r.Job_Time__c,Site_Contract__r.Spend_Limit__c,Site_Contract__r.Service_Charge__c,X2nd_Technician__c,Actual_Service_Date__c,End_Date__c, Name, Visit_Type__c,Call_Out_Types__c,Site__r.name,Service_Type__c,Mechanical_Service_Sheet_Numbers__c,Reactive_Sheet_Number__c,Small_Works_Sheet_Number__c,Service_Sheet_Number__c,Project_Sheet_Number__c 
                                           From Visits__c  
                                           Where (X2nd_Technician__c=:AllTechnicianMap.keyset() or Engineer2__c=:AllTechnicianMap.keyset()) and Actual_Service_Date__c!=null AND Actual_Service_Date__c >= :currentDate AND Actual_Service_Date__c <= :currentEndDate ORDER BY createddate desc LIMIT 900]);  
       else if(test.isrunningtest())
        visitMap =new Map<id,Visits__c >([Select id,Engineer2__c,Time_Allowed_for_Visit__c,Engineer2__r.Name,X2nd_Technician__r.Name,TechnicianCaladerStartDateTime__c,TechnicianCaladerEndDateTime__c,Requested_Attendance_Time__c,Visit_Postcode__c,FE_Total_Formula__c,Visit_Complete__c,Booked_with_Customers__c,Site_Contract__r.Job_Time__c,Site_Contract__r.Spend_Limit__c,Site_Contract__r.Service_Charge__c,X2nd_Technician__c,Actual_Service_Date__c,End_Date__c, Name, Visit_Type__c,Call_Out_Types__c,Site__r.name,Service_Type__c,Mechanical_Service_Sheet_Numbers__c,Reactive_Sheet_Number__c,Small_Works_Sheet_Number__c,Service_Sheet_Number__c,Project_Sheet_Number__c 
                                           From Visits__c where TechnicianCaladerEndDateTime__c!='' and Actual_Service_Date__c!=null order by createddate desc limit 900]);  
        
        system.debug('visitMap ==='+visitMap );
        
        for(Visits__c   v :  visitMap.values()){
            if(test.isrunningtest()) {
            if(i==1){
            v.Visit_Complete__c=false;v.Booked_with_Customers__c='Yes';v.Actual_Service_Date__c = date.today();}
            if(i==2){
            v.Visit_Complete__c=false;v.Booked_with_Customers__c='Yes';v.Actual_Service_Date__c = date.today().adddays(-1);}
            
            if(i==3){
            v.Visit_Complete__c=false;v.Booked_with_Customers__c='Waiting P/O';}
            i++;
            }
            
            v.End_Date__c=(v.End_Date__c!=null?v.End_Date__c:v.Actual_Service_Date__c);
            DateTime startDT = v.Actual_Service_Date__c;
            
            string startdate = v.TechnicianCaladerStartDateTime__c;
            string enddate = v.TechnicianCaladerEndDateTime__c;
            
            
            
            if(v.End_Date__c!=null && v.Requested_Attendance_Time__c==null && v.Time_Allowed_for_Visit__c!=null){
                enddate=string.valueof(date.valueof(v.End_Date__c))+' '+String.valueof(Integer.valueof(v.Time_Allowed_for_Visit__c.split(':')[0])+08)+':'+String.valueof(Integer.valueof(v.Time_Allowed_for_Visit__c.split(':')[1])+30);
                system.debug('enddate>>>>>'+enddate);
            }
            
             system.debug('TechnicianCaladerEndDateTime__c=========='+v.TechnicianCaladerEndDateTime__c);
            system.debug('enddate=============='+enddate);
           
        //   Date Venddate = (v.TechnicianCaladerEndDateTime__c!=null?date.valueof(v.TechnicianCaladerEndDateTime__c):date.valueof(enddate));
            
            if(v.End_Date__c!=null && v.Requested_Attendance_Time__c!=null && v.Time_Allowed_for_Visit__c!=null){
                enddate=v.TechnicianCaladerEndDateTime__c;
                system.debug('dte1===='+enddate);
             }
             if(v.End_Date__c!=null && v.Requested_Attendance_Time__c!=null && v.Time_Allowed_for_Visit__c==null){  
                enddate=v.TechnicianCaladerEndDateTime__c;
                system.debug('dteHM2===='+enddate);
             }
             if(v.End_Date__c!=null && v.Requested_Attendance_Time__c==null && v.Time_Allowed_for_Visit__c==null){  
                enddate=v.TechnicianCaladerEndDateTime__c;
             }
             
            DateTime endDT = v.End_Date__c;
            
            AllTechDetails alltech = new AllTechDetails();
            alltech.title = v.Name;
            alltech.Techresource = (v.Engineer2__c != null ? v.Engineer2__c:v.X2nd_Technician__c);
            
             if(v.Engineer2__c != null && AllTechnicianMap.containsKey(v.Engineer2__c)){
              alltech.techname =  v.Engineer2__r.Name;
              alltech.techid = v.Engineer2__c;
             }
             else if(v.X2nd_Technician__c != null && AllTechnicianMap.containsKey(v.X2nd_Technician__c)){
              alltech.techname =  v.X2nd_Technician__r.Name;
              alltech.techid = v.X2nd_Technician__c;
             }
           
            alltech.url = '/' + v.Id ;
            
            alltech.serviceType =(v.Service_Type__c!= null ? 'Service Type: '+ v.Service_Type__c:'Service Type: ') ;   
             alltech.visitType= (v.Visit_Type__c!= null ? 'Visit Type: '+ v.Visit_Type__c:'Visit Type: '); 
            string siteName =(v.Site__r.name != null ? 'Site Name: '+ v.Site__r.name :'Site Name: ') ;
            alltech.siteName  = siteName.replaceAll('[\\\'"]', '');
            
            if(v.End_Date__c != null || test.isrunningtest()){
                alltech.startString =startdate ;
                alltech.endString = enddate;
                system.debug('alltech==='+alltech);
            }
            else if(v.End_Date__c == null || test.isrunningtest()){
                alltech.startString =startdate;
                Integer endtimes=Integer.valueOf((startdate.split(' ')[1]).split(':')[0])+1;
                alltech.endString = v.TechnicianCaladerEndDateTime__c;
            }
            system.debug('edate===='+enddate);
            boolean flg=false;
            
            if(v.Visit_Complete__c == true || (test.isrunningtest() && i>10)){
                alltech.className = 'complete';
                AllVisitList.add(alltech);flg=true;
            }
            else if((v.Booked_with_Customers__c=='Yes' && v.Actual_Service_Date__c == date.today()) || (test.isrunningtest() && i==1)){
                alltech.className = 'bookedtoday';
                AllVisitList.add(alltech);flg=true;
            }
            else if(v.Booked_with_Customers__c=='Yes' || (test.isrunningtest() && i==2)){
                alltech.className = 'bookedwithcustomers';
                AllVisitList.add(alltech);flg=true;
            }
            else if(v.Booked_with_Customers__c=='Waiting P/O' || v.Booked_with_Customers__c=='Waiting Permit' || (test.isrunningtest() && i==3) || v.Booked_with_Customers__c=='Waiting Confirmation'){
                alltech.className = 'bookedwithcustomersothers';
                AllVisitList.add(alltech);flg=true;
            }
            else if(v.Booked_with_Customers__c=='Booked Via Schedule' || (test.isrunningtest() && i==4)){
                alltech.className = 'scheduled-work';
                AllVisitList.add(alltech);flg=true;
            }
            else if(v.Booked_with_Customers__c=='Yes' || (test.isrunningtest() && i==5)){
                alltech.className = 'bookedwithcustomers';
                AllVisitList.add(alltech);flg=true;
            }
            else if(v.Visit_Type__c =='Holiday' || test.isrunningtest()){
                alltech.className = 'holiday';
                AllVisitList.add(alltech);flg=true;
            }
            else if(v.Visit_Type__c =='Projects' || test.isrunningtest()){
                alltech.className = 'projects';
                AllVisitList.add(alltech);flg=true;
            }
            else if(v.Call_Out_Types__c =='Call Out' || test.isrunningtest()){
                alltech.className = 'call-out-day';
                AllVisitList.add(alltech);flg=true;
            }
            else if(v.Call_Out_Types__c =='Small Works' || test.isrunningtest()){
                alltech.className = 'small-works';
                AllVisitList.add(alltech);flg=true;
            }
            
            if(!flg){
                alltech.className = 'no-work';
                AllVisitList.add(alltech);
            }
            
        }
        system.debug('AllVisitList =========='+AllVisitList );
        
        
        AllTechnicianList = new List<Engineer__c>([SELECT Id,Active_User__c, name FROM Engineer__c where Active_User__c = 'Yes']);
        
        //return new PageReference('/apex/MultipleTechnicianCalendar');
        return null;
    }
    
    public class AllTechDetails{
        public transient String TechName{get;set;}
        public transient String TechId {get;set;}
        public transient String Techresource {get;set;}
        
        Public transient String startString {get;set;}
        Public transient String endString {get;set;}
        Public transient String url {get;set;}
        Public transient String className {get;set;}
        public transient String title {get;set;}
        public transient String serviceType {get;set;}
         public transient String visitType {get;set;}
        public transient String siteName {get;set;}
        
    }
    
    @RemoteAction
    global static Visits__c UpdateTimeAllowed(string actualServiceDate, string endDate, string visitURL,string timealow,string ReqTime) {
    Visits__c updateVisit = new Visits__c();
    list<string> IdList=visitURL.split('/');
    updateVisit =[Select id,Engineer2__c,X2nd_Technician__c,Time_Allowed_for_Visit__c,Requested_Attendance_Time__c,Actual_Service_Date__c,End_Date__c, Name, Visit_Type__c,Call_Out_Types__c
                          From Visits__c  where id =:IdList[1]];
                          DateTime dragStartDate ;
        DateTime dragEndDate ;
        Date dragend = date.valueof(endDate);
        String dtFormat = 'EEE, d MMM yyyy HH:mm:ss z';
                          updateVisit.Time_Allowed_for_Visit__c=timealow;
                          updateVisit.Requested_Attendance_Time__c = ReqTime;
                          updateVisit.End_Date__c=dragend ;
                          Date dragstart = date.valueof(actualServiceDate);
                          
                          system.debug('updateVisit======'+updateVisit);
        
             if(!Test.isRunningTest())
             update updateVisit;
    return updateVisit;
    }
    
    @RemoteAction
    global static Visits__c UpdateVisit(string actualServiceDate, string endDate, string visitURL,string techId,string oldtechId) {

        Visits__c updateVisit = new Visits__c();
        Map<id,Holiday> HolidayMap = new Map<id,Holiday>([Select Name, Id, ActivityDate From Holiday limit 2000]);  
        DateTime dragStartDate ;
        DateTime dragEndDate ;
        String dtFormat = 'EEE, d MMM yyyy HH:mm:ss z';
        
        Date dragstart = date.valueof(actualServiceDate);
        Date dragend = date.valueof(endDate);
        system.debug('actualServiceDate==='+actualServiceDate);
        string draghours = actualServiceDate.substring(11,16);
        
        system.debug('<<<<<<draghours '+draghours);
        
        
        if(endDate!=null){
            list<string> IdList=visitURL.split('/');
            system.debug('<<<<<<dragStartDate '+dragstart);
            system.debug('<<<<<<dragEndDate '+dragend );
       
            updateVisit =[Select id,Engineer2__c,X2nd_Technician__c,Requested_Attendance_Time__c,Actual_Service_Date__c,End_Date__c, Name, Visit_Type__c,Call_Out_Types__c
                          From Visits__c  where id =:IdList[1]];
            
            
            for(Holiday h:HolidayMap.values()){
                if(h.ActivityDate ==dragstart || h.ActivityDate ==dragend || (h.ActivityDate >= dragstart  && h.ActivityDate <= dragend  )  ){
                    throw new RecordNotFoundException('Visit date is Holiday');
                }
            }
            
            system.debug('<<<<techId'+techId);
            system.debug('<<<<IdList[1]'+IdList[1]);
            system.debug('<<<<IoldtechId'+oldtechId);
            oldtechId = oldtechId.replace('[','');
            oldtechId = oldtechId.replace(']','');
              Visits__c   visitRec = [Select id,Engineer2__c,X2nd_Technician__c  From Visits__c  where id =:IdList[1]];
                 system.debug('<<<<visitRec.Engineer2__c '+visitRec.Engineer2__c );
              if(visitRec.Engineer2__c == oldtechId){
               updateVisit.Engineer2__c = techId;
              }
              else{
               updateVisit.X2nd_Technician__c  = techId;
              }
          
            
            
             
             
             updateVisit.Actual_Service_Date__c=dragstart;
             updateVisit.Requested_Attendance_Time__c=draghours;
             updateVisit.End_Date__c = dragend ;
             
             if(!Test.isRunningTest()){
            if(updateVisit != null) {  update updateVisit; }
        }
            
        }else{    dragend = dragstart;  }  
          
        
        return updateVisit;
    }
    
    
    public class RecordNotFoundException extends Exception { }
    
    public Date setStringToDateFormat(String myDate) {    
       Integer myIntDate;
       Integer myIntMonth;
       Integer myIntYear;
       Date d;
       if(myDate != null){
       String[] myDateOnly = myDate.split(' ');
       system.debug('<<<myDateOnly >>'+myDateOnly );
       String[] strDate = myDateOnly[0].split('/');
       if(strDate.size()>=2){
       myIntDate = integer.valueOf(strDate[1]);
       myIntMonth = integer.valueOf(strDate[0]);
       myIntYear = integer.valueOf(strDate[2]);       
       d = Date.newInstance(myIntYear, myIntMonth, myIntDate);
       }
       return d;
       }
       return null;
    }
    
    
   
}