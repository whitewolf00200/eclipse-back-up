@isTest(SeeAllData=true)
public class LongProjectOrderControllerTest{
  static testMethod void myTest(){
  Test.startTest();
  Account a=new Account();
  a.Name='Test';
  a.Customer_type__c='Dental Laboratory';
 /* a.Billing Street='Billing Street';
  a.Billing City='Billing City';
 // a.Billing State/Province='Billing State';
 // a.Billing Zip/Postal Code='Billing Zip';
  a.Billing Country='Billing Country';
  a.Shipping Street='Shipping Street'; 
  a.Shipping City='Shipping City';
  a.Shipping State/Province='Shipping State';
  a.Shipping Zip/Postal Code='Shipping Zip';
  a.Shipping Country='Shipping Country'; */
  a.SAGE_Code__c='1234';
  a.Site_Invoice_Name__c='test';
  insert a;
  
  SiteContracts__c sc=new SiteContracts__c();
  sc.Site__c=a.id;
      sc.Customer__c = a.id;
  sc.AM_Status__c='Live';
  sc.Visit_Rescheduling__c='On Schedule';
  sc.Number_of_Services__c=2;
  sc.Due__c='MAR';
  insert sc;
  
 /* RecordType oppRT;
        try{
            oppRT = [Select Id, Name, DeveloperName From RecordType Where DeveloperName = 'To_Invoice'];
        } catch(Exception ex){}
        
         Opportunity opp = new Opportunity(Name='Test Opp',RecordTypeId = oppRT.Id, AccountId = a.Id, CloseDate = closeDate, StageName='Proposal/Price Quote' ,Type='Catalogue Order');
  */
 //  Id PSPBId = Schema.SObjectType.SalesOrder__c.getRecordTypeInfosByName().get('Long_Project_Order_Confirmation').getRecordTypeId();
  SalesOrder__c so=new SalesOrder__c();
 //so.RecordTypeId = PSPBId ;
  so.Account__c=a.id;
  so.Service_Type__c='Air Compressor';
  so.Due_Date__c=system.today();
  so.Account__c=a.id;
  so.Phone__c='944567898';
  so.Email__c='test@gmail.com';
  /* so.Total_Price__c=70;
  so.Vat_Total__c=10;
  so.Order_Total__c  =80; */
  
  insert so;
  
  ApexPages.currentPage().getParameters().put('id',so.id);
  
  
  Project__c p=new Project__c();
  p.Name='Test project';
  p.Long_Project_Order__c=so.id;
  insert p;
  LongProjectOrderController lp=new LongProjectOrderController ();
  lp.getMasterRecordId ();
  lp.setMasterRecordId (so.id);
  Test.stopTest();
  
  
  }
  
  }