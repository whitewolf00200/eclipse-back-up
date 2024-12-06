@isTest(SeeAllData=true)
    public class CreditHandlerTest{
       static TestMethod void method1(){
       
       Product2 prd=new Product2();
       prd.name='test prd';
       prd.IsActive=true;
       insert prd;
       
       Account acc=new Account();
       acc.name='test';
       insert acc;
       
       Opportunity opp=new opportunity();
       opp.Name='test opp';
       opp.AccountId=acc.id;
       opp.CloseDate=system.today();
       opp.StageName='Closed Won';
       insert opp;
       
       Credit_Notes__c cn=new Credit_Notes__c();
       cn.Opportunity__c=opp.id;
       cn.Account__c=acc.id;
       insert cn;
       
       Credit_Note_Line_Item__c cnli=new Credit_Note_Line_Item__c();
       cnli.Opportunity__c=opp.id;
       cnli.Product_credit__c=prd.id;
       cnli.Credit_Notes__c=cn.id;
       insert cnli;
       
       cn.Show_Description__c=true;
       update cn;
       
       
       }
            
    }