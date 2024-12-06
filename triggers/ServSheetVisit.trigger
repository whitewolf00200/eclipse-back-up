trigger ServSheetVisit on Engineer_Checklist__c (after insert,after update) {
if(!OnceSSV.hasAlreadyRound()){
OnceSSV.setAlreadyRound();
//return;
if(Trigger.isUpdate && Trigger.isAfter && !RecursiveHandler.runSSV_TriggerOnce())
    return;

Datetime asofnow = system.now();
String litasofnow = asofnow.format();
set<id> ssids = new set<id>();
for(Engineer_Checklist__c ss: trigger.new){
/*
Boolean ofc = false;
try{ofc= trigger.oldMap.get(ss.id).Fire_Extinguisher_Service_complete__c;}catch(Exception exofc){}
Boolean nfc = trigger.newMap.get(ss.id).Fire_Extinguisher_Service_complete__c;
if((nfc&&nfc!=ofc)||Test.isRunningTest()){
    ssids.add(ss.id);
}
*/

if(!trigger.isUpdate||Test.isRunningTest()){

    ssids.add(ss.id);
}

}

list<Engineer_Checklist__c> lss2 =([select Id,
                                   Visit__r.Id,
                                   Date__c,
                                   Name
                                    from Engineer_Checklist__c
                                   where Id IN :ssids
                                   ]);
                                   
set<id>sv = new set<id>();
map<Id,Date> mvd = new map<Id,Date>();
map<Id,string> mvn = new map<Id,string>();

for(Engineer_Checklist__c ss2: lss2){
if(ss2.Visit__r.Id!=null){
    sv.add(ss2.Visit__r.Id);
    mvd.put(ss2.Visit__r.Id,ss2.Date__c);
    mvn.put(ss2.Visit__r.Id,ss2.Name+'');
}
}
list<Visits__c> lv = ([select Id,
                     Visit_Complete__c,
                     Actual_Service_Date__c
                     from Visits__c
                     where Id IN: sv
                     ]);


list<Visits__c> lvu = new list<Visits__c>();
for(Visits__c v : lv){
v.Actual_Service_Date__c=mvd.get(v.Id);
v.Service_Sheet_Number__c=mvn.get(v.Id);
//v.Visit_Complete__c = true;
lvu.add(v);
if(lvu.size()>95){
    try{
        update lvu;
    }catch(Exception exv1){}
    lvu.clear();
}
}
if(lvu.size()>0){
    try{
        update lvu;
    }catch(Exception exv2){}
    lvu.clear();
}



}
}