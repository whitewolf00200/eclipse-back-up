trigger SurveyTakerTrigger on SurveyTaker__c (after insert, after update) {

  if (Trigger.isAfter) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            SurveyTakerHandler.sendEmailTemplate(Trigger.new,Trigger.oldmap);
        }
    }
    
}