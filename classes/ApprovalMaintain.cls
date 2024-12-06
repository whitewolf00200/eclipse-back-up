public class ApprovalMaintain{
   
    public String Mid;
        public ApprovalMaintain(ApexPages.StandardController controller) {
        Mid=  ApexPages.CurrentPage().getParameters().get('id');
        system.debug('Mid====='+Mid);
       for(Service_Sheet_STD__c eng: [select Name,id,(select name,Approval_status__c from Opportunities__r) from Service_Sheet_STD__c where id=:Mid])
        {
        for(Opportunity opp:eng.Opportunities__r){
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