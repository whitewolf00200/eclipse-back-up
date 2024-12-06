trigger SWOpp on Small_Works__c (after update) {

List<PricebookEntry>  lpe =([select Id,
                                    Pricebook2Id
                                    from PricebookEntry
                                    where
                                    Product2Id ='01t280000005nKK']);
map<string,string> mbk2peid = new map<string,string>();
String visitType;    //Added By Puthuvannam for Ticket SFD000163 on Date 18/08/2014
String lineDescription;    //Added By Puthuvannam for Ticket SFD000163 on Date 18/08/2014
for(PricebookEntry pe:lpe){
    mbk2peid.put((''+pe.Pricebook2Id).substring(0,15),(''+pe.id).substring(0,15));
}




set<id> ssids = new set<id>();
for(Small_Works__c ss:trigger.new){ 

ssids.add(ss.id);

}


list<Small_Works__c> sss=([select Id,
                                 Site_Contract__r.Standard_Reactive_Call_Out_Charge__c,
                                 Site_Contract__r.Price_Book_IdFormula__c,
                                 Parts_Used_and_Quantity__c,Visit__r.Quotation_Reference__c,
                                 Site__r.Name,Visit__r.Visit_Type__c,
                                 Visit__r.Id,
                                 Name
                                  from Small_Works__c
                                   where Id IN: ssids  limit 1]);

map<id,double> mco = new map<id,double>();
map<id,string> mcpbk = new map<id,string>();
map<id,id> msw2v = new map<id,id>();
for(Small_Works__c ss : sss){
    //if(ss.Visit__r.Visit_Type__c=='Small Works'){
        mcpbk.put(ss.id,ss.Site_Contract__r.Price_Book_IdFormula__c.substring(0,15));
        double x= ss.Site_Contract__r.Standard_Reactive_Call_Out_Charge__c;
        lineDescription=ss.Visit__r.Quotation_Reference__c;         //Added  By Puthuvannam for Ticket SFD000163 on Date 18/08/2014
        visitType=ss.Visit__r.Visit_Type__c;    //Added By Puthuvannam for Ticket SFD000163 on Date 18/08/2014
        msw2v.put(ss.id,ss.Visit__r.Id);
        if(x!=null){
            mco.put(ss.Id,x);
        }else{
            mco.put(ss.Id,0.0);
            
        }
   // }
}


for(Small_Works__c ss:trigger.new){ 

Boolean ofc = false;
try{ofc= trigger.oldMap.get(ss.id).Submit_this_Small_Works_Sheet__c;}catch(Exception exofc){}
Boolean nfc = trigger.newMap.get(ss.id).Submit_this_Small_Works_Sheet__c;
if((nfc&&nfc!=ofc)||Test.isRunningTest()){
 
  
    Opportunity op = new Opportunity(
   // RecordTypeID='01228000000D11p',
    AccountID = ss.Site__c,
    CloseDate = system.today(),
    StageName = 'Closed Won',
    Type='Non Sales Opportunity',
    Name = 'SW '+ss.Name.replace('HSW','')+' - '+ss.Site_Name__c+' - '+system.today().format(),
    Site_Visit_Details__c=ss.Site_Visit_Details_Comments__c,
    Time_to_Site__c=ss.Travel_Time__c+'',
    Parts_Used_and_Quantity__c=ss.Parts_Used_and_Quantity__c,
    Pricebook2Id=mcpbk.get(ss.id),
    Technician_Groups__c=ss.Technician_Group__c,    // Modified by Puthuvannam for the ticket - SFD000044 and Date 08/05/2014
    Technician_Super_Groups__c=ss.Technician_Super_Group__c,    // Modified by Puthuvannam for the ticket - SFD000044 and Date 08/05/2014
    Customer_Works_Completion_Note__c=ss.Document_Attached__c,  //Added by Puthuvannam-16/06/2014 
    Small_Works__c=ss.id
    );
    insert op;
    
    id vid=msw2v.get(ss.Id);
    if(vid!=null){
        Visits__c vxx = [select Id,Opportunity__c,Booking_Confirmation__c,Booking_Notes__c from Visits__c where Id=:vid
                                 limit 1];
    if(vxx!=null){
        vxx.Opportunity__c=op.Id;
        vxx.Small_Works_Sheet_Number__c = ss.Name;        
        update vxx;
    }
    }
         
    
    id scopbeid = '01t280000005nKK';
    scopbeid=mbk2peid.get(mcpbk.get(ss.id).substring(0,15));
        if(scopbeid==null){
            scopbeid = '01t280000005nKK';
        }
    
    double xup=mco.get(ss.id);
    if(xup==null){
        xup=0.0;
    }
 try{   
    OpportunityLineItem oli = new OpportunityLineItem(
       OpportunityID = op.Id,
       PricebookEntryID = scopbeid,
       Quantity = 1.0,
       UnitPrice = xup,
       Description=lineDescription
    );
    if(visitType=='Small Works'){    //Added By Puthuvannam for Ticket SFD000163 on Date 18/08/2014
    insert oli;}
 }catch(Exception exoli){}
}
}
}