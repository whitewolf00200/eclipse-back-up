/*============================================================================================================
*Class Name     : SurveySubmitController
*Description    : When the survey submit button is clicked
*Company        : Merfantz Technology Pvt Ltd.
*Date           : 13th April, 2014
*Version        : 1.1
*Methods        : public SurveySubmitController(ApexPages.StandardController controller)

*============================================================================================================*/
public class SurveySubmitController {
    public visits__c THisVisit {get;set;}
    //public List<Visits__C> VisitList {get;set;}
    public List<Visits__c> VisitToSend = new list<Visits__c>();
    public list<SurveyTaker__c> Surveys {get;set;}
    public id currentRecordId;
    public boolean popUP {get;set;}
    public boolean Error {get;set;}
    public set<id> selectedVisits {get;set;}
    public integer ThisVisitSurvey{get;set;}
    public account acc {get;set;}
    
    public SurveySubmitController(ApexPages.StandardController controller) {
        ThisVisitSurvey=0;
        popUP=false;
        Error=false;
        selectedVisits=new set<id>();
        acc = new account();
        //currentRecordId  = ApexPages.CurrentPage().getparameters().get('id')!=null?ApexPages.CurrentPage().getparameters().get('id'):'a0Q7Z000008st1C';
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        System.debug(currentRecordId);
        THisVisit = [SELECT id,Name,Engineer2__c,Survey_Sent__c,Mail_Count__c,Site__r.name,Engineer2__r.name,Site__c,Visit_Confirmation_Email_to__c  FROM Visits__c WHERE id =: currentRecordId ];
        Surveys=[SELECT Id, Visit__c, Site__c, Survey__c,Visit__r.name, Site__r.name, Survey__r.name, Name FROM SurveyTaker__c where Site__c = :THisVisit.Site__c  and (createddate=this_month or createddate=LAST_N_MONTHS:2)];
    	ThisVisitSurvey=[SELECT Id, Visit__c, Site__c, Survey__c,Visit__r.name, Site__r.name, Survey__r.name, Name FROM SurveyTaker__c where Site__c = :THisVisit.Site__c  and (createddate=this_month or createddate=LAST_N_MONTHS:2) and Visit__c=:THisVisit.id].size();
        acc=[select id,name,Survey_Date__c,Survey_Count_HS__c from account where id=:THisVisit.Site__c];

        system.debug(ThisVisitSurvey);
    }
    
    public void sendSurvey()
    {
        System.debug('e');
        try{
        THisVisit.Survey_Sent__c=THisVisit.Survey_Sent__c==true?false:true;
        acc.Survey_Date__c=System.today();
            if(acc.Survey_Count_HS__c>0){
             acc.Survey_Count_HS__c = acc.Survey_Count_HS__c + 1;
            }
            else{
                 acc.Survey_Count_HS__c =1;
            }
            
        acc.Survey_Engineer__c = THisVisit.Engineer2__r.name;
        update THisVisit;
        update acc;
        popUP=true;
        Error=false;
        system.debug('fun line');
        }catch(Exception e)
        {
            Error=true;
            if(e.getMessage().contains('Survey can send only'))
            apexpages.addMessage(new ApexPages.message(Apexpages.Severity.INFO,'Survey can send only when Visit is completed'));
            else
            apexpages.addMessage(new ApexPages.message(Apexpages.Severity.INFO,e.getMessage()));
            System.debug(e);
        }
        System.debug('e');
        
    }

    public PageReference doRedirect(){
        PageReference pg = new PageReference('/'+currentRecordId);
        pg.setRedirect(true);
        return pg;  
    }
    
    
    
}