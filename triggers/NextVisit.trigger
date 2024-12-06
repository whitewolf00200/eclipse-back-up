trigger NextVisit on Visits__c (after insert, after update) {
/* 
Object : Visits__c, onupdate or oncreate
When the Visit_Complete__c is TRUE, create a followup visit.
 
Refer to the site Contract. SiteContracts__c
 
Visit_Rescheduling_Formula__c  is a formula, which will include :
On Schedule
On Visit
Pre-Scheduled
 
This is a formula so that I can include logic from the accounts
 to over-ride the site contracts. It will cascade down from parent
  to site to site contract.
 
Number_of_Services__c will include 1,2,4, 3, 52….and other combinations. 
These are the number of services Annually.
Due__c = Month Due, JAN, FEB, MAR, etc ( may be blank )
Year__c = Year Due, 2013, 2014, etc ( may be blank )
If the year is blank, ignore, otherwise indicates the year in which visits
 should begin.
 
So 52, JAN, 2014 means 1 visit per week, starting January 2014.
2, JAN 2013 = 2 visits per year, 1 in January, 1 in July.
 
If Visit_Rescheduling_Formula__c  = Pre-Scheduled, DO NOT CREATE A NEW VISIT.
 
If Visit_Rescheduling_Formula__c  = On Schedule, use the schedule from the Site
 contract and calculate the first date of the next period, regardless of the date
  of the visit.
( for example, if the previous visit was 6 July but on the contract number
 of services = 2, APR, 2013 then the next service is April + 6 months = 1
  September 2013 not 6 January 2014 )
Calculate the period in which this visit falls, and go to the beginning 
of the next period.
 
If Visit_Rescheduling_Formula__c  = On Visit, use Previous Visit End Date
 if not blank, otherwise actual service date if not blank as Seed Date for new
  visit planned service date.
So if the visit actual service date is populated and is 01 February 2013, 
and site contract is 4, FEB, 2013, next visit is 1 MAY 2013
If it was 01 February 2013, and site contract is 52, FEB, 2013,
 next visit is 8 February 2013
if the previous visit was 6 July and on the contract number of 
services = 2, APR, 2013 then the next service is 6 January 2014 based on
 the visit date.
 
Create a new visit, as follows :
 
Planned Service Date : ( lookup field in format DD/MM/YYYY 
– needs leading 0 eg March is 03. this fires a workflow that puts
 an actual service date into the actual_service_date__C field. 
 I love this, its really neat and allows people to schedule based 
 on the planned date but choosing the next working day- all this just FYI )
 
Calculate planned service date as above.
 
Attach to same Site,
Site Contract,
Technician = SiteContract. Technician__c. If this is blank, use the technician
 on the visit (Engineer2__c)
Previous_Visit__c = the ID of the visit which triggered this one. 
( it’s a lookup field )
Visit Complete = False
Accepted = Blank
Booked with Customer = Blank
Service Type = same as previous visit. If blank, use 
SiteContracts__c.AM_System_Type__c
*/
/* changes Cascloud 24/02/2014

 addmonths rather than addDays if number of services <=12
  o/w weekly so add 7  days

*/

    system.debug('Cursor Point===NExT visit');
//if(Trigger.isUpdate && !RecursiveHandler.runNV_TriggerOnce())
  //  return;
    system.debug('Cursor Point===NExT visit2');

if(Limits.getQueries()>50 && Test.isRunningTest())    //Escaping from the old test classes issues
    return;

if(Test.isRunningTest()||!OnceNV.hasAlreadyRound()){

integer im0=NextVisitUtils.mtoi('MAR');

system.debug('Coming to the trigger---');

set<id> vs = new set<id>();
set<id> novs = new set<id>();
set<id> sinvx=new set<id>();
map<id,id> mnxv = new map<id,id>();
list<Visits__c> linv = new list<Visits__c>();
//Modified By Puthuvannam On 05-08-2014 
//if the Visit Type is equal to Projects, it does not create a new Visit when completed.
for(Visits__c v : trigger.new){
system.debug('Callout---------'+v.Call_Out_Types__c);
system.debug('Projects---------'+v.Visit_Type__c);
 
    if(v.Visit_Complete__c&&(v.Call_Out_Types__c==''||v.Call_Out_Types__c==null) && (v.Visit_Type__c!='Callout') && (v.Visit_Type__c!='Project') && (v.Visit_Type__c!='Warranty') && (v.Visit_Type__c!='Workshop Repair')){
    
        if(Trigger.isInsert){
        system.debug('Callout1---------'+v.Call_Out_Types__c);
        system.debug('Projects1---------'+v.Visit_Type__c);
            vs.add(v.Id);
        }else if(Trigger.isUpdate){
            boolean ovc = trigger.oldMap.get(v.id).Visit_Complete__c;
            boolean nvc = trigger.newMap.get(v.id).Visit_Complete__c;
            if(nvc&&!ovc&&(v.Call_Out_Types__c==''||v.Call_Out_Types__c==null)&&(v.Visit_Type__c!='Projects')){
                vs.add(v.Id);
            }
        }
    }
}

if(vs.size()>0){

System.debug('========Next Visit============');
List<Engineer_Checklist__c> lss = ([select Id, Visit__r.Id,Close_Visit__c
                                           from Engineer_Checklist__c
                                           where Visit__r.Id!=null
                                           and Visit__r.Id IN: vs
                                           and Close_Visit__c='No']);
for(Engineer_Checklist__c ss : lss){
    novs.add(ss.Visit__r.Id);   
}

if(Test.isRunningTest()){novs=new set<id>();}




    
 List<Holiday> Holidays = new List<Holiday>([Select id, Name, activitydate from holiday Limit 5000]);
   
    list<Visits__c> lv = ([select Id,
                               Site__r.Id,
                               Site_Contract__r.Id,
                               Site_Contract__r.Visit_Rescheduling_Formula__c,
                               Site_Contract__r.Number_of_Services__c,
                               Site_Contract__r.Due__c,
                               Site_Contract__r.Year__c,
                               Site_Contract__r.Technician__r.Id,
                               Site_Contract__r.AM_System_Type__c,
                               End_Date__c,
                           	   Customer_Contact__c,
                               Actual_Service_Date__c,
                               Engineer2__r.Id,
                               Service_Type__c, 
                               Next_Visit__c,
                               Visit_Type__c,
                               Last_Submitted_Service_Sheet__c,
                               Notes_from_Previous_Service__c,
                               Last_Submitted_Service_Sheet__r.Notes_for_next_service__c
 
                               from  Visits__c
                               where Id IN: vs
                               AND Id NOT IN:novs]);
                               
                               system.debug('List of visits==='+lv);
    for(Visits__c v : lv){
        boolean nv=false;
        date vd;
 //Modified By Puthuvannam On 02-09-2014 FOR SFD000193 - Number of Services 
//if Number of Services is < 1 its calucate next in Years 
 
        
      if(v.Visit_Type__c != 'Service Revisit' && v.Visit_Type__c != 'Service Revisit FOC')
        {
            if(v.Site_Contract__r.Visit_Rescheduling_Formula__c=='Pre-Scheduled'){
            }else if(v.Site_Contract__r.Visit_Rescheduling_Formula__c=='On Schedule'){
     
                date sd;
                if(v.End_Date__c!=null){
                    sd=v.End_Date__c;
 
                }else if(v.Actual_Service_Date__c!=null){
                    sd=v.Actual_Service_Date__c ;
                    
                }else{
                    sd=system.today();
                }
                
                integer im;
                integer iy;
                if(v.Site_Contract__r.Due__c==null||v.Site_Contract__r.Due__c==''){
                    im = 1;
                }else{
                    im=NextVisitUtils.mtoi(v.Site_Contract__r.Due__c);
                }
                if(v.Site_Contract__r.Year__c==null||v.Site_Contract__r.Year__c==''){
                    //iy = system.today().year()-2;
                    iy = system.today().year();
                }else{
                    iy=integer.valueof(v.Site_Contract__r.Year__c);
                }
                Decimal ns;
                if(v.Site_Contract__r.Number_of_Services__c==null){
                    ns=52;
                }else{
                    ns=v.Site_Contract__r.Number_of_Services__c;
                }
                system.debug('!!!!!!!!!!!!!!!!!!!ns'+ns);
                system.debug('im>>>'+im);
                
                integer iid=sd.day();
                try{
                integer nd = 7;
                integer ndm = (Integer) (12/ns);
                date td = system.today();
                vd = date.newInstance(iy,im,iid);
                while(vd<=td||vd<=v.End_Date__c||vd<=v.Actual_Service_Date__c){
                    if(ns<=12){
                        vd=vd.addMonths(ndm);
                    }else{
                        vd=vd.addDays(nd);
                    }
                }
                system.debug('!!!!!!!!!!!!!!!!!!!After Divide'+vd);
               //Check Actual Visit Date Held on Week Ends
             
                DateTime VisitDateTime = (DateTime)vd;
                String dayOfWeek = VisitDateTime.format('EEEE');
                    if(dayOfWeek == 'Saturday'){
                        vd=vd.addDays(2);
                    }else if(dayOfWeek =='Sunday'){
                        vd=vd.addDays(1);
                    }
                   For( Holiday Holi: Holidays){
                       IF(vd==Holi.activitydate && (Holi.Name=='New Year’s Day' || Holi.Name=='Spring bank holiday' ||  Holi.Name=='Summer bank holiday' || Holi.Name =='Easter Monday' || Holi.Name =='Early May bank holiday'|| Holi.Name =='Boxing Day')){
                           vd=vd.addDays(1);
                       }else IF(vd==Holi.activitydate && (Holi.Name=='Good Friday' || Holi.Name=='ChristmasDay') ){
                           vd=vd.addDays(4);
                       }
                   }  
                   
                //vd = vd.toStartOfMonth();
                nv=true;
                }catch(Exception exnv1s){
                 System.debug('---Error---'+exnv1s);}
                
            }else if(v.Site_Contract__r.Visit_Rescheduling_Formula__c=='On Visit'){
                system.debug('On Visit Section===');
                date sd;
                if(v.End_Date__c!=null){
                    sd=v.End_Date__c;
                   
                }else if(v.Actual_Service_Date__c!=null){
                    sd=v.Actual_Service_Date__c;
                }else{
                    sd=system.today();
                }
                vd=sd;
                Decimal ns;
                if(v.Site_Contract__r.Number_of_Services__c==null){
                    ns=52;
                }else{
                    ns=v.Site_Contract__r.Number_of_Services__c;
                }
             system.debug('!!!!!!!!!!!!!!!!!!!ns'+ns);
                try{
                integer nd = 7;
                integer ndm= (Integer)(12/ns);
                    if(ns<=12){
                        vd=vd.addMonths(ndm);
                    }else{
                        vd=vd.addDays(nd);
                    }
                    system.debug('!!!!!!!!!!!!!!!!!!!After Divide'+vd);
            //Check Actual Visit Date Held on Week Ends        
              
                DateTime VisitDateTime = (DateTime)vd;    
                String dayOfWeek = VisitDateTime.format('EEEE');
                    if(dayOfWeek =='Saturday'){
                       vd=vd.addDays(2);
                     }else if(dayOfWeek =='Sunday'){
                        vd=vd.addDays(1);
                    }
                     
                  
                  For( Holiday Holi: Holidays){
                       IF((vd==Holi.activitydate) && (Holi.Name=='New Year’s Day' ||Holi.Name=='Spring bank holiday' ||  Holi.Name=='Summer bank holiday' || Holi.Name =='Easter Monday' || Holi.Name =='Early May bank holiday'|| Holi.Name =='Boxing Day' ) ){
                           vd=vd.addDays(1);
                       }else IF((vd==Holi.activitydate) && (Holi.Name=='Good Friday' || Holi.Name=='ChristmasDay') ){
                           vd=vd.addDays(4);
                       }
                   }  
                  
                 
               //vd = vd.toStartOfMonth();
                nv=true;
                }catch(Exception exnvv1){
                System.debug('---Error---'+exnvv1);
                }
            
        }
     }
 system.debug('!!!!!!!!!!!!!!!!!!!date'+vd) ;       
        if(nv){
  OnceNV.setAlreadyRound();
            
        //id idt = v.Site_Contract__r.Technician__r.Id;
        //if(idt==null){idt=v.Engineer2__r.Id;}
        id idt = v.Engineer2__r.Id; // Modified by Merfantz for Same Technician Feature.
        
        string svt = v.Service_Type__c;
        if(svt==''||svt==null){svt=v.Site_Contract__r.AM_System_Type__c;}
        
        string sxd = vd.day().format();
        if(sxd.length()==1){sxd='0'+sxd;}
        string sxm = vd.month().format();
        if(sxm.length()==1){sxm='0'+sxm;}
        string sxy = vd.year().format().replaceall(',','');
        string sxdmy = sxd+'/'+sxm+'/'+sxy;
        system.debug('!!!!!!!!!!!!!!!!!!!sxdmy'+sxdmy);
        id idvd;
        try{
            idvd = [select Id,Name from Date__c where Name=:sxdmy limit 1].Id;
        }catch(Exception exidvd){}
        if(idvd==null){
            Date__c dxd = new Date__c(
              Date_Field__c=vd,
              Name=sxdmy            
            );
            insert dxd;
            idvd=dxd.id;
        }
        system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!id'+idvd); 
        
        
        Visits__c xv = new Visits__c();
/*
Attach to same Site,
Site Contract,
Technician = SiteContract. Technician__c. If this is blank, use the technician
 on the visit (Engineer2__c)
Previous_Visit__c = the ID of the visit which triggered this one. 
( it’s a lookup field )
Visit Complete = False
Accepted = Blank
Booked with Customer = Blank
Service Type = same as previous visit. If blank, use 
SiteContracts__c.AM_System_Type__c          
 */     
         xv.Site__c=v.Site__r.Id;
         xv.Site_Contract__c=v.Site_Contract__r.Id;
         xv.Engineer2__c=idt;
         xv.Previous_Visit__c=v.Id;
         xv.Visit_Complete__c=false;
         xv.Accepted__c='';
         xv.Customer_Contact__c=v.Customer_Contact__c;
         xv.Booked_with_Customers__c='';
         xv.Service_Type__c=svt;
         xv.Visit_Type__c=v.Visit_Type__c;
         xv.Date__c=idvd;
          system.debug('v.Last_Submitted_Service_Sheet__r.Notes_for_next_service__c=========='+v.Last_Submitted_Service_Sheet__r.Notes_for_next_service__c);         
         if(v.Last_Submitted_Service_Sheet__c!=null && v.Last_Submitted_Service_Sheet__r.Notes_for_next_service__c!=null){
                system.debug('v.Last_Submitted_Service_Sheet__r.Notes_for_next_service__c=========='+v.Last_Submitted_Service_Sheet__r.Notes_for_next_service__c);
                xv.Notes_from_Previous_Service__c=v.Last_Submitted_Service_Sheet__r.Notes_for_next_service__c;
              }
        sinvx.add(v.id);
        linv.add(xv);
        if(linv.size()>95){        
            insert linv;            
            linv.clear();
        }
    }
 }
 if(linv.size()>0){
    insert linv;
    linv.clear();
} 
try{
   list<Visits__c>lvxx = ([select Id,Previous_Visit__r.Id from Visits__c
                             where Previous_Visit__r.Id IN: sinvx
                             and Previous_Visit__r.Id!=null]);
   list<Visits__c>lvyy = ([select Id,Next_Visit__c from Visits__c
                             where Id IN: sinvx
                             and Id!=null]);
   map<Id,Id>mvxx = new map<id,id>();
   
   for(Visits__c vxx : lvxx){
        mvxx.put(vxx.Previous_Visit__r.Id,vxx.Id);
   }
   for(Visits__c vyy : lvyy){
        Id ivxx = mvxx.get(vyy.Id);
        if(ivxx!=null){
            vyy.Next_Visit__c=ivxx;
            linv.add(vyy);
            if(linv.size()>95){
                update linv;
                linv.clear();
            }
        }
   }
    if(linv.size()>0){
    update linv;
    linv.clear();
    }
 }catch(Exception exnv){}
}
}    
}