trigger ServSheetOppAutoFE on Engineer_Checklist__c (after insert, after update) {
    /*
if(Trigger.isUpdate && Trigger.isAfter && !RecursiveHandler.runSSOAFE_TriggerOnce())
        return;

if(Test.isRunningTest()||!OnceSSOAFE.hasAlreadyRound()){
OnceSSOAFE.setAlreadyRound();


list<OpportunityLineItem> lolinb= new list<OpportunityLineItem>();
list<OpportunityLineItem> lolin = new list<OpportunityLineItem>();
Datetime asofnow = system.now();
String litasofnow = asofnow.format();
Id pbid;
Engineer_Checklist__c ss = trigger.new[0];

{
pbid = [select Id, Price_Book_ID__c from Account where Id=:ss.Site__c limit 1].Price_Book_ID__c;
Boolean ofc = false;
Boolean ofca = false;
Boolean ofcc = false;
try{ofc= trigger.oldMap.get(ss.id).Fire_Extinguisher_Service_complete__c;}catch(Exception exofc){}
try{ofca= trigger.oldMap.get(ss.id).Fire_Extinguisher_Service_complete__c;}catch(Exception exofca){}
try{ofcc= trigger.oldMap.get(ss.id).Fire_Extinguisher_Service_complete__c;}catch(Exception exofcc){}
Boolean nfc = trigger.newMap.get(ss.id).Fire_Extinguisher_Service_complete__c;
Boolean nfca = trigger.newMap.get(ss.id).Fire_Extinguisher_Service_complete__c;
Boolean nfcc = trigger.newMap.get(ss.id).Fire_Extinguisher_Service_complete__c;
if((nfc&&nfc!=ofc&&ss.RecordTypeID=='01228000000D11b')
||(nfca&&nfca!=ofca&&ss.RecordTypeID=='01228000000D11a')
||(nfcc&&nfcc!=ofcc&&ss.RecordTypeID=='01228000000D11c')
||Test.isRunningTest()){
    string opnam ='Service Sheet Complete '+ss.Site_Name__c+' '+system.today().format();
    integer lopnam = opnam.length();
    if(lopnam>119){
        opnam=opnam.substring(0,120);
    }
    Opportunity op = new Opportunity(
    AccountID = ss.Site__c,
    CloseDate = system.today(),
    StageName = 'Closed Won',
    Name = opnam,
    Service_Sheet__c = ss.id,
    ss_run_date__c = asofnow,
    Engineer_Completed_Service__c=true
    );
    insert op;


Opportunity opp = [select Id, Service_Sheet__r.Id,
          Account.Fire_Extinguisher_call_out__c
          from Opportunity where
          ss_run_date__c =: asofnow limit 1];
          
try{
    Id copbeid=[select Id from PricebookEntry where
            Product2.Name='Site Visit Fee Service'
            and Pricebook2.Id=:pbid
            limit 1].Id;  

{
    Decimal xup=opp.Account.Fire_Extinguisher_call_out__c;
    if(xup!=null){
        if(xup>0.0){
    OpportunityLineItem oli = new OpportunityLineItem(
       OpportunityID = opp.Id,
       PricebookEntryID = copbeid,
       Quantity = 1.0,
       UnitPrice = xup
    );
    lolin.add(oli);
    }
    }                           
}
}catch(Exception exsvfs){}

List<PricebookEntry> lpbe = ([select Id,UnitPrice,
                                     Product2.Service_Sheet_API_Name__c
                                     from PricebookEntry
                                     where Product2.Service_Sheet_API_Name__c!=null
                                     and Product2.Service_Sheet_Picklist_Name__c=null
                                     and Pricebook2.Id=:pbid
                                     ]);
map<string,Id> sftopbeid =new map<string,Id>();
map<string,double> sftoup =new map<string,double>();
set<string> sfs =new set<string>();
for(PricebookEntry pbe: lpbe){
    sftopbeid.put(pbe.Product2.Service_Sheet_API_Name__c,pbe.Id);
    sfs.add(pbe.Product2.Service_Sheet_API_Name__c);
    sftoup.put(pbe.Product2.Service_Sheet_API_Name__c,pbe.UnitPrice);
}

lpbe = ([select Id,UnitPrice,
                                     Product2.Service_Sheet_Picklist_Name__c,
                                     Product2.Service_Sheet_Picklist_Option__c,
                                     Product2.Service_Sheet_Quantity_API_Name__c
                                     from PricebookEntry
                                     where Product2.Service_Sheet_API_Name__c=null
                                     and Product2.Service_Sheet_Picklist_Name__c!=null
                                     and Product2.Service_Sheet_Picklist_Option__c!=null
                                     and Product2.Service_Sheet_Quantity_API_Name__c!=null
                                     and Pricebook2.Id=:pbid
                                     ]);
map<string,Id> pktopbeid =new map<string,Id>();
map<string,string> pktoqty =new map<string,string>();
set<string> pks =new set<string>();
map<string,double> pktoup = new map<string,double>();
for(PricebookEntry pbe: lpbe){
    string idx = pbe.Product2.Service_Sheet_Picklist_Name__c;
    idx=idx+'|'+pbe.Product2.Service_Sheet_Picklist_Option__c;
    pktopbeid.put(idx,pbe.Id);
    pks.add(idx);
    pktoup.put(idx,pbe.UnitPrice);
    pktoqty.put(idx,pbe.Product2.Service_Sheet_Quantity_API_Name__c);
}

Schema.DescribeSObjectResult dsor =
             Engineer_Checklist__c.getSObjectType().getDescribe();
Map<String, Schema.SObjectField> objectFields = dsor.fields.getMap();
Map<String,Schema.DescribeFieldResult> finalMap = 
    new Map<String, Schema.DescribeFieldResult>();
Set <String> afields = new Set<String>();
afields = objectFields.keySet();
Set<String> qfields = new Set<String>();        
for(String f: afields){
    Schema.DescribeFieldResult dr = objectFields.get(f).getDescribe();
    String fn = dr.getName();
        finalMap.put(fn,dr);
        qfields.add(fn);
    }

for(string f : qfields){
system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!f'+f);
    Id pbeid = sftopbeid.get(f);
system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!pbeid'+pbeid);
    double xup = sftoup.get(f);
system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!xup'+xup);
    Decimal xqty;
    try{
        xqty=(Decimal) ss.get(f);
    }catch(Exception exqty1){
        try{
            string sxqty =(String) ss.get(f);
            xqty = 0.0+ integer.valueOf(sxqty);
        }catch(Exception exqty1s){} 
    }
system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!xqty'+xqty);
    if(pbeid!=null&&xqty!=null&&xqty>0.0&&xup!=null){
       OpportunityLineItem oli = new OpportunityLineItem(
       OpportunityID = opp.Id,
       PricebookEntryID = pbeid,
       Quantity = xqty,
       UnitPrice = xup
    );
    try{lolin.add(oli); }catch(Exception exi1){}
    }
}
for(string f: qfields){
    string pkval;
    try{pkval = (String) ss.get(f);}catch(Exception expkv){}
    string idx=f+'|'+pkval;
    Id pbeid = pktopbeid.get(idx);
    double xup=pktoup.get(idx);
    string pkqty = pktoqty.get(idx);
    Decimal xqty;
    try{xqty = (Decimal) ss.get(pkqty);}catch(Exception exqty2){}
    if(pbeid!=null&&xqty!=null&&xqty>0.0&&xup!=null){
       OpportunityLineItem oli = new OpportunityLineItem(
       OpportunityID = opp.Id,
       PricebookEntryID = pbeid,
       Quantity = xqty,
       UnitPrice = xup
    );
    try{lolin.add(oli); }catch(Exception exi2){}
        
    }
    
}


}
}

if(lolin.size()>0){
    for(OpportunityLineItem oli : lolin){
        lolinb.add(oli);
        if(lolinb.size()>95){
            insert lolinb;
            lolinb.clear();
        }
    }
    if(lolinb.size()>0){
        insert lolinb;
        lolinb.clear();
    }
        
}







}
*/
}