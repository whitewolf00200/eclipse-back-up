/*============================================================================================================
*Class Name     : ProjectSheetTriggerHandlerTest
*Description    : Test Class for ProjectSheetTriggerHandler
*Company        : Puthuvannam Technology Solutions
*Date           : 9th July, 2014
*Version        : 1.0
*Change History : 
*============================================================================================================*/


@isTest(seeAlldata=true)
Public Class ProjectSheetTriggerHandlerTest{

     @isTest Public static void UpdateSiteVisitTimeTest() { 
        Test.StartTest(); 
            Project_Sheet__c exProsheet;
            try{
            exprosheet=[Select id,Arrive__c,Depart__c 
                                            FROM Project_Sheet__c
                                            WHERE Fire_Extinguisher_Service_complete__c!=TRUE AND Site_Contract__c!=NULL AND Visit__c!=NULL LIMIT 1];
            
            Project_Sheet__c newProSheet=exProsheet.clone();
            insert newProSheet;        
            exProsheet.Arrive__c=system.now();
            exProsheet.Depart__c=system.now()+2;        
            update exProsheet; 
            Opportunity exOpp=[SELECT id, Site_Visit_Time__c 
                           FROM Opportunity
                           WHERE Project_Sheet__c =:exProsheet.id LIMIT 1];                                   
            //Check the testing Resuls
            if(exOpp!=NULL){
                system.assertNotEquals(exOpp.Site_Visit_Time__c,'','Site Visit Time not updated');               
            }
        }catch(exception e){
      
      }
        
        
        Test.StopTest();       
        
     }     
     
     //Test Auto Visit complete checkbox testing
     @isTest Public static void AutoVisitCompleteTest(){
        
         Project_Sheet__c exProsheet;
         try{
             exprosheet=[Select id,Fire_Extinguisher_Service_complete__c,Visit__c,Depart__c,Close_Visit__c 
                                            FROM Project_Sheet__c
                                            WHERE Fire_Extinguisher_Service_complete__c!=TRUE AND Site_Contract__c!=NULL AND Visit__c!=NULL LIMIT 1];
             exProsheet.Fire_Extinguisher_Service_complete__c=True;
             exProsheet.Close_Visit__c='Yes';
             exProsheet.Depart__c=system.today();
             exProsheet.Document_Attached__c='Testing';
             //Submit the service sheet
             Update exProsheet;
             System.assertEquals([SELECT Visit_Complete__c from Visits__c WHERE id=:exProsheet.Visit__c].Visit_Complete__c,TRUE,'Visit not completed');
         }catch(exception e){
      
          }         
      
     }   

}