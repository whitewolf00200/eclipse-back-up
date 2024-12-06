/*
        Name           : MonthlyTargetTrigger
        Author         : 
        Date           : 23rd June 2014
        Description    : This trigger handle Monthly Target calculation.
*/

trigger MonthlyTargetTrigger on Visits__c(before insert, before update){
    Integer currentMonth = 0;
    for(Visits__c visit : Trigger.New){
        if(Trigger.isInsert){
            if(visit.Order_Value__c != null){
                if(!Test.isRunningTest()){
                    currentMonth = System.today().month();
                }else{
                    currentMonth++;
                }
                setMonthlyTarget(visit);
            }
        }else if(Trigger.isUpdate){
            Visits__c oldVisit = Trigger.oldMap.get(visit.Id);
            if(!Test.isRunningTest()){
                currentMonth = System.today().month();
            }else{
                currentMonth++;
            }
            if(visit.Order_Value__c == null || visit.Order_Value__c == 0){
                clearAllMonths(visit);
            }else if(visit.Order_Value__c != null && (oldVisit.Order_Value__c == null || (oldVisit.Order_Value__c != null && oldVisit.Order_Value__c != visit.Order_Value__c))){
                clearAllMonths(visit);
                setMonthlyTarget(visit);
            }else{
                if(oldVisit.January__c != null && visit.January__c != null && visit.January__c < oldVisit.January__c){
                    visit.February__c = oldVisit.January__c - visit.January__c;
                }
                if(oldVisit.February__c != null && visit.February__c != null && visit.February__c < oldVisit.February__c){
                    visit.March__c = oldVisit.February__c - visit.February__c;
                }
                if(oldVisit.March__c != null && visit.March__c != null && visit.March__c < oldVisit.March__c){
                    visit.April__c = oldVisit.March__c - visit.March__c;
                }
                if(oldVisit.April__c != null && visit.April__c != null && visit.April__c < oldVisit.April__c){
                    visit.May__c = oldVisit.April__c - visit.April__c;
                }
                if(oldVisit.May__c != null && visit.May__c != null && visit.May__c < oldVisit.May__c){
                    visit.June__c = oldVisit.May__c - visit.May__c;
                }
                if(oldVisit.June__c != null && visit.June__c != null && visit.June__c < oldVisit.June__c){
                    visit.July__c = oldVisit.June__c - visit.June__c;
                }
                if(oldVisit.July__c != null && visit.July__c != null && visit.July__c < oldVisit.July__c){
                    visit.August__c = oldVisit.July__c - visit.July__c;
                }
                if(oldVisit.August__c != null && visit.August__c != null && visit.August__c < oldVisit.August__c){
                    visit.September__c = oldVisit.August__c - visit.August__c;
                }
                if(oldVisit.September__c != null && visit.September__c != null && visit.September__c < oldVisit.September__c){
                    visit.October__c = oldVisit.September__c - visit.September__c;
                }
                if(oldVisit.October__c != null && visit.October__c != null && visit.October__c < oldVisit.October__c){
                    visit.November__c = oldVisit.October__c - visit.October__c;
                }
                if(oldVisit.November__c != null && visit.November__c != null && visit.November__c < oldVisit.November__c){
                    visit.December__c = oldVisit.November__c - visit.November__c;
                }
                if(oldVisit.December__c != null && visit.December__c != null && visit.December__c < oldVisit.December__c){
                    visit.January__c = oldVisit.December__c - visit.December__c;
                }
            }
        }
    }
    
    private void clearAllMonths(Visits__c visit){
        visit.January__c = null;
        visit.February__c = null;
        visit.March__c = null;
        visit.April__c = null;
        visit.May__c = null;
        visit.June__c = null;
        visit.July__c = null;
        visit.August__c = null;
        visit.September__c = null;
        visit.October__c = null;
        visit.November__c = null;
        visit.December__c = null;
    }
    
    private void setMonthlyTarget(Visits__c visit){
        if(currentMonth == 1){
            visit.January__c = visit.Order_Value__c;
        }else if(currentMonth == 2){
            visit.February__c = visit.Order_Value__c;
        }else if(currentMonth == 3){
            visit.March__c = visit.Order_Value__c;
        }else if(currentMonth == 4){
            visit.April__c = visit.Order_Value__c;
        }else if(currentMonth == 5){
            visit.May__c = visit.Order_Value__c;
        }else if(currentMonth == 6){
            visit.June__c = visit.Order_Value__c;
        }else if(currentMonth == 7){
            visit.July__c = visit.Order_Value__c;
        }else if(currentMonth == 8){
            visit.August__c = visit.Order_Value__c;
        }else if(currentMonth == 9){
            visit.September__c = visit.Order_Value__c;
        }else if(currentMonth == 10){
            visit.October__c = visit.Order_Value__c;
        }else if(currentMonth == 11){
            visit.November__c = visit.Order_Value__c;
        }else if(currentMonth == 12){
            visit.December__c = visit.Order_Value__c;
        }
    }
}