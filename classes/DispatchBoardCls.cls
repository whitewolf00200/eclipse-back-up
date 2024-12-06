public class DispatchBoardCls {
    public static string YESORNO ='Yes';
    
    //Get the dispatch board settings to allign the dispatch board
    @AuraEnabled
    public static Map<String,Setting__mdt> getDispatchBoardSettings(){
        list<Setting__mdt> settingList = new list<Setting__mdt>();
        
              settingList =[Select id,DeveloperName, DB_Start_Time__c, DB_End_Time__c  from Setting__mdt] ;     

        Map<String, Setting__mdt> settings = new Map<String, Setting__mdt>();
        system.debug('settings:'+settings);
        for(Setting__mdt setting : settingList){
            settings.put(setting.DeveloperName, setting);
        }
        return settings;
    }

      @AuraEnabled
    public static list<visits__c> getAssignmentsByUser(string userId){  
        
        visits__c eng  =new  visits__c();
        list<visits__c> assignments = new list<visits__c>();
        Date startDate=System.TODAY()-90;
        Date endDate=System.TODAY()+90;

         //assignments =[Select id, Name,End_DateTime__c,Start_datetime__c,Job_Number__c,Site__c,Job_Status__c,Job_Time__c,Start_date_time__c,End_Date_Time__c,Visit_Type__c,Booking_Status__c,Original_Actual_Service_Date__c, Actual_Service_Date__c, End_Date__c,Gantt_color__c,Engineer2__c from visits__c where Engineer2__r.Salesforce_User__c=:userId and ((Start_date_time__c>=:startDate and Start_date_time__c<=:endDate) OR (End_Date_Time__c>=:startDate and End_Date_Time__c<=:endDate) OR (Start_date_time__c<:startDate and End_Date_Time__c>:endDate)) LIMIT 5000];
        assignments =[Select id, Name,End_DateTime__c,Message_to_Technician__c,Site_Name__c,Start_datetime__c,Job_Number__c,Site__c,Job_Status__c,Job_Time__c,Start_date_time__c,End_Date_Time__c,Visit_Type__c,Booking_Status__c,Original_Actual_Service_Date__c, Actual_Service_Date__c, End_Date__c,Gantt_color__c,Engineer2__c from visits__c where Engineer2__r.Salesforce_User__c=:userId and ((Start_datetime__c>=:startDate and Start_datetime__c<=:endDate) OR (End_DateTime__c>=:startDate and End_DateTime__c<=:endDate) OR (Start_datetime__c<:startDate and End_DateTime__c>:endDate)) LIMIT 5000];   
              
          system.debug('Engineers:'+assignments);
        return assignments;
        
    }
  



}