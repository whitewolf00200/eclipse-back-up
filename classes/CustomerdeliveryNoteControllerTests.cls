@isTest(SeeAllData=True)

    public class CustomerdeliveryNoteControllerTests {

      @isTest Static void CustomerdeliveryNoteControllerTests() {
      Technician_Compliance__c comp=new Technician_Compliance__c();
      comp.Customer_Site__c=[SELECT id from Account LIMIT 1].id;
      comp.Firstname__c='First Name';
      comp.Lastname__c='Last Name';
      comp.Gift__c ='Gift';
      insert comp;
      Technician_Compliance__c Cid=[select id,Customer_Site__r.name,Firstname__c,Lastname__c,Gift__c from Technician_Compliance__c LIMIT 1];
      
      apexPages.CurrentPage().getParameters().Put('id',String.valueOf(Cid.id));
      ApexPages.StandardController sc = new ApexPages.StandardController(Cid);
      CustomerdeliveryNoteController CNc = New CustomerdeliveryNoteController(sc);
      
      Account listAccount=[select ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry from Account where id=:Cid.Customer_Site__c LIMIT 1];
    }
}