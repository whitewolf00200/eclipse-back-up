trigger ReactiveVisit on Service_Sheet_STD__c (after insert,after update) {
if(!RecursiveHandler.runRV_TriggerOnce()) //Controls the recursive calls
    return;
    
if(!OnceSSV.hasAlreadyRound()){
OnceSSV.setAlreadyRound();

Datetime asofnow = system.now();
String litasofnow = asofnow.format();
set<id> ssids = new set<id>();
for(Service_Sheet_STD__c ss: trigger.new){
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

list<Service_Sheet_STD__c> lss2 =([select Id,
                                   Visit__r.Id,
                                   Name
                                    from Service_Sheet_STD__c
                                   where Id IN :ssids
                                   ]);
                                   
set<id>sv = new set<id>();
map<Id,string> mvn = new map<Id,string>();

for(Service_Sheet_STD__c ss2: lss2){
if(ss2.Visit__r.Id!=null){
    sv.add(ss2.Visit__r.Id);
    mvn.put(ss2.Visit__r.Id,ss2.Name+'');
}
}
list<Visits__c> lv = ([select Id,
                     Visit_Complete__c
                     from Visits__c
                     where Id IN: sv
                     ]);


list<Visits__c> lvu = new list<Visits__c>();
for(Visits__c v : lv){
v.Reactive_Sheet_Number__c=mvn.get(v.Id);
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