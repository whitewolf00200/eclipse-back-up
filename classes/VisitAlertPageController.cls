/*============================================================================================================
*Class Name     : VisitAlertPageController
*Description    : To handle the technician call
*Company        : Puthuvannam Technology Solutions Pvt Ltd.
*Date           : 28th May, 2014
*Version        : 1.1
*Methods        : public VisitAlertPageController(ApexPages.StandardController controller)

*============================================================================================================*/

public class VisitAlertPageController {
    public String visitId{get; set;}
    Public Visits__c currentVisit{get; set;}
    
    public VisitAlertPageController(ApexPages.StandardController controller) {
        //Variable Initialization
        visitId =  ApexPages.CurrentPage().getParameters().get('id');
        //get the current engineer details based on the current page id.
       
        currentVisit  =[SELECT id,Name,Engineer2__c,Actual_Service_Date__c,End_Date__c,Site__c,Site_Contract__c,Booked_with_Customers__c 
                                  FROM Visits__c  
                                  WHERE id = :visitId ];
        //currentVisit=(Visits__c)controller.getRecord();
        CheckTechnicianOnCallAvailability();
        CheckTechnicianUnavailableAvailability();
        CheckTechnicianVisitAvailability();
        CheckPurchaseOrderRequiredyes();
        CheckBookedviaSchedule(); // If BookedWithCustomer is 'Booked Via Schedule' show a warning alert
               
    }
    
    
    public void CheckTechnicianOnCallAvailability(){
    
        
        //Check the Engineer's Availability
        if(currentVisit.Engineer2__c !=Null){
            //Fetch the start date and end date of the engineer's call
            Engineer__c currentTechnician = [SELECT id,Service_End_Date__c,Service_Start_Date__c 
                                             FROM Engineer__c 
                                             WHERE id = :currentVisit.Engineer2__c];

            if((currentTechnician.Service_Start_Date__c <= currentVisit.Actual_Service_Date__c && 
                currentTechnician.Service_End_Date__c >= currentVisit.Actual_Service_Date__c) || 
               (currentTechnician.Service_Start_Date__c <= currentVisit.End_Date__c && 
                currentTechnician.Service_End_Date__c <= currentVisit.End_Date__c) ){
                    //Show the warning message 
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Technician is on Call from  [ '+currentTechnician.Service_Start_Date__c.format()+'  ]  to  [ '+currentTechnician.Service_End_Date__c.format()+' ]'));
            }
            //For testing purospe while running in the production after the deploy.
            system.debug('============'+currentTechnician +'========='+currentVisit.Actual_Service_Date__c );
    
        }    
    }
    
    // Technician CheckTechnicianUnavailableAvailability
    
     public void CheckTechnicianUnavailableAvailability(){
    
        
        //Check the Engineer's Availability
        if(currentVisit.Engineer2__c !=Null){
            //Fetch the start date and end date of the engineer's Unavailable
            Engineer__c currentTechnician = [SELECT id,Start_Date__c,End_Date__c
                                             FROM Engineer__c 
                                             WHERE id = :currentVisit.Engineer2__c];

            if((currentTechnician.Start_Date__c <= currentVisit.Actual_Service_Date__c && 
                currentTechnician.End_Date__c >= currentVisit.Actual_Service_Date__c) || 
               (currentTechnician.Start_Date__c <= currentVisit.End_Date__c && 
                currentTechnician.End_Date__c <= currentVisit.End_Date__c) ){
                    //Show the warning message 
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Technician is on Unavailable from  [ '+currentTechnician.Start_Date__c.format()+'  ]  to  [ '+currentTechnician.End_Date__c.format()+' ]'));
            }
            //For testing purospe while running in the production after the deploy.
            system.debug('============'+currentTechnician +'========='+currentVisit.Actual_Service_Date__c );
    
        }    
    }
    
     /*Method Name   : CheckTechnicianCall
    //Description    : Check the availability of the technician call 
    //Arguments      : newVList- Receiving all the Visit records which triggers this trigger.
    */
    Private void CheckTechnicianVisitAvailability(){
      if( currentVisit.Engineer2__c  != null){
      List<Visits__c> VisitRecords = [SELECT id,Name,Engineer2__c,Actual_Service_Date__c,End_Date__c 
                                  FROM Visits__c  
                                  WHERE Engineer2__c = :currentVisit.Engineer2__c AND id!=:visitId];
                                  
      if(VisitRecords != null){
       for(Visits__c v:VisitRecords){
         
            if((currentVisit.Actual_Service_Date__c >= v.Actual_Service_Date__c && 
                currentVisit.Actual_Service_Date__c < = v.End_Date__c) || 
               (currentVisit.End_Date__c >= v.Actual_Service_Date__c && 
                currentVisit.End_Date__c <= v.End_Date__c) ){
                    //Show the warning message 
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Technician is on another Visit [ '+v.Name+'  ] from  [ '+v.Actual_Service_Date__c.format()+'  ]  to  [ '+v.End_Date__c.format()+' ]'));
                }
                
             }
       }                            
      }
      
    }
    
    /*Method Name   :  CheckPurchaseOrderRequiredYes
    //Description    : Check the Purchase Order Required is Yes in Customer/Site and SiteContact
    //Arguments      : newVList- Receiving all the Visit records which triggers this trigger.
    */
     
   Private void CheckPurchaseOrderRequiredyes(){
           //Check the Purchase Order Required is Yes
        if(((currentVisit.Site__c!=Null) || (currentVisit.Site_Contract__c !=Null)) || ((currentVisit.Site__c!=Null) && (currentVisit.Site_Contract__c !=Null) )){
            //Fetch the Purchase Order Required in Customer Site And Site Contracts
            Account currentCustomerSite = [SELECT id,Purchase_Order_Required__c 
                                             FROM Account
                                             WHERE id = :currentVisit.Site__c];
         
           SiteContracts__c currentSiteContracts = [SELECT id,Purchase_Order_Required__c 
                                             FROM SiteContracts__c
                                             WHERE id = :currentVisit.Site_Contract__c ];
         
           if(((currentCustomerSite.Purchase_Order_Required__c =='Yes')||(currentSiteContracts.Purchase_Order_Required__c =='Yes' )) ||((currentCustomerSite.Purchase_Order_Required__c =='Yes')&&(currentSiteContracts.Purchase_Order_Required__c =='Yes' ))) {
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'This Visit requires a Purchase Order before it is booked in / attended'));
               }
           }
   }
    /*Method Name   :  CheckBookedviaSchedule
    //Description    : Check the Purchase Order Required is Yes in Customer/Site and SiteContact
    //Arguments      : newVList- Receiving all the Visit records which triggers this trigger.
    */
    
    Private void CheckBookedviaSchedule(){
       if( currentVisit.Booked_with_Customers__c != null && currentVisit.Booked_with_Customers__c=='Booked Via Schedule'){
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'This Visit still requires booking, do not move the date as it has forms part of a schedule already sent to the customer'));    
       }
       
    }
}