@isTest(SeeAllData=True)
public class SurveySubmitControllerTest {
    
    static testmethod void SurveySubmit()
    {
        Account a = new Account();
        a.Name='Test Customer';
        a.Customer_type__c='others';
        a.Survey_required__c=false;
        a.account_status__c='Live';
        insert a;
        
        Account a2 = new Account();
        a2.Name='Test site';
        a2.Customer_type__c='others';
        a2.parentid=a.id;
        a2.recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        a2.Survey_required__c=false;
        a2.Account_Status__c='Live';
        insert a2;
        
        SiteContracts__c b = new SiteContracts__c();
        b.Site__c=a2.id;
        b.AM_Status__c='Live';
        b.Customer__c=a.id;
        insert b;
        
        
        
        Engineer__c c = new Engineer__c();
        c.Name='Andrew';
        c.Engineer_ID__c='3a443d2f-f632-4d30-a60b-7eda067b958b';
        c.Active_User__c='Yes';
        
        c.Country__c= 'Australia';
        insert c;
        
        Engineer__c c1 = new Engineer__c();
        c1.Name='Test';
        c1.Engineer_ID__c='3a443d2f-f632-4d30-a60b-7eda067b958b';
        c1.Active_User__c='Yes';
        
        c1.Country__c= 'Australia';
        insert c1;
        
        Contact cont = new Contact();
        cont.AccountId = a2.id;
        cont.Email = 'test@email.com';
        cont.Relationship__c = 'Average';          
        cont.Description = 'Test comment';
        cont.Lastname = 'Test ';
        insert cont;
        
        
        
        Visits__c vist = new Visits__c();
        
        vist.Site__c=a2.id;
        vist.Site_Contract__c=b.id;
        vist.Engineer2__c=c.id;
        vist.Service_Type__c ='Storm Water Pump';
        vist.End_Date_Time__c=system.today();
        vist.Order_Value__c=2000;
        vist.Customer_Contact__c=cont.id;
        vist.Booked_with_Customers__c='Yes';
        vist.Actual_Service_Date__c=system.today();
        vist.Visit_Type__c='Service';
        vist.Visit_Complete__c=true;
        insert vist;
        
        apexPages.CurrentPage().getParameters().Put('id',String.valueOf(vist.id));
        ApexPages.StandardController sc = new ApexPages.StandardController(vist);
        SurveySubmitController SSc = New SurveySubmitController(sc);
        SSc.sendSurvey();
        vist.Visit_Complete__c=false;
        update vist;
        SSc.sendSurvey();
        SSc.doRedirect();
    }
    
    
    
    
}