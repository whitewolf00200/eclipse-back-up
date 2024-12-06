@istest

/*============================================================================================================
*Class Name     : overallTest
*Description    :Over All Test class for all object 
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 20th Nov, 2018
*Version        : 1.0
*Change History : Initial class Test
*Methods        :testMethod void overtestmethod()
*============================================================================================================*/

Public class overallTest{


/*====================================================

*Method Name     : overtestmethod
*Description     : Test Method
*Arguments       : Null
====================================================*/

static testMethod void overtestmethod(){

//RecordType 
    Id siteId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
    Id siteId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
    Id psp = Schema.SObjectType.Engineer_Checklist__c.getRecordTypeInfosByName().get('Air Compressor Service and Test Report').getRecordTypeId();
    Id opId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Invoice (To Invoice)').getRecordTypeId();

//Contact
    Contact cn=new Contact();
    cn.LastName='test';
    insert cn;  

//Account Supplier
    Account acc=new Account();
    acc.Name='test account';
    acc.Account_Status__c='Live';
    acc.recordtypeid=siteId1 ;
    insert acc;

//Account Site
    Account ac=new Account();
    ac.Name='test account';
    ac.Account_Status__c='Live';
    ac.recordtypeid=siteId ;
    insert ac;

//SiteContracts 
    SiteContracts__c si=new SiteContracts__c();
    si.Site__c=ac.id;
    si.Visit_Rescheduling__c='On Schedule';
    si.Number_of_Services__c=2;
    si.AM_Status__c='Live';
    si.Price_Book__c=Test.getStandardPricebookId();
    si.Due__c='march';    
    insert si;

//Technician
    Engineer__c technician=new Engineer__c();
    technician.Name='test';
    technician.Engineer_ID__c='1234';
    technician.Active_User__c='Yes';
    technician.Street__c='test address';
    technician.City__c='test city';
    technician.Country__c='test country';
    technician.Postal_Code__c='1245';
    technician.State_Province__c='test state';
    insert technician;

//Visit
    Visits__c vi=new Visits__c();
    vi.Site__c=ac.id;
    vi.Site_Contract__c=si.id;
    vi.Visit_Type__c='Service';
    vi.Actual_Service_Date__c=system.today();
    vi.Engineer2__c=technician.id;
    insert vi;

//Lead
    Lead li=new Lead();
    li.Status='Unqualified';
    li.LastName='kc';
    li.Company='testcompany';
    insert li;

//Custom Setting ControlFetch - Record name: 'Lead Creation'
    ControlFetch__c con=new ControlFetch__c();
    con.name='Lead Creation';
    con.isEnable__c=true;
    insert con;

//Custom Setting ControlFetch - Record name: 'System Admin id'
    ControlFetch__c con1=new ControlFetch__c();
    con1.name='System Admin id';
    con1.TechnicianId__c='00558000000fdRW';
    insert con1;   

//Custom Setting ControlFetch - Record name: 'Parts Used Condition'
    ControlFetch__c con2=new ControlFetch__c();
    con2.name='Parts Used Condition'; 
    con2.Flag__c=true;
    insert con2;

//Service Sheet 
    Engineer_Checklist__c sheet=new Engineer_Checklist__c();
    sheet.recordtypeid=psp;
    sheet.Site__c=ac.id;
    sheet.Site_Contract__c=si.id;
    sheet.Visit__c=vi.id;
    sheet.Engineer__c=technician.id;
    sheet.Date_Of_System_Manufacture__c=system.today();
    sheet.Start_Date_and_Time__c=system.now();
    sheet.End_Date_and_Time__c=system.now()+10;
    sheet.Start_Travel_Time__c=system.now();
    sheet.End_Travel_Time__c=system.now()+10;
    sheet.Email_Confirmation_to__c='test@gmail.com';
    sheet.Congestion_Charge__c=12;
    sheet.Parking_Costs__c=12;
    sheet.Fire_Extinguisher_Service_complete__c = false;
    sheet.Date_Of_Manufacture__c=system.today();
    insert sheet; 

//Project
    Project__c pp=new Project__c();
    pp.Name='test';
    pp.Contact__c=cn.id;         
    insert pp; 

//Campaingn
    Campaign ca=new Campaign();
    ca.Name='test';
    insert ca;

//Opportunity  
    Opportunity op=new Opportunity();
    op.recordtypeid=opId;
    op.Name='test';
    op.CloseDate=system.today()+5;
    op.StageName='Qualification';
    op.AccountID =ac.id;
    op.CampaignID=ca.id;
    insert op; 

//Standard PriceBook
    PriceBook2 pb = New PriceBook2(Id = test.getStandardPricebookId(), isActive = true);
    update pb;

//Product
    Product2 Prd=new Product2();
    Prd.Name='Test Product';
    Prd.isActive=true;
    insert Prd;

//Internal & Technician Order
    Technician_Orders__c tech=new Technician_Orders__c();//Internal & Technician Order  
    tech.Required_By_On__c=system.today();
    tech.Priority_Status__c='1 = Life Threatening Within 24hrs';
    tech.For_Attention_Of__c='test';
    tech.Delivery_Address__c='Home Address';
    tech.Department__c='Accounts';
    tech.Visit__c=vi.id;
    tech.Make_Manufacturer_A__c='1';
    tech.Model_Part_Number_A__c ='test';
    tech.Description__c='test description';
    tech.Qty_A__c=7;
    tech.Site_Address__c=ac.id;
    tech.Technician__c=technician.id;
    insert tech;

//Complaints
    Complaints__c com=new Complaints__c();
    com.Customer_Site__c=ac.id;
    com.Department__c='test';
    com.Complaint_Details__c='test complaints';
    com.Recorded_By__c='Adrian Warne';
    com.Passed_To__c='Adrian Warne';
    com.Reported_to_Manager__c='test';
    insert com;

//Warehouse
    Warehouse__c house=new Warehouse__c();
    house.Name='test';
    insert house;

//Vehicle
    Vehicle__c ve=new Vehicle__c();
    ve.Name ='test';
    ve.Warehouse__c=house.id;
    insert ve;

//Quote
    Quote qu=new Quote ();
    qu.Name ='test';
    qu.OpportunityID=op.id;
    qu.Service_Type__c='Air Compressor  ';
    insert qu;

//SalesOrder
    SalesOrder__c sa=new SalesOrder__c();
    sa.Service_Type__c='Air Compressor  ';
    sa.Quote__c=qu.id;
    insert sa;

//Delivery Note 
    Delivery_Note__c dn=new Delivery_Note__c();
    dn.Site__c=ac.id;
    dn.Opportunity__c=op.id;
    dn.Sales_Order__c=sa.id;
    insert dn;

//Credit Notes
    Credit_Notes__c cr=new Credit_Notes__c();
    cr.Opportunity__c=op.id;
    cr.Account__c=acc.id;
    cr.Customer_site_Account__c =ac.id;
    insert cr;

//SupplierProduct
    SupplierProduct__c su=new SupplierProduct__c();
    su.Product__c=prd.id;
    su.Supplier__c=acc.id;
    insert su;

//Sales Order Line Items
    SalesOrderLineItems__c sl=new SalesOrderLineItems__c();
    sl.Sales_Order__c=sa.id;
    sl.Product__c=prd.id;
    sl.Quantity__c=7;
    insert sl;

//Purchase Order
    PurchaseOrder__c pl=new PurchaseOrder__c();
    pl.Supplier__c=acc.id;
    pl.Account__c=ac.id;
    pl.Supplier_Contact__c=cn.id;
    insert pl;

//Purchase Order Line Item
    PurchaseOrderLineItem__c pu=new PurchaseOrderLineItem__c();
    pu.Purchase_Order__c=pl.id;
    pu.Product__c=prd.id;
    insert pu;

//Supplier
    Suppliers__c sup=new Suppliers__c();
    sup.Name='test';
    sup.Sage_Code__c='test';
    sup.Billing_Street__c='test';
    sup.Billing_Country__c='test';
    sup.Billing_State_Province__c='test tamilnadu';
    sup.Billing_Zip_Postal_Code__c='625012';
    sup.Billing_City__c='testcity';
    insert sup;

//Suplier Purchase Order Line Item
    SFDC_Purchase_Order__c sf=new SFDC_Purchase_Order__c();
    sf.Supplier1__c=sup.id;
    sf.Department__c='Fleet';
    sf.Opportunity__c=op.id;
    insert sf;

//Small Work
    Small_Works__c sm=new Small_Works__c();
    sm.Site__c=ac.id;
    sm.Technician__c=technician.id;
    sm.System_Type__c='Access Control';
    sm.Out_of_Hours__c='Yes';
    sm.visit__c=vi.id;
    sm.Re_Visit_Required__c='No';
    sm.Arrive__c=system.today();
    sm.Depart__c=system.today();
    sm.Travel_Time__c=7;
    insert sm;

}
}