@IsTest(SeeAllData=true)
public class SiteContractDormantTest {
public static testMethod void Tester() {
    
   Account a=new Account();
   a.Name='Test';
   a.Account_Status__c  = 'Dormant';
    a.Date_Account_Status_Changed__c=system.today();    
    a.Reason_Dormant_On_Hold__c = 'Testing';
    insert a;   
    
    List<SiteContracts__c> sc=new List<SiteContracts__c>{new SiteContracts__c( AM_Status__c='Live',
     Visit_Rescheduling__c='On Schedule',
     Number_of_Services__c=2,
     Site__c=a.id,
     Due__c='MAR')};
    
     insert sc;           
     
     set<id> scid=new set<id>();
     List<SiteContracts__c> scc=new List <SiteContracts__c>{[select id from SiteContracts__c where id =:sc]};
     for(SiteContracts__c n:scc){
     n.AM_Status__c='Dormant';
     n.Contract_Status_Change_Date_Time__c=system.today();   
     scid.add(n.Id);
     }
     update scc;      
     
     Engineer__c tech=new Engineer__c();
     tech.Name='technician';
     tech.Engineer_ID__c='123';
     tech.Active_User__c='Yes';
     tech.Street__c='street';
     tech.Postal_Code__c='60039';
     tech.City__c='city';tech.Country__c='country';tech.State_Province__c='state';
     insert tech;
     
       List<Visits__c> lv=new List<Visits__c>{new Visits__c(Engineer2__c=tech.id,Site__c=a.id,Site_Contract__c=sc[0].id,Visit_Type__c='Callout',Actual_Service_Date__c=system.today(),Visit_Complete__c=false)};      
       insert lv;
       system.debug('lv======'+lv);
       
 
       
   /*    List<Visits__c > v=new List<Visits__c >();
       for(Visits__c lvd:lv){
       v.add(lvd);      
     if(v.size()>0)
     v.clear();
       } */
       

                     
}
}