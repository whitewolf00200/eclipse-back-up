public class Approval{
    List<Engineer_Checklist__c > eng;
    List<Opportunity > opp;
    public String Sid;
        public Approval(ApexPages.StandardController controller) {
        Sid=  ApexPages.CurrentPage().getParameters().get('id');
        system.debug('sidd====='+Sid);
       for(Engineer_Checklist__c eng: [select Name,id,(select name,Approval_status__c from Service_Sheet__r) from Engineer_Checklist__c where id=:Sid])
        {
        for(Opportunity opp:eng.Service_Sheet__r){
        if(opp.Approval_status__c!=null && opp.Approval_status__c=='Approved')
        {
        system.debug('status===='+opp.Approval_status__c );
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,opp.Name+' - Invoice is Approved'));
        }
        
         if(opp.Approval_status__c!=null && opp.Approval_status__c=='Rejected')
        {
        system.debug('status===='+opp.Approval_status__c );
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,opp.Name+' - Invoice is Rejected'));
        }
            }
         }
        }
    
    }