public class SurveyTakerHandler {
    public static void sendEmailTemplate(List<SurveyTaker__c> surveyTakers, Map<id,SurveyTaker__c> oldmap) {
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        
        String[] toAddresses = new String[]{'salesforcetestwork@gmail.com'};
        
        Id emailTemplateId = '00X4E000001e5AQUAY';
        
        for (SurveyTaker__c st : surveyTakers) {
        if(st.No_of_Question__c>0 && oldmap.get(st.id).No_of_Question__c!=st.No_of_Question__c){
        
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name ='Survey Submit Notification' limit 1];
            email.setToAddresses(toAddresses);
             email.setSubject(Messaging.renderStoredEmailTemplate(emailTemplate.Id,UserInfo.getUserId(), st.Id).getSubject());
            email.setHtmlBody(Messaging.renderStoredEmailTemplate(emailTemplate.Id,UserInfo.getUserId(), st.Id).getHtmlBody()); 
            emailList.add(email);
        
        if(emailList.size()>0){
            Messaging.sendEmail(emailList);
        }
      }
    }
}
}