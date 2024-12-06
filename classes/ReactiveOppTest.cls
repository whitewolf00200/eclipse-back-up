public class ReactiveOppTest {
public static testMethod void Tester() {
/*******Start Modified by Puthuvannam*******/
Account newAccount =new Account();
newAccount.Name='Test Account';
insert newAccount;

Engineer__c tmp_technician = new Engineer__c();
tmp_technician.Name='Test Engineer';
insert tmp_technician;

SiteContracts__c t_siteContract= new SiteContracts__c();
t_siteContract.site__c=newAccount.id;
insert t_siteContract;

Visits__c t_visit= new Visits__c();
t_visit.site__c=newAccount.id;
t_visit.site_Contract__c=t_siteContract.id;
t_visit.Engineer2__c=tmp_technician.id;
t_visit.Service_Type__c='Testing'    ;
insert t_visit;
/*******End Modified by Puthuvannam*******/
Service_Sheet_STD__c ss2;

try{
    ss2= [select Id, Fire_Extinguisher_Service_complete__c,
                                     Sales_Quote_Required__c,Technician__c,Site_Contract__c,Visit__c
                                     from Service_Sheet_STD__c 
                                     where Site_Contract__r.Price_Book_IdFormula__c!=null                                 
                                     limit 1];
    Service_Sheet_STD__c ss = ss2.clone(false,true,true,true);
    ss.Fire_Extinguisher_Service_complete__c=false;   
    ss.Technician__c=tmp_technician.id;        /*******Modified by Puthuvannam*******/
    ss.Site_Contract__c=t_siteContract.id;     /*******Modified by Puthuvannam*******/                             
    ss.Visit__c=t_visit.id;                    /*******Modified by Puthuvannam*******/                             
    ss.Maintenance_Type__c = t_visit.Service_Type__c;    
    ss.Sales_Quote_Required__c='No';
    insert ss;
}catch(exception e){

}
//update ss;
}
}