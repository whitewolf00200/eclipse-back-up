/*============================================================================================================
*Class Name     : VisitDuplicateSheetHandler
*Description    : Identify the Duplicate sheet
*Company        : Merfantz Technology Solutions
*Date           : 25th Oct, 2014
*Version        : 31.0
*Change History : Initial Version
*============================================================================================================*/
public class VisitDuplicateSheetHandler {

     // Variable Declaration
     public Boolean Allvisitsubmitedsheet{get;set;}
     public String ObjType{get; set;}
     public String VisitId{get; set;}
     
     public List<Engineer_Checklist__c> listEngineerCheckList;
    
     public  map<string, id> allrecordtypeMap {get;set;}
     
     // Constractor
     public VisitDuplicateSheetHandler(ApexPages.StandardController objStandardController){
     
        map<String, Schema.RecordTypeInfo> recordTypeInfos;
       
        // get the Service sheet Recordtype Name and ids in that map:
            recordTypeInfos=Schema.SObjectType.Engineer_Checklist__c.RecordTypeInfosByName;
            
            allrecordtypeMap  = new map<string, id>();
            // get the Service sheet recordtype ids 
            
            allrecordtypeMap.put('Air Compressor Service and Test Report',recordTypeInfos.get('Air Compressor Service and Test Report').RecordTypeId);
            allrecordtypeMap.put('Getinge Autoclave',recordTypeInfos.get('Getinge Autoclave').RecordTypeId);
            allrecordtypeMap.put('Getinge Washer Disinfector',recordTypeInfos.get('Getinge Washer Disinfector').RecordTypeId);
            allrecordtypeMap.put('Mechanical X-Ray Report',recordTypeInfos.get('Mechanical X-Ray Report').RecordTypeId);
            allrecordtypeMap.put('Medisafe Washer disinfector service',recordTypeInfos.get('Medisafe Washer disinfector service').RecordTypeId);
            allrecordtypeMap.put('Report of Examination',recordTypeInfos.get('Report of Examination').RecordTypeId);
            allrecordtypeMap.put('Suction Pump Service',recordTypeInfos.get('Suction Pump Service').RecordTypeId);
            allrecordtypeMap.put('Treatment Centre Certificate Of Service',recordTypeInfos.get('Treatment Centre Certificate Of Service').RecordTypeId);
            
            system.debug('****************allrecordtypeMap*************'+allrecordtypeMap);
   
         ObjType = Apexpages.CurrentPage().getparameters().get('ObjType');
         
         VisitId = Apexpages.CurrentPage().getparameters().get('id');
       
         if (VisitId != null) {

                listEngineerCheckList = new List<Engineer_Checklist__c>([SELECT Id,Visit__c 
                                                                         FROM Engineer_Checklist__c
                                                                         
                                                                         WHERE Visit__r.Id =: VisitId AND Fire_Extinguisher_Service_complete__c = True]);


                if (listEngineerCheckList.size() > 0 )  {

                     Allvisitsubmitedsheet = true;
                 } else {
                     Allvisitsubmitedsheet = false;
                 }

          }
    }
 
}