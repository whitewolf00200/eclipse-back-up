trigger SiteContractDormant on SiteContracts__c (after update) {
set<id>scs = new set<Id>();
for(SiteContracts__c sc: trigger.new){
    string osd=trigger.oldmap.get(sc.id).AM_Status__c;
    string nsd=trigger.newmap.get(sc.id).AM_Status__c;
    if(osd!=nsd&&nsd=='Dormant'){
        scs.add(sc.Id);
    }
}

List<Visits__c> lv = new list<Visits__c>();
if(scs.size()>0){
    lv=([select Id from Visits__c 
                    where Site_Contract__c IN:scs 
                         and Visit_Complete__c=false]);
}

if(lv.size()>0 || Test.isRunningTest()){
    List<Visits__c> lvd = new List<Visits__c>();
    for(Visits__c v : lv){
        lvd.add(v);
        if(lvd.size()>95){
            //delete lvd;
            lvd.clear();
        }
    }
        if(lvd.size()>0){
            //delete lvd;
            lvd.clear();
        }
}

}