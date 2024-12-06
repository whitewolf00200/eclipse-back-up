public class SWOppTest {
public static testMethod void Tester() {
Small_Works__c ss2;
try{
    ss2= [select Id, Submit_this_Small_Works_Sheet__c,close_visit__c
                                     from Small_Works__c 
                                     where Site_Contract__r.Price_Book_IdFormula__c!=null                                 
                                     limit 1];
    Small_Works__c ss = ss2.clone(false,true,true,true);
    ss.Submit_this_Small_Works_Sheet__c=false;                                 
    insert ss;
    ss.Submit_this_Small_Works_Sheet__c=true; 
    ss.close_visit__c='Yes';
    ss.Depart__c=system.now();                                
    update ss;
}catch(exception e){

}
}
}