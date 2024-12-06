@istest(SeeAllData=true)
class PurchaseOrderControllerTest{
static testmethod void method1(){

test.starttest();

Account a=new Account();
a.Name='test';
insert a;

SiteContracts__c sc=new SiteContracts__c();
sc.Site__c=a.id;
sc.AM_Status__c='Live';
insert sc;

Engineer__c tech=new Engineer__c();
tech.name='test';
tech.Engineer_ID__c='123';
tech.Active_User__c='Yes';
tech.Street__c='street';
tech.City__c='city';
tech.State_Province__c='state';
tech.Postal_Code__c='40498';
tech.Country__c='country';
insert tech;

Visits__c vi=new Visits__c();
vi.Site__c=a.id;
vi.Site_Contract__c=sc.id;
vi.Engineer2__c=tech.id;
vi.Visit_Type__c='Callout';
vi.Actual_Service_Date__c=system.today();
insert vi;

Suppliers__c su=new Suppliers__c();
su.Name='test supplier';
su.Sage_Code__c='123';
su.Billing_Street__c='street';
su.Billing_City__c='city';
su.Billing_State_Province__c='state';
su.Billing_Zip_Postal_Code__c='6000056';
su.Billing_Country__c='india';
insert su;

SFDC_Purchase_Order__c spo=new SFDC_Purchase_Order__c();
spo.Supplier1__c=su.id;
spo.Visit__c=vi.id;
spo.Department__c='test';
insert spo;

ApexPages.CurrentPage().getParameters().put('id',spo.id);
ApexPages.StandardController sco = new ApexPages.StandardController(spo);
Purchase_Order_Controller poc=new Purchase_Order_Controller(sco);
test.stoptest();
}

}